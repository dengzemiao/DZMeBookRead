//
//  HJNavigationController.swift
//  HJProject
//
//  Created by 邓泽淼 on 16/8/1.
//  Copyright © 2016年 HanJue. All rights reserved.
//

import UIKit

class HJNavigationController: UINavigationController {

    
    override class func initialize(){
        
        // 重载导航条属性
        HJNavigationController.setupNavBarTheme()
        
    }
    
    
    /// 设置导航栏
    class func setupNavBarTheme(){
        
        // 取出appearance对象
        let navBar:UINavigationBar = UINavigationBar.appearance()
        
//        if iOS7 {
//            navBar.setBackgroundImage(UIImage(named: "NavBar_bg"), forBarMetrics: UIBarMetrics.Default)
//        }
        
        // 设置标题属性
        let textAttrs:NSDictionary = [NSForegroundColorAttributeName:HJColor_4,NSFontAttributeName:UIFont.systemFont(ofSize: 18)]
        
        navBar.titleTextAttributes = textAttrs as? [String : AnyObject]
    }
    
    /// 设置Item属性
    class func setupBarButtonItemTheme() {
        
        let item = UIBarButtonItem.appearance()
        
        // 设置文字属性
        let textAttrs = [NSForegroundColorAttributeName:UIColor.black,NSFontAttributeName:UIFont.systemFont(ofSize: 18)]
        
        item.setTitleTextAttributes(textAttrs, for: UIControlState())
    }
    
    // MARK: -- 拦截Push
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        
        if viewControllers.count > 0 {
            
            viewController.hidesBottomBarWhenPushed = true
            
            viewController.navigationItem.leftBarButtonItem = UIBarButtonItem.AppNavigationBarBackItemOne(UIEdgeInsetsMake(0, 0, 0, 0), target: self, action: #selector(HJNavigationController.clickBack))
        }
        
        super.pushViewController(viewController, animated: animated)
    }
    
    /// 点击返回方法
    func clickBack() {
        popViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
