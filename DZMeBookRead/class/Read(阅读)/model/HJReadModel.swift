//
//  HJReadModel.swift
//  HJProject
//
//  Created by 邓泽淼 on 16/8/29.
//  Copyright © 2016年 HanJue. All rights reserved.
//

import UIKit

class HJReadModel: NSObject,NSCoding {

    /// 当前的小说ID (本地小说的话 bookID就是bookName)
    var bookID:String!
    
    /// 章节列表数组
    var readChapterListModels:[HJReadChapterListModel]!
    
    /// 阅读记录
    var readRecord:HJReadRecord!
    
    /// 是否为本地小说
    var isLocalBook:NSNumber! = 0
    
    /// 本地小说使用 解析获得的整本字符串
//    var content:String! = ""
    
    /// 本地小说使用 来源地址 路径
    var resource:NSURL?
    
    // MARK: -- 构造方法
    
    /// 初始化大字符串文本
    convenience init(bookID:String,content:String) {
        self.init()
        
//        self.content = content
        
        self.bookID = bookID
        
        readChapterListModels = HJReadParser.separateContent(bookID, content: content)
        
        if !readChapterListModels.isEmpty {
            
            readRecord.readChapterListModel = readChapterListModels.first
            
            readRecord.chapterIndex = 0
            
            readRecord.chapterCount = readChapterListModels.count
        }
    }
    
    override init() {
        super.init()
        
        readChapterListModels = [HJReadChapterListModel]()
        
        readRecord = HJReadRecord()
    }
    
    /// 初始化本地URL小说地址
    class func readModelWithLocalBook(url:NSURL) ->HJReadModel {
        
        // 本地小说 bookID 也是 bookName
        let bookID = HJReadParser.GetBookName(url)
        
        var model = ReadKeyedUnarchiver(bookID, fileName: bookID) as? HJReadModel
        
        // 没有缓存
        if model == nil {
            
            if url.path!.lastPathComponent().pathExtension() == "txt" {  // text 格式
                
                model = HJReadModel(bookID: bookID,content: HJReadParser.encodeURL(url))
                model!.resource = url
                model!.isLocalBook = 1
                HJReadModel.updateReadModel(model!)
                
                return model!
                
            }else{
                
                print("格式错误!")
            }
        }
        
        return model!
    }
    
    /// 传入Key 获取对应阅读模型
    class func readModelWithFileName(booID:String) ->HJReadModel? {
        
        return ReadKeyedUnarchiver(booID, fileName: booID) as? HJReadModel
        
    }
    
    // MARK: -- 刷新缓存数据
    
    class func updateReadModel(readModel:HJReadModel) {
        
        ReadKeyedArchiver(readModel.bookID, fileName: readModel.bookID, object: readModel)
    }
    
    // MARK: -- aDecoder
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init()
        
        bookID = aDecoder.decodeObjectForKey("bookID") as! String
        
        readChapterListModels = aDecoder.decodeObjectForKey("readChapterListModels") as! [HJReadChapterListModel]
        
        readRecord = aDecoder.decodeObjectForKey("readRecord") as! HJReadRecord
        
        isLocalBook = aDecoder.decodeObjectForKey("isLocalBook") as! NSNumber
        
        resource = aDecoder.decodeObjectForKey("resource") as? NSURL
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(bookID, forKey: "bookID")
        
        aCoder.encodeObject(readChapterListModels, forKey: "readChapterListModels")
        
        aCoder.encodeObject(readRecord, forKey: "readRecord")
        
        aCoder.encodeObject(isLocalBook, forKey: "isLocalBook")
        
        aCoder.encodeObject(resource, forKey: "resource")
    }
}
