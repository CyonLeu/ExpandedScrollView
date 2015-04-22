//
//  ESExpandedArrowView.m
//
//
//  Created by CyonLeu on 15/3/25.
//  Copyright (c) 2015年 Netease. All rights reserved.
//

#import "ESExpandedArrowView.h"

@implementation ESExpandedArrowView

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setupView];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupView];
    }
    return self;
}

- (void)setupView {
    self.fillColor = [UIColor colorWithWhite:0 alpha:0.4];
    self.backgroundColor = [UIColor clearColor];
}

- (void)drawRect:(CGRect)rect {
    //拿到当前视图准备好的画板
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //利用path进行绘制三角形
    CGContextBeginPath(context);//标记
    CGContextMoveToPoint(context, CGRectGetWidth(self.bounds)/2, 0);//设置起点
    CGContextAddLineToPoint(context, 0, CGRectGetHeight(self.bounds));
    CGContextAddLineToPoint(context, CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
    CGContextClosePath(context);//路径结束标志，不写默认封闭
    [self.fillColor setFill];

    CGContextDrawPath(context, kCGPathFill);//绘制路径path
}


@end
