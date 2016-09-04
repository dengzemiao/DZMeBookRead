//
//  HJUserDefaults.swift
//  HJProject
//
//  Created by 邓泽淼 on 16/8/1.
//  Copyright © 2016年 HanJue. All rights reserved.
//

import UIKit

class HJUserDefaults: NSObject {

    // MARK: -- 清理 NSUserDefaults
    
    /// 清空 NSUserDefaults
    class func UserDefaultsClear() {
        
    }
    
    /// 删除 对应Key 的值
    class func removeObjectForKey(key:String) {
        let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.removeObjectForKey(key)
        defaults.synchronize()
    }
    
    // MARK: -- 存
    
    /// 存储Object
    class func setObject(value:AnyObject?,key:String) {
        let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(value, forKey: key)
        defaults.synchronize()
    }
    
    /// 存储String
    class func setString(value:String?,key:String) {
        HJUserDefaults.setObject(value, key: key)
    }
    
    /// 存储NSInteger
    class func setInteger(value:NSInteger,key:String) {
        let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(value, forKey: key)
        defaults.synchronize()
    }
    
    /// 存储Bool
    class func setBool(value:Bool,key:String) {
        let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.setBool(value, forKey: key)
        defaults.synchronize()
    }
    
    /// 存储Float
    class func setFloat(value:Float,key:String) {
        let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.setFloat(value, forKey: key)
        defaults.synchronize()
    }
    
    /// 存储Double
    class func setDouble(value:Double,key:String) {
        let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.setDouble(value, forKey: key)
        defaults.synchronize()
    }
    
    /// 存储URL
    class func setURL(value:NSURL?,key:String) {
        let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        defaults.setURL(value, forKey: key)
        defaults.synchronize()
    }
    
    // MARK: -- 取
    
    /// 获取Object
    class func objectForKey(key:String) -> AnyObject? {
        let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        return defaults.objectForKey(key)
    }
    
    /// 获取String
    class func stringForKey(key:String) -> String {
        let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        let string = defaults.objectForKey(key) as? String ??  ""
        return string
    }
    
    /// 获取Bool
    class func boolForKey(key:String) -> Bool {
        let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        return defaults.boolForKey(key)
    }
    
    /// 获取Float
    class func floatForKey(key:String) -> Float {
        let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        return defaults.floatForKey(key)
    }
    
    /// 获取Double
    class func doubleForKey(key:String) -> Double {
        let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        return defaults.doubleForKey(key)
    }
    
    /// 获取URL
    class func URLForKey(key:String) -> NSURL? {
        let defaults:NSUserDefaults = NSUserDefaults.standardUserDefaults()
        return defaults.URLForKey(key)
    }
}
