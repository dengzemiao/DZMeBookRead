//
//  HJReadSettingColorView.swift
//  HJProject
//
//  Created by 邓泽淼 on 16/8/17.
//  Copyright © 2016年 HanJue. All rights reserved.
//

import UIKit

@objc protocol HJReadSettingColorViewDelegate:NSObjectProtocol {
    
    /**
     阅读背景颜色发生变化的时候调用
     */
    @objc optional func readSettingColorView(_ readSettingColorView:HJReadSettingColorView,changeReadColor readColor:UIColor)
}

class HJReadSettingColorView: UIScrollView {

    // 代理
    weak var aDelegate:HJReadSettingColorViewDelegate?
    
    /// 分割线
    fileprivate var spaceLine:UIView!
    
    /// 当前选中的按钮
    fileprivate var selectButton:UIButton?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        addSubviews()
    }
    
    func addSubviews() {
        
        // 创建颜色按钮
        let count = HJReadColors.count
        
        for i in 0..<count {
            
            let backgroundColor = HJReadColors[i]
            let button = UIButton(type:UIButtonType.custom)
            button.tag = i
            button.layer.borderColor = HJColor_4.cgColor
            button.layer.borderWidth = backgroundColor == HJColor_13 ? 1 : 0
            button.backgroundColor = backgroundColor
            addSubview(button)
            button.addTarget(self, action: #selector(HJReadSettingColorView.clickButton(_:)), for: UIControlEvents.touchUpInside)
            
            // 当前选中的颜色
            if i == HJReadConfigureManger.shareManager.readColorInex.intValue {
                
                clickButton(button)
            }
         }
        
        // 分割线
        spaceLine = SpaceLineSetup(self, color: HJColor_6)
    }
    
    func clickButton(_ button:UIButton) {

        if selectButton == button {return}
        
        selectButton?.layer.borderWidth -= 1
        
        button.layer.borderWidth += 1
        
        selectButton = button
        
        let readColor = HJReadColors[button.tag]
        
        HJReadConfigureManger.shareManager.readColorInex = NSNumber(value: button.tag)
        
        aDelegate?.readSettingColorView?(self, changeReadColor: readColor)
    }
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let count = HJReadColors.count
        
        // 左右间距
        let spaceW:CGFloat = HJReadSettingSpaceW
        
        let buttoonWH:CGFloat = 36
        
        let buttoonY:CGFloat = (height - buttoonWH) / 2
        
        let centerSpaceW:CGFloat = (width - 2*spaceW - buttoonWH*CGFloat(count)) / (CGFloat(count) - 1)
        
        for i in 0..<count {
            
            let button = subviews[i]
            
            button.frame = CGRect(x: spaceW + CGFloat(i) * (buttoonWH + centerSpaceW), y: buttoonY, width: buttoonWH, height: buttoonWH)
            
            button.layer.cornerRadius = buttoonWH/2
        }
        
        spaceLine.frame = CGRect(x: 0, y: height - HJSpaceLineHeight, width: width, height: HJSpaceLineHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
