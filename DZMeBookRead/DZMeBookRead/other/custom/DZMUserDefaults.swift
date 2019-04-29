//
//  DZMUserDefaults.swift
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/4/18.
//  Copyright © 2019年 DZM. All rights reserved.
//

import UIKit

class DZMUserDefaults: NSObject {

    // MARK: 删除清空
    
    /// 清空
    class func clear() {
        
        let defaults:UserDefaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        
        for key in dictionary.keys {
            
            defaults.removeObject(forKey: key)
            defaults.synchronize()
        }
    }
    
    /// 删除
    class func remove(_ key:String) {
        let defaults:UserDefaults = UserDefaults.standard
        defaults.removeObject(forKey: key)
        defaults.synchronize()
    }
    
    // MARK: -- 存储
    
    /// 存储Object
    class func setObject(_ value:Any?, _ key:String) {
        let defaults:UserDefaults = UserDefaults.standard
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
    
    /// 存储String
    class func setString(_ value:String?, _ key:String) {
        DZMUserDefaults.setObject(value, key)
    }
    
    /// 存储NSInteger
    class func setInteger(_ value:NSInteger, _ key:String) {
        let defaults:UserDefaults = UserDefaults.standard
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
    
    /// 存储Bool
    class func setBool(_ value:Bool, _ key:String) {
        let defaults:UserDefaults = UserDefaults.standard
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
    
    /// 存储Float
    class func setFloat(_ value:Float, _ key:String) {
        let defaults:UserDefaults = UserDefaults.standard
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
    
    /// 存储TimeInterval
    class func setTime(_ value:TimeInterval, _ key:String) {
        setInteger(NSInteger(value), key)
    }
    
    /// 存储Double
    class func setDouble(_ value:Double, _ key:String) {
        let defaults:UserDefaults = UserDefaults.standard
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
    
    /// 存储URL
    class func setURL(_ value:URL?, _ key:String) {
        let defaults:UserDefaults = UserDefaults.standard
        defaults.set(value, forKey: key)
        defaults.synchronize()
    }
    
    // MARK: -- 获取
    
    /// 获取Object
    class func object(_ key:String) -> Any? {
        let defaults:UserDefaults = UserDefaults.standard
        return defaults.object(forKey: key)
    }
    
    /// 获取String
    class func string(_ key:String) -> String {
        let defaults:UserDefaults = UserDefaults.standard
        let string = defaults.object(forKey: key) as? String
        return string ?? ""
    }
    
    /// 获取Bool
    class func bool(_ key:String) -> Bool {
        let defaults:UserDefaults = UserDefaults.standard
        return defaults.bool(forKey: key)
    }
    
    /// 获取NSInteger
    class func integer(_ key:String) -> NSInteger {
        let defaults:UserDefaults = UserDefaults.standard
        return defaults.integer(forKey: key)
    }
    
    /// 获取Float
    class func float(_ key:String) -> Float {
        let defaults:UserDefaults = UserDefaults.standard
        return defaults.float(forKey: key)
    }
    
    /// 获取Double
    class func double(_ key:String) -> Double {
        let defaults:UserDefaults = UserDefaults.standard
        return defaults.double(forKey: key)
    }
    
    /// 获取TimeInterval
    class func time(_ key:String) -> TimeInterval {
        return TimeInterval(integer(key))
    }
    
    /// 获取URL
    class func url(_ key:String) -> URL? {
        let defaults:UserDefaults = UserDefaults.standard
        return defaults.url(forKey: key)
    }
}
