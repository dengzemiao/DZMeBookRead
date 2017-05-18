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
        
        // 控件想要从00开始需要设置这两个属性
        // 显示状态栏 加上这句可以全部从00开始 设置隐藏显示导航栏全部控件不会移动  不加上 全部视图控件则会根据是否有导航栏自己上下调整位置
        // extendedLayoutIncludesOpaqueBars = true
        
        // 有滚动的控件想要00从状态栏开始需要设置该属性为false
        // automaticallyAdjustsScrollViewInsets = false
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
