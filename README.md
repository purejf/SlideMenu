

####先来两个gif图
![侧滑gifoc和swift.gif](http://upload-images.jianshu.io/upload_images/939127-c0a6ca6cbf0aa7ac.gif?imageMogr2/auto-orient/strip)
![侧滑gifoc和swift3.gif](http://upload-images.jianshu.io/upload_images/939127-f3832de7abfbbb9e.gif?imageMogr2/auto-orient/strip)


####这个侧滑抽屉Demo中包含了Swift版本和OC版本。
#####文件目录
![文件.png](http://upload-images.jianshu.io/upload_images/939127-fc83e759158eb613.png?imageMogr2/auto-orient/strip%7CimageView2/2/w/1240)

####部分代码
#####部分Swift
``` 
    /**
     侧滑
     */
    func slideToLeft() {
        self.updateContransWithTransX(self.slideTranlationX, animated: true)
    }
    
    /**
     返回初始样式
     */
    func slideBack() {
        self.updateContransWithTransX(0, animated: true)
    }
    
    func updateContransWithTransX(tx: CGFloat, animated: Bool)  {
        self.trans = tx
        if animated == true { // 有动画
            
            UIView.animateWithDuration(NSTimeInterval(kAnimationDuration), animations: {
                
                self.mainVc.view.x = self.trans
                self.mainVc.view.alpha = (kScreenWidth - self.trans * 0.5 ) / kScreenWidth * 1.0
                let scale: CGFloat = 1.0 - 0.1 * self.trans / CGFloat(self.slideTranlationX)
                self.leftVc.view.transform = CGAffineTransformMakeScale(scale, scale)
                }, completion: { (_) in
                    
                    if self.trans == self.slideTranlationX {
                        self.addCover()
                    } else {
                        var button = self.mainVc.view.viewWithTag(101) as? UIButton
                        button?.removeFromSuperview()
                        button = nil
                    } 
            })
            
        } else { // 无动画
            self.mainVc.view.x = self.trans
            self.mainVc.view.alpha = (kScreenWidth - self.trans * 0.5 ) / kScreenWidth * 1.0
            let scale: CGFloat = 1.0 - 0.1 * self.trans / CGFloat(self.slideTranlationX)
            self.leftVc.view.transform = CGAffineTransformMakeScale(scale, scale)
            
            if self.trans == self.slideTranlationX {
                self.addCover()
            } else {
                var button = self.mainVc.view.viewWithTag(101) as? UIButton
                button?.removeFromSuperview()
                button = nil
            }
        }
    } 
    /**
     滑动手势响应
     */
    func panGest(gest: UIPanGestureRecognizer) {
        if self.mainVc.view.x == self.slideTranlationX {
            let point = gest.locationInView(view)
            if CGRectContainsPoint(CGRectMake(0, 0, self.slideTranlationX, kScreenHeight), point) {
                return ;
            }
        }
        if gest.view!.isEqual(self.view) == false {
            return ;
        }
        
        if gest.state == .Began || gest.state == .Changed {
            let translation = gest.translationInView(view)
            if translation.x < 0 {
                // 左滑
                if self.mainVc.view.x >= 0 {
                    self.trans += translation.x
                    if self.trans < kMainViewOriginTransX {
                        self.trans = kMainViewOriginTransX
                    }
                    
                    self.updateContransWithTransX(self.trans, animated: false)
                }
            } else {
                // 右滑
                self.trans += translation.x
                if self.trans > self.slideTranlationX {
                    self.trans = self.slideTranlationX
                }
                self.updateContransWithTransX(self.trans, animated: false)
            }
            gest.setTranslation(CGPointZero, inView: view)
            
        }
        if gest.state == .Ended {
            
            if self.trans > self.slideTranlationX * 0.5 && trans <= self.slideTranlationX {
                self.trans = self.slideTranlationX
                self.updateContransWithTransX(self.trans, animated: true)
            } else if (self.trans <= self.slideTranlationX * 0.5) {
                self.trans = kMainViewOriginTransX
                self.updateContransWithTransX(self.trans, animated: true)
            }
        }
    }
```

#####部分OC代码
``` 
/**
 *  打开抽屉
 */
- (void)slideToLeft {
    [self updateContrantsWithTransX:_slideTranslationX animated:YES];
}

/**
 *  返回初始样式
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
            CGFloat scale =  1 - 0.10 * transX / _slideTranslationX;
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
        CGFloat scale =  1 - 0.10 * transX / _slideTranslationX;
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
``` 
###另外，在空余时间我还高仿了一个内涵段子，如果有兴趣的话，可以点击此链接   高仿内涵段子：Github地址：[https://github.com/Charlesyaoxin/NeiHanDuanZI](https://github.com/Charlesyaoxin/NeiHanDuanZI)
##[10天时间高仿内涵段子app，一个你值得收藏的Demo源码](https://github.com/Charlesyaoxin/NeiHanDuanZI)
