//
//  TestLeftViewController.m
//  QQSlideViewController
//
//  Created by Charles on 16/9/12.
//  Copyright © 2016年 Charles. All rights reserved.
//

#import "TestLeftViewController.h"

@interface TestLeftViewController ()

@end

@implementation TestLeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *label = [[UILabel alloc] init];
    label.frame = CGRectMake(0, 100, 80, 300);
    [self.view addSubview:label];
    [label setText:@"回到swift版本的侧滑"];
    label.font = [UIFont boldSystemFontOfSize:18];
    label.textColor = [UIColor redColor];
    label.userInteractionEnabled = YES;
    label.numberOfLines = 0;
    [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGest:)]];
}

- (void)tapGest:(UITapGestureRecognizer *)tapGest {
    [self dismissViewControllerAnimated:YES completion:nil];
}
 

@end
