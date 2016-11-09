//
//  HJReadLightView.swift
//  HJProject
//
//  Created by 邓泽淼 on 16/8/16.
//  Copyright © 2016年 HanJue. All rights reserved.
//

import UIKit

protocol HJReadLightViewDelegate:NSObjectProtocol {
    
    /// 切换亮度背景
    func readLightView(_ readLightView:HJReadLightView, lightType:HJReadLightType)
}

class HJReadLightView: UIView {

    /// 代理
    weak var delegate:HJReadLightViewDelegate?
    
    // 分割线
    fileprivate var spaceLine:UIView!
    
    /// 进度条
    fileprivate var slider:UISlider!
    
    /// textLabel
    fileprivate var textLabel:UILabel!
    
    /// 亮度按钮
    fileprivate var lightButton:UIButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        addSubviews()
    }
    
    func addSubviews() {
        
        // 进度条
        slider = UISlider()
        slider.minimumValue = 0.0
        slider.maximumValue = 1.0
        slider.value = Float(UIScreen.main.brightness)
        slider.tintColor = HJColor_4
        slider.setThumbImage(UIImage(named: "icon_read_0")!, for: UIControlState())
        slider.addTarget(self, action: #selector(HJReadLightView.sliderChanged(_:)), for: UIControlEvents.valueChanged)
        addSubview(slider)
        
        // textLabel
        textLabel = UILabel()
        textLabel.text = "亮度"
        textLabel.textAlignment = .right
        textLabel.font = UIFont.fontOfSize(14)
        addSubview(textLabel)
        
        // lightButton
        lightButton = UIButton(type:UIButtonType.custom)
        lightButton.isSelected = HJReadConfigureManger.shareManager.lightTypeNumber.boolValue
        lightButton.setImage(UIImage(named: "icon_read_2"), for: UIControlState())
        lightButton.setImage(UIImage(named: "icon_read_1"), for: UIControlState.selected)
        lightButton.contentHorizontalAlignment = .left
        lightButton.addTarget(self, action: #selector(HJReadLightView.clickLightButton(_:)), for: UIControlEvents.touchUpInside)
        addSubview(lightButton)
        
        // 分割线
        spaceLine = SpaceLineSetup(self, color: HJColor_6)
    }
    
    func clickLightButton(_ button:UIButton) {
        
        button.isSelected = !button.isSelected
        
        let lightType = HJReadLightType(rawValue: button.isSelected.hashValue)!
        
        HJReadConfigureManger.shareManager.lightType = lightType
        
        delegate?.readLightView(self, lightType: lightType)
    }
    
    @objc fileprivate func sliderChanged(_ slider:UISlider) {
        
        UIScreen.main.brightness = CGFloat(slider.value)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 进度条
        let sliderW:CGFloat = 208
        let chapterButtonW:CGFloat = (width - sliderW) / 2
        slider.frame = CGRect(x: chapterButtonW, y: 0, width: sliderW, height: height)
        
        // textLabel
        let textLabelH = slider.frame.minX - HJSpaceTwo
        textLabel.frame = CGRect(x: 0, y: 0, width: textLabelH, height: height)
        
        // lightButton
        let lightButtonX:CGFloat = slider.frame.maxX + HJSpaceTwo
        let lightButtonW:CGFloat = width - lightButtonX
        lightButton.frame = CGRect(x: lightButtonX, y: 0, width: lightButtonW, height: height)
        
        /// spaceLine
        spaceLine.frame = CGRect(x: 0, y: 0, width: width, height: HJSpaceLineHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
