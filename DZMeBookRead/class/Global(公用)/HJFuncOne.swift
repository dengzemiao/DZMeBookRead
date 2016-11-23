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

// 自定义LOG
func HJLog<T>(_ message:T) {
    
    #if DEBUG
        
        print("\(message)")
        
    #endif
}

// MARK: -- 代码屏幕适配

///  以iPhone6为比例
func HJSize(_ size:CGFloat) ->CGFloat {
    
    return size * (ScreenWidth / 375)
}


// MARK: -- 颜色 -----------------------

/// RGB
func RGB(_ r:CGFloat,g:CGFloat,b:CGFloat) -> UIColor {
    return RGBA(r, g: g, b: b, a: 1.0)
}

/// RGBA
func RGBA(_ r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat) -> UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}


// MARK: -- 高度适配使用 Screen Adaptation

func SA(_ is45:CGFloat,other:CGFloat) ->CGFloat {
    
    return SA(is45, is6: other, is6P: other)
}

func SA(_ is45:CGFloat,is6:CGFloat,is6P:CGFloat) ->CGFloat {
    
    if (is4sOr4 || is5sOr5) {
        
        return is45
        
    }else if is6sOr6 {
        
        return is6
        
    }else{}
    
    return is6P
}


// MARK: -- 计算字符串 -----------------------

/// 计算字符串
func Size(_ string:String?,font:UIFont) ->CGSize {
    
    return Size(string,font: font,constrainedToSize: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
}

/// 计算字符串
func Size(_ string:String?,font:UIFont,constrainedToSize:CGSize) ->CGSize {
    
    var TempSize = CGSize(width: 0, height: 0)
    
    if (string != nil && !string!.isEmpty) {
        
        TempSize = string!.size(font, constrainedToSize: constrainedToSize)
    }
    
    return TempSize
}




// MARK: -- 计算多态字符串 -----------------------

/// 计算多态字符串
func Size(_ string:NSAttributedString?) ->CGSize {
    
    return Size(string, constrainedToSize: CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude))
}

/// 计算多态字符串
func Size(_ string:NSAttributedString?,constrainedToSize:CGSize) ->CGSize {
    
    var TempSize = CGSize(width: 0, height: 0)
    
    if (string != nil) {
        
        TempSize = string!.size(constrainedToSize)
    }
    
    return TempSize
}

// MARK: -- 获取时间

/// 获取当前时间传入 时间格式 "YYYY-MM-dd-HH-mm-ss"
func GetCurrentTimerString(_ dateFormat:String) ->String {
    
    let dateformatter = DateFormatter()
    
    dateformatter.dateFormat = dateFormat
    
    return dateformatter.string(from: Date())
}

func GetTimerString(_ dateFormat:String,date:Date) ->String {
    
    let dateformatter = DateFormatter()
    
    dateformatter.dateFormat = dateFormat
    
    return dateformatter.string(from: date)
}

// MARK: -- 归档对象

/**
 归档对象
 
 - parameter fileName:    fileName
 - parameter object: 对象
 */
func KeyedArchiver(_ fileName:String,object:Any) {
    
    let path = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last! as String) + "/\(fileName)"
    
    NSKeyedArchiver.archiveRootObject(object, toFile: path)
}

/**
 删除归档文件
 
 - parameter fileName: 文件名称
 */
func KeyedRemoveArchiver(_ fileName:String) {
    
    let path = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last! as String) + "/\(fileName)"
    
    do{
        try FileManager.default.removeItem(atPath: path)
    }catch{}
}

/**
 是否存在了改归档文件
 
 - parameter fileName: 文件名称
 
 - returns: 是否存在
 */
func KeyedIsExistArchiver(_ fileName:String) ->Bool {
    
    let path = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last! as String) + "/\(fileName)"
    
    return FileManager.default.fileExists(atPath: path)
}

/**
 解档对象
 
 - parameter fileName: fileName
 
 - returns: 对象
 */
func KeyedUnarchiver(_ fileName:String) ->Any? {
    
    let path = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last! as String) + "/\(fileName)"
    
    return NSKeyedUnarchiver.unarchiveObject(withFile: path)
}
