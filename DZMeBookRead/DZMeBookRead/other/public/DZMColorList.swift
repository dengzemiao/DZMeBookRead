//
//  DZMColorList.swift
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/4/17.
//  Copyright © 2019年 DZM. All rights reserved.
//

import UIKit

let DZM_COLOR_46_46_46:UIColor = RGB(46, 46, 46)        // 菜单背景颜色
let DZM_COLOR_58_52_54:UIColor = RGB(58, 52, 54)        // 阅读背景颜色支持 || 灰色
let DZM_COLOR_124_126_128:UIColor = RGB(124, 126, 128)  // 阅读上下状态栏字体颜色
let DZM_COLOR_145_145_145:UIColor = RGB(145, 145, 145)  // 阅读字体颜色
let DZM_COLOR_205_239_205:UIColor = RGB(205, 239, 205)  // 阅读背景颜色支持
let DZM_COLOR_206_233_241:UIColor = RGB(206, 233, 241)  // 阅读背景颜色支持
let DZM_COLOR_230_230_230:UIColor = RGB(230, 230, 230)  // 分割线 || 菜单默认颜色
let DZM_COLOR_238_224_202:UIColor = RGB(238, 224, 202)  // 阅读背景颜色支持
let DZM_COLOR_253_85_103:UIColor = RGB(253, 85, 103)    // 粉红色

/// 阅读背景颜色支持 - 牛皮黄
let DZM_COLOR_BG_0:UIColor = UIColor(patternImage: UIImage(named: "read_bg_0_icon")!)

/// 随机颜色
var DZM_COLOR_ARC:UIColor { return RGB(CGFloat(arc4random() % 255), CGFloat(arc4random() % 255), CGFloat(arc4random() % 255)) }
