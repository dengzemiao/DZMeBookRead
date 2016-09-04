//
//  HJReadLeftHeaderView.swift
//  HJProject
//
//  Created by 邓泽淼 on 16/8/15.
//  Copyright © 2016年 HanJue. All rights reserved.
//

import UIKit

class HJReadLeftHeaderView: UIView {

    /// title
    private var textLabel:UILabel!
    
    /// 分割线
    private var spaceLine:UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.whiteColor()
        
        addSubviews()
    }
    
    func addSubviews() {
        
        // title
        textLabel = UILabel()
        textLabel.text = "全部章节"
        textLabel.textColor = HJColor_4
        textLabel.font = UIFont.fontOfSize(10)
        addSubview(textLabel)
        
        // 分割线
        spaceLine = SpaceLineSetup(self, color: HJColor_6)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        textLabel.frame = CGRectMake(18, 10, 50, 15)
        
        spaceLine.frame = CGRectMake(0, height - HJSpaceLineHeight, width, HJSpaceLineHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
