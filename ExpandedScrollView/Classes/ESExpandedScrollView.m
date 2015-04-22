//
//  ESExpandedScrollView.m
//  
//
//  Created by CyonLeu on 15/3/18.
//  Copyright (c) 2015年 CyonLeuInc. All rights reserved.
//

#import "ESExpandedScrollView.h"

@implementation ESGridIndex

- (instancetype)initWithRow:(NSInteger)row column:(NSInteger)column {
    self = [super init];
    if (self) {
        self.row = row;
        self.column = column;
    }
    
    return self;
}

@end

@implementation ESExpandedItemView

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        self.layer.borderWidth = 0;
    } else {
        self.layer.borderWidth = self.borderWidth;
    }
    
    [self setNeedsDisplay];
}

- (void)setBorderWidth:(CGFloat)borderWidth {
    _borderWidth = borderWidth;
    
    self.layer.borderWidth = borderWidth;
}

@end

#pragma mark - ESExpandedContainerView

@interface ESExpandedContainerView ()

@property (strong, nonatomic) NSMutableArray *itemViews;
@property (assign, nonatomic) NSInteger countOfItems;

@end

@implementation ESExpandedContainerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    
    return self;
}

- (void)setupView {
    self.countOfColumns = 4;
    self.itemSize = CGSizeMake(80, 30);
    self.itemSpace = 14.f;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.6];
    [self addSubview:imageView];
    [self sendSubviewToBack:imageView];
    self.backgroundImageView = imageView;
    
    ESExpandedArrowView *arrowImageView = [[ESExpandedArrowView alloc] init];
    [self addSubview:arrowImageView];
    self.arrowView = arrowImageView;
    self.arrowView.hidden = YES;
}

- (NSMutableArray *)itemViews {
    if (!_itemViews) {
        _itemViews = [NSMutableArray array];
    }
    
    return _itemViews;
}

- (void)removeSubViewsWithAutoLayout {
    for (UIView *subView in self.itemViews){
        [subView removeFromSuperview];
    }
    
    [self.itemViews removeAllObjects];
    
    [self.backgroundImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.leading.equalTo(self);
        make.trailing.equalTo(self);
        make.top.equalTo(self);
        make.bottom.equalTo(self);
    }];
    self.arrowView.hidden = YES;
 
}

- (void)reloadData {
    
    [self.arrowView setNeedsDisplay];
    self.countOfItems = [self.dataSource numberOfItemsInExpandedContainerView:self];
    NSInteger rowCount = self.countOfItems / self.countOfColumns;
    if (self.countOfItems % self.countOfColumns != 0) {
        ++ rowCount;
    }
    
    if (rowCount > 0) {
        CGFloat offsetX = self.itemSpace / 2 + self.index.column * (self.mainItemSize.width + self.itemSpace) + self.mainItemSize.width / 2.f ;
        [self.arrowView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.backgroundImageView.mas_top).offset(1);
            make.leading.equalTo(self).offset(offsetX);
            make.size.equalTo([NSValue valueWithCGSize:CGSizeMake(self.itemSpace, self.itemSpace/2)]);
        }];

        
        self.arrowView.hidden = NO;
        [self.backgroundImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self);
            make.trailing.equalTo(self);
            make.top.equalTo(self).offset(self.itemSpace);
            make.bottom.equalTo(self);
        }];
    } else {
        self.arrowView.hidden = YES;
        [self.backgroundImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.leading.equalTo(self);
            make.trailing.equalTo(self);
            make.top.equalTo(self);
            make.bottom.equalTo(self);
        }];
    }
    
    CGFloat itemWidth = (CGRectGetWidth(self.bounds) - self.itemSpace * (self.countOfColumns + 1)) / self.countOfColumns;
    CGFloat itemHeight = self.itemSize.height;
    self.itemSize = CGSizeMake(itemWidth, itemHeight);

    ESExpandedItemView *rowBeginItemView = nil;
    
    for (int row = 0; row < rowCount; ++ row) {
        ESExpandedItemView *leftItemView = nil;
        NSInteger leftItems = self.countOfItems - row * self.countOfColumns;
        NSInteger columnCount = (leftItems >= self.countOfColumns ? self.countOfColumns : leftItems);
        for (int column = 0; column < columnCount; ++ column) {
            ESGridIndex *index = [[ESGridIndex alloc] initWithRow:row column:column];
            ESExpandedItemView *itemView = [self.dataSource expandedContainerView:self cellForItemAtIndex:index];
            itemView.index = index;

            [itemView addTarget:self action:@selector(onTouchContainerItemView:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:itemView];
            [self.itemViews addObject:itemView];

            if (row == 0 && column == 0) {
                //(row, column)= (0, 0)
                if (row == (rowCount - 1)) {
                    [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(self).offset(self.itemSpace * 2);
                        make.bottom.equalTo(self).offset(-self.itemSpace);
                        make.leading.equalTo(self).offset(self.itemSpace);
                        make.size.equalTo([NSValue valueWithCGSize:CGSizeMake(itemWidth, itemHeight)]);
                    }];
                } else {
                    [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(self).offset(self.itemSpace * 2);
                        make.leading.equalTo(self).offset(self.itemSpace);
                        make.size.equalTo([NSValue valueWithCGSize:CGSizeMake(itemWidth, itemHeight)]);
                    }];
                }
                
                rowBeginItemView = itemView;
                
            } else if (column == 0) {
                //(row, column)= (r>0, 0)
                
                if (row == (rowCount - 1)) {
                    [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(rowBeginItemView.mas_bottom).offset(self.itemSpace);
                        make.bottom.equalTo(self).offset(-self.itemSpace);
                        make.leading.equalTo(self).offset(self.itemSpace);
                        make.size.equalTo([NSValue valueWithCGSize:CGSizeMake(itemWidth, itemHeight)]);
                    }];
                } else {
                    [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(rowBeginItemView.mas_bottom).offset(self.itemSpace);
                        make.leading.equalTo(self).offset(self.itemSpace);
                        make.size.equalTo([NSValue valueWithCGSize:CGSizeMake(itemWidth, itemHeight)]);
                    }];
                }
                rowBeginItemView = itemView;
            } else  {
                //(row, column)= (r>0, c>0)
                [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.equalTo(leftItemView.mas_trailing).offset(self.itemSpace);
                    make.centerY.equalTo(leftItemView);
                    make.size.equalTo(leftItemView);
                }];
            }
            leftItemView = itemView;
        }//end for(column...)
    }//end for(row...)
}


- (void)selectItemViewForIndex:(ESGridIndex *)index {
    NSInteger itemIndex = index.row * self.countOfColumns + index.column;
    if (itemIndex < self.itemViews.count) {
        ESExpandedItemView *itemView = [self.itemViews objectAtIndex:itemIndex];
        [itemView setSelected:YES];
    }
}

- (void)deselectItemViewForIndex:(ESGridIndex *)index {
    NSInteger itemIndex = index.row * self.countOfColumns + index.column;
    if (itemIndex < self.itemViews.count) {
        ESExpandedItemView *itemView = [self.itemViews objectAtIndex:itemIndex];
        [itemView setSelected:NO];
    }
}

- (void)onTouchContainerItemView:(ESExpandedItemView *)itemView {
    ESGridIndex *index = itemView.index;
    if (self.selectedIndex && self.selectedIndex != index) {
        [self deselectItemViewForIndex:self.selectedIndex];
    }
    
    [itemView setSelected:YES];
    self.selectedIndex = index;
    if (self.delegate && [self.delegate respondsToSelector:@selector(expandedContainerView:didSelectItemAtIndex:)]) {
        [self.delegate expandedContainerView:self didSelectItemAtIndex:itemView.index];
    }
}

@end

#pragma mark - ESExpandedScrollView

@interface ESExpandedScrollView () <ESExpandedContainerViewDataSource, ESExpandedContainerViewDelegate>

@property (strong, nonatomic) NSMutableArray *itemViews;
@property (strong, nonatomic) NSMutableArray *expandedItemsViews;
@property (strong, nonatomic) ESExpandedContainerView *expandedView;

@property (assign, nonatomic) NSInteger countOfItems;


@end

@implementation ESExpandedScrollView

@dynamic delegate;

#pragma mark - init method

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    
    return self;
}

- (void)setupView {
    self.countOfColumns = 4;
    self.itemSize = CGSizeMake(80, 30);
    self.itemSpace = 14.f;
    self.maxHeight = [UIScreen mainScreen].bounds.size.height;
    self.showExpandedViewAnimationDuration = 0.3f;
    self.expandedViewColor = [UIColor colorWithWhite:1 alpha:0.6];
}

- (NSMutableArray *)itemViews {
    if (!_itemViews) {
        _itemViews = [NSMutableArray array];
    }

    return _itemViews;
}

- (NSMutableArray *)expandedItemsViews {
    if (!_expandedItemsViews) {
        _expandedItemsViews = [NSMutableArray array];
    }
    
    return _expandedItemsViews;
}


#pragma mark - Public method

- (void)cleanSubViews {
    for (UIView *subView in self.itemViews){
        [subView removeFromSuperview];
    }
    
    [self.itemViews removeAllObjects];
    
    for (UIView *subView in self.expandedItemsViews){
        [subView removeFromSuperview];
    }
    
    [self.expandedItemsViews removeAllObjects];
    
    self.expandedView = nil;
}

- (void)reloadData {
    
    self.countOfItems = [self.dataSource numberOfItemsInExpandedScrollView:self];
    
    NSInteger rowCount = self.countOfItems / self.countOfColumns;
    if (self.countOfItems % self.countOfColumns != 0) {
        ++ rowCount;
    }
    
    CGFloat itemWidth = (CGRectGetWidth(self.bounds) - self.itemSpace * (self.countOfColumns + 1)) / self.countOfColumns;
    CGFloat itemHeight = self.itemSize.height;
    self.itemSize = CGSizeMake(itemWidth, itemHeight);
    
    ESExpandedItemView *rowBeginItemView = nil;
    ESExpandedContainerView *containerView = nil;
    
    for (int row = 0; row < rowCount; ++ row) {
        ESExpandedItemView *leftItemView = nil;

        NSInteger leftItems = self.countOfItems - row * self.countOfColumns;
        NSInteger columnCount = (leftItems >= self.countOfColumns ? self.countOfColumns : leftItems);
        for (int column = 0; column < columnCount; ++ column) {
            ESGridIndex *index = [[ESGridIndex alloc] initWithRow:row column:column];
            
            
            ESExpandedItemView *itemView = [self.dataSource expandedScrollView:self cellForItemAtIndex:index];
            itemView.index = index;
            [itemView addTarget:self action:@selector(onTouchExpandedScrollViewItemView:) forControlEvents:UIControlEventTouchUpInside];
            
            [self addSubview:itemView];
            [self.itemViews addObject:itemView];
        
            if (row == 0 && column == 0) {
                [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(self).offset(self.itemSpace);
                    make.leading.equalTo(self).offset(self.itemSpace);
                    make.size.equalTo([NSValue valueWithCGSize:CGSizeMake(itemWidth, itemHeight)]);
                }];
                rowBeginItemView = itemView;
                
            } else if (column == 0) {
                [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(containerView.mas_bottom).offset(self.itemSpace);
                    make.leading.equalTo(self).offset(self.itemSpace);
                    make.size.equalTo([NSValue valueWithCGSize:CGSizeMake(itemWidth, itemHeight)]);
                }];
                rowBeginItemView = itemView;
            } else  {
                //(row, column)= (r>0, c>0)
                [itemView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.leading.equalTo(leftItemView.mas_trailing).offset(self.itemSpace);
                    make.centerY.equalTo(leftItemView);
                    make.size.equalTo(leftItemView);
                }];
            }
            
            leftItemView = itemView;
        }//end for(column...)
        
        ESGridIndex *index = [[ESGridIndex alloc] initWithRow:row column:0];
        containerView = [self expandedContainerViewForIndex:index];
        [self addSubview:containerView];
        [self.expandedItemsViews addObject:containerView];
        
        CGFloat containerHeight = 0;
        CGFloat containerWidth = CGRectGetWidth(self.bounds);
        if (row == (rowCount - 1)) {
            [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(rowBeginItemView.mas_bottom);
                make.leading.equalTo(self);
                make.bottom.equalTo(self).offset(-self.itemSpace);
                make.height.equalTo(@(containerHeight)).priority(MASLayoutPriorityDefaultMedium);
                make.width.equalTo(@(containerWidth));
            }];
        } else {
            [containerView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(rowBeginItemView.mas_bottom);
                make.leading.equalTo(self);
                make.height.equalTo(@(containerHeight)).priority(MASLayoutPriorityDefaultMedium);
                make.width.equalTo(@(containerWidth));
            }];
        }
        
        
    }//end for(row...)
    
    [self layoutIfNeeded];
}

- (void)selectItemViewForIndex:(ESGridIndex *)index {
    NSInteger itemIndex = index.row * self.countOfColumns + index.column;
    if (itemIndex < self.itemViews.count) {
        ESExpandedItemView *itemView = [self.itemViews objectAtIndex:itemIndex];
//        [itemView setSelected:YES];
        ESGridIndex *subSelectIndex = nil;
        if (self.subSelectedIndex) {
             subSelectIndex = [[ESGridIndex alloc] initWithRow:self.subSelectedIndex.row column:self.subSelectedIndex.column];
            [self onTouchExpandedScrollViewItemView:itemView];
        } else {
            [itemView setSelected:YES];
        }
        
        if (subSelectIndex) {
            [self performSelector:@selector(selectSubItemViewForIndex:) withObject:subSelectIndex afterDelay:0.3];
        }
    }
}

- (void)selectSubItemViewForIndex:(ESGridIndex *)index {
//    NSInteger itemIndex = index.row * self.subCountOfColumns + index.column;
    if (self.selectedIndex.row < self.expandedItemsViews.count) {
        ESExpandedContainerView *containerView = [self.expandedItemsViews objectAtIndex:self.selectedIndex.row];
        if (containerView) {
            self.subSelectedIndex = index;
            [containerView selectItemViewForIndex:index];
        }
    }
}

#pragma mark - Private method


- (ESExpandedContainerView *)expandedContainerViewForIndex:(ESGridIndex *)index {
    ESExpandedContainerView *containerView = [[ESExpandedContainerView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), 150)];
    containerView.index = index;
    containerView.mainItemSize = self.itemSize;
    containerView.backgroundColor = [UIColor clearColor];
    containerView.backgroundImageView.backgroundColor = self.expandedViewColor;
    containerView.arrowView.fillColor = self.expandedViewColor;
    
    containerView.dataSource = self;
    containerView.delegate = self;
    
    return containerView;
}

- (void)onTouchExpandedScrollViewItemView:(ESExpandedItemView *)itemView {
    ESGridIndex *index = itemView.index;
    BOOL showSubContainerView = [self.dataSource expandedScrollView:self shouldShowSubExpandedContainerViewAtIndex:index];
    if (self.selectedIndex && self.selectedIndex != index) {
        NSInteger preIndex = self.selectedIndex.row * self.countOfColumns + self.selectedIndex.column;
        ESExpandedItemView *preItemView = [self.itemViews objectAtIndex:preIndex];
        [preItemView setSelected:NO];
    }
    
    if (showSubContainerView && index.row < self.expandedItemsViews.count) {
        [itemView setSelected:YES];
        
        ESExpandedContainerView *containerView = [self.expandedItemsViews objectAtIndex:index.row];
        if (self.isExpanded && self.expandedView) {
            if (index.row == self.selectedIndex.row && index.column == self.selectedIndex.column){
                self.isExpanded  = NO;
                [UIView animateWithDuration:0.2 animations:^{
                    self.expandedView.alpha = 0;
                } completion:nil];
                [self.expandedView removeSubViewsWithAutoLayout];
                self.expandedView.index = index;
                [self updateScrollViewFrameWithAnimated:YES completionBlock:nil];
                
            } else if (index.row == self.selectedIndex.row) {
                [self.expandedView removeSubViewsWithAutoLayout];

                self.selectedIndex = index;
                self.expandedView.index = index;

                [self.expandedView reloadData];
                [self.expandedView layoutIfNeeded];

                self.subSelectedIndex = nil;

                [self updateScrollViewFrameWithAnimated:YES completionBlock:nil];
                
            } else {
                [self.expandedView removeSubViewsWithAutoLayout];
                self.selectedIndex = index;
                self.subSelectedIndex = nil;

                [self updateScrollViewFrameWithAnimated:YES completionBlock:^(BOOL finished) {
                    if (finished) {
                        ESExpandedContainerView *nextContainerView = [self.expandedItemsViews objectAtIndex:index.row];
                        nextContainerView.index = index;
                        [self showExpandedView:nextContainerView shouldSelectIndex:nil];
                    }
                }];
            }
           
        } else {
            containerView.index = index;
            self.isExpanded = YES;
            ESGridIndex *preSelectedIndex = self.selectedIndex;
            self.selectedIndex = index;
            if (preSelectedIndex == index) {
                [self showExpandedView:containerView shouldSelectIndex:self.subSelectedIndex];
            } else {
                self.subSelectedIndex = nil;
                [self showExpandedView:containerView shouldSelectIndex:nil];
            }
            
        }//end of if (self.isExpanded

    } else {
        
        if (self.isExpanded && self.expandedView) {
            [UIView animateWithDuration:0.2 animations:^{
                self.expandedView.alpha = 0;
            } completion:nil];
            
            [self.expandedView removeSubViewsWithAutoLayout];
            [self updateScrollViewFrameWithAnimated:YES completionBlock:nil];
        }
        
        self.isExpanded = NO;
        self.selectedIndex = index;
        [itemView setSelected:YES];

        if (self.delegate && [self.delegate respondsToSelector:@selector(expandedScrollView:didSelectItemAtIndex:inSubExpandedContainerView:subItemAtIndex:)]) {
            [self.delegate expandedScrollView:self didSelectItemAtIndex:self.selectedIndex inSubExpandedContainerView:nil subItemAtIndex:nil];
        }
    }
}

- (void)showExpandedView:(ESExpandedContainerView *)containerView shouldSelectIndex:(ESGridIndex *)subIndex {
    containerView.alpha = 0;
    [containerView reloadData];
    [containerView layoutIfNeeded];
    [self.expandedView selectItemViewForIndex:subIndex];
 
    [self updateScrollViewFrameWithAnimated:YES completionBlock:nil];
    
    [UIView animateWithDuration:0.2 animations:^{
        containerView.alpha = 1;
    } completion:nil];
    
    self.expandedView = containerView;
}


- (void)updateScrollViewFrameWithAnimated:(BOOL)animated completionBlock:(void(^)(BOOL finished))completionBlock {
    if (animated) {
        [UIView animateWithDuration:0.2 animations:^{
            [self layoutIfNeeded];
            CGRect frame = self.frame;
            if (self.contentSize.height < self.maxHeight) {
                frame.size.height = self.contentSize.height;
            } else {
                frame.size.height = self.maxHeight;
            }
            self.frame = frame;
        } completion:completionBlock];
    } else {
        [self layoutIfNeeded];
        CGRect frame = self.frame;
        if (self.contentSize.height < self.maxHeight) {
            frame.size.height = self.contentSize.height;
        } else {
            frame.size.height = self.maxHeight;
        }
        self.frame = frame;
        if (completionBlock) {
            completionBlock(YES);
        }
    }
}

#pragma mark - ESExpandedContainerViewDataSource

- (NSInteger)numberOfItemsInExpandedContainerView:(ESExpandedContainerView *)containerView {
    return [self.dataSource numberOfItemsInSubExpandedContainerView:containerView itemAtIndex:self.selectedIndex inExpandedScrollView:self];
}
- (ESExpandedItemView *)expandedContainerView:(ESExpandedContainerView *)containerView cellForItemAtIndex:(ESGridIndex *)index {
    return [self.dataSource subExpandedContainerView:containerView cellForItemAtIndex:index inExpandedScrollView:self];
}

#pragma mark - ESExpandedContainerViewDelegate 

- (void)expandedContainerView:(ESExpandedContainerView *)containerView didSelectItemAtIndex:(ESGridIndex *)index {
    self.subSelectedIndex = index;
    if (self.delegate && [self.delegate respondsToSelector:@selector(expandedScrollView:didSelectItemAtIndex:inSubExpandedContainerView:subItemAtIndex:)]) {
        [self.delegate expandedScrollView:self didSelectItemAtIndex:self.selectedIndex inSubExpandedContainerView:containerView subItemAtIndex:index];
    }
}

@end
