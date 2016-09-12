//
//  SwiftTestLeftViewController.swift
//  QQSlideViewController
//
//  Created by Charles on 16/9/12.
//  Copyright © 2016年 Charles. All rights reserved.
//

import UIKit

class SwiftTestLeftViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let label = UILabel()
        self.view.addSubview(label)
        label.frame = CGRectMake(30, 100, 80, 300)
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFontOfSize(18)
        label.text = "这里是Swift版本的侧滑，点击此按钮进入OC版本的侧滑"
        label.userInteractionEnabled = true
        label.backgroundColor = UIColor.redColor()
        label.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action:  #selector(self.tapGest(_:))))
    }
    
    @objc private func tapGest(tap: UITapGestureRecognizer) {
        let ocTestLeft = TestLeftViewController()
        ocTestLeft.view.backgroundColor = UIColor(red: 0.38, green: 0.38, blue: 0.38, alpha: 1.0)
        
        let ocV1 = UIViewController()
        ocV1.view.backgroundColor = UIColor.redColor()
        ocV1.title = "第一个"
        
        let ocV2 = UIViewController()
        ocV2.view.backgroundColor = UIColor.blueColor()
        ocV2.title = "第二个"
        
        let tabbarVc = UITabBarController()
        tabbarVc.viewControllers = [ocV1, ocV2]
        
        let swiftSlideRoot = UIApplication.sharedApplication().keyWindow?.rootViewController as! SwiftSlideRootViewController
        swiftSlideRoot.slideBack()
        
        let ocSlide = SlideRootViewController.init(leftVC: ocTestLeft, mainVC: tabbarVc, slideTranslationX: 80)
        self.presentViewController(ocSlide, animated: true, completion: nil)
        
        
    }
    
    

}
