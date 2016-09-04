//
//  HJReadSettingView.swift
//  HJProject
//
//  Created by 邓泽淼 on 16/8/16.
//  Copyright © 2016年 HanJue. All rights reserved.
//

/// 阅读设置view 子控件的左右间距
let HJReadSettingSpaceW:CGFloat = SA(25, other: 30)

import UIKit

class HJReadSettingView: UIView {

    /// 分割线
    private var spaceLine:UIView!
    
    /// 颜色
    var colorView:HJReadSettingColorView!
    
    // 翻页效果
    var flipEffectView:HJReadSettingFlipEffectView!
    
    // 字体
    var fontView:HJReadSettingFontView!
    
    // 字号
    var fontSizeView:HJReadSettingFontSizeView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.whiteColor()
        
        addSubviews()
    }
    
    func addSubviews() {
        
        // 颜色
        colorView = HJReadSettingColorView()
        addSubview(colorView)
        
        // 翻页效果
        flipEffectView = HJReadSettingFlipEffectView()
        addSubview(flipEffectView)
        
        // 字体
        fontView = HJReadSettingFontView()
        addSubview(fontView)
        
        // 字号
        fontSizeView = HJReadSettingFontSizeView()
        addSubview(fontSizeView)
        
        // 分割线
        spaceLine = SpaceLineSetup(self, color: HJColor_6)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        colorView.frame = CGRectMake(0, 0, width, 65)
        
        let tempH:CGFloat = (height - colorView.height) / 3
        
        flipEffectView.frame = CGRectMake(0, CGRectGetMaxY(colorView.frame), width, tempH)
        
        fontView.frame = CGRectMake(0, CGRectGetMaxY(flipEffectView.frame), width, tempH)
        
        fontSizeView.frame = CGRectMake(0, CGRectGetMaxY(fontView.frame), width, tempH)
        
        spaceLine.frame = CGRectMake(0, 0, width, HJSpaceLineHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
