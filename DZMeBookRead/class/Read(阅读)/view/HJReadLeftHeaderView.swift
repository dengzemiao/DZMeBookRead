//
//  HJReadLeftHeaderView.swift
//  HJProject
//
//  Created by 邓泽淼 on 16/8/15.
//  Copyright © 2016年 HanJue. All rights reserved.
//

// 模式
@objc enum HJReadLeftViewType:Int {
    
    case allChapters                // 全部章节
    case allBookMarks               // 全部书签
}

import UIKit

@objc protocol HJReadLeftHeaderViewDelegate:NSObjectProtocol {
    
    // 切换 HJLeftViewType
    @objc optional func readLeftHeaderView(_ readLeftHeaderView:HJReadLeftHeaderView,type:HJReadLeftViewType)
}

class HJReadLeftHeaderView: UIView {

    // 代理
    weak var delegate:HJReadLeftHeaderViewDelegate?
    
    /// allChapters
    fileprivate var allChapters:UIButton!
    
    /// allBookMarks
    fileprivate var allBookMarks:UIButton!
    
    /// 分割线
    fileprivate var spaceLine_H:UIView!
    
    /// 分割线
    fileprivate var spaceLine_V:UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        addSubviews()
    }
    
    func addSubviews() {
        
        // allChapters
        allChapters = UIButton(type:UIButtonType.custom);
        allChapters.tag = HJReadLeftViewType.allChapters.rawValue
        allChapters.titleLabel?.font = UIFont.fontOfSize(10)
        allChapters.setTitle("章节", for: UIControlState.normal);
        allChapters.setTitle("章节", for: UIControlState.selected);
        allChapters.setTitleColor(UIColor.gray, for: UIControlState.normal)
        allChapters.setTitleColor(HJColor_4, for: UIControlState.selected)
        allChapters.addTarget(self, action: #selector(HJReadLeftHeaderView.clickButton(button:)), for: UIControlEvents.touchUpInside)
        addSubview(allChapters)
        
        // allChapters
        allBookMarks = UIButton(type:UIButtonType.custom);
        allBookMarks.tag = HJReadLeftViewType.allBookMarks.rawValue
        allBookMarks.titleLabel?.font = UIFont.fontOfSize(10)
        allBookMarks.setTitle("书签", for: UIControlState.normal);
        allBookMarks.setTitle("书签", for: UIControlState.selected);
        allBookMarks.setTitleColor(UIColor.gray, for: UIControlState.normal)
        allBookMarks.setTitleColor(HJColor_4, for: UIControlState.selected)
        allBookMarks.addTarget(self, action: #selector(HJReadLeftHeaderView.clickButton(button:)), for: UIControlEvents.touchUpInside)
        addSubview(allBookMarks)
        
        // 分割线
        spaceLine_H = SpaceLineSetup(self, color: HJColor_6)
        
        // 分割线
        spaceLine_V = SpaceLineSetup(self, color: HJColor_6)
        
        // 默认选中按钮
        clickButton(button: allChapters)
    }
    
    // 点击切换按钮
    @objc private func clickButton(button:UIButton) {
        
        // 防止重复点击
        if button.isSelected {return}
        
        if (button.tag == HJReadLeftViewType.allChapters.rawValue) { // 书签
            
            allChapters.isSelected = true
            allBookMarks.isSelected = false
            
        }else{
            
            allChapters.isSelected = false
            allBookMarks.isSelected = true
        }
        
        delegate?.readLeftHeaderView?(self, type: HJReadLeftViewType(rawValue: button.tag)!)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let buttonW = (width - HJSpaceLineHeight)/2
        
        allChapters.frame = CGRect(x: 0, y: 0, width: buttonW, height: height)
        
        spaceLine_V.frame = CGRect(x: buttonW, y: 0, width: HJSpaceLineHeight, height: height)
        
        allBookMarks.frame = CGRect(x: buttonW + HJSpaceLineHeight, y: 0, width: buttonW, height: height)
        
        spaceLine_H.frame = CGRect(x: 0, y: height - HJSpaceLineHeight, width: width, height: HJSpaceLineHeight)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
