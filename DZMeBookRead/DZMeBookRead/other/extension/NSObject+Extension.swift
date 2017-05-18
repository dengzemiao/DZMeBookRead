//
//  NSObject+Extension.swift
//  DZMeBookRead
//
//  Created by 邓泽淼 on 2017/5/11.
//  Copyright © 2016年 DZM. All rights reserved.
//
import Foundation

extension NSObject {
    
    // MARK: -- 对象属性处理
    
    /// 获取对象的所有属性名称
    func allPropertyNames() ->[String] {
        
        // 这个类型可以使用CUnsignedInt,对应Swift中的UInt32
        var count: UInt32 = 0
        
        let properties = class_copyPropertyList(self.classForCoder, &count)
        
        var propertyNames: [String] = []
        
        // Swift中类型是严格检查的，必须转换成同一类型
        for i in 0 ..< Int(count) {
            // UnsafeMutablePointer<objc_property_t>是
            // 可变指针，因此properties就是类似数组一样，可以
            // 通过下标获取
            let property = properties![i]
            let name = property_getName(property)
            
            // 这里还得转换成字符串
            let propertyName = String(cString: name!)
            propertyNames.append(propertyName)
        }
        
        // 释放内存，否则C语言的指针很容易成野指针的
        free(properties)
        
        return propertyNames;
    }
    
    /// 获取对象的所有属性名称跟值
    func allPropertys() ->[String : Any?] {
        
        var dict:[String : Any?] = [String : Any?]()
        
        // 这个类型可以使用CUnsignedInt,对应Swift中的UInt32
        var count: UInt32 = 0
        
        let properties = class_copyPropertyList(self.classForCoder, &count)
        
        for i in 0 ..< Int(count) {
            
            // 获取属性名称
            let property = properties![i]
            let name = property_getName(property)
            let propertyName = String(cString: name!)
            
            if (!propertyName.isEmpty) {
                
                // 获取Value数据
                let propertyValue = self.value(forKey: propertyName)
                
                dict[propertyName] = propertyValue
            }
        }
        
        return dict
    }
}
