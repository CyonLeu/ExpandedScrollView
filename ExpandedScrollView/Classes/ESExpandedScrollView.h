//
//  ESExpandedScrollView.h
//
//
//  Created by CyonLeu on 15/3/18.
//  Copyright (c) 2015年 CyonLeuInc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <Masonry/Masonry.h>

#import "ESExpandedArrowView.h"

@interface ESGridIndex : NSObject

- (instancetype)initWithRow:(NSInteger)row column:(NSInteger)column;

@property (assign, nonatomic) NSInteger row;
@property (assign, nonatomic) NSInteger column;

@end

@interface ESExpandedItemView : UIButton

@property (strong, nonatomic) ESGridIndex *index;
@property (assign, nonatomic) CGFloat borderWidth;

@end

#pragma mark - ESExpandedContainerView

@class ESExpandedContainerView;

@protocol ESExpandedContainerViewDataSource <NSObject>

- (NSInteger)numberOfItemsInExpandedContainerView:(ESExpandedContainerView *)containerView;
- (ESExpandedItemView *)expandedContainerView:(ESExpandedContainerView *)containerView cellForItemAtIndex:(ESGridIndex *)index;

@end


@protocol ESExpandedContainerViewDelegate <NSObject>

@optional
- (void)expandedContainerView:(ESExpandedContainerView *)containerView didSelectItemAtIndex:(ESGridIndex *)index;


@end

@interface ESExpandedContainerView : UIView

@property (weak, nonatomic) id<ESExpandedContainerViewDataSource> dataSource;
@property (weak, nonatomic) id<ESExpandedContainerViewDelegate> delegate;


@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) ESExpandedArrowView *arrowView;

@property (strong, nonatomic) ESGridIndex *index;
@property (strong, nonatomic) ESGridIndex *selectedIndex;

@property (assign, nonatomic) CGSize itemSize;
@property (assign, nonatomic) CGFloat itemSpace;
@property (assign, nonatomic) CGSize mainItemSize;


@property (assign, nonatomic) NSInteger countOfColumns;


- (void)reloadData;
- (void)removeSubViewsWithAutoLayout;

- (void)selectItemViewForIndex:(ESGridIndex *)index;
- (void)deselectItemViewForIndex:(ESGridIndex *)index;

@end

#pragma mark - ESExpandedScrollView

@class ESExpandedScrollView;

@protocol ESExpandedScrollViewDataSource <NSObject>

- (NSInteger)numberOfItemsInExpandedScrollView:(ESExpandedScrollView *)scrollView;
- (ESExpandedItemView *)expandedScrollView:(ESExpandedScrollView *)scrollView cellForItemAtIndex:(ESGridIndex *)index;

//sub itemView

- (NSInteger)numberOfItemsInSubExpandedContainerView:(ESExpandedContainerView *)subContainerView itemAtIndex:(ESGridIndex *)index inExpandedScrollView:(ESExpandedScrollView *)scrollView;

- (ESExpandedItemView *)subExpandedContainerView:(ESExpandedContainerView *)subContainerView cellForItemAtIndex:(ESGridIndex *)index inExpandedScrollView:(ESExpandedScrollView *)scrollView;
- (BOOL)expandedScrollView:(ESExpandedScrollView *)scrollView shouldShowSubExpandedContainerViewAtIndex:(ESGridIndex *)index;

@end

@protocol ESExpandedScrollViewDelegate <UIScrollViewDelegate>

@optional

- (void)expandedScrollView:(ESExpandedScrollView *)scrollView didSelectItemAtIndex:(ESGridIndex *)index inSubExpandedContainerView:(ESExpandedContainerView *)subContainerView subItemAtIndex:(ESGridIndex *)subIndex;

@end

@interface ESExpandedScrollView : UIScrollView

@property (weak, nonatomic) id<ESExpandedScrollViewDataSource> dataSource;
@property (weak, nonatomic) id<ESExpandedScrollViewDelegate> delegate;

@property (assign, nonatomic) CGSize itemSize; //default is (80, 40)
@property (assign, nonatomic) CGFloat itemSpace; //default is 14
@property (assign, nonatomic) CGFloat maxHeight; //default is screenSize.height

@property (strong, nonatomic) UIColor *expandedViewColor; //[UIColor colorWithWhite:1 alpha:0.6]
@property (strong, nonatomic) UIImage *expandedArrowImage;

@property (assign, nonatomic) NSInteger countOfColumns; //default is 4
@property (assign, nonatomic) NSInteger subCountOfColumns; //default is 4

@property (assign, nonatomic) BOOL isExpanded; //default is NO
@property (strong, nonatomic) ESGridIndex *selectedIndex;
@property (strong, nonatomic) ESGridIndex *subSelectedIndex;

@property (assign, nonatomic) NSTimeInterval showExpandedViewAnimationDuration; //default is 0.3

- (void)cleanSubViews;
- (void)reloadData;

- (void)selectItemViewForIndex:(ESGridIndex *)index;
- (void)onTouchExpandedScrollViewItemView:(ESExpandedItemView *)itemView;

@end
