//
//  DZMViewController.swift
//  DZMeBookRead
//
//  Created by 邓泽淼 on 2017/5/11.
//  Copyright © 2017年 DZM. All rights reserved.
//

import UIKit

class DZMViewController: UIViewController {

    /// 状态栏是否显示白色
    var isStatusBarLightContent:Bool = false {
        
        didSet{
            
            if isStatusBarLightContent != oldValue {
                
                setStatusBarStyle()
            }
        }
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // backgroundColor
        view.backgroundColor = UIColor.white
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
      
        // 设置状态栏颜色
        setStatusBarStyle()
    }
    
    /// 设置状态栏颜色
    private func setStatusBarStyle() {
        
        if isStatusBarLightContent {
            
            UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.lightContent, animated: true)
            
        }else{
            
            UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: true)
        }
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
}
