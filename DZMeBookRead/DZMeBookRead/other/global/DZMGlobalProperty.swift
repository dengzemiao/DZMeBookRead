//
//  DZMGlobalProperty.swift
//  DZMeBookRead
//
//  Created by 邓泽淼 on 2017/5/11.
//  Copyright © 2017年 DZM. All rights reserved.
//

import UIKit

// MARK: -- 屏幕属性

/// 屏幕宽度
let ScreenWidth:CGFloat = UIScreen.main.bounds.size.width

/// 屏幕高度
let ScreenHeight:CGFloat = UIScreen.main.bounds.size.height

/// iPhone X
let isX:Bool = (ScreenHeight == CGFloat(812) && ScreenWidth == CGFloat(375))

/// 导航栏高度
let NavgationBarHeight:CGFloat = isX ? 88 : 64

/// TabBar高度
let TabBarHeight:CGFloat = 49

/// iPhone X 顶部刘海高度
let TopLiuHeight:CGFloat = 30

/// StatusBar高度
let StatusBarHeight:CGFloat = isX ? 44 : 20

// MARK: -- 全局属性

/// 段落头部双圆角空格
let DZMParagraphHeaderSpace:String = "　　"

// MARK: -- 颜色支持

/// 灰色 || 阅读背景颜色支持
let DZMColor_51_51_51:UIColor = RGB(51, g: 51, b: 51)

/// 粉红色
let DZMColor_253_85_103:UIColor = RGB(253, g: 85, b: 103)

/// 阅读上下状态栏颜色 || 小说阅读上下状态栏字体颜色
let DZMColor_127_136_138:UIColor = RGB(127, g: 136, b: 138)

/// 小说阅读颜色
let DZMColor_145_145_145:UIColor = RGB(145, g: 145, b: 145)

/// LeftView文字颜色
let DZMColor_200_200_200:UIColor = RGB(200, g: 200, b: 200)

/// 阅读背景颜色支持
let DZMColor_238_224_202:UIColor = RGB(238, g: 224, b: 202)
let DZMColor_205_239_205:UIColor = RGB(205, g: 239, b: 205)
let DZMColor_206_233_241:UIColor = RGB(206, g: 233, b: 241)
let DZMColor_251_237_199:UIColor = RGB(251, g: 237, b: 199)  // 牛皮黄

/// 菜单背景颜色
let DZMMenuUIColor:UIColor = UIColor.black.withAlphaComponent(0.85)


// MARK: -- 字体支持
let DZMFont_10:UIFont = UIFont.systemFont(ofSize: 10)
let DZMFont_12:UIFont = UIFont.systemFont(ofSize: 12)
let DZMFont_18:UIFont = UIFont.systemFont(ofSize: 18)


// MARK: -- 间距支持
let DZMSpace_1:CGFloat = 1
let DZMSpace_5:CGFloat = 5
let DZMSpace_10:CGFloat = 10
let DZMSpace_15:CGFloat = 15
let DZMSpace_20:CGFloat = 20
let DZMSpace_25:CGFloat = 25

// MARK: 拖拽触发光标范围
let DZMCursorOffset:CGFloat = -DZMSpace_20


// MARK: -- Key

/// 是夜间还是日间模式   true:夜间 false:日间
let DZMKey_IsNighOrtDay:String = "isNightOrDay"

/// ReadView 手势开启状态
let DZMKey_ReadView_Ges_isOpen:String = "isOpen"

// MARK: 通知名称

/// ReadView 手势通知
let DZMNotificationName_ReadView_Ges = "ReadView_Ges"
