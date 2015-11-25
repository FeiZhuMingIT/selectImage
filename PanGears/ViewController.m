//
//  ViewController.m
//  PanGears
//
//  Created by WZZ on 15/11/25.
//  Copyright © 2015年 晓志. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property(nonatomic,weak) UIImageView *imageView0;

@property(nonatomic,weak) UIImageView *imageView;

@property(nonatomic,weak) UIImageView *moveImage;

@property(nonatomic,weak) UIImageView *goalView;

@property(nonatomic,weak) UIButton *clearBtn;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupSubView];
    
}


- (void)setupSubView {
    
    // 目标ImageView
    UIImageView * goalView= [[UIImageView alloc] initWithFrame:CGRectMake(100, 300, 200, 200)];
    goalView.layer.borderWidth = 5;
    goalView.layer.borderColor = [UIColor blackColor].CGColor;
    goalView.layer.cornerRadius = 100;
    goalView.layer.masksToBounds = YES;
    self.goalView = goalView;
    [self.view addSubview:goalView];
    
    // 头像imageView
    UIImageView *imageView0 = [[UIImageView alloc] initWithFrame:CGRectMake(50, 100, 100, 100)];
    imageView0.image = [UIImage imageNamed:@"2"];
    imageView0.layer.cornerRadius = 50;
    imageView0.userInteractionEnabled = YES;
    imageView0.clipsToBounds = YES;
    UIPanGestureRecognizer *pan0 = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panselection:)];
    imageView0.gestureRecognizers = @[pan0];
    [self.view addSubview:imageView0];
    self.imageView0 = imageView0;
    
    // 头像imageView
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(200, 100, 100, 100)];
    imageView.image = [UIImage imageNamed:@"1"];
    imageView.layer.cornerRadius = 50;
    imageView.userInteractionEnabled = YES;
    imageView.clipsToBounds = YES;
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panselection:)];
    imageView.gestureRecognizers = @[pan];
    [self.view addSubview:imageView];
    self.imageView = imageView;
    
    // 移动的moveImage
    UIImageView *moveImage = [[UIImageView alloc] initWithFrame:CGRectMake(100, 100, 100, 100)];
    moveImage.layer.cornerRadius = 50;
    moveImage.userInteractionEnabled = YES;
    moveImage.clipsToBounds = YES;
    [self.view addSubview:moveImage];
    self.moveImage = moveImage;
    self.moveImage.hidden = YES;
    
    UIButton *clearBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 30, 60, 40)];
    [clearBtn setTitle:@"清除" forState:UIControlStateNormal];
    clearBtn.backgroundColor = [UIColor orangeColor];
    self.clearBtn = clearBtn;
    [self.clearBtn addTarget:self action:@selector(clearBtnDidClear) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:self.clearBtn];
    
}

- (void)panselection:(UIPanGestureRecognizer *)panGestureRecognizer {
    
    CGPoint point = [panGestureRecognizer translationInView:self.view];
    //找到当前点击的view
    UIImageView* originImageView = (UIImageView*)panGestureRecognizer.view;
    NSLog(@"%@",NSStringFromCGPoint(point));
    if (panGestureRecognizer.state == UIGestureRecognizerStateBegan) {
        self.moveImage.image = originImageView.image;
        // 解决闪烁问题
        self.moveImage.frame = originImageView.frame;
        self.moveImage.hidden = NO;
    }
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateChanged) {
        
        // 找到当前点击的view相对与controler的位置, 因为如果直接使用originImageView的frame是不对的
//        CGPoint imageViewPoint = [self.view convertPoint:originImageView.center fromView:originImageView];
        self.moveImage.center = CGPointMake(originImageView.center.x + point.x, originImageView.center.y + point.y);
    }
    
    if (panGestureRecognizer.state == UIGestureRecognizerStateEnded) {
        self.moveImage.hidden = YES;
        // 判断是否当前移动的点是否在圈内
        if ([self circleFrame:self.goalView.frame constanFrame:self.moveImage.frame]) {
            self.goalView.image = originImageView.image;
        }
    }
}

- (BOOL)circleFrame:(CGRect)cirCleFrame constanFrame:(CGRect)otherCircleFrame {
    
    CGFloat xMargin = cirCleFrame.origin.x - otherCircleFrame.origin.x;
    CGFloat yMargin = cirCleFrame.origin.y - otherCircleFrame.origin.y;
    CGFloat distance = sqrtf(xMargin * xMargin + yMargin * yMargin);
    
    if (distance < cirCleFrame.size.width - otherCircleFrame.size.width) {
        return YES;
    }
    
    return NO;
}

#pragma mark - 清楚按钮

- (void)clearBtnDidClear {
    self.goalView.image = nil;
}

@end
