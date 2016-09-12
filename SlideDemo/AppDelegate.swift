//
//  AppDelegate.swift
//  SlideDemo
//
//  Created by Charles on 16/9/12.
//  Copyright © 2016年 Charles. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.backgroundColor = UIColor.whiteColor()
        let ocTestLeft = SwiftTestLeftViewController()
        ocTestLeft.view.backgroundColor = UIColor(red: 0.38, green: 0.38, blue: 0.38, alpha: 1.0)
        
        let ocV1 = UIViewController()
        ocV1.view.backgroundColor = UIColor.redColor()
        ocV1.title = "第一个"
        let ocV2 = UIViewController()
        ocV2.view.backgroundColor = UIColor.blueColor()
        ocV2.title = "第二个"
        let tabbarVc = UITabBarController()
        tabbarVc.viewControllers = [ocV1, ocV2]
        
        let ocSlide = SwiftSlideRootViewController.init(leftVc: ocTestLeft, mainVc: tabbarVc, slideTranlationX: 200.0)
        self.window?.rootViewController = ocSlide
        
        self.window?.makeKeyAndVisible()
        return true
    }
 
}

