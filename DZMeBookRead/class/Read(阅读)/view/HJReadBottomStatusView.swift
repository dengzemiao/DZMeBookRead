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
        timeLabel.text = "12:30"
        timeLabel.font = UIFont.fontOfSize(12)
        timeLabel.textAlignment = .Right
        addSubview(timeLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 电池W
        let batteryW:CGFloat = 30
        
        let h = HJSpaceTwo
        
        // 页码
        let numberPageLabelW:CGFloat = width/2
        numberPageLabel.frame = CGRectMake(HJSpaceTwo, (height - h)/2, width/2, h)
        
        // 时间
        let timeLabelW:CGFloat = width - numberPageLabelW - batteryW
        timeLabel.frame = CGRectMake(ScreenWidth - batteryW - timeLabelW, (height - h)/2, timeLabelW, h)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
