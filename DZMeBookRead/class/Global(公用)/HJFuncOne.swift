//
//  HJFuncOne.swift
//  HJProject
//
//  Created by 邓泽淼 on 16/8/1.
//  Copyright © 2016年 HanJue. All rights reserved.
//

import Foundation
import UIKit

// MARK: -- 该页面只存放与系统全局使用有关的

// MARK: -- 代码屏幕适配

///  以iPhone6为比例
func HJSize(size:CGFloat) ->CGFloat {
    
    return size * (ScreenWidth / 375)
}


// MARK: -- 颜色 -----------------------

/// RGB
func RGB(r:CGFloat,g:CGFloat,b:CGFloat) -> UIColor {
    return RGBA(r, g: g, b: b, a: 1.0)
}

/// RGBA
func RGBA(r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat) -> UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}


// MARK: -- 高度适配使用 Screen Adaptation

func SA(is45:CGFloat,other:CGFloat) ->CGFloat {
    
    return SA(is45, is6: other, is6P: other)
}

func SA(is45:CGFloat,is6:CGFloat,is6P:CGFloat) ->CGFloat {
    
    if (is4sOr4 || is5sOr5) {
        
        return is45
        
    }else if is6sOr6 {
        
        return is6
        
    }else{}
    
    return is6P
}


// MARK: -- 计算字符串 -----------------------

/// 计算字符串
func Size(string:String?,font:UIFont) ->CGSize {
    
    return Size(string,font: font,constrainedToSize: CGSizeMake(CGFloat.max, CGFloat.max))
}

/// 计算字符串
func Size(string:String?,font:UIFont,constrainedToSize:CGSize) ->CGSize {
    
    var TempSize = CGSizeMake(0, 0)
    
    if (string != nil && !string!.isEmpty) {
        
        TempSize = string!.size(font, constrainedToSize: constrainedToSize)
    }
    
    return TempSize
}




// MARK: -- 计算多态字符串 -----------------------

/// 计算多态字符串
func Size(string:NSAttributedString?) ->CGSize {
    
    return Size(string, constrainedToSize: CGSizeMake(CGFloat.max, CGFloat.max))
}

/// 计算多态字符串
func Size(string:NSAttributedString?,constrainedToSize:CGSize) ->CGSize {
    
    var TempSize = CGSizeMake(0, 0)
    
    if (string != nil) {
        
        TempSize = string!.size(constrainedToSize)
    }
    
    return TempSize
}

// MARK: -- 获取时间

/// 获取当前时间传入 时间格式 "YYYY-MM-dd-HH-mm-ss"
func GetCurrentTimerString(dateFormat:String) ->String {
    
    let dateformatter = NSDateFormatter()
    
    dateformatter.dateFormat = dateFormat
    
    return dateformatter.stringFromDate(NSDate())
}

// MARK: -- 归档对象

/**
 归档对象
 
 - parameter fileName:    fileName
 - parameter object: 对象
 */
func KeyedArchiver(fileName:String,object:AnyObject) {
    
    let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last?.stringByAppendingString("/\(fileName)")
    
    NSKeyedArchiver.archiveRootObject(object, toFile: path!)
}

/**
 删除归档文件
 
 - parameter fileName: 文件名称
 */
func KeyedRemoveArchiver(fileName:String) {
    
    let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last?.stringByAppendingString("/\(fileName)")
    
    do{
        try NSFileManager.defaultManager().removeItemAtPath(path!)
    }catch{}
}

/**
 是否存在了改归档文件
 
 - parameter fileName: 文件名称
 
 - returns: 是否存在
 */
func KeyedIsExistArchiver(fileName:String) ->Bool {
    
    let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last?.stringByAppendingString("/\(fileName)")
    
    return NSFileManager.defaultManager().fileExistsAtPath(path!)
}

/**
 解档对象
 
 - parameter fileName: fileName
 
 - returns: 对象
 */
func KeyedUnarchiver(fileName:String) ->AnyObject? {
    
    let path = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true).last?.stringByAppendingString("/\(fileName)")
    
    return NSKeyedUnarchiver.unarchiveObjectWithFile(path!)
}
