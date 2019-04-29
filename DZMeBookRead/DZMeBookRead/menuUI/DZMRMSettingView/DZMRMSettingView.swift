//
//  DZMRMSettingView.swift
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/4/18.
//  Copyright © 2019年 DZM. All rights reserved.
//

import UIKit

/// 子视图高度
let DZM_READ_MENU_SETTING_SUB_VIEW_HEIGHT:CGFloat = DZM_SPACE_SA_50

/// settingView 内容高度
let DZM_READ_MENU_SETTING_VIEW_HEIGHT:CGFloat = DZM_READ_MENU_SETTING_SUB_VIEW_HEIGHT * 6

/// settingView 总高度(内容高度 + iphoneX情况下底部间距)
let DZM_READ_MENU_SETTING_VIEW_TOTAL_HEIGHT:CGFloat = SA(isX: DZM_READ_MENU_SETTING_VIEW_HEIGHT + DZM_SPACE_SA_20, DZM_READ_MENU_SETTING_VIEW_HEIGHT)

class DZMRMSettingView: DZMRMBaseView {
    
    /// 亮度
    private var lightView:DZMRMLightView!
    
    /// 字体大小
    private var fontSizeView:DZMRMFontSizeView!
    
    /// 背景
    private var bgColorView:DZMRMBGColorView!
    
    /// 翻页效果
    private var effectTypeView:DZMRMEffectTypeView!
    
    /// 字体
    private var fontTypeView:DZMRMFontTypeView!
    
    /// 间距
    private var spacingView:DZMRMSpacingView!

    override init(frame: CGRect) { super.init(frame: frame) }
    
    override func addSubviews() {
        
        super.addSubviews()
        
        let x = DZM_SPACE_SA_15
        let w = DZM_READ_CONTENT_VIEW_WIDTH - DZM_SPACE_SA_30
        let h = DZM_READ_MENU_SETTING_SUB_VIEW_HEIGHT
        
        lightView = DZMRMLightView(readMenu: readMenu)
        addSubview(lightView)
        lightView.frame = CGRect(x: x, y: 0, width: w, height: h)
        
        fontSizeView = DZMRMFontSizeView(readMenu: readMenu)
        addSubview(fontSizeView)
        fontSizeView.frame = CGRect(x: x, y: lightView.frame.maxY, width: w, height: h)
        
        effectTypeView = DZMRMEffectTypeView(readMenu: readMenu)
        addSubview(effectTypeView)
        effectTypeView.frame = CGRect(x: x, y: fontSizeView.frame.maxY, width: w, height: h)
        
        fontTypeView = DZMRMFontTypeView(readMenu: readMenu)
        addSubview(fontTypeView)
        fontTypeView.frame = CGRect(x: x, y: effectTypeView.frame.maxY, width: w, height: h)
        
        bgColorView = DZMRMBGColorView(readMenu: readMenu)
        addSubview(bgColorView)
        bgColorView.frame = CGRect(x: x, y: fontTypeView.frame.maxY, width: w, height: h)
        
        spacingView = DZMRMSpacingView(readMenu: readMenu)
        addSubview(spacingView)
        spacingView.frame = CGRect(x: x, y: bgColorView.frame.maxY, width: w, height: h)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
