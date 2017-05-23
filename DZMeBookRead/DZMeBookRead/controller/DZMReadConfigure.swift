//
//  DZMReadConfigure.swift
//  DZMeBookRead
//
//  Created by 邓泽淼 on 2017/5/11.
//  Copyright © 2017年 DZM. All rights reserved.
//

/// key
let DZMReadConfigureKey:String = "ReadConfigure"

/// 单利对象
private var instance:DZMReadConfigure? = DZMReadConfigure.readInfo()

// MARK: -- 配置属性

/// 背景颜色数组
let DZMReadBGColors:[UIColor] = [UIColor.white,DZMReadBGColor_1,DZMReadBGColor_2,DZMReadBGColor_3,DZMReadBGColor_4,DZMReadBGColor_5]

/// 根据背景颜色 对应的文字颜色 数组(数量必须与 DZMReadBGColors 相同)
// let DZMReadTextColors:[UIColor] = [DZMColor_5,DZMColor_5,DZMColor_5,DZMColor_5,DZMColor_5,DZMColor_5]

/// 阅读最小阅读字体大小
let DZMReadMinFontSize:NSInteger = 12

/// 阅读最大阅读字体大小
let DZMReadMaxFontSize:NSInteger = 25

/// 阅读当前默认字体大小
let DZMReadDefaultFontSize:NSInteger = 14

import UIKit

class DZMReadConfigure: NSObject {

    // MARK: -- 属性
    
    /// 当前阅读的背景颜色
    var colorIndex:NSInteger = 0 {didSet{save()}}
    
    /// 字体类型
    var fontType:NSInteger = DZMRMFontType.system.rawValue {didSet{save()}}
    
    /// 字体大小
    var fontSize:NSInteger = DZMReadDefaultFontSize {didSet{save()}}
    
    /// 翻页效果
    var effectType:NSInteger = DZMRMEffectType.simulation.rawValue {didSet{save()}}
    
    /// 阅读文字颜色(更加需求自己选)
    var textColor:UIColor {
        
        // 固定颜色使用
        get{return DZMColor_5}
        
        
        // 根据背影颜色选择字体颜色(假如想要根据背景颜色切换字体颜色 需要在 configureBGColor() 方法里面调用 tableView.reloadData())
//        get{return DZMReadTextColors[colorIndex]}
        
        
        // 日夜间区分颜色使用 (假如想要根据日夜间切换字体颜色 需要调用 tableView.reloadData() 或者取巧 使用上面的方式)
//        get{
//            
//            if DZMUserDefaults.boolForKey(DZMKey_IsNighOrtDay) { // 夜间
//                
//                return DZMColor_5
//                
//            }else{ // 日间
//                
//                return DZMColor_5
//            }
//        }
    }
    
    // MARK: -- 操作
    
    /// 单例
    class func shared() ->DZMReadConfigure {
        
        if instance == nil {
            
            instance = DZMReadConfigure.readInfo()
        }
        
        return instance!
    }
    
    /// 保存
    func save() {
        
        var dict = allPropertys()
        
        dict.removeValue(forKey: "lineSpacing")
        
        dict.removeValue(forKey: "textColor")
        
        DZMUserDefaults.setObject(dict, key: DZMReadConfigureKey)
    }
    
    /// 清理(暂无需求使用)
    private func clear() {
        
        instance = nil
        
        DZMUserDefaults.removeObjectForKey(DZMReadConfigureKey)
    }
    
    /// 获得文字属性字典
    func readAttribute() ->[String:NSObject] {
        
        // 段落配置
        let paragraphStyle = NSMutableParagraphStyle()
        
        // 行间距
        paragraphStyle.lineSpacing = DZMSpace_4
        
        // 段间距
        paragraphStyle.paragraphSpacing = DZMSpace_6
        
        // 当前行间距(lineSpacing)的倍数(可根据字体大小变化修改倍数)
        paragraphStyle.lineHeightMultiple = 1.0
        
        // 对其
        paragraphStyle.alignment = NSTextAlignment.justified
        
        // 返回
        return [NSForegroundColorAttributeName:textColor,NSFontAttributeName:readFont(),NSParagraphStyleAttributeName:paragraphStyle]
    }
    
    /// 获得颜色
    func readColor() ->UIColor {
        
        if colorIndex == DZMReadBGColors.index(of: DZMReadBGColor_4) { // 牛皮黄
            
            return UIColor(patternImage:UIImage(named: "read_bg_0")!)
            
        }else{
            
            return DZMReadBGColors[colorIndex]
        }
    }
    
    /// 获得文字Font
    func readFont() ->UIFont {
        
        if fontType == DZMRMFontType.one.rawValue { // 黑体
            
            return UIFont(name: "EuphemiaUCAS-Italic", size: CGFloat(fontSize))!
            
        }else if fontType == DZMRMFontType.two.rawValue { // 楷体
            
            return UIFont(name: "AmericanTypewriter-Light", size: CGFloat(fontSize))!
            
        }else if fontType == DZMRMFontType.three.rawValue { // 宋体
            
            return UIFont(name: "Papyrus", size: CGFloat(fontSize))!
            
        }else{ // 系统
            
            return UIFont.systemFont(ofSize: CGFloat(fontSize))
        }
    }
    
    // MARK: -- 构造初始化
    
    /// 创建获取内存中的用户信息
    class func readInfo() ->DZMReadConfigure {
        
        let info = DZMUserDefaults.objectForKey(DZMReadConfigureKey)
        
        return DZMReadConfigure(dict:info)
    }
    
    /// 初始化
    private init(dict:Any?) {
        
        super.init()
        
        setData(dict: dict)
    }
    
    /// 更新设置数据
    private func setData(dict:Any?) {
        
        if dict != nil {
            
            setValuesForKeys(dict as! [String : AnyObject])
        }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) {}
}
