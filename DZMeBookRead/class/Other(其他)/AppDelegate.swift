//
//  AppDelegate.swift
//  DZMeBookRead
//
//  Created by 邓泽淼 on 16/8/31.
//  Copyright © 2016年 DZM. All rights reserved.
//

import UIKit

@objc protocol HJAppDelegate:NSObjectProtocol {
    
    /// 程序即将退出
    optional func applicationWillTerminate(application: UIApplication)
    
    /// 内存警告可能要终止程序
    optional func applicationDidReceiveMemoryWarning(application: UIApplication)
    
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var delegate:HJAppDelegate?
    
    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // 允许获取电量
        UIDevice.currentDevice().batteryMonitoringEnabled = true
        
        // 显示状态栏
        application.setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Fade)
        
        window = UIWindow(frame:UIScreen.mainScreen().bounds)
        
        window!.makeKeyAndVisible()
        
        // 设置RootVC
        let vc = HJMainViewController()
        
        let navVC = UINavigationController(rootViewController:vc)
        
        window!.rootViewController = navVC
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    /// 程序即将退出
    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        
        delegate?.applicationWillTerminate?(application)
    }
    
    /// 内存警告可能要终止程序
    func applicationDidReceiveMemoryWarning(application: UIApplication) {
        
        delegate?.applicationDidReceiveMemoryWarning?(application)
    }

}

