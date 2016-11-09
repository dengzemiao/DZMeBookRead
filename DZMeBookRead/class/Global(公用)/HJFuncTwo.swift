//
//  HJFuncTwo.swift
//  HJProject
//
//  Created by 邓泽淼 on 16/8/2.
//  Copyright © 2016年 HanJue. All rights reserved.
//

import Foundation
import UIKit

// MARK: -- 自动获取屏幕高度 -----------------------

/// 自动获取view的高度 自动判断 是否有 导航栏跟TabBar
func ViewHeight(_ controller:UIViewController) ->CGFloat {
    
    var navigationHidden = true
    
    var tabBarHidden = true
    
    if controller.navigationController != nil { // 有导航栏
        
        navigationHidden = controller.navigationController!.isNavigationBarHidden
    }
    
    if controller.tabBarController != nil { // 有tabBar
        
        tabBarHidden = controller.tabBarController!.tabBar.isHidden
    }
    
    return ViewHeight(navigationHidden, tabBarHidden: tabBarHidden)
}

/// 自动判断 是否有 导航栏 手动设置 是否有 TabBar
func ViewHeight(_ controller:UIViewController,tabBarHidden:Bool) ->CGFloat {
    
    var navigationHidden = true
    
    if controller.navigationController != nil { // 有导航栏
        
        navigationHidden = controller.navigationController!.isNavigationBarHidden
    }
    
    return ViewHeight(navigationHidden, tabBarHidden: tabBarHidden)
}

/// 自定义计算View高 手动设置 是否有 导航栏跟TabBar
func ViewHeight(_ navigationHidden:Bool,tabBarHidden:Bool) -> CGFloat {
    
    var h = ScreenHeight
    
    if !navigationHidden { // 有导航栏
        
        h -= NavgationBarHeight
    }
    
    if !tabBarHidden { // 有tabBar
        
        h -= TabBarHeight
    }
    
    return h
}



// MARK: -- 时间 -----------------------

// MARK: - "yyyy-MM-dd HH:mm:ss" 格式 字符串转成NSDate

func DateWithString(_ str:String) ->Date {
    
    let format = DateFormatter()
    
    format.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    let timeDate = format.date(from: str)
    
    return timeDate!
}

// MARK: - 获取 "yyyy-MM-dd HH:mm:ss" 格式 的时间字符串

func DateString() ->String {
    
    let format = DateFormatter()
    
    format.dateFormat = "yyyy-MM-dd HH:mm:ss"
    
    let timeDate = Date()
    
    return format.string(from: timeDate)
}



// MARK: -- 手机号码处理 -----------------------

/// 判断输入的是否是手机格式  YES 为是手机号码 NO 不是
func CheckIsPhoneNumber(_ phoneNum:String) ->Bool {
    
    /// 手机号码
    let MOBILE:String = "^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$"
    
    /// 中国移动：China Mobile
    let CM:String = "^1(34[0-8]|(3[5-9]|5[017-9]|8[278])\\d)\\d{7}$"
    
    /// 手机号码
    let CU:String = "^1(3[0-2]|5[256]|8[56])\\d{8}$"
    
    /// 手机号码
    let CT:String = "^1((33|53|8[09])[0-9]|349)\\d{7}$"
    
    /// 大陆地区固话及小灵通
    // let PHS:String = "^0(10|2[0-5789]|\\d{3})\\d{7,8}$"
    
    let regextestmobile:NSPredicate = NSPredicate(format: "SELF MATCHES %@", MOBILE)
    let regextestcm:NSPredicate = NSPredicate(format: "SELF MATCHES %@", CM)
    let regextestcu:NSPredicate = NSPredicate(format: "SELF MATCHES %@", CU)
    let regextestct:NSPredicate = NSPredicate(format: "SELF MATCHES %@", CT)
    let res1:Bool = regextestmobile.evaluate(with: phoneNum)
    let res2:Bool = regextestcm.evaluate(with: phoneNum)
    let res3:Bool = regextestcu.evaluate(with: phoneNum)
    let res4:Bool = regextestct.evaluate(with: phoneNum)
    
    if res1 || res2 || res3 || res4 {
        return true
    }else{
        return false
    }
}

/**
 隐藏手机号码中间的数 188*****449
 
 - parameter phoneNum: 手机号码 18812345449
 
 - returns: 处理好的手机号码 188*****449
 */
func phoneNumberEncryption(_ phoneNum:String) ->String {
    
    if CheckIsPhoneNumber(phoneNum) {
        
        let length:Int = 3 // 前后隐藏长度
        
        let strOneStart = phoneNum.characters.index(phoneNum.startIndex, offsetBy: 0)
        
        let strOneEnd = phoneNum.characters.index(phoneNum.startIndex, offsetBy: length)
        
        let strOne:String = phoneNum.substring(with: Range(strOneStart ..< strOneEnd))
        
        
        let strTwoStart = phoneNum.characters.index(phoneNum.endIndex, offsetBy: -length)
        
        let strTwoEnd = phoneNum.characters.index(phoneNum.endIndex, offsetBy: 0)
        
        let strTwo:String = phoneNum.substring(with: Range(strTwoStart ..< strTwoEnd))
        
        return strOne + "*****" + strTwo
    }
    
    return phoneNum
}

// MARK: -- 创建文件夹 -----------------------

/**
 创建文件夹 如果存在则不创建
 
 - parameter filePath: 文件路径
 
 return 是否有文件夹存在
 */
func CreatFilePath(_ filePath:String) ->Bool {
    
    let fileManager = FileManager.default
    
    // 文件夹是否存在
    if fileManager.fileExists(atPath: filePath) {
        
        return true
    }
    
    do{
        try fileManager.createDirectory(atPath: filePath, withIntermediateDirectories: true, attributes: nil)
        
        return true
        
    }catch{}
    
    return false
}

// MARK: -- view的手势禁用开启

/// 当前view的 Tap Enabled
func ViewTapGestureRecognizerEnabled(_ view:UIView,enabled:Bool) {
    
    if (view.gestureRecognizers != nil) {
        
        for ges in view.gestureRecognizers! {
            
            if ges.isKind(of: UITapGestureRecognizer.classForCoder()) {
                
                ges.isEnabled = enabled
            }
        }
    }
}

/// 当前view的 Pan Enabled
func ViewPanGestureRecognizerEnabled(_ view:UIView,enabled:Bool) {
    
    if (view.gestureRecognizers != nil) {
        
        for ges in view.gestureRecognizers! {
            
            if ges.isKind(of: UIPanGestureRecognizer.classForCoder()) {
                
                ges.isEnabled = enabled
            }
        }
    }
}

// MARK: -- 阅读页面获取文件方法 ----------------

/// 归档阅读文件文件
func ReadKeyedArchiver(_ folderName:String,fileName:String,object:AnyObject) {
    
    var path = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!) + "/DZMeBookRead/DZM\(folderName)"
    
    if (CreatFilePath(path)) { // 创建文件夹成功或者文件夹存在
        
        path = path + "/\(fileName)"
        
        NSKeyedArchiver.archiveRootObject(object, toFile: path)
    }
}

/// 解档阅读文件文件
func ReadKeyedUnarchiver(_ folderName:String,fileName:String) ->AnyObject? {
    
    let path = ((NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last! as String) + "/DZMeBookRead/DZM\(folderName)") + "/\(fileName)"
    
    return NSKeyedUnarchiver.unarchiveObject(withFile: path) as AnyObject?
}

/// 删除阅读归档文件
func ReadKeyedRemoveArchiver(_ folderName:String,fileName:String) {
    
    let path = ((NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last! as String) + "/DZMeBookRead/DZM\(folderName)") + "/\(fileName)"
    
    do{
        try FileManager.default.removeItem(atPath: path)
    }catch{}
}

/// 是否存在了改归档文件
func ReadKeyedIsExistArchiver(_ folderName:String,fileName:String) ->Bool {
    
    let path = ((NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last! as String) + "/DZMeBookRead/DZM\(folderName)") + "/\(fileName)"
    
    return FileManager.default.fileExists(atPath: path)
}
