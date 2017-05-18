//
//  DZMRMBaseView.swift
//  DZMeBookRead
//
//  Created by 邓泽淼 on 2017/5/11.
//  Copyright © 2017年 DZM. All rights reserved.
//

import UIKit

class DZMRMBaseView: UIControl {

    /// 菜单
    weak var readMenu:DZMReadMenu!
    
    /// 初始化方法
    convenience init(readMenu:DZMReadMenu) {
        
        self.init(frame:CGRect.zero,readMenu:readMenu)
    }
    
    /// 初始化方法
    init(frame:CGRect,readMenu:DZMReadMenu) {
        
        self.readMenu = readMenu
        
        super.init(frame: frame)
        
        addSubviews()
    }
    
    /// 初始化方法
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        addSubviews()
    }
    
    /// 添加子控件
    func addSubviews() {
        
        backgroundColor = DZMMenuUIColor
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
