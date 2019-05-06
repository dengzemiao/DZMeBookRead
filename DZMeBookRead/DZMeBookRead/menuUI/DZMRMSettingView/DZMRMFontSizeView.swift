//
//  DZMRMFontSizeView.swift
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/4/18.
//  Copyright © 2019年 DZM. All rights reserved.
//

import UIKit

class DZMRMFontSizeView: DZMRMBaseView {

    private var title:UILabel!
    
    private var leftButton:UIButton!
    
    private var rightButton:UIButton!
    
    private var fontSize:UILabel!
    
    private var displayProgress:UIButton!
    
    override init(frame: CGRect) { super.init(frame: frame) }
    
    override func addSubviews() {
        
        super.addSubviews()
        
        backgroundColor = UIColor.clear
        
        leftButton = UIButton(type: .custom)
        leftButton.titleLabel?.font = DZM_FONT_SA_12
        leftButton.setTitle("A-", for: .normal)
        leftButton.setTitleColor(DZM_READ_COLOR_MENU_COLOR, for: .normal)
        leftButton.layer.cornerRadius = DZM_SPACE_SA_6
        leftButton.layer.borderColor = DZM_READ_COLOR_MENU_COLOR.cgColor
        leftButton.layer.borderWidth = DZM_SPACE_1
        leftButton.addTarget(self, action: #selector(clickLeftButton), for: .touchUpInside)
        addSubview(leftButton)
        
        rightButton = UIButton(type: .custom)
        rightButton.titleLabel?.font = DZM_FONT_SA_14
        rightButton.setTitle("A+", for: .normal)
        rightButton.setTitleColor(DZM_READ_COLOR_MENU_COLOR, for: .normal)
        rightButton.layer.cornerRadius = DZM_SPACE_SA_6
        rightButton.layer.borderColor = DZM_READ_COLOR_MENU_COLOR.cgColor
        rightButton.layer.borderWidth = DZM_SPACE_1
        rightButton.addTarget(self, action: #selector(clickRightButton), for: .touchUpInside)
        addSubview(rightButton)
        
        fontSize = UILabel()
        fontSize.text = "\(DZMReadConfigure.shared().fontSize.stringValue)"
        fontSize.font = DZM_FONT_SA_16
        fontSize.textColor = DZM_READ_COLOR_MENU_COLOR
        fontSize.textAlignment = .center
        addSubview(fontSize)
        
        displayProgress = UIButton(type: .custom)
        displayProgress.setBackgroundImage(UIImage(named: "page")!.withRenderingMode(.alwaysTemplate), for: .normal)
        displayProgress.addTarget(self, action: #selector(clickDisplayProgress(button:)), for: .touchUpInside)
        displayProgress.isSelected = DZMReadConfigure.shared().progressIndex.boolValue
        addSubview(displayProgress)
        updateDisplayProgressButton()
    }
    
    @objc private func clickDisplayProgress(button:UIButton) {
        
        button.isSelected = !button.isSelected
        
        updateDisplayProgressButton()
        
        DZMReadConfigure.shared().progressIndex = NSNumber(value: button.isSelected)
        
        DZMReadConfigure.shared().save()
        
        readMenu?.delegate?.readMenuClickDisplayProgress?(readMenu: readMenu)
    }
    
    /// 刷新日夜间按钮显示状态
    private func updateDisplayProgressButton() {
        
        if displayProgress.isSelected { displayProgress.tintColor = DZM_READ_COLOR_MAIN
            
        }else{ displayProgress.tintColor = DZM_READ_COLOR_MENU_COLOR }
    }
    
    @objc private func clickLeftButton() {
        
        let size = NSNumber(value: DZMReadConfigure.shared().fontSize.intValue - DZM_READ_FONT_SIZE_SPACE)
        
        if !(size.intValue < DZM_READ_FONT_SIZE_MIN) {
            
            fontSize.text = "\(size.stringValue)"
            
            DZMReadConfigure.shared().fontSize = size
            
            DZMReadConfigure.shared().save()
            
            readMenu?.delegate?.readMenuClickFontSize?(readMenu: readMenu)
        }
    }
    
    @objc private func clickRightButton() {
        
        let size = NSNumber(value: DZMReadConfigure.shared().fontSize.intValue + DZM_READ_FONT_SIZE_SPACE)
        
        if !(size.intValue > DZM_READ_FONT_SIZE_MAX) {
            
            fontSize.text = "\(size.stringValue)"
            
            DZMReadConfigure.shared().fontSize = size
            
            DZMReadConfigure.shared().save()
            
            readMenu?.delegate?.readMenuClickFontSize?(readMenu: readMenu)
        }
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let w = frame.size.width
        let h = frame.size.height
        
        let itemW = DZM_SPACE_SA_100
        let itemH = DZM_SPACE_SA_30
        let itemY = (h - itemH) / 2
        let displayProgressWH = DZM_SPACE_SA_45
        
        leftButton.frame = CGRect(x: 0, y: itemY, width: itemW, height: itemH)
        
        rightButton.frame = CGRect(x: w - itemW - displayProgressWH - DZM_SPACE_SA_25, y: itemY, width: itemW, height: itemH)
        
        fontSize.frame = CGRect(x: leftButton.frame.maxX, y: itemY, width: rightButton.frame.minX - leftButton.frame.maxX, height: itemH)
        
        displayProgress.frame = CGRect(x: w - displayProgressWH - DZM_SPACE_SA_2, y: (h - displayProgressWH) / 2, width: displayProgressWH, height: displayProgressWH)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
