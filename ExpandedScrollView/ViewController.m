//
//  ViewController.m
//  ExpandedScrollView
//
//  Created by CyonLeu on 15/4/22.
//  Copyright (c) 2015年 CyonLeuInc. All rights reserved.
//

#import "ViewController.h"
#import "ESExpandedViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onShowMenuButton:(id)sender {
    ESExpandedViewController *viewController = [[ESExpandedViewController alloc] initWithNibName:@"ESExpandedViewController" bundle:nil];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:viewController];
    [self presentViewController:navigationController animated:YES completion:nil];
}
@end
