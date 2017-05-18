//
//  DZMReadView.swift
//  DZMeBookRead
//
//  Created by 邓泽淼 on 2017/5/15.
//  Copyright © 2017年 DZM. All rights reserved.
//

import UIKit

class DZMReadView: UIView {

    /// 内容
    var content:String? {
        
        didSet{
            
            if content != nil && !content!.isEmpty {
                
                frameRef = DZMReadParser.GetReadFrameRef(content: content!, attrs: DZMReadConfigure.shared().readAttribute(), rect: GetReadViewFrame())
            }
        }
    }
    
    /// CTFrame
    var frameRef:CTFrame? {
        
        didSet{
            
            if frameRef != nil {
                
                setNeedsDisplay()
            }
        }
    }
    
    /// 绘制
    override func draw(_ rect: CGRect) {
        
        if (frameRef == nil) {return}
        
        let ctx = UIGraphicsGetCurrentContext()
        
        ctx?.textMatrix = CGAffineTransform.identity
        
        ctx?.translateBy(x: 0, y: bounds.size.height);
        
        ctx?.scaleBy(x: 1.0, y: -1.0);
        
        CTFrameDraw(frameRef!, ctx!);
    }
}
