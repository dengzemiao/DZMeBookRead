//
//  DZMHaloButton.swift
//  DZMeBookRead
//
//  Created by 邓泽淼 on 2017/3/24.
//  Copyright © 2017年 DZM. All rights reserved.
//

import UIKit

/* imageView 四周默认间距为 HJSpace_3 算宽高的时候记得加上 用于光晕范围*/

class DZMHaloButton: UIControl {

    /// imageView
    private(set) var imageView:UIImageView!
    
    /// 光晕颜色
    private(set) var haloColor:UIColor!
    
    /// 默认图片
    var nomalImage:UIImage?
    
    /// 选中图片
    var selectImage:UIImage?
    
    /// 选中
    override var isSelected: Bool {
        
        didSet{
            
            if isSelected {
                
                if selectImage != nil {
                    
                    imageView.image = selectImage
                }
                
            }else{
                
                if nomalImage != nil {
                    
                    imageView.image = nomalImage
                }
            }
        }
    }
    
    /// 初始化方法
    init(_ frame: CGRect, haloColor:UIColor) {
        
        super.init(frame: frame)
        
        // 记录
        self.haloColor = haloColor
        
        // 添加
        addSubviews()
        
        // 开启光晕
        openHalo(haloColor)
    }
    
    /// 通过正常的Size返回对应的按钮大小
    class func HaloButtonSize(_ size:CGSize) ->CGSize {
        
        return CGSize(width: size.width + DZMSpace_5, height: size.height + DZMSpace_5)
    }
    
    /// 开启光晕
    func openHalo(_ haloColor:UIColor?) {
        
        if haloColor != nil {
            
            self.haloColor = haloColor;
            
            // 开启按钮闪动
            imageView.startPulse(with: haloColor, scaleFrom: 1.0, to: 1.2, frequency: 1.0, opacity: 0.5, animation: .regularPulsing)
        }
    }
    
    // 关闭光晕
    func closeHalo() {
        
        imageView.stopPulse()
    }
    
    private func addSubviews() {
        
        // imageView
        imageView = UIImageView()
        imageView.backgroundColor = haloColor
        imageView.contentMode = .center
        addSubview(imageView)
        
        // 布局
        setFrame()
    }
    
    private func setFrame() {
        
        // 布局
        imageView.frame = CGRect(x: DZMSpace_4, y: DZMSpace_4, width: width - DZMSpace_5, height: height - DZMSpace_5)
        
        // 圆角
        imageView.layer.cornerRadius = (width - DZMSpace_5) / 2
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        setFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
