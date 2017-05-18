//
//  DZMRMStatusView.swift
//  DZMeBookRead
//
//  Created by 邓泽淼 on 2017/5/11.
//  Copyright © 2017年 DZM. All rights reserved.
//

import UIKit

class DZMRMStatusView: DZMRMBaseView {
    
    /// 电池
    private(set) var batteryView:DZMBatteryView!
    
    /// 时间
    private(set) var timeLabel:UILabel!
    
    /// 标题
    private(set) var titleLabel:UILabel!
    
    /// 计时器
    private(set) var timer:Timer?
    
    override func addSubviews() {
        
        super.addSubviews()
        
        // 背景颜色
        backgroundColor = DZMColor_1.withAlphaComponent(0.4)
        
        // 电池
        batteryView = DZMBatteryView()
        batteryView.tintColor = DZMColor_3
        addSubview(batteryView)
        
        // 时间
        timeLabel = UILabel()
        timeLabel.textAlignment = .center
        timeLabel.font = DZMFont_12
        timeLabel.textColor = DZMColor_3
        addSubview(timeLabel)
        
        // 标题
        titleLabel = UILabel()
        titleLabel.font = DZMFont_12
        titleLabel.textColor = DZMColor_3
        addSubview(titleLabel)
        
        // 初始化调用
        didChangeTime()
        
        // 添加定时器
        addTimer()
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        // 电池
        batteryView.origin = CGPoint(x: width - DZMBatterySize.width, y: (height - DZMBatterySize.height)/2)
        
        // 时间
        let timeLabelW:CGFloat = DZMSizeW(50)
        timeLabel.frame = CGRect(x: batteryView.frame.minX - timeLabelW, y: 0, width: timeLabelW, height: height)
        
        // 标题
        titleLabel.frame = CGRect(x: 0, y: 0, width: timeLabel.frame.minX, height: height)
    }

    // MARK: -- 时间相关
    
    /// 添加定时器
    func addTimer() {
        
        if timer == nil {
            
            timer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(DZMRMStatusView.didChangeTime), userInfo: nil, repeats: true)
            
            RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
        }
    }
    
    /// 删除定时器
    func removeTimer() {
        
        if timer != nil {
            
            timer!.invalidate()
            
            timer = nil
        }
    }
    
    /// 时间变化
    func didChangeTime() {
        
        timeLabel.text = GetCurrentTimerString(dateFormat: "HH:mm")
        
        batteryView.batteryLevel = UIDevice.current.batteryLevel
    }
    
    /// 销毁
    deinit {
        
        removeTimer()
    }
}
