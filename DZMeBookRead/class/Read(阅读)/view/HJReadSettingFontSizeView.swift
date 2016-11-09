//
//  HJReadSettingFontSizeView.swift
//  HJProject
//
//  Created by 邓泽淼 on 16/8/17.
//  Copyright © 2016年 HanJue. All rights reserved.
//

import UIKit

@objc protocol HJReadSettingFontSizeViewDelegate:NSObjectProtocol {
    
    /**
     字号发生变化的时候调用
     */
    @objc optional func readSettingFontSizeView(_ readSettingFontSizeView:HJReadSettingFontSizeView,changeFontSize fontSize:Int)
}

class HJReadSettingFontSizeView: HJReadSettingCustomView {

    // 代理
    weak var delegate:HJReadSettingFontSizeViewDelegate?
    
    // 减
    fileprivate var minus:UIButton!
    
    // 加
    fileprivate var add:UIButton!
    
    // 当前size
    fileprivate var currentFontSize:Int = HJReadConfigureManger.shareManager.readFontSize.intValue
    
    fileprivate var minusImage:UIImage = UIImage(named: "icon_read_3")!
    fileprivate var addImage:UIImage = UIImage(named: "icon_read_4")!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        
        titleLabel.text = "字号"
    }
    
    override func addSubviews() {
        
        super.addSubviews()
        
        // 减
        minus = UIButton(type:UIButtonType.custom)
        minus.setImage(minusImage, for: UIControlState())
        minus.addTarget(self, action: #selector(HJReadSettingFontSizeView.clickMinus), for: UIControlEvents.touchUpInside)
        addSubview(minus)
        
        // 加
        add = UIButton(type:UIButtonType.custom)
        add.setImage(addImage, for: UIControlState())
        add.addTarget(self, action: #selector(HJReadSettingFontSizeView.clickAdd), for: UIControlEvents.touchUpInside)
        addSubview(add)
    }
    
    func clickMinus() {
        
        // 没有小于最小字体
        if (currentFontSize - 1) >= HJReadMinFontSize {
            
            currentFontSize -= 1
            
            HJReadConfigureManger.shareManager.readFontSize = currentFontSize as NSNumber!
            
            delegate?.readSettingFontSizeView?(self, changeFontSize: currentFontSize)
        }
    }
    
    func clickAdd() {
        
        // 没有大于最大字体
        if (currentFontSize + 1) <= HJReadMaxFontSize {
            
            currentFontSize += 1
            
            HJReadConfigureManger.shareManager.readFontSize = currentFontSize as NSNumber!
            
            delegate?.readSettingFontSizeView?(self, changeFontSize: currentFontSize)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let spaceW = HJReadSettingSpaceW
        
        let buttonY:CGFloat = (height - addImage.size.height)/2
        
        add.frame = CGRect(x: width - spaceW - addImage.size.width, y: buttonY, width: addImage.size.width, height: addImage.size.height)
        
        minus.frame = CGRect(x: add.frame.minX - minusImage.size.width, y: buttonY, width: minusImage.size.width, height: minusImage.size.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
