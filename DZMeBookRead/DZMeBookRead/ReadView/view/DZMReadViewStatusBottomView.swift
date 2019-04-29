//
//  DZMReadViewStatusBottomView.swift
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/4/17.
//  Copyright © 2019年 DZM. All rights reserved.
//

import UIKit

/// bottomView 高度
let DZM_READ_STATUS_BOTTOM_VIEW_HEIGHT:CGFloat =  DZM_SPACE_SA_30

class DZMReadViewStatusBottomView: UIView {
    
    /// 进度
    private(set) var progress:UILabel!
    
    /// 电池
    private var batteryView:DZMBatteryView!
    
    /// 时间
    private var timeLabel:UILabel!
    
    /// 计时器
    private var timer:Timer?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        addSubviews()
    }
    
    private func addSubviews() {
        
        // 电池
        batteryView = DZMBatteryView()
        batteryView.tintColor = DZMReadConfigure.shared().statusTextColor
        addSubview(batteryView)
        
        // 时间
        timeLabel = UILabel()
        timeLabel.textAlignment = .center
        timeLabel.font = DZM_FONT_SA_10
        timeLabel.textColor = DZMReadConfigure.shared().statusTextColor
        addSubview(timeLabel)
        
        // 进度
        progress = UILabel()
        progress.font = DZM_FONT_SA_10
        progress.textColor = DZMReadConfigure.shared().statusTextColor
        addSubview(progress)
        
        // 初始化调用
        didChangeTime()
        
        // 添加定时器
        addTimer()
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let w = frame.size.width
        let h = frame.size.height
    
        // 电池
        batteryView.frame.origin = CGPoint(x: w - DZMBatterySize.width, y: (h - DZMBatterySize.height) / 2)
        
        // 时间
        timeLabel.frame = CGRect(x: batteryView.frame.minX - DZM_SPACE_SA_50, y: 0, width: DZM_SPACE_SA_50, height: h)
        
        // 进度
        progress.frame = CGRect(x: 0, y: 0, width: DZM_SPACE_SA_50, height: h)
    }
    
    // MARK: -- 时间相关
    
    /// 添加定时器
    func addTimer() {
        
        if timer == nil {
            
            timer = Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(didChangeTime), userInfo: nil, repeats: true)
            
            RunLoop.current.add(timer!, forMode: .common)
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
    @objc func didChangeTime() {
        
        timeLabel.text = TimerString("HH:mm")
        
        batteryView.batteryLevel = UIDevice.current.batteryLevel
    }
    
    /// 销毁
    deinit {
        
        removeTimer()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
