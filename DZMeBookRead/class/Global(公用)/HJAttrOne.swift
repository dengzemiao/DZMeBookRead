//
//  HJAttrOne.swift
//  HJProject
//
//  Created by 邓泽淼 on 16/8/1.
//  Copyright © 2016年 HanJue. All rights reserved.
//

import Foundation
import AdSupport
import UIKit

// MARK: -- 屏幕属性 -----------------------

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




// MARK: -- 判断系统设备 -----------------------

/// 是4s 或者 4
let is4sOr4:Bool = (ScreenHeight == CGFloat(480) && ScreenWidth == CGFloat(320))

/// 是5s 或者 5
let is5sOr5:Bool = (ScreenHeight == CGFloat(568) && ScreenWidth == CGFloat(320))

/// 是6s 或者 6
let is6sOr6:Bool = (ScreenHeight == CGFloat(667) && ScreenWidth == CGFloat(375))

/// 是6Plus 或者 6sPlus
let is6sPlusOr6Plus:Bool = (ScreenHeight == CGFloat(736) && ScreenWidth == CGFloat(414))

/// iOS7 以上版本
let iOS7:Bool = (UIDevice.current.systemVersion.doubleValue() >= 7.0)




// MARK: -- Key 值存放

/// 系统Key

/// APP版本号Key
let Key_CFBundleVersion = "CFBundleVersion"

// MARK: -- 其他全局属性 -----------------------

/// 动画时间
let AnimateDuration:TimeInterval = 0.25

/// IDFA
let HJIDFA:String = ASIdentifierManager.shared().advertisingIdentifier.uuidString
