//
//  HJReadSettingCustomView.swift
//  HJProject
//
//  Created by 邓泽淼 on 16/8/17.
//  Copyright © 2016年 HanJue. All rights reserved.
//

import UIKit

class HJReadSettingCustomView: UIView {

    /// 分割线
    var spaceLine:UIView!
    
    /// title
    var titleLabel:UILabel!
    
    /// 按钮名称数组
    var nomalNames:[String]! = []
    
    /// 按钮数组
    var Buttons:[UIButton]! = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
    }
    
    func addSubviews() {
        
        // title
        titleLabel = UILabel()
        titleLabel.font = UIFont.fontOfSize(14)
        titleLabel.textColor = UIColor.black
        addSubview(titleLabel)
        
        // 创建按钮
        for i in 0..<nomalNames.count {
           
            let button = UIButton(type:UIButtonType.custom)
            button.tag = i
            button.setTitle(nomalNames[i], for: UIControlState())
            button.setTitleColor(UIColor.black, for: UIControlState())
            button.setTitleColor(HJColor_4, for: UIControlState.selected)
            button.titleLabel?.font = UIFont.fontOfSize(14)
            addSubview(button)
            Buttons.append(button)
        }
        
        // 分割线
        spaceLine = SpaceLineSetup(self, color: HJColor_6)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 间距
        let spaceW:CGFloat = HJReadSettingSpaceW
        
        // 标题
        titleLabel.frame = CGRect(x: spaceW, y: 0, width: 60, height: height)
        
        // 按钮frame
        if !nomalNames.isEmpty {
            
            let tempX:CGFloat = titleLabel.frame.maxX
            
            let buttonW = (width - tempX - spaceW) / CGFloat(nomalNames.count)
            
            for i in 0..<nomalNames.count {
                
                let button = Buttons[i]
                
                button.frame = CGRect(x: tempX + CGFloat(i) * buttonW, y: 0, width: buttonW, height: height)
            }
        }
        
        // 分割线
        spaceLine.frame = CGRect(x: 0, y: height - HJSpaceLineHeight, width: width, height: HJSpaceLineHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
