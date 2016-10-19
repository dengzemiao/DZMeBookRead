//
//  HJReadConfigureManger.swift
//  HJProject
//
//  Created by 邓泽淼 on 16/8/16.
//  Copyright © 2016年 HanJue. All rights reserved.
//

/// 阅读配置 KeyedArchiver 文件名
private let HJReadConfigure:String = "HJReadConfigure"

/// 颜色数组
let HJReadColors:[UIColor] = [HJColor_8,HJColor_9,HJColor_10,HJColor_11,HJColor_12,HJColor_13]

/// 阅读最小阅读字体大小
let HJReadMinFontSize:Int = 12

/// 阅读最大阅读字体大小
let HJReadMaxFontSize:Int = 25

/// 阅读当前默认字体大小
let HJReadDefaultFontSize:Int = 14

/// 字体颜色
let HJReadTextColor:UIColor = RGB(68, g: 68, b: 68)

import UIKit

class HJReadConfigureManger: NSObject,NSCoding {
    
    // MARK: -- 属性
    
    // MARK: -- 设置 - 颜色属性
    
    /// 当前的阅读颜色
    var readColorInex:NSNumber = 4 {
        
        didSet{
            
            updateKeyedArchiver()
        }
    }
    
    // MARK: -- 阅读翻书效果
    
    /// 记录阅读翻书效果 不建议使用该值
    var flipEffectNumber:NSNumber! = 1 {
        
        didSet{
          
            updateKeyedArchiver()
        }
    }
    
    /// 阅读翻书效果
    var flipEffect:HJReadFlipEffect! {
        
        get{
            
            return HJReadFlipEffect(rawValue: flipEffectNumber.integerValue) ?? HJReadFlipEffect(rawValue: 1)
        }
        set{
            
            flipEffectNumber = newValue.rawValue
        }
    }
    
    
    // MARK: -- 字号
    
    /// 阅读字号
    var readFontSize:NSNumber! = HJReadDefaultFontSize {
        
        didSet{
            
            updateKeyedArchiver()
        }
    }
    
    /// 分隔间距
    var readSpaceLineH:CGFloat = 10
    
    // MARK: -- 阅读字体
    
    /// 阅读字体颜色
    var textColor:UIColor! = HJReadTextColor
    
    /// 记录 阅读字体 不建议使用该值
    var readFontNumber:NSNumber! = 0 {
        
        didSet{
            
            updateKeyedArchiver()
        }
    }
    
    ///  阅读字体
    var readFont:HJReadFont! {
        
        get{
            
            return HJReadFont(rawValue: readFontNumber.integerValue) ?? HJReadFont(rawValue: 0)
        }
        set{
            
            readFontNumber = newValue.rawValue
        }
    }
    
    
    // MARK: -- 亮度属性
    
    /// 记录阅读亮度模式 不建议使用该值
    var lightTypeNumber:NSNumber! = 0 {
        
        didSet{
            
            updateKeyedArchiver()
        }
    }
    
    /// 阅读亮度模式
    var lightType:HJReadLightType! {
        
        get{
            
            return HJReadLightType(rawValue: lightTypeNumber.integerValue) ?? HJReadLightType(rawValue: 0)
        }
        set{
            
            lightTypeNumber = newValue.rawValue
        }
    }
    
    // MARK: -- 刷新缓存
    
    /**
     刷新 KeyedArchiver
     */
    func updateKeyedArchiver() {
        
        KeyedArchiver(HJReadConfigure, object: self)
    }
    
    
    // MARK: --  对象相关
    
    // 获取单利对象
    class var shareManager : HJReadConfigureManger {
        
        struct Static {
            
            static let instance : HJReadConfigureManger = HJReadConfigureManger.GetManager()
        }
        
        return Static.instance
    }
    
    /**
     获取配置对象
     
     - returns: 配置对象
     */
    private class func GetManager() ->HJReadConfigureManger {
        
        var manager:HJReadConfigureManger? = KeyedUnarchiver(HJReadConfigure) as? HJReadConfigureManger
        
        if manager == nil {
            
            manager = HJReadConfigureManger()
        }
    
        return manager!
    }
    
    override init() {
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init()
        
        readColorInex = aDecoder.decodeObjectForKey("readColorInex") as! NSNumber
        
        flipEffectNumber = aDecoder.decodeObjectForKey("flipEffectNumber") as! NSNumber
        
        readFontSize = aDecoder.decodeObjectForKey("readFontSize") as! NSNumber
        
        readFontNumber = aDecoder.decodeObjectForKey("readFontNumber") as! NSNumber
        
        lightTypeNumber = aDecoder.decodeObjectForKey("lightTypeNumber") as! NSNumber
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(readColorInex, forKey: "readColorInex")
        
        aCoder.encodeObject(flipEffectNumber, forKey: "flipEffectNumber")
        
        aCoder.encodeObject(readFontSize, forKey: "readFontSize")
        
        aCoder.encodeObject(readFontNumber, forKey: "readFontNumber")
        
        aCoder.encodeObject(lightTypeNumber, forKey: "lightTypeNumber")
        
    }
}
