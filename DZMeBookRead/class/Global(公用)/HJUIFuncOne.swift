//
//  HJUIFuncOne.swift
//  HJProject
//
//  Created by 邓泽淼 on 16/8/5.
//  Copyright © 2016年 HanJue. All rights reserved.
//

import Foundation
import UIKit

// MARK: -- 创建分割线

/**
 给一个视图 创建添加 一条分割线 高度: HJSpaceLineHeight
 
 - parameter view:  需要添加的视图
 - parameter color: 颜色 可选
 
 - returns: 分割线view
 */
func SpaceLineSetup(_ view:UIView,color:UIColor?) ->UIView {
    
    let spaceLine = UIView()
    
    spaceLine.backgroundColor = color != nil ? color : UIColor.red
    
    view.addSubview(spaceLine)
    
    return spaceLine
}
