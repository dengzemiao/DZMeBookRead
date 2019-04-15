//
//  DZMReadBGController.swift
//  DZMeBookRead
//
//  Created by 邓泽淼 on 2017/12/20.
//  Copyright © 2017年 DZM. All rights reserved.
//

import UIKit

class DZMReadBGController: UIViewController {

    /// 临时阅读记录
    var readRecordModel:DZMReadRecordModel!
    
    /// 目标视图(无值则跟阅读背景颜色保持一致)
    var targetView:UIView!
    
    /// 图片
    private var imageView:UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // imageView
        imageView = UIImageView()
        imageView.backgroundColor = DZMReadConfigure.shared().readColor()
        imageView.frame = view.bounds
        view.addSubview(imageView)
        
        // funcOne()
        
        funcTwo()
        
        // 释放对象
        targetView = nil
    }
    
    // MARK: 方式一
    
    /// 方式一
    private func funcOne() {
        
        // 展示图片
        if targetView != nil {
            
            imageView.layer.transform = CATransform3DMakeRotation(CGFloat.pi, 0, 1, 0)
            
            imageView.image = ScreenCapture(targetView)
        }
    }
    
    // MARK: 方式二
    
    /// 方式二
    private func funcTwo() {
        
        // 展示图片
        if targetView != nil {
            
            let rect = targetView.frame
            
            UIGraphicsBeginImageContextWithOptions(rect.size, true, 0.0)
            
            let context = UIGraphicsGetCurrentContext()
            
            let transform = CGAffineTransform(a: -1.0, b: 0.0, c: 0.0, d: 1.0, tx: rect.size.width, ty: 0.0)
            
            context?.concatenate(transform)
            
            targetView.layer.render(in: context!)
            
            imageView.image = UIGraphicsGetImageFromCurrentImageContext()
            
            UIGraphicsEndImageContext()
        }
    }

    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
}
