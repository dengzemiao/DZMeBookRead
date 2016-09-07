//
//  HJReadBottomStatusView.swift
//  DZMeBookRead
//
//  Created by 邓泽淼 on 16/9/7.
//  Copyright © 2016年 DZM. All rights reserved.
//

let HJReadBottomStatusViewH:CGFloat = 30

import UIKit

class HJReadBottomStatusView: UIView {
    
    /// 页码
    private var numberPageLabel:UILabel!

    /// 时间
    private var timeLabel:UILabel!
    
    /// 倒计时器
    private var timer:NSTimer?
    
    /// 电池view
    private var batteryView:HJBatteryView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
    }
    
    /// 设置页码
    func setNumberPage(page:Int,tatolPage:Int) {
        
        numberPageLabel.text = "\(page + 1)/\(tatolPage)"
    }
    
    func addSubviews() {
       
        // 页码
        numberPageLabel = UILabel()
        numberPageLabel.textColor = UIColor.blackColor()
        numberPageLabel.font = UIFont.fontOfSize(12)
        numberPageLabel.textAlignment = .Left
        addSubview(numberPageLabel)
        
        // 时间label
        timeLabel = UILabel()
        timeLabel.textColor = UIColor.blackColor()
        timeLabel.font = UIFont.fontOfSize(12)
        timeLabel.textAlignment = .Right
        addSubview(timeLabel)
        
        // 电池
        batteryView = HJBatteryView()
        addSubview(batteryView)
        
        // 添加定时器获取时间
        addTimer()
        didChangeTime()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let h = HJSpaceTwo
        
        // 页码
        let numberPageLabelW:CGFloat = width/2
        numberPageLabel.frame = CGRectMake(HJSpaceTwo, (height - h)/2, width/2, h)
        
        // 时间
        let timeLabelW:CGFloat = width - numberPageLabelW - 2*HJBatterySize.width
        timeLabel.frame = CGRectMake(CGRectGetMaxX(numberPageLabel.frame), (height - h)/2, timeLabelW, h)
        
        // 电池
        batteryView.frame.origin = CGPointMake(CGRectGetMaxX(timeLabel.frame) + 5, (height - HJBatterySize.height)/2)
        
    }
    
    // MARK: -- 时间相关
    
    func addTimer() {
        
        if timer == nil {
            
            timer = NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: #selector(HJReadBottomStatusView.didChangeTime), userInfo: nil, repeats: true)
            
            NSRunLoop.currentRunLoop().addTimer(timer!, forMode: NSRunLoopCommonModes)
        }
    }
    
    func removeTimer() {
       
        if timer != nil {
            
            timer!.invalidate()
            
            timer = nil
        }
    }
    
    /// 时间变化
    func didChangeTime() {
        
        batteryView.batteryLevel = UIDevice.currentDevice().batteryLevel
        
        timeLabel.text = GetCurrentTimerString("HH:mm")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        
        removeTimer()
    }
}
