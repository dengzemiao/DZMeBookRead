//
//  HJReadView.swift
//  HJProject
//
//  Created by 邓泽淼 on 16/8/25.
//  Copyright © 2016年 HanJue. All rights reserved.
//

import UIKit

class HJReadView: UIView {

    /// 当前文字
    var content:String!
    
    /// 当前视图文字
    var frameRef:CTFrame? {
        
        didSet{
            
            setNeedsDisplay()
        }
    }
    
    override func draw(_ rect: CGRect) {
        
        if (frameRef == nil) {
            
            return
        }
        
        let ctx = UIGraphicsGetCurrentContext()
        ctx?.textMatrix = CGAffineTransform.identity
        ctx?.translateBy(x: 0, y: self.bounds.size.height);
        ctx?.scaleBy(x: 1.0, y: -1.0);
        CTFrameDraw(frameRef!, ctx!);
    }

}
