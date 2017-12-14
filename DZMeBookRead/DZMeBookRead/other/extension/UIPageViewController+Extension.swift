//
//  UIPageViewController+Extension.swift
//  DZMeBookRead
//
//  Created by 邓泽淼 on 2017/5/11.
//  Copyright © 2017年 DZM. All rights reserved.
//

/// key
private var IsGestureRecognizerEnabled = "IsGestureRecognizerEnabled"
private var TapIsGestureRecognizerEnabled = "TapIsGestureRecognizerEnabled"

import UIKit

extension UIPageViewController {

    /// 手势开关
    var gestureRecognizerEnabled:Bool {
        
        get{
            
            return (objc_getAssociatedObject(self, &IsGestureRecognizerEnabled) as? Bool) ?? true
        }
        
        set{
            
            for ges in gestureRecognizers { ges.isEnabled = newValue }
            
            objc_setAssociatedObject(self, &IsGestureRecognizerEnabled, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    /// Tap手势开关
    var tapGestureRecognizerEnabled:Bool {
        
        get{
            
            return (objc_getAssociatedObject(self, &TapIsGestureRecognizerEnabled) as? Bool) ?? true
        }
        
        set{
            
            for ges in gestureRecognizers {
                
                if ges.isKind(of: UITapGestureRecognizer.classForCoder()) {
                    
                    ges.isEnabled = newValue
                }
            }
            
            objc_setAssociatedObject(self, &TapIsGestureRecognizerEnabled, newValue , objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
}
