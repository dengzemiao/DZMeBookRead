//
//  DZMRMBaseView.swift
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/4/18.
//  Copyright © 2019年 DZM. All rights reserved.
//

import UIKit

class DZMRMBaseView: UIView {

    /// 菜单对象
    weak var readMenu:DZMReadMenu!
    
    /// 系统初始化
    override init(frame: CGRect) { super.init(frame: frame) }
    
    /// 初始化
    convenience init(readMenu:DZMReadMenu!) {
        
        self.init(frame: CGRect.zero)
        
        self.readMenu = readMenu
        
        addSubviews()
    }
    
    func addSubviews() {
        
        backgroundColor = DZM_READ_COLOR_MENU_BG_COLOR
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
