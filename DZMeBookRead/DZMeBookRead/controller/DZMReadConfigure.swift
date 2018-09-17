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
let DZMReadBGColors:[UIColor] = [UIColor.white,DZMColor_238_224_202,DZMColor_205_239_205,DZMColor_206_233_241,DZMColor_251_237_199,DZMColor_51_51_51]

/// 根据背景颜色 对应的文字颜色 数组(数量必须与 DZMReadBGColors 相同)
// let DZMReadTextColors:[UIColor] = [DZMColor_145_145_145,DZMColor_145_145_145,DZMColor_145_145_145,DZMColor_145_145_145,DZMColor_145_145_145,DZMColor_145_145_145]

/// 阅读最小阅读字体大小
let DZMReadMinFontSize:NSInteger = 12

/// 阅读最大阅读字体大小
let DZMReadMaxFontSize:NSInteger = 25

/// 阅读当前默认字体大小
let DZMReadDefaultFontSize:NSInteger = 14

/// 章节标题字体在当前字体上增加指数
let DZMReadTitleFontSize:NSInteger = 8

import UIKit

class DZMReadConfigure: NSObject {

    // MARK: -- 属性
    
    /// 当前阅读的背景颜色
    @objc var colorIndex:NSInteger = 0 {didSet{save()}}
    
    /// 字体类型
    @objc var fontType:NSInteger = DZMRMFontType.system.rawValue {didSet{save()}}
    
    /// 字体大小
    @objc var fontSize:NSInteger = DZMReadDefaultFontSize {didSet{save()}}
    
    /// 翻页效果
    @objc var effectType:NSInteger = DZMRMEffectType.simulation.rawValue {didSet{save()}}
    
    /// 阅读文字颜色(根据需求自己选)
    @objc var textColor:UIColor {
        
        // 固定颜色使用
        get{return DZMColor_145_145_145}
        
        
        // 根据背影颜色选择字体颜色(假如想要根据背景颜色切换字体颜色 需要在 configureBGColor() 方法里面调用 tableView.reloadData())
//        get{return DZMReadTextColors[colorIndex]}
        
        
        // 日夜间区分颜色使用 (假如想要根据日夜间切换字体颜色 需要调用 tableView.reloadData() 或者取巧 使用上面的方式)
//        get{
//            
//            if DZMUserDefaults.boolForKey(DZMKey_IsNighOrtDay) { // 夜间
//                
//                return DZMColor_145_145_145
//                
//            }else{ // 日间
//                
//                return DZMColor_145_145_145
//            }
//        }
    }
    
    // MARK: -- 操作
    
    /// 单例
    @objc class func shared() ->DZMReadConfigure {
        
        if instance == nil {
            
            instance = DZMReadConfigure.readInfo()
        }
        
        return instance!
    }
    
    /// 保存
    @objc func save() {
        
        var dict = allPropertys()
        
        dict.removeValue(forKey: "textColor")
        
        DZMUserDefaults.setObject(dict, key: DZMReadConfigureKey)
    }
    
    /// 清理(暂无需求使用)
    private func clear() {
        
        instance = nil
        
        DZMUserDefaults.removeObjectForKey(DZMReadConfigureKey)
    }
    
    /// 获得文字属性字典 (isPaging: 为YES的时候只需要返回跟分页相关的属性即可 注意: 包含 UIColor , 小数点相关的...不可返回,因为无法进行比较)
    @objc func readAttribute(isPaging:Bool = false, isTitle:Bool = false) ->[NSAttributedStringKey:Any] {
        
        // 段落配置
        let paragraphStyle = NSMutableParagraphStyle()
        
        // 当前行间距(lineSpacing)的倍数(可根据字体大小变化修改倍数)
        paragraphStyle.lineHeightMultiple = 1.0
        
        if isTitle {
            
            // 行间距
            paragraphStyle.lineSpacing = 0
            
            // 段间距
            paragraphStyle.paragraphSpacing = 0
            
            // 对其
            paragraphStyle.alignment = .center
            
        }else{
            
            // 行间距
            paragraphStyle.lineSpacing = DZMSpace_10
            
            // 段间距
            paragraphStyle.paragraphSpacing = DZMSpace_5
            
            // 对其
            paragraphStyle.alignment = .justified
        }
        
        // 返回
        if isPaging {
            
            // 只需要传回跟分页有关的属性即可
            return [NSAttributedStringKey.font:readFont(isTitle: isTitle), NSAttributedStringKey.paragraphStyle:paragraphStyle]
            
        }else{
            
            return [NSAttributedStringKey.foregroundColor:textColor, NSAttributedStringKey.font:readFont(isTitle: isTitle), NSAttributedStringKey.paragraphStyle:paragraphStyle]
        }
    }
    
    /// 获得颜色
    @objc func readColor() ->UIColor {
        
        if colorIndex == DZMReadBGColors.index(of: DZMColor_251_237_199) { // 牛皮黄
            
            return UIColor(patternImage:UIImage(named: "read_bg_0")!)
            
        }else{
            
            return DZMReadBGColors[colorIndex]
        }
    }
    
    /// 获得文字Font
    @objc func readFont(isTitle:Bool = false) ->UIFont {
        
        let size = CGFloat(fontSize + (isTitle ? DZMReadTitleFontSize : 0))
        
        if fontType == DZMRMFontType.one.rawValue { // 黑体
            
            return UIFont(name: "EuphemiaUCAS-Italic", size: size)!
            
        }else if fontType == DZMRMFontType.two.rawValue { // 楷体
            
            return UIFont(name: "AmericanTypewriter-Light", size: size)!
            
        }else if fontType == DZMRMFontType.three.rawValue { // 宋体
            
            return UIFont(name: "Papyrus", size: size)!
            
        }else{ // 系统
            
            return UIFont.systemFont(ofSize: size)
        }
    }
    
    // MARK: -- 构造初始化
    
    /// 创建获取内存中的用户信息
    @objc class func readInfo() ->DZMReadConfigure {
        
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
