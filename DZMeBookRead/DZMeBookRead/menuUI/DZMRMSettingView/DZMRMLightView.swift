//
//  DZMRMLightView.swift
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/4/18.
//  Copyright © 2019年 DZM. All rights reserved.
//

import UIKit

class DZMRMLightView: DZMRMBaseView {
    
    private var leftIcon:UIImageView!
    
    private var slider:UISlider!
    
    private var rightIcon:UIImageView!
    
    override init(frame: CGRect) { super.init(frame: frame) }
    
    override func addSubviews() {
        
        super.addSubviews()
    
        backgroundColor = UIColor.clear
        
        leftIcon = UIImageView()
        leftIcon.image = UIImage(named: "light_0")!.withRenderingMode(.alwaysTemplate)
        leftIcon.tintColor = DZM_READ_COLOR_MENU_COLOR
        addSubview(leftIcon)
        
        rightIcon = UIImageView()
        rightIcon.image = UIImage(named: "light_1")!.withRenderingMode(.alwaysTemplate)
        rightIcon.tintColor = DZM_READ_COLOR_MENU_COLOR
        addSubview(rightIcon)
        
        // 进度条
        slider = UISlider()
        slider.minimumValue = 0.0
        slider.maximumValue = 1.0
        slider.value = Float(UIScreen.main.brightness)
        slider.addTarget(self, action: #selector(sliderChanged(_:)), for: .valueChanged)
        slider.setThumbImage(UIImage(named:"slider")!.withRenderingMode(.alwaysTemplate), for: .normal)
        // 设置当前进度颜色
        slider.minimumTrackTintColor = DZM_READ_COLOR_MAIN
        // 设置总进度颜色
        slider.maximumTrackTintColor = DZM_READ_COLOR_MENU_COLOR
        // 设置当前拖拽圆圈颜色
        slider.tintColor = DZM_READ_COLOR_MENU_COLOR
        addSubview(slider)
    }
    
    /// 滑块变化
    @objc private func sliderChanged(_ slider:UISlider) {
        
        UIScreen.main.brightness = CGFloat(slider.value)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let w = frame.size.width
        let h = frame.size.height
        
        let iconWH = DZM_SPACE_SA_20
        let iconY = (h - iconWH) / 2
        leftIcon.frame = CGRect(x: 0, y: iconY, width: iconWH, height: iconWH)
        rightIcon.frame = CGRect(x: w - iconWH, y: iconY, width: iconWH, height: iconWH)
        
        let sliderX = leftIcon.frame.maxX + DZM_SPACE_SA_15
        let sliderW = rightIcon.frame.minX - DZM_SPACE_SA_15 - sliderX
        slider.frame = CGRect(x: sliderX, y: 0, width: sliderW, height: h)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
