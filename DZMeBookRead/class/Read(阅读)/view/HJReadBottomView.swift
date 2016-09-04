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
    optional func readBottomView(readBottomView:HJReadBottomView,clickBarButtonIndex index:NSInteger)

    /// 上一章
    optional func readBottomViewLastChapter(readBottomView:HJReadBottomView)
    
    /// 下一章
    optional func readBottomViewNextChapter(readBottomView:HJReadBottomView)
    
    /// 进度
    optional func readBottomViewChangeSlider(readBottomView:HJReadBottomView,slider:UISlider)
}

class HJReadBottomView: UIView {
    
    /// 代理
    weak var delegate:HJReadBottomViewDelegate?
    
    /// 图片个数
    private let BarIconNumber:Int = 4
    
    /// 上一章
    private var lastChapter:UIButton!
    
    /// 下一章
    private var nextChapter:UIButton!
    
    /// 进度条
    var slider:UISlider!
    
    /// 分割线
    private var spaceLine:UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.whiteColor()
        
        addSubviews()
    }
    
    func addSubviews() {
        
        // 创建按钮
        for i in 0 ..< BarIconNumber {
            
            let button = UIButton(type:UIButtonType.Custom)
            
            button.setImage(UIImage(named: "read_bar_\(i)"), forState: UIControlState.Normal)
            
            button.tag = i
            
            button.addTarget(self, action: #selector(HJReadBottomView.clickButton(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            addSubview(button)
        }
        
        // 分割线
        spaceLine = SpaceLineSetup(self, color: RGB(234, g: 236, b: 242))
        
        // 上一章按钮
        lastChapter = UIButton(type:UIButtonType.Custom)
        lastChapter.titleLabel?.font = UIFont.systemFontOfSize(12)
        lastChapter.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Right
        lastChapter.setTitle("上一章", forState: UIControlState.Normal)
        lastChapter.setTitleColor(HJColor_4, forState: UIControlState.Normal)
        lastChapter.addTarget(self, action: #selector(HJReadBottomView.clickLastChapter), forControlEvents: UIControlEvents.TouchUpInside)
        addSubview(lastChapter)
        
        // 下一章按钮
        nextChapter = UIButton(type:UIButtonType.Custom)
        nextChapter.titleLabel?.font = UIFont.systemFontOfSize(12)
        nextChapter.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        nextChapter.setTitle("下一章", forState: UIControlState.Normal)
        nextChapter.setTitleColor(HJColor_4, forState: UIControlState.Normal)
        nextChapter.addTarget(self, action: #selector(HJReadBottomView.clickNextChapter), forControlEvents: UIControlEvents.TouchUpInside)
        addSubview(nextChapter)
        
        // 进度条
        slider = UISlider()
        slider.minimumValue = 0
        slider.tintColor = HJColor_4
        slider.setThumbImage(UIImage(named: "icon_read_0")!, forState: UIControlState.Normal)
        slider.addTarget(self, action: #selector(HJReadBottomView.sliderChanged(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        addSubview(slider)
    }
    
    func clickLastChapter() {
        
        delegate?.readBottomViewLastChapter?(self)
    }
    
    func clickNextChapter() {
        
        delegate?.readBottomViewNextChapter?(self)
    }
    
    /// 滑动方法
    @objc private func sliderChanged(slider:UISlider) {
        
        delegate?.readBottomViewChangeSlider?(self, slider: slider)
    }
    
    /// 点击按钮
    func clickButton(button:UIButton) {
        
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
            
            button.frame = CGRectMake(CGFloat(i) * buttonW, buttonY, buttonW, buttonH)
        }
        
        // 分割线
        spaceLine.frame = CGRectMake(0, 0, width, 0.5)
        
        // 以下使用的高度
        let tempH:CGFloat = buttonY
        
        // 进度条
        let sliderW:CGFloat = 208
        var chapterButtonW:CGFloat = (width - sliderW) / 2
        slider.frame = CGRectMake(chapterButtonW, 0, sliderW, tempH)
        
            
        // 按钮位置
        chapterButtonW -= HJSpaceOne
        lastChapter.frame = CGRectMake(0, 0, chapterButtonW, tempH)
        nextChapter.frame = CGRectMake(CGRectGetMaxX(slider.frame) + HJSpaceOne , 0, chapterButtonW, tempH)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
