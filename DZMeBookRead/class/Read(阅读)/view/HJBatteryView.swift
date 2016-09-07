//
//  HJBatteryView.swift
//  asdasd
//
//  Created by 邓泽淼 on 16/9/7.
//  Copyright © 2016年 DZM. All rights reserved.
//

/// 电池宽推荐使用宽高
var HJBatterySize:CGSize = CGSizeMake(25, 10)

/// 电池量宽度 跟图片的比例
private var HJBatteryLevelViewW:CGFloat = 20
private var HJBatteryLevelViewScale = HJBatteryLevelViewW / HJBatterySize.width

import UIKit

class HJBatteryView: UIImageView {
   
    /// BatteryLevel
    var batteryLevel:Float = 0 {
        
        didSet{
            
            setNeedsLayout()
        }
    }
    
    /// BatteryLevelView
    private var batteryLevelView:UIView!
    
    convenience init() {
        
        self.init(frame: CGRectMake(0, 0, HJBatterySize.width, HJBatterySize.height))
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: CGRectMake(0, 0, HJBatterySize.width, HJBatterySize.height))
        
        addSubviews()
    }
    
    func addSubviews() {
        
        // 图片
        image = UIImage(named: "Battery")
        
        // 进度
        batteryLevelView = UIView()
        batteryLevelView.layer.masksToBounds = true
        batteryLevelView.backgroundColor = UIColor.blackColor()
        addSubview(batteryLevelView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let spaceW:CGFloat = 1 * (frame.width / HJBatterySize.width) * HJBatteryLevelViewScale
        let spaceH:CGFloat = 1 * (frame.height / HJBatterySize.height) * HJBatteryLevelViewScale
        
        let batteryLevelViewY:CGFloat = 2.1*spaceH
        let batteryLevelViewX:CGFloat = 1.4*spaceW
        let batteryLevelViewH:CGFloat = frame.height - 3.4*spaceH
        let batteryLevelViewW:CGFloat = frame.width * HJBatteryLevelViewScale
        let batteryLevelViewWScale:CGFloat = batteryLevelViewW / 100
        
        // 判断电量
        var tempBatteryLevel = batteryLevel
        
        if batteryLevel < 0 {
            
            tempBatteryLevel = 0
            
        }else if batteryLevel > 1 {
            
            tempBatteryLevel = 1
            
        }else{}
        
        batteryLevelView.frame = CGRectMake(batteryLevelViewX , batteryLevelViewY, CGFloat(tempBatteryLevel * 100) * batteryLevelViewWScale, batteryLevelViewH)
        batteryLevelView.layer.cornerRadius = batteryLevelViewH * 0.125
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
