//
//  DZMRMSettingView.swift
//  DZMeBookRead
//
//  Created by 邓泽淼 on 2017/5/11.
//  Copyright © 2017年 DZM. All rights reserved.
//

import UIKit

class DZMRMSettingView: DZMRMBaseView {

    /// 颜色
    private(set) var colorView:DZMRMColorView!
    
    /// 翻页效果
    private(set) var effectView:DZMRMFuncView!
    
    /// 字体
    private(set) var fontView:DZMRMFuncView!
    
    /// 字体大小
    private(set) var fontSizeView:DZMRMFuncView!
     
    /// 添加控件
    override func addSubviews() {
        
        super.addSubviews()
        
        // 颜色
        colorView = DZMRMColorView(frame:CGRect(x: 0, y: 0, width: ScreenWidth, height: 74),readMenu:readMenu,colors:DZMReadBGColors,selectIndex:DZMReadConfigure.shared().colorIndex)
        addSubview(colorView)
    
        // funcViewH
        let funcViewH:CGFloat = (height - colorView.height) / 3
        
        // 翻页效果 labels 排放顺序参照 DZMRMNovelEffectType
        effectView = DZMRMFuncView(frame:CGRect(x: 0, y: colorView.frame.maxY, width: ScreenWidth, height: funcViewH), readMenu:readMenu, funcType: .effect, title:"翻书动画", labels:["无效果","平移","仿真","上下"], selectIndex:DZMReadConfigure.shared().effectType)
        addSubview(effectView)
        
        // 字体 labels 排放顺序参照 DZMRMNovelFontType
        fontView = DZMRMFuncView(frame:CGRect(x: 0, y: effectView.frame.maxY, width: ScreenWidth, height: funcViewH), readMenu:readMenu, funcType: .font, title:"字体", labels:["系统","黑体","楷体","宋体"], selectIndex:DZMReadConfigure.shared().fontType)
        addSubview(fontView)
        
        // 字体大小
        fontSizeView = DZMRMFuncView(frame:CGRect(x: 0, y: fontView.frame.maxY, width: ScreenWidth, height: funcViewH), readMenu:readMenu, funcType: .fontSize, title:"字号")
        addSubview(fontSizeView)
    }

}
