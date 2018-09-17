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
    
    var length:Int { return (self as NSString).length }
    
    var bool:Bool { return (self as NSString).boolValue }
    
    var integer:NSInteger { return (self as NSString).integerValue }
    
    var float:Float { return (self as NSString).floatValue }
    
    var cgFloat:CGFloat { return CGFloat(self.float) }
    
    var double:Double { return (self as NSString).doubleValue }
    
    /// 文件后缀(不带'.')
    var pathExtension:String { return (self as NSString).pathExtension }
    
    /// 文件名(带后缀)
    var lastPathComponent:String { return (self as NSString).lastPathComponent }
    
    /// 文件名(不带后缀)
    var deletingPathExtension:String { return (self as NSString).deletingPathExtension }
    
    /// 去除首尾空格
    var removeSpaceHeadAndTail:String { return trimmingCharacters(in: NSCharacterSet.whitespaces) }
    
    /// 去除首尾换行
    var removeEnterHeadAndTail:String { return trimmingCharacters(in: NSCharacterSet.whitespaces) }
    
    /// 去除首尾空格和换行
    var removeSpaceHeadAndTailPro:String { return trimmingCharacters(in: NSCharacterSet.whitespacesAndNewlines) }
    
    /// 去掉所有空格
    var removeSapceAll:String { return replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "　", with: "") }
    
    /// 去除所有空格换行
    var removeSapceEnterAll:String { return removeSapceAll.replacingOccurrences(of: "\n", with: "") }
    
    /// 是否为整数
    var isInt:Bool {
        
        let scan: Scanner = Scanner(string: self)
        
        var val:Int = 0
        
        return scan.scanInt(&val) && scan.isAtEnd
    }
    
    /// 是否为数字或Float
    var isFloat:Bool {
        
        let scan: Scanner = Scanner(string: self)
        
        var val:Float = 0
        
        return scan.scanFloat(&val) && scan.isAtEnd
    }
    
    /// 是否为空格
    var isSpace:Bool {
        
        if (self == " ") || (self == "　") { return true }
        
        return false
    }
    
    /// 是否为空格或者回车
    var isSpaceOrEnter:Bool {
        
        if isSpace || (self == "\n") { return true }
        
        return false
    }
    
    /// MD5加密
    var md5:String {
        
        let string = cString(using: String.Encoding.utf8)
        
        let stringLength = CUnsignedInt(lengthOfBytes(using: String.Encoding.utf8))
        
        let digestLength = Int(CC_MD5_DIGEST_LENGTH)
        
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLength)
        
        CC_MD5(string!, stringLength, result)
        
        let hash = NSMutableString()
        
        for i in 0 ..< digestLength { hash.appendFormat("%02x", result[i]) }
        
        result.deinitialize()
        
        return String(format: hash as String)
    }
    
    /// 转JSON
    var json:Any? {
        
        let data = self.data(using: String.Encoding.utf8, allowLossyConversion: false)
        
        let json = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments)
        
        return json
    }
    
    /// 是否包含字符串
    func range(_ string: String) ->NSRange {
        
        return (self as NSString).range(of: string)
    }
    
    /// 截取字符串
    func substring(_ range:NSRange) ->String {
        
        return (self as NSString).substring(with: range)
    }
    
    /// 处理带中文的字符串
    func addingPercentEncoding(_ characters: CharacterSet = .urlQueryAllowed) ->String {
        
        return (self as NSString).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) ?? ""
    }
    
    /// 正则替换字符
    func replacingCharacters(_ pattern:String, _ template:String) ->String {
        
        do {
            let regularExpression = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            
            return regularExpression.stringByReplacingMatches(in: self, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, length), withTemplate: template)
            
        } catch {return self}
    }
    
    /// 正则搜索相关字符位置
    func matches(_ pattern:String) ->[NSTextCheckingResult] {
        
        if isEmpty {return []}
        
        do {
            let regularExpression = try NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive)
            
            return regularExpression.matches(in: self, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSMakeRange(0, length))
            
        } catch {return []}
    }
    
    /// 计算大小
    func size(_ font:UIFont, _ size:CGSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)) ->CGSize {
        
        let string:NSString = self as NSString
        
        return string.boundingRect(with: size, options: [.usesLineFragmentOrigin,.usesFontLeading], attributes: [.font:font], context: nil).size
    }
}

extension NSAttributedString {
    
    /// 计算size
    func size(_ size:CGSize = CGSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)) ->CGSize{
        
        return self.boundingRect(with: size, options: [NSStringDrawingOptions.usesLineFragmentOrigin,NSStringDrawingOptions.usesFontLeading], context: nil).size
    }
    
    /// 扩展拼接
    func add<T:NSAttributedString>(_ string:T) ->NSAttributedString {
        
        let attributedText = NSMutableAttributedString(attributedString: self)
        
        attributedText.append(string)
        
        return attributedText
    }
}
