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
    fileprivate var textLabel:UILabel!
    
    /// 分割线
    fileprivate var spaceLine:UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.white
        
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
        
        textLabel.frame = CGRect(x: 18, y: 10, width: 50, height: 15)
        
        spaceLine.frame = CGRect(x: 0, y: height - HJSpaceLineHeight, width: width, height: HJSpaceLineHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
