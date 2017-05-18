//
//  DZMReadChapterModel.swift
//  DZMeBookRead
//
//  Created by 邓泽淼 on 2017/5/12.
//  Copyright © 2017年 DZM. All rights reserved.
//

import UIKit

class DZMReadChapterModel: NSObject,NSCoding {
    
    /// 小说ID
    var bookID:String!
    
    /// 章节ID
    var id:String!
    
    /// 章节名称
    var name:String!
    
    /// 优先级 (一般章节段落都带有排序的优先级 从 0 开始)
    var priority:NSNumber!
    
    /// 内容
    var content:String!
    
    /// 本章有多少页
    var pageCount:NSNumber = NSNumber(value: 0)
    
    /// 每一页的Range数组
    var rangeArray:[NSRange] = []
    
    
    // MARK: -- 更新字体
    
    /// 记录该章使用的字体属性
    private var readAttribute:[String:NSObject] = [:]
    
    /// 更新字体
    func updateFont(isSave:Bool = false) {
        
        let readAttribute = DZMReadConfigure.shared().readAttribute()
        
        if self.readAttribute != readAttribute {
            
            self.readAttribute = readAttribute
            
            rangeArray = DZMReadParser.ParserPageRange(string: content, rect: GetReadViewFrame(), attrs: readAttribute)
            
            pageCount = NSNumber(value: rangeArray.count)
            
            if isSave {save()}
        }
    }
    
    // MARK: -- init
    
    override init() {
        
        super.init()
    }
    
    /// 通过书ID 章节ID 获得阅读章节 没有则创建传出
    class func readChapterModel(bookID:String, chapterID:String, isUpdateFont:Bool = false) ->DZMReadChapterModel {
        
        var readChapterModel:DZMReadChapterModel!
        
        if DZMReadChapterModel.IsExistReadChapterModel(bookID: bookID, chapterID: chapterID) { // 存在
            
            readChapterModel = ReadKeyedUnarchiver(folderName: bookID, fileName: chapterID) as! DZMReadChapterModel
            
            if isUpdateFont {readChapterModel.updateFont(isSave: true)}
            
        }else{ // 不存在
            
            readChapterModel = DZMReadChapterModel()
            
            readChapterModel.bookID = bookID
            
            readChapterModel.id = chapterID
        }
        
        return readChapterModel
    }
    
    // MARK: -- 操作
    
    /// 通过 Page 获得字符串
    func string(page:NSInteger) ->String {
        
        return content.substring(rangeArray[page])
    }
    
    /// 通过 Location 获得 Page
    func page(location:NSInteger) ->NSInteger {
        
        let count = rangeArray.count
        
        for i in 0..<count {
            
            let range = rangeArray[i]
            
            if location < (range.location + range.length) {
                
                return i
            }
        }
        
        return 0
    }
    
    /// 保存
    func save() {
        
        ReadKeyedArchiver(folderName: bookID, fileName: id, object: self)
    }
    
    /// 是否存在章节内容模型
    class func IsExistReadChapterModel(bookID:String, chapterID:String) ->Bool {
        
        return ReadKeyedIsExistArchiver(folderName: bookID, fileName: chapterID)
    }
    
    // MARK: -- NSCoding
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init()
        
        bookID = aDecoder.decodeObject(forKey: "bookID") as! String
        
        id = aDecoder.decodeObject(forKey: "id") as! String
        
        name = aDecoder.decodeObject(forKey: "name") as! String
        
        priority = aDecoder.decodeObject(forKey: "priority") as! NSNumber
        
        content = aDecoder.decodeObject(forKey: "content") as! String
        
        pageCount = aDecoder.decodeObject(forKey: "pageCount") as! NSNumber
        
        rangeArray = aDecoder.decodeObject(forKey: "rangeArray") as! [NSRange]
        
        readAttribute = aDecoder.decodeObject(forKey: "readAttribute") as! [String:NSObject]
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(bookID, forKey: "bookID")
        
        aCoder.encode(id, forKey: "id")
        
        aCoder.encode(name, forKey: "name")
        
        aCoder.encode(priority, forKey: "priority")
        
        aCoder.encode(content, forKey: "content")
        
        aCoder.encode(pageCount, forKey: "pageCount")
        
        aCoder.encode(rangeArray, forKey: "rangeArray")
        
        aCoder.encode(readAttribute, forKey: "readAttribute")
    }
}
