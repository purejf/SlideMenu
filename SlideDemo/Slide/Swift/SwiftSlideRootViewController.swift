//
//  SwiftLideRootViewController.swift
//  QQSlideViewController
//
//  Created by Charles on 16/9/12.
//  Copyright © 2016年 Charles. All rights reserved.
//

import UIKit

let kScreenWidth: CGFloat = UIScreen.mainScreen().bounds.size.width
let kScreenHeight: CGFloat = UIScreen.mainScreen().bounds.size.height
let kAnimationDuration: CGFloat = 0.3
let kMainViewOriginTransX: CGFloat = 0.0

class SwiftSlideRootViewController: UIViewController {
    
    var trans: CGFloat = 0.0
    
    var leftVc: UIViewController!
    var mainVc: UIViewController!
    var slideTranlationX: CGFloat = 0.0
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /**
     构造方法
     */
    init(leftVc: UIViewController, mainVc: UIViewController, slideTranlationX: CGFloat) {
        
        super.init(nibName: nil, bundle: nil)
        
        self.slideTranlationX = 200
        if (slideTranlationX < 200 || slideTranlationX == 0) {
            self.slideTranlationX = 200
        }  else if (slideTranlationX > 0 && slideTranlationX < 100) {
            self.slideTranlationX = 100
        }
        self.addChildViewController(leftVc)
        self.addChildViewController(mainVc)
        
        self.leftVc = leftVc
        self.mainVc = mainVc
        
        
    }
    
    
    override func loadView() {
        super.loadView()
        
        view.addSubview(self.leftVc!.view)
        view.addSubview(self.mainVc!.view)
        
        self.leftVc.view.frame = CGRectMake(kMainViewOriginTransX, 0, self.slideTranlationX, self.view.height)
        self.mainVc.view.frame = view.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 添加手势
        let pan = UIPanGestureRecognizer(target: self, action: #selector(self.panGest(_:)))
        view.addGestureRecognizer(pan)
        
        
    }
    
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
    
    func updateContransWithTransX(tx: CGFloat, animated: Bool)  {
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
    
    func addCover() {
        
        if (self.mainVc.view.viewWithTag(101) != nil) {
            return ;
        }
        
        let button = UIButton(type: .Custom)
        button.tag = 101
        mainVc.view.addSubview(button)
        button.frame = mainVc.view.bounds
        button.addTarget(self, action: #selector(self.backBtnTouch(_:)), forControlEvents: .TouchUpInside)
    }
    
    /**
     点击遮罩
     */
    func backBtnTouch(btn: UIButton) {
        if mainVc.view.x < self.slideTranlationX {
            return ;
        }
        self.updateContransWithTransX(kMainViewOriginTransX, animated: true)
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
}