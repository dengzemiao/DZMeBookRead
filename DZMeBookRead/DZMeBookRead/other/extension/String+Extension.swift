//
//  String+Extension.swift
//  DZMeBookRead
//
//  Created by 邓泽淼 on 2017/5/11.
//  Copyright © 2016年 DZM. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
    
    /**
     String 的 length
     
     - returns: Int
     */
    var length:Int {
        get{return (self as NSString).length}
    }
    
    /**
     String 转换 intValue = int32Value
     
     - returns: Int
     */
    func int32Value() ->Int32{
        return NSString(string: self).intValue
    }
    
    /**
     String 转换 boolValue
     
     - returns: Bool
     */
    func boolValue() ->Bool{
        return NSString(string: self).boolValue
    }
    
    /**
     String 转换 integerValue
     
     - returns: Int
     */
    func integerValue() ->Int{
        return NSString(string: self).integerValue
    }
    
    /**
     String 转换 floatValue
     
     - returns: float
     */
    func floatValue() ->Float{
        return NSString(string: self).floatValue
    }
    
    /**
     String 转换 CGFloatValue
     
     - returns: CGFloat
     */
    func CGFloatValue() ->CGFloat{
        return CGFloat(self.floatValue())
    }
    
    /**
     String 转换 doubleValue
     
     - returns: double
     */
    func doubleValue() ->Double{
        return NSString(string: self).doubleValue
    }
    
    /**
     截取字符串
     
     - returns: String
     */
    func substring(_ range:NSRange) ->String {
        
        return NSString(string: self).substring(with: range)
    }
    
    /**
     获得文件的后缀名（不带'.'）
     
     - returns: String
     */
    func pathExtension() ->String {
        
        return NSString(string: self).pathExtension
    }
    
    /**
     从路径中获得完整的文件名（带后缀）
     
     - returns: String
     */
    func lastPathComponent() ->String {
        
        return NSString(string: self).lastPathComponent
    }
    
    /**
     获得文件名（不带后缀）
     
     - returns: String
     */
    func stringByDeletingPathExtension() ->String {
        
        return NSString(string: self).deletingPathExtension
    }
    
    /**
     字符串MD5加密
     
     - returns: MD5加密好的字符串
     */
    func md5() ->String!{
        
        let str = self.cString(using: String.Encoding.utf8)
        
        let strLen = CUnsignedInt(self.lengthOfBytes(using: String.Encoding.utf8))
        
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        
        CC_MD5(str!, strLen, result)
        
        let hash = NSMutableString()
        
        for i in 0 ..< digestLen {
            
            hash.appendFormat("%02x", result[i])
        }
        
        result.deinitialize()
        
        return String(format: hash as String)
    }
    
    /// 计算字符串大小
    func size(font:UIFont,constrainedToSize:CGSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)) ->CGSize {
        
        let string:NSString = self as NSString
        
        return string.boundingRect(with: constrainedToSize, options: [.usesLineFragmentOrigin,.usesFontLeading], attributes: [NSFontAttributeName:font], context: nil).size
    }
    
    /// 正则替换字符
    func replacing(pattern:String, template:String) ->String {
        
        if isEmpty {return self}
        
        do {
            let regularExpression = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            
            return regularExpression.stringByReplacingMatches(in: self, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, length), withTemplate: template)
            
        } catch {return self}
    }
    
    /// 正则搜索相关字符位置
    func matches(pattern:String) ->[NSTextCheckingResult] {
        
        if isEmpty {return []}
        
        do {
            let regularExpression = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            
            return regularExpression.matches(in: self, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, length))
            
        } catch {return []}
    }
    
    /// 是否存在正则匹配到的内容
    func isExist(pattern:String) ->Bool {
        
        let result:[NSTextCheckingResult] = matches(pattern: pattern)
        
        return !result.isEmpty
    }
    
}

extension NSAttributedString{
    
    /// 计算多态字符串的size
    func size(constrainedToSize:CGSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)) ->CGSize{
        
        return self.boundingRect(with: constrainedToSize, options: [NSStringDrawingOptions.usesLineFragmentOrigin,NSStringDrawingOptions.usesFontLeading], context: nil).size
    }
}
