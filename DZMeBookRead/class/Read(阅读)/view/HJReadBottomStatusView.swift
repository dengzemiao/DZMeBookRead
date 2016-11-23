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
    fileprivate var numberPageLabel:UILabel!

    /// 时间
    fileprivate var timeLabel:UILabel!
    
    /// 倒计时器
    fileprivate var timer:Timer?
    
    /// 电池view
    fileprivate var batteryView:HJBatteryView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubviews()
    }
    
    /// 设置页码
    func setNumberPage(_ page:Int,tatolPage:Int) {
        
        let tempPage = (page + 1) > tatolPage ? tatolPage : (page + 1)
        
        numberPageLabel.text = "\(tempPage)/\(tatolPage)"
    }
    
    func addSubviews() {
       
        // 页码
        numberPageLabel = UILabel()
        numberPageLabel.textColor = UIColor.black
        numberPageLabel.font = UIFont.fontOfSize(12)
        numberPageLabel.textAlignment = .left
        addSubview(numberPageLabel)
        
        // 时间label
        timeLabel = UILabel()
        timeLabel.textColor = UIColor.black
        timeLabel.font = UIFont.fontOfSize(12)
        timeLabel.textAlignment = .right
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
        numberPageLabel.frame = CGRect(x: HJSpaceTwo, y: (height - h)/2, width: width/2, height: h)
        
        // 时间
        let timeLabelW:CGFloat = width - numberPageLabelW - 2*HJBatterySize.width - HJSpaceThree
        timeLabel.frame = CGRect(x: numberPageLabel.frame.maxX, y: (height - h)/2, width: timeLabelW, height: h)
        
        // 电池
        batteryView.frame.origin = CGPoint(x: timeLabel.frame.maxX + HJSpaceThree, y: (height - HJBatterySize.height)/2)
        
    }
    
    // MARK: -- 时间相关
    
    func addTimer() {
        
        if timer == nil {
            
            timer = Timer.scheduledTimer(timeInterval: 30, target: self, selector: #selector(HJReadBottomStatusView.didChangeTime), userInfo: nil, repeats: true)
            
            RunLoop.current.add(timer!, forMode: RunLoopMode.commonModes)
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
        
        batteryView.batteryLevel = UIDevice.current.batteryLevel
        
        timeLabel.text = GetCurrentTimerString("HH:mm")
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        
        removeTimer()
    }
}
