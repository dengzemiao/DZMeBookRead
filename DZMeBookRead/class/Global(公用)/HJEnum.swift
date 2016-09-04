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
    case Day            // 白天
    case Night          // 夜间
}

/// 阅读翻页效果
enum HJReadFlipEffect:Int {
    case None           // 无效果
    case Translation    // 平移
    case Simulation     // 仿真
    case UpAndDown      // 上下
}

/// 阅读字体
enum HJReadFont:Int {
    case System         // 系统
    case One            // 黑体
    case Two            // 楷体
    case Three          // 宋体
}

enum HJReadLoadType {
    case None           // 加载当前章
    case Next           // 下一章
    case Last           // 上一章
}