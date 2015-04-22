//
//  ESExpandedViewController.m
//
//
//  Created by CyonLeu on 15/3/18.
//  Copyright (c) 2015年 CyonLeuInc. All rights reserved.
//

#import "ESExpandedViewController.h"

#import "ESExpandedScrollView.h"

@interface ESExpandedViewController ()<ESExpandedScrollViewDataSource, ESExpandedScrollViewDelegate>

@property (nonatomic, strong) ESExpandedScrollView *expandedScrollView;
@property (nonatomic, strong) UIView *containerView;

@end

@implementation ESExpandedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"下拉菜单" style:UIBarButtonItemStylePlain target:self action:@selector(showDropdownMenu)];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(dismissVC)];
    
    self.containerView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.containerView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
    [self.view addSubview:self.containerView];
    self.containerView.alpha = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)showDropdownMenu {
    
    ESExpandedScrollView *scrollView = [[ESExpandedScrollView alloc] initWithFrame:self.view.bounds];
//    [self.view addSubview:scrollView];
    [self.containerView addSubview:scrollView];
    scrollView.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
    scrollView.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), 500);
    scrollView.maxHeight = CGRectGetHeight(self.view.bounds);
    scrollView.dataSource = self;
    scrollView.delegate = self;
    scrollView.expandedViewColor = [UIColor colorWithWhite:0.5 alpha:1];
    scrollView.expandedArrowImage = [UIImage imageNamed:@"menu_arrow_down"];
    
    self.expandedScrollView = scrollView ;
    
    [self.expandedScrollView reloadData];
    
    CGSize cSize = self.expandedScrollView.contentSize;
    
    CGRect frame = self.expandedScrollView.frame;
    if (cSize.height > CGRectGetHeight(self.view.bounds)) {
        frame.size.height = CGRectGetHeight(self.view.bounds);
    } else {
        frame.size.height = cSize.height;
    }
    
    CGRect beforeFrame = frame;
    beforeFrame.origin.y = - CGRectGetHeight(frame);
    self.expandedScrollView.frame = beforeFrame;
    
    self.containerView.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.containerView.alpha = 1;
        self.expandedScrollView.frame = frame;
    } completion:^(BOOL finished) {
        
    }];
    
 
}


- (void)dismissVC {
//    [self dismissViewControllerAnimated:YES completion:nil];
    CGRect beforeFrame = self.expandedScrollView.frame;
    beforeFrame.origin.y = - CGRectGetHeight(self.expandedScrollView.frame);
//    self.expandedScrollView.frame = beforeFrame;
    
    self.containerView.alpha = 1;
    [UIView animateWithDuration:0.3 animations:^{
        self.containerView.alpha = 0;
        self.expandedScrollView.frame = beforeFrame;
    } completion:^(BOOL finished) {
        
    }];
}


#pragma mark -  ESExpandedScrollViewDataSource

- (NSInteger)numberOfItemsInExpandedScrollView:(ESExpandedScrollView *)scrollView {
    return 22;
}
- (ESExpandedItemView *)expandedScrollView:(ESExpandedScrollView *)scrollView cellForItemAtIndex:(ESGridIndex *)index {
    ESExpandedItemView *itemView = [self cellForItemAtIndex:index];

    NSString *title = [NSString stringWithFormat:@"item(%d,%d)", (int)index.row, (int)index.column];
    [itemView setTitle:title forState:UIControlStateNormal];
    
    return itemView;
}

//sub itemView

- (NSInteger)numberOfItemsInSubExpandedContainerView:(ESExpandedContainerView *)subContainerView itemAtIndex:(ESGridIndex *)index {
    return (4 + index.column);
}

- (BOOL)expandedScrollView:(ESExpandedScrollView *)scrollView shouldShowSubExpandedContainerViewAtIndex:(ESGridIndex *)index {
    if (index.row == 3) {
        return NO;
    }
    
    return YES;
}

- (ESExpandedItemView *)cellForItemAtIndex:(ESGridIndex *)index {
    ESExpandedItemView *itemView = [ESExpandedItemView buttonWithType:UIButtonTypeCustom];
    [itemView setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [itemView setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    itemView.titleLabel.font = [UIFont systemFontOfSize:14.f];
    
    [itemView setBackgroundImage:[UIImage imageNamed:@"btn_bg_normal"] forState:UIControlStateNormal];
    [itemView setBackgroundImage:[UIImage imageNamed:@"btn_bg_selected"] forState:UIControlStateHighlighted];
    [itemView setBackgroundImage:[UIImage imageNamed:@"btn_bg_selected"] forState:UIControlStateSelected];
    
    return itemView;
}

- (NSInteger)numberOfItemsInSubExpandedContainerView:(ESExpandedContainerView *)subContainerView itemAtIndex:(ESGridIndex *)index inExpandedScrollView:(ESExpandedScrollView *)scrollView {
    return 5 + index.column;
}

- (ESExpandedItemView *)subExpandedContainerView:(ESExpandedContainerView *)subContainerView cellForItemAtIndex:(ESGridIndex *)index inExpandedScrollView:(ESExpandedScrollView *)scrollView {
    ESExpandedItemView *itemView = [self cellForItemAtIndex:index];
    NSString *title = [NSString stringWithFormat:@"Exp(%d,%d)", (int)index.row, (int)index.column];
    [itemView setTitle:title forState:UIControlStateNormal];
    
    return itemView;
}

@end
