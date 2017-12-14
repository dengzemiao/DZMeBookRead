//
//  UIView+Extension.swift
//  DZMeBookRead
//
//  Created by 邓泽淼 on 2017/5/11.
//  Copyright © 2016年 DZM. All rights reserved.
//

private var IsOpenTouch = "isOpenTouch"

import Foundation
import UIKit

extension UIView{
    
    
    // MARK: -- 扩展属性使用
    
    public var x: CGFloat{
        get{
            return self.frame.origin.x
        }
        set{
            var r = self.frame
            r.origin.x = newValue
            self.frame = r
        }
    }
    
    public var y: CGFloat{
        get{
            return self.frame.origin.y
        }
        set{
            var r = self.frame
            r.origin.y = newValue
            self.frame = r
        }
    }
    
    public var width: CGFloat{
        get{
            return self.frame.size.width
        }
        set{
            var r = self.frame
            r.size.width = newValue
            self.frame = r
        }
    }
    public var height: CGFloat{
        get{
            return self.frame.size.height
        }
        set{
            var r = self.frame
            r.size.height = newValue
            self.frame = r
        }
    }
    
    
    public var origin: CGPoint{
        get{
            return self.frame.origin
        }
        set{
            self.x = newValue.x
            self.y = newValue.y
        }
    }
    
    public var size: CGSize{
        get{
            return self.frame.size
        }
        set{
            self.width = newValue.width
            self.height = newValue.height
        }
    }
    
    public var centerX : CGFloat{
        get{
            return self.center.x
        }
        set{
            self.center = CGPoint(x: newValue, y: self.center.y)
        }
    }
    
    public var centerY : CGFloat{
        get{
            return self.center.y
        }
        set{
            self.center = CGPoint(x: self.center.x, y: newValue)
        }
    }
    
    public var rightX: CGFloat{
        get{
            return self.x + self.width
        }
        set{
            var r = self.frame
            r.origin.x = newValue - frame.size.width
            self.frame = r
        }
    }

    public var bottomY: CGFloat{
        get{
            return self.y + self.height
        }
        set{
            var r = self.frame
            r.origin.y = newValue - frame.size.height
            self.frame = r
        }
    }
    
    // MARK: -- 响应者拦截
    
    /// 开启允许父视图监听Touch事件
    var openTouch:Bool {
        
        get{
            
            return (objc_getAssociatedObject(self, &IsOpenTouch) as? Bool) ?? false
        }
        
        set{
            
            objc_setAssociatedObject(self, &IsOpenTouch, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    /// 开始触摸
    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if openTouch {
            
            next?.touchesBegan(touches, with: event)
            
        }else{
            
            super.touchesBegan(touches, with: event)
        }
    }
    
    /// 触摸移动
    open override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if openTouch {
            
            next?.touchesMoved(touches, with: event)
            
        }else{
            
            super.touchesMoved(touches, with: event)
        }
    }
    
    /// 触摸结束
    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if openTouch {
            
            next?.touchesEnded(touches, with: event)
            
        }else{
            
            super.touchesEnded(touches, with: event)
        }
    }
    
    /// 触摸取消
    open override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if openTouch {
            
            next?.touchesCancelled(touches, with: event)
            
        }else{
            
            super.touchesCancelled(touches, with: event)
        }
    }
    
    
    // MARK: -- 扩展方法
    
    /// 获得视图控制器
    func viewController() ->UIViewController? {
        
        // 通过响应者链，取得此视图所在的视图控制器
        var next = self.next
        
        repeat{
            
            // 判断响应者对象是否是视图控制器类型
            if next!.isKind(of: UIViewController.classForCoder()) {
                
                return next as? UIViewController
            }
            
            next = next!.next
            
        }while next != nil
        
        return nil
    }
}
