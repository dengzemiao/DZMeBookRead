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
            
            let obj = objc_getAssociatedObject(self, &IsGestureRecognizerEnabled) as? NSNumber
            
            return  obj == nil ? true : obj!.boolValue
        }
        
        set{
            
            for ges in gestureRecognizers { ges.isEnabled = newValue}
            
            objc_setAssociatedObject(self, &IsGestureRecognizerEnabled,NSNumber(value: newValue as Bool), objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    /// Tap手势开关
    var tapGestureRecognizerEnabled:Bool {
        
        get{
            
            let obj = objc_getAssociatedObject(self, &TapIsGestureRecognizerEnabled) as? NSNumber
            
            return  obj == nil ? true : obj!.boolValue
        }
        
        set{
            
            for ges in gestureRecognizers {
                
                if ges.isKind(of: UITapGestureRecognizer.classForCoder()) {
                    
                    ges.isEnabled = newValue
                }
            }
            
            objc_setAssociatedObject(self, &TapIsGestureRecognizerEnabled,NSNumber(value: newValue as Bool), objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
}
