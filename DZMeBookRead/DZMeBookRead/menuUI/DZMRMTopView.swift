//
//  DZMRMTopView.swift
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/4/18.
//  Copyright © 2019年 DZM. All rights reserved.
//

import UIKit

/// topView 高度
let DZM_READ_MENU_TOP_VIEW_HEIGHT:CGFloat = NavgationBarHeight

class DZMRMTopView: DZMRMBaseView {
    
    /// 返回
    private var back:UIButton!
    
    /// 书签
    private var mark:UIButton!

    override init(frame: CGRect) { super.init(frame: frame) }
    
    override func addSubviews() {
        
        super.addSubviews()
        
        // 返回
        back = UIButton(type:.custom)
        back.setImage(UIImage(named:"back")!.withRenderingMode(.alwaysTemplate), for: .normal)
        back.addTarget(self, action: #selector(clickBack), for: .touchUpInside)
        back.tintColor = DZM_READ_COLOR_MENU_COLOR
        addSubview(back)
        
        // 书签
        mark = UIButton(type:.custom)
        mark.contentMode = .center
        mark.setImage(UIImage(named:"mark")!.withRenderingMode(.alwaysTemplate), for: .normal)
        mark.addTarget(self, action: #selector(clickMark(_:)), for: .touchUpInside)
        mark.tintColor = DZM_READ_COLOR_MENU_COLOR
        addSubview(mark)
        updateMarkButton()
    }
    
    /// 点击返回
    @objc private func clickBack() {
        
        readMenu?.delegate?.readMenuClickBack?(readMenu: readMenu)
    }
    
    /// 点击书签
    @objc private func clickMark(_ button:UIButton) {
        
        readMenu?.delegate?.readMenuClickMark?(readMenu: readMenu, topView: self, markButton: button)
    }
    
    /// 检查是否存在书签
    func checkForMark() {
        
        mark.isSelected = (readMenu.vc.readModel.isExistMark() != nil)
        
        updateMarkButton()
    }
    
    /// 刷新书签按钮显示状态
    func updateMarkButton() {
        
        if mark.isSelected { mark.tintColor = DZM_READ_COLOR_MAIN
            
        }else{ mark.tintColor = DZM_READ_COLOR_MENU_COLOR }
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let y = StatusBarHeight
        
        let wh = NavgationBarHeight - y
        
        back.frame = CGRect(x: 0, y: y, width: wh, height: wh)
        
        mark.frame = CGRect(x: frame.size.width - wh, y: y, width: wh, height: wh)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
