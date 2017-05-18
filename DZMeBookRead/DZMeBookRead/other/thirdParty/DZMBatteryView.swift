//
//  DZMBatteryView.swift
//  DZMeBookRead
//
//  Created by 邓泽淼 on 2017/5/11.
//  Copyright © 2017年 DZM. All rights reserved.
//


/// 电池宽推荐使用宽高
var DZMBatterySize:CGSize = CGSize(width: 25, height: 10)

/// 电池量宽度 跟图片的比例
private var HJBatteryLevelViewW:CGFloat = 20
private var HJBatteryLevelViewScale = HJBatteryLevelViewW / DZMBatterySize.width

import UIKit

class DZMBatteryView: UIImageView {

    /// 颜色
    override var tintColor: UIColor! {
        
        didSet{
    
            batteryLevelView.backgroundColor = tintColor
        }
    }
    
    /// BatteryLevel
    var batteryLevel:Float = 0 {
        
        didSet{
            
            setNeedsLayout()
        }
    }
    
    /// BatteryLevelView
    private var batteryLevelView:UIView!
    
    /// 初始化
    convenience init() {
        
        self.init(frame: CGRect(x: 0, y: 0, width: DZMBatterySize.width, height: DZMBatterySize.height))
    }
    
    /// 初始化
    override init(frame: CGRect) {
        
        super.init(frame: CGRect(x: 0, y: 0, width: DZMBatterySize.width, height: DZMBatterySize.height))
        
        addSubviews()
    }
    
    func addSubviews() {
        
        // 进度
        batteryLevelView = UIView()
        batteryLevelView.layer.masksToBounds = true
        addSubview(batteryLevelView)
        
        // 设置样式
        image = UIImage(named: "G_Battery_Black")?.withRenderingMode(.alwaysTemplate)
        tintColor = UIColor.white
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let spaceW:CGFloat = 1 * (frame.width / DZMBatterySize.width) * HJBatteryLevelViewScale
        let spaceH:CGFloat = 1 * (frame.height / DZMBatterySize.height) * HJBatteryLevelViewScale
        
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
