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

/// 导航栏高度
let NavgationBarHeight:CGFloat = 64

/// TabBar高度
let TabBarHeight:CGFloat = 49

/// StatusBar高度
let StatusBarHeight:CGFloat = 20


// MARK: -- 颜色支持

/// 灰色
let DZMColor_1:UIColor = RGB(51, g: 51, b: 51)

/// 粉红色
let DZMColor_2:UIColor = RGB(253, g: 85, b: 103)

/// 阅读上下状态栏颜色
let DZMColor_3:UIColor = RGB(127, g: 136, b: 138)

/// 小说阅读上下状态栏字体颜色
let DZMColor_4:UIColor = RGB(127, g: 136, b: 138)

/// 小说阅读颜色
let DZMColor_5:UIColor = RGB(145, g: 145, b: 145)

/// LeftView文字颜色
let DZMColor_6:UIColor = RGB(200, g: 200, b: 200)


/// 阅读背景颜色支持
let DZMReadBGColor_1:UIColor = RGB(238, g: 224, b: 202)
let DZMReadBGColor_2:UIColor = RGB(205, g: 239, b: 205)
let DZMReadBGColor_3:UIColor = RGB(206, g: 233, b: 241)
let DZMReadBGColor_4:UIColor = RGB(251, g: 237, b: 199)  // 牛皮黄
let DZMReadBGColor_5:UIColor = RGB(51, g: 51, b: 51)

/// 菜单背景颜色
let DZMMenuUIColor:UIColor = UIColor.black.withAlphaComponent(0.85)

// MARK: -- 字体支持
let DZMFont_10:UIFont = UIFont.systemFont(ofSize: 10)
let DZMFont_12:UIFont = UIFont.systemFont(ofSize: 12)
let DZMFont_18:UIFont = UIFont.systemFont(ofSize: 18)


// MARK: -- 间距支持
let DZMSpace_1:CGFloat = 15
let DZMSpace_2:CGFloat = 25
let DZMSpace_3:CGFloat = 1
let DZMSpace_4:CGFloat = 10
let DZMSpace_5:CGFloat = 20
let DZMSpace_6:CGFloat = 5


// MARK: -- Key
/// 是夜间还是日间模式   true:夜间 false:日间
let DZMKey_IsNighOrtDay:String = "isNightOrDay"
