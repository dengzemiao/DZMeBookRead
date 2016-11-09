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
    fileprivate var leftTitle:UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor.clear
        
        addSubviews()
    }
    
    
    /**
     设置头部标题
     
     - parameter title: 标题
     */
    func setLeftTitle(_ title:String?) {
        
        self.leftTitle.text = title
    }
    
    
    func addSubviews() {
        
        // leftTitle
        leftTitle = UILabel()
        leftTitle.textColor = HJReadTextColor
        leftTitle.font = UIFont.fontOfSize(12)
        leftTitle.textAlignment = .left
        addSubview(leftTitle)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        leftTitle.frame = CGRect(x: HJSpaceTwo, y: 0, width: width - 2*HJSpaceTwo, height: height)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
