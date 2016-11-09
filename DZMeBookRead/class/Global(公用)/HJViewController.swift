//
//  HJViewController.swift
//  HJProject
//
//  Created by 邓泽淼 on 16/8/1.
//  Copyright © 2016年 HanJue. All rights reserved.
//

import UIKit

class HJViewController: UIViewController {
    
    // MARK: -- 返回手势
    var openInteractivePopGestureRecognizer:Bool = true {  // 是否开启返回手势 当有导航栏的时候
        
        didSet{
            
            navigationController?.interactivePopGestureRecognizer?.isEnabled = openInteractivePopGestureRecognizer
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.white
        
        // 控件想要从00开始需要设置这两个属性
        // 显示状态栏 加上这句可以全部从00开始 设置隐藏显示导航栏全部控件不会移动  不加上 全部视图控件则会根据是否有导航栏自己上下调整位置
        //        extendedLayoutIncludesOpaqueBars = true
        
        // 有滚动的控件想要00从状态栏开始需要设置该属性为false
        automaticallyAdjustsScrollViewInsets = false
        
        // 初始化导航栏 子控件
        initNavigationBarSubviews()
        
        // 添加子控件
        addSubviews()
    }
    
    /// 添加子控件
    func addSubviews(){
        
        // 返回手势
        navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
    }
    
    /// 初始化导航栏
    func initNavigationBarSubviews(){
        
    }
    
    /// 点击返回方法
    func clickBack() {
        
       let _ = navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // 记录当前显示的控制器
        HJManager.shareManager.displayController = self
        
        // 删除系统自动生成的UITabBarButton
        deleteItem()
    }
    
    // 删除可能会出现的Item
    func deleteItem() {
        
        if (self.tabBarController != nil) {
            
            for child:UIView in self.tabBarController!.tabBar.subviews {
                
                if child.isKind(of: UIControl.self){
                    
                    child.removeFromSuperview()
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
