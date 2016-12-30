//
//  HJBatteryView.swift
//  asdasd
//
//  Created by 邓泽淼 on 16/9/7.
//  Copyright © 2016年 DZM. All rights reserved.
//

/// 电池宽推荐使用宽高
var HJBatterySize:CGSize = CGSize(width: 25, height: 10)

// 电池样式
enum HJBatteryType:Int {
    case Black
    case White
}

/// 电池量宽度 跟图片的比例
private var HJBatteryLevelViewW:CGFloat = 20
private var HJBatteryLevelViewScale = HJBatteryLevelViewW / HJBatterySize.width

import UIKit

class HJBatteryView: UIImageView {
   
    // 电池样式
    var batteryType:HJBatteryType! {
        
        didSet{
            
            if batteryType == .Black {
                
                image = UIImage(named: "Battery_Black")
                batteryLevelView.backgroundColor = UIColor.black
                
            }else{
                
                image = UIImage(named: "Battery_White")
                batteryLevelView.backgroundColor = UIColor.white
            }
        }
    }
    
    /// BatteryLevel
    var batteryLevel:Float = 0 {
        
        didSet{
            
            setNeedsLayout()
        }
    }
    
    /// BatteryLevelView
    fileprivate var batteryLevelView:UIView!
    
    convenience init() {
        
        self.init(frame: CGRect(x: 0, y: 0, width: HJBatterySize.width, height: HJBatterySize.height))
    }
    
    override init(frame: CGRect) {
        
        super.init(frame: CGRect(x: 0, y: 0, width: HJBatterySize.width, height: HJBatterySize.height))
        
        addSubviews()
    }
    
    func addSubviews() {
        
        // 进度
        batteryLevelView = UIView()
        batteryLevelView.layer.masksToBounds = true
        addSubview(batteryLevelView)
        
        // 设置样式
        batteryType = .Black
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
        
        batteryLevelView.frame = CGRect(x: batteryLevelViewX , y: batteryLevelViewY, width: CGFloat(tempBatteryLevel * 100) * batteryLevelViewWScale, height: batteryLevelViewH)
        batteryLevelView.layer.cornerRadius = batteryLevelViewH * 0.125
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
