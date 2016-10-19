//
//  HJReadTopStatusView.swift
//  HJProject
//
//  Created by 邓泽淼 on 16/9/20.
//  Copyright © 2016年 HanJue. All rights reserved.
//

let HJReadTopStatusViewH:CGFloat = 30

import UIKit

class HJReadTopStatusView: UIView {

    // leftTitle
    private var leftTitle:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clearColor()
        
        addSubviews()
    }
    
    
    /**
     设置头部标题
     
     - parameter title: 标题
     */
    func setLeftTitle(title:String?) {
        
        self.leftTitle.text = title
    }
    
    
    func addSubviews() {
        
        // leftTitle
        leftTitle = UILabel()
        leftTitle.textColor = HJReadTextColor
        leftTitle.font = UIFont.fontOfSize(12)
        leftTitle.textAlignment = .Left
        addSubview(leftTitle)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        leftTitle.frame = CGRectMake(HJSpaceTwo, 0, width - 2*HJSpaceTwo, height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
