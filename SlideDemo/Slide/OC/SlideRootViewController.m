//
//  SlideRootViewController.m
//  QQSlideViewController
//
//  Created by Charles on 16/9/12.
//  Copyright © 2016年 Charles. All rights reserved.
//

#import "SlideRootViewController.h"
#import "UIView+Frame.h"

#define kAnimationDuration 0.3
#define kMainViewOriginTransX 0
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@implementation SlideRootViewController {
    CGFloat _slideTranslationX;
}

/**
 *  构造方法 ： 初始化控制器
 *
 *  @param leftController 左控制器
 *  @param mainController 主控制器
 *  @param slideTranslationX  抽屉宽度，默认为200，最大为200，最小为100
 */
- (instancetype)initWithLeftVC:(UIViewController *)leftController
                        mainVC:(UIViewController *)mainController
             slideTranslationX:(CGFloat)slideTranslationX {
    
    self = [super init];
    if (self) {
        
        // 默认为200宽度，小于100为100，大于200为200
        _slideTranslationX = 200;
        
        if (_slideTranslationX < 200 || _slideTranslationX == 0) {
            _slideTranslationX = 200;
        }
        if (_slideTranslationX > 0 && _slideTranslationX < 100) {
            _slideTranslationX = 100;
        }
        [self addChildViewController:leftController];
        [self addChildViewController:mainController];
        _leftV = leftController;
        _mainV = mainController;
        
    }
    return self;
}
/**
 *  重写
 */
- (void)loadView {
    [super loadView];
    
    [self.view addSubview:_leftV.view];
    [self.view addSubview:_mainV.view]; 
    _leftV.view.frame = CGRectMake(kMainViewOriginTransX, 0, _slideTranslationX, kScreenHeight);
    _mainV.view.frame = self.view.bounds;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 添加侧滑手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGest:)];
    [self.view addGestureRecognizer:pan];
}

/**
 *  打开抽屉
 */
- (void)slideToLeft {
    [self updateContrantsWithTransX:_slideTranslationX animated:YES];
}

/**
 *  返回初始样式
 */
- (void)slideBack {
    [self updateContrantsWithTransX:0 animated:YES];
}

// 侧滑
- (void)updateContrantsWithTransX:(CGFloat)tX
                         animated:(BOOL)animated {
    transX = tX;
    if (animated) {
        [UIView animateWithDuration:kAnimationDuration animations:^{
            [self.mainV.view setX:transX];
            self.mainV.view.alpha = (kScreenWidth - transX * 0.5) / kScreenWidth * 1.0f;
            CGFloat scale =  1 - 0.10 * transX / _slideTranslationX;
            self.leftV.view.transform = CGAffineTransformMakeScale(scale, scale);
            
        } completion:^(BOOL finished) {
            if (finished) {
                if (transX == _slideTranslationX) {
                    [self addCover];
                } else {
                    UIButton *button = (UIButton *)[self.mainV.view viewWithTag:101];
                    [button removeFromSuperview];
                    button = nil;
                }
            }
        }];
    } else {
        [self.mainV.view setX:transX];
        self.mainV.view.alpha = (kScreenWidth - transX * 0.5) / kScreenWidth * 1.0f;
        CGFloat scale =  1 - 0.10 * transX / _slideTranslationX;
        self.leftV.view.transform = CGAffineTransformMakeScale(scale, scale);
        
        if (transX == _slideTranslationX) {
            [self addCover];
        } else {
            UIButton *button = (UIButton *)[self.mainV.view viewWithTag:101];
            [button removeFromSuperview];
            button = nil;
        }
    }
    
}

int transX = 0;
- (void)panGest:(UIPanGestureRecognizer *)gest {
    
    if (self.mainV.view.x == _slideTranslationX) {
        CGPoint point = [gest locationInView:self.view];
        if (CGRectContainsPoint(CGRectMake(0, 0, _slideTranslationX, kScreenHeight), point)) {
            return ;
        }
    }
    if (![gest.view isEqual:self.view]) {
        return ;
    }
    if (gest.state == UIGestureRecognizerStateBegan || gest.state == UIGestureRecognizerStateChanged) {
        
        CGPoint translation = [gest translationInView:self.view];
        
        if (translation.x < 0) { // 左滑
            if (self.mainV.view.x >= 0) {
                transX += translation.x;
                if (transX < kMainViewOriginTransX) {
                    transX = kMainViewOriginTransX;
                }
                [self updateContrantsWithTransX:transX animated:NO];
            }
        } else { // 右滑
            
            transX +=translation.x;
            
            if (transX > _slideTranslationX) {
                transX = _slideTranslationX;
            }
            [self updateContrantsWithTransX:transX animated:NO];
        }
        // 重置滑动距离
        [gest setTranslation:CGPointZero inView:self.view];
    }
    if (gest.state == UIGestureRecognizerStateEnded) {
        
        if (transX > _slideTranslationX * 0.5 && transX <= _slideTranslationX) {
            transX = _slideTranslationX;
            [self updateContrantsWithTransX:transX animated:YES];
        } else if (transX <= _slideTranslationX * 0.5) {
            transX = kMainViewOriginTransX;
            [self updateContrantsWithTransX:transX animated:YES];
        }
    }
}

/**
 *  添加遮罩
 */
- (void)addCover {
    
    if ([self.mainV.view viewWithTag:101]) {
        return ;
    }
    
    UIButton *button = [[UIButton alloc] init];
    button.tag = 101;
    [self.mainV.view addSubview:button];
    [button setFrame:self.mainV.view.bounds];
    [button addTarget:self action:@selector(backBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
}

/**
 *  点击遮罩
 */
- (void)backBtnTouch:(UIButton *)btn {
    if (self.mainV.view.x < _slideTranslationX) {
        return ;
    }
    [self updateContrantsWithTransX:kMainViewOriginTransX animated:YES];
}
@end
