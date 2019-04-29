//
//  DZMReadViewBGController.swift
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/4/24.
//  Copyright © 2019年 DZM. All rights reserved.
//

import UIKit

class DZMReadViewBGController: DZMViewController {

    /// 当前页阅读记录
    var recordModel:DZMReadRecordModel!
    
    /// 目标视图(无值则跟阅读背景颜色保持一致)
    var targetView:UIView!
    
    /// imageView
    private var imageView:UIImageView!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // imageView
        imageView = UIImageView()
        imageView.backgroundColor = DZMReadConfigure.shared().bgColor
        view.addSubview(imageView)
        imageView.frame = view.bounds
        
        // 显示背面
//        funcOne()
        funcTwo()
        
        // 清空视图
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
