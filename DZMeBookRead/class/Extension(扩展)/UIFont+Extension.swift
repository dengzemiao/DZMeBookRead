//
//  UIFont+Extension.swift
//  BlockPlay
//
//  Created by 邓泽淼 on 16/7/23.
//  Copyright © 2016年 DZM. All rights reserved.
//

import Foundation
import UIKit

extension UIFont {
    
    // MARK: -- System Font
    
    /// System 设置全部机型
    class func fontOfSize(_ size:CGFloat) ->UIFont {
        return systemFont(ofSize: size)
    }
    
    // System 区分机型设置 4 5 || 6 6P
    class func fontOfSize(_ is45:CGFloat,other:CGFloat) ->UIFont {
        
        if (is4sOr4 || is5sOr5) {
            
            return fontOfSize(is45)
            
        }
        
        return fontOfSize(other)
    }
    
    // System 区分机型设置 区分 4 5 || 6 || 6P
    class func fontOfSize(_ is45:CGFloat,is6:CGFloat,is6P:CGFloat) ->UIFont {
        
        if (is4sOr4 || is5sOr5) {
            
            return fontOfSize(is45)
            
        }else if is6sOr6 {
            
            return fontOfSize(is6)
            
        }else{}
        
        return fontOfSize(is6P)
    }
    
    
    // MARK: -- BoldSystem Font
    
    /// BoldSystem 设置全部机型
    class func boldFontOfSize(_ size:CGFloat) ->UIFont {
        return boldSystemFont(ofSize: size)
    }
    
    // BoldSystem 区分机型设置 4 5 || 6 6P
    class func boldFontOfSize(_ is45:CGFloat,other:CGFloat) ->UIFont {
        
        if (is4sOr4 || is5sOr5) {
            
            return boldFontOfSize(is45)
            
        }
        
        return boldFontOfSize(other)
    }
    
    // BoldSystem 区分机型设置 区分 4 5 || 6 || 6P
    class func boldFontOfSize(_ is45:CGFloat,is6:CGFloat,is6P:CGFloat) ->UIFont {
        
        if (is4sOr4 || is5sOr5) {
            
            return boldFontOfSize(is45)
            
        }else if is6sOr6 {
            
            return boldFontOfSize(is6)
            
        }else{}
        
        return boldFontOfSize(is6P)
    }
    
    
    // MARK: -- Custom Font
    
    /// CustomFont 设置全部机型
    class func fontOfNameSize(_ fontName:String,size:CGFloat) ->UIFont {
        return UIFont(name: fontName, size: size)!
    }
    
    // CustomFont 区分机型设置 4 5 || 6 6P
    class func fontOfNameSize(_ fontName:String,is45:CGFloat,other:CGFloat) ->UIFont {
        
        if (is4sOr4 || is5sOr5) {
            
            return fontOfNameSize(fontName,size: is45)
            
        }
        
        return fontOfNameSize(fontName,size: other)
    }
    
    // CustomFont 区分机型设置 区分 4 5 || 6 || 6P
    class func fontOfNameSize(_ fontName:String,is45:CGFloat,is6:CGFloat,is6P:CGFloat) ->UIFont {
        
        if (is4sOr4 || is5sOr5) {
            
            return fontOfNameSize(fontName,size: is45)
            
        }else if is6sOr6 {
            
            return fontOfNameSize(fontName,size: is6)
            
        }else{}
        
        return fontOfNameSize(fontName,size: is6P)
    }
    
}
