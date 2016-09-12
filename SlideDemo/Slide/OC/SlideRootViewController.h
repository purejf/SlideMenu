//
//  SlideRootViewController.h
//  QQSlideViewController
//
//  Created by Charles on 16/9/12.
//  Copyright © 2016年 Charles. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideRootViewController : UIViewController

/**
 *  左控制器
 */
@property (nonatomic, weak)  UIViewController *leftV;

/**
 *  主控制器
 */
@property (nonatomic, weak)  UIViewController *mainV;

/**
 *  构造方法 ： 初始化控制器
 *  @param leftController 左控制器
 *  @param mainController 主控制器
 *  @param slideTranslationX  抽屉宽度，默认为200，最大为200，最小为100
 */
- (instancetype)initWithLeftVC:(UIViewController *)leftController
                        mainVC:(UIViewController *)mainController
             slideTranslationX:(CGFloat)slideTranslationX;
 

/**
 *  侧滑抽屉
 */
- (void)slideToLeft;

/**
 *  返回初始样式
 */
- (void)slideBack;
@end
