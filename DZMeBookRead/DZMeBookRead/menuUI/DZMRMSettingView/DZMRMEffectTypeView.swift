//
//  DZMRMEffectTypeView.swift
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/4/25.
//  Copyright © 2019年 DZM. All rights reserved.
//

import UIKit

class DZMRMEffectTypeView: DZMRMBaseView {

    private var effectNames:[String] = ["仿真","覆盖","平移","滚动","无效果"]
    
    private var items:[UIButton] = []
    
    private var selectItem:UIButton!
    
    override init(frame: CGRect) { super.init(frame: frame) }
    
    override func addSubviews() {
        
        super.addSubviews()
        
        backgroundColor = UIColor.clear
        
        let count = effectNames.count
        
        for i in 0..<count {
            
            let effectName = effectNames[i]
            
            let item = UIButton(type: .custom)
            item.tag = i
            item.layer.cornerRadius = DZM_SPACE_SA_6
            item.layer.borderColor = DZM_READ_COLOR_MENU_COLOR.cgColor
            item.layer.borderWidth = DZM_SPACE_SA_1
            item.titleLabel?.font = DZM_FONT_SA_12
            item.setTitle(effectName, for: .normal)
            item.setTitleColor(DZM_READ_COLOR_MENU_COLOR, for: .normal)
            item.setTitleColor(DZM_READ_COLOR_MAIN, for: .selected)
            item.addTarget(self, action: #selector(clickItem(_:)), for: .touchUpInside)
            addSubview(item)
            items.append(item)
            
            if i == DZMReadConfigure.shared().effectIndex.intValue { selectItem(item) }
        }
    }
    
    private func selectItem(_ item:UIButton) {
        
        selectItem?.isSelected = false
        
        selectItem?.layer.borderColor = DZM_READ_COLOR_MENU_COLOR.cgColor
        
        item.isSelected = true
        
        item.layer.borderColor = DZM_READ_COLOR_MAIN.cgColor
        
        selectItem = item
    }
    
    @objc private func clickItem(_ item:UIButton) {
        
        if selectItem == item { return }
        
        selectItem(item)
        
        DZMReadConfigure.shared().effectIndex = NSNumber(value: item.tag)
        
        DZMReadConfigure.shared().save()
        
        readMenu?.delegate?.readMenuClickEffect?(readMenu: readMenu)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let count = effectNames.count
        
        let w = frame.size.width
        let h = frame.size.height
        
        let itemW = DZM_SPACE_SA_60
        let itemH = DZM_SPACE_SA_30
        let itemY = (h - itemH) / 2
        let itemSpaceW = (w - CGFloat(count) * itemW) / (CGFloat(count - 1))
        
        for i in 0..<count {
            
            let item = items[i]
            item.frame = CGRect(x: CGFloat(i) * (itemW + itemSpaceW), y: itemY, width: itemW, height: itemH)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
