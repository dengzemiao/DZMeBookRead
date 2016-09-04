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
        
        backgroundColor = UIColor.whiteColor()
    }
    
    func addSubviews() {
        
        // title
        titleLabel = UILabel()
        titleLabel.font = UIFont.fontOfSize(14)
        titleLabel.textColor = UIColor.blackColor()
        addSubview(titleLabel)
        
        // 创建按钮
        for i in 0..<nomalNames.count {
           
            let button = UIButton(type:UIButtonType.Custom)
            button.tag = i
            button.setTitle(nomalNames[i], forState: UIControlState.Normal)
            button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            button.setTitleColor(HJColor_4, forState: UIControlState.Selected)
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
        titleLabel.frame = CGRectMake(spaceW, 0, 60, height)
        
        // 按钮frame
        if !nomalNames.isEmpty {
            
            let tempX:CGFloat = CGRectGetMaxX(titleLabel.frame)
            
            let buttonW = (width - tempX - spaceW) / CGFloat(nomalNames.count)
            
            for i in 0..<nomalNames.count {
                
                let button = Buttons[i]
                
                button.frame = CGRectMake(tempX + CGFloat(i) * buttonW, 0, buttonW, height)
            }
        }
        
        // 分割线
        spaceLine.frame = CGRectMake(0, height - HJSpaceLineHeight, width, HJSpaceLineHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
