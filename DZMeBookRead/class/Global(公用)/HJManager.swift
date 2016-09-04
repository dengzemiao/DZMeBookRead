//
//  HJManager.swift
//  HJProject
//
//  Created by 邓泽淼 on 16/8/1.
//  Copyright © 2016年 HanJue. All rights reserved.
//

import UIKit

class HJManager: NSObject {

    /// 获取单利对象
    class var shareManager : HJManager {
        struct Static {
            static let instance : HJManager = HJManager()
        }
        return Static.instance
    }
    
    
    /// 当前正在显示的控制器
    weak var displayController:UIViewController?
}
