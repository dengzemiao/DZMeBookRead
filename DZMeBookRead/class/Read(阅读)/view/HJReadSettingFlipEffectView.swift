//
//  HJReadSettingFlipEffectView.swift
//  HJProject
//
//  Created by 邓泽淼 on 16/8/17.
//  Copyright © 2016年 HanJue. All rights reserved.
//

import UIKit

protocol HJReadSettingFlipEffectViewDelegate:NSObjectProtocol {
    
    /**
     翻页效果发生变化的时候调用
     */
    func readSettingFlipEffectView(_ readSettingFlipEffectView:HJReadSettingFlipEffectView,changeFlipEffect flipEffect:HJReadFlipEffect)
}


class HJReadSettingFlipEffectView: HJReadSettingCustomView {

    // 代理
    weak var delegate:HJReadSettingFlipEffectViewDelegate?
    
    /// 当前选中的按钮
    fileprivate var selectButton:UIButton?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        nomalNames = ["无效果","覆盖","仿真","上下"]
        
        addSubviews()
        
        titleLabel.text = "翻书动画"
        
        for button in Buttons {
            
            button.contentHorizontalAlignment = .center
            
            button.addTarget(self, action: #selector(HJReadSettingFlipEffectView.clickButton(_:)), for: UIControlEvents.touchUpInside)
        }
        
        if !Buttons.isEmpty {
            
            clickButton(Buttons[HJReadConfigureManger.shareManager.flipEffect.rawValue])
        }
    }
    
    // 点击按钮
    func clickButton(_ button:UIButton) {
        
        if selectButton == button {return}
        
        let flipEffect = HJReadFlipEffect(rawValue: button.tag)!
        
        // 暂时不支持的效果
//        if flipEffect == HJReadFlipEffect.UpAndDown {return}
        
        selectButton?.isSelected = false
        
        button.isSelected = true
        
        selectButton = button
        
        HJReadConfigureManger.shareManager.flipEffect = flipEffect
        
        delegate?.readSettingFlipEffectView(self, changeFlipEffect: flipEffect)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
