//
//  DZMRMLightView.swift
//  DZMeBookRead
//
//  Created by 邓泽淼 on 2017/5/11.
//  Copyright © 2017年 DZM. All rights reserved.
//

import UIKit

class DZMRMLightView: DZMRMBaseView {

    /// 标题
    private(set) var titleLabel:UILabel!
    
    /// 进度条
    private(set) var slider:UISlider!
    
    /// 类型
    private(set) var typeLabel:UILabel!
    
    override func addSubviews() {
        
        super.addSubviews()
        
        titleLabel = UILabel()
        titleLabel.text = "亮度"
        titleLabel.textAlignment = .right
        titleLabel.textColor = UIColor.white
        titleLabel.font = DZMFont_12
        addSubview(titleLabel)
        
        typeLabel = UILabel()
        typeLabel.text = "系统"
        typeLabel.layer.cornerRadius = 3
        typeLabel.textAlignment = .center
        typeLabel.textColor = UIColor.black
        typeLabel.backgroundColor = UIColor.white
        typeLabel.font = DZMFont_10
        addSubview(typeLabel)
        
        // 进度条
        slider = UISlider()
        slider.minimumValue = 0.0
        slider.maximumValue = 1.0
        slider.tintColor = DZMColor_2
        slider.setThumbImage(UIImage(named: "RM_3")!, for: UIControlState())
        slider.addTarget(self, action: #selector(DZMRMLightView.sliderChanged(_:)), for: UIControlEvents.valueChanged)
        slider.value = Float(UIScreen.main.brightness)
        addSubview(slider)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        // 标题
        titleLabel.frame = CGRect(x: 0, y: 0, width: 45, height: height)
        
        // 类型
        let typeLabelW:CGFloat = 32
        let typeLabelH:CGFloat = 16
        typeLabel.frame = CGRect(x: width - typeLabelW - DZMSpace_1, y: (height - typeLabelH) / 2, width: typeLabelW, height: typeLabelH)
        
        // 进度条
        let sliderX = titleLabel.frame.maxX + DZMSpace_1
        let sliderW = typeLabel.frame.minX - DZMSpace_1 - sliderX
        slider.frame = CGRect(x: sliderX, y: 0, width: sliderW, height: height)
    }
    
    /// 滑动方法
    @objc private func sliderChanged(_ slider:UISlider) {
        
        UIScreen.main.brightness = CGFloat(slider.value)
    }
}
