//
//  HJReadBottomView.swift
//  HJProject
//
//  Created by 邓泽淼 on 16/8/15.
//  Copyright © 2016年 HanJue. All rights reserved.
//

import UIKit

@objc protocol HJReadBottomViewDelegate:NSObjectProtocol {
    
    /// 点击底部Bar按钮  index:单击按钮的索引
    @objc optional func readBottomView(_ readBottomView:HJReadBottomView,clickBarButtonIndex index:NSInteger)

    /// 上一章
    @objc optional func readBottomViewLastChapter(_ readBottomView:HJReadBottomView)
    
    /// 下一章
    @objc optional func readBottomViewNextChapter(_ readBottomView:HJReadBottomView)
    
    /// 进度
    @objc optional func readBottomViewChangeSlider(_ readBottomView:HJReadBottomView,slider:UISlider)
}

class HJReadBottomView: UIView {
    
    /// 代理
    weak var delegate:HJReadBottomViewDelegate?
    
    /// 图片个数
    fileprivate let BarIconNumber:Int = 4
    
    /// 上一章
    fileprivate var lastChapter:UIButton!
    
    /// 下一章
    fileprivate var nextChapter:UIButton!
    
    /// 进度条
    var slider:UISlider!
    
    /// 分割线
    fileprivate var spaceLine:UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
        addSubviews()
    }
    
    func addSubviews() {
        
        // 创建按钮
        for i in 0 ..< BarIconNumber {
            
            let button = UIButton(type:UIButtonType.custom)
            
            button.setImage(UIImage(named: "read_bar_\(i)"), for: UIControlState())
            
            button.tag = i
            
            button.addTarget(self, action: #selector(HJReadBottomView.clickButton(_:)), for: UIControlEvents.touchUpInside)
            
            addSubview(button)
        }
        
        // 分割线
        spaceLine = SpaceLineSetup(self, color: RGB(234, g: 236, b: 242))
        
        // 上一章按钮
        lastChapter = UIButton(type:UIButtonType.custom)
        lastChapter.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        lastChapter.contentHorizontalAlignment = UIControlContentHorizontalAlignment.right
        lastChapter.setTitle("上一章", for: UIControlState())
        lastChapter.setTitleColor(HJColor_4, for: UIControlState())
        lastChapter.addTarget(self, action: #selector(HJReadBottomView.clickLastChapter), for: UIControlEvents.touchUpInside)
        addSubview(lastChapter)
        
        // 下一章按钮
        nextChapter = UIButton(type:UIButtonType.custom)
        nextChapter.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        nextChapter.contentHorizontalAlignment = UIControlContentHorizontalAlignment.left
        nextChapter.setTitle("下一章", for: UIControlState())
        nextChapter.setTitleColor(HJColor_4, for: UIControlState())
        nextChapter.addTarget(self, action: #selector(HJReadBottomView.clickNextChapter), for: UIControlEvents.touchUpInside)
        addSubview(nextChapter)
        
        // 进度条
        slider = UISlider()
        slider.minimumValue = 0
        slider.tintColor = HJColor_4
        slider.setThumbImage(UIImage(named: "icon_read_0")!, for: UIControlState())
        slider.addTarget(self, action: #selector(HJReadBottomView.sliderChanged(_:)), for: UIControlEvents.touchUpInside)
        addSubview(slider)
    }
    
    func clickLastChapter() {
        
        delegate?.readBottomViewLastChapter?(self)
    }
    
    func clickNextChapter() {
        
        delegate?.readBottomViewNextChapter?(self)
    }
    
    /// 滑动方法
    @objc fileprivate func sliderChanged(_ slider:UISlider) {
        
        delegate?.readBottomViewChangeSlider?(self, slider: slider)
    }
    
    /// 点击按钮
    func clickButton(_ button:UIButton) {
        
        delegate?.readBottomView?(self, clickBarButtonIndex: button.tag)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 按钮布局
        
        let buttonH:CGFloat = 70
        
        let buttonY:CGFloat = height - buttonH
        
        let buttonW:CGFloat =  width / CGFloat(BarIconNumber)
        
        for i in 0..<BarIconNumber {
            
            let button = subviews[i]
            
            button.frame = CGRect(x: CGFloat(i) * buttonW, y: buttonY, width: buttonW, height: buttonH)
        }
        
        // 分割线
        spaceLine.frame = CGRect(x: 0, y: 0, width: width, height: 0.5)
        
        // 以下使用的高度
        let tempH:CGFloat = buttonY
        
        // 进度条
        let sliderW:CGFloat = 208
        var chapterButtonW:CGFloat = (width - sliderW) / 2
        slider.frame = CGRect(x: chapterButtonW, y: 0, width: sliderW, height: tempH)
        
            
        // 按钮位置
        chapterButtonW -= HJSpaceOne
        lastChapter.frame = CGRect(x: 0, y: 0, width: chapterButtonW, height: tempH)
        nextChapter.frame = CGRect(x: slider.frame.maxX + HJSpaceOne , y: 0, width: chapterButtonW, height: tempH)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
