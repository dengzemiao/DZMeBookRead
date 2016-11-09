//
//  HJEnum.swift
//  HJProject
//
//  Created by 邓泽淼 on 16/8/3.
//  Copyright © 2016年 HanJue. All rights reserved.
//

import Foundation
import UIKit

// MARK: -- 阅读页面枚举

/// 阅读亮度模式
enum HJReadLightType:Int {
    case day            // 白天
    case night          // 夜间
}

/// 阅读翻页效果
enum HJReadFlipEffect:Int {
    case none           // 无效果
    case translation    // 平移
    case simulation     // 仿真
    case upAndDown      // 上下
}

/// 阅读字体
enum HJReadFont:Int {
    case system         // 系统
    case one            // 黑体
    case two            // 楷体
    case three          // 宋体
}

enum HJReadLoadType {
    case none           // 加载当前章
    case next           // 下一章
    case last           // 上一章
}
