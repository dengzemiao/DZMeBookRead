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
    optional func readSettingFontSizeView(readSettingFontSizeView:HJReadSettingFontSizeView,changeFontSize fontSize:Int)
}

class HJReadSettingFontSizeView: HJReadSettingCustomView {

    // 代理
    weak var delegate:HJReadSettingFontSizeViewDelegate?
    
    // 减
    private var minus:UIButton!
    
    // 加
    private var add:UIButton!
    
    // 当前size
    private var currentFontSize:Int = HJReadConfigureManger.shareManager.readFontSize.integerValue
    
    private var minusImage:UIImage = UIImage(named: "icon_read_3")!
    private var addImage:UIImage = UIImage(named: "icon_read_4")!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
        
        titleLabel.text = "字号"
    }
    
    override func addSubviews() {
        
        super.addSubviews()
        
        // 减
        minus = UIButton(type:UIButtonType.Custom)
        minus.setImage(minusImage, forState: UIControlState.Normal)
        minus.addTarget(self, action: #selector(HJReadSettingFontSizeView.clickMinus), forControlEvents: UIControlEvents.TouchUpInside)
        addSubview(minus)
        
        // 加
        add = UIButton(type:UIButtonType.Custom)
        add.setImage(addImage, forState: UIControlState.Normal)
        add.addTarget(self, action: #selector(HJReadSettingFontSizeView.clickAdd), forControlEvents: UIControlEvents.TouchUpInside)
        addSubview(add)
    }
    
    func clickMinus() {
        
        // 没有小于最小字体
        if (currentFontSize - 1) >= HJReadMinFontSize {
            
            currentFontSize -= 1
            
            HJReadConfigureManger.shareManager.readFontSize = currentFontSize
            
            delegate?.readSettingFontSizeView?(self, changeFontSize: currentFontSize)
        }
    }
    
    func clickAdd() {
        
        // 没有大于最大字体
        if (currentFontSize + 1) <= HJReadMaxFontSize {
            
            currentFontSize += 1
            
            HJReadConfigureManger.shareManager.readFontSize = currentFontSize
            
            delegate?.readSettingFontSizeView?(self, changeFontSize: currentFontSize)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let spaceW = HJReadSettingSpaceW
        
        let buttonY:CGFloat = (height - addImage.size.height)/2
        
        add.frame = CGRectMake(width - spaceW - addImage.size.width, buttonY, addImage.size.width, addImage.size.height)
        
        minus.frame = CGRectMake(CGRectGetMinX(add.frame) - minusImage.size.width, buttonY, minusImage.size.width, minusImage.size.height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
