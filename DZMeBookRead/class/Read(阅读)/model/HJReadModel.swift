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
    
    // 书签列表
    var readBookMarks:[HJReadMarkModel] = []
    
    /// 阅读记录
    var readRecord:HJReadRecord!
    
    /// 是否为本地小说
    var isLocalBook:NSNumber! = 0
    
    /// 本地小说使用 解析获得的整本字符串
//    var content:String! = ""
    
    /// 本地小说使用 来源地址 路径
    var resource:URL?
    
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
            
            readRecord.chapterCount = NSNumber(value:readChapterListModels.count)
        }
    }
    
    override init() {
        super.init()
        
        readChapterListModels = [HJReadChapterListModel]()
        
        readRecord = HJReadRecord()
    }
    
    /// 初始化本地URL小说地址
    class func readModelWithLocalBook(_ url:URL) ->HJReadModel {
        
        // 本地小说 bookID 也是 bookName
        let bookID = HJReadParser.GetBookName(url)
        
        var model = ReadKeyedUnarchiver(bookID, fileName: bookID) as? HJReadModel
        
        // 没有缓存
        if model == nil {
            
            if url.path.lastPathComponent().pathExtension() == "txt" {  // text 格式
                
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
    class func readModelWithFileName(_ booID:String) ->HJReadModel? {
        
        return ReadKeyedUnarchiver(booID, fileName: booID) as? HJReadModel
        
    }
    
    // MARK: -- 刷新缓存数据
    
    class func updateReadModel(_ readModel:HJReadModel) {
        
        ReadKeyedArchiver(readModel.bookID, fileName: readModel.bookID, object: readModel)
    }
    
    // MARK: -- aDecoder
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init()
        
        bookID = aDecoder.decodeObject(forKey: "bookID") as! String
        
        readChapterListModels = aDecoder.decodeObject(forKey: "readChapterListModels") as! [HJReadChapterListModel]
        
        readBookMarks = aDecoder.decodeObject(forKey: "readBookMarks") as! [HJReadMarkModel]
        
        readRecord = aDecoder.decodeObject(forKey: "readRecord") as! HJReadRecord
        
        isLocalBook = aDecoder.decodeObject(forKey: "isLocalBook") as! NSNumber
        
        resource = aDecoder.decodeObject(forKey: "resource") as? URL
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(bookID, forKey: "bookID")
        
        aCoder.encode(readChapterListModels, forKey: "readChapterListModels")
        
        aCoder.encode(readBookMarks, forKey: "readBookMarks")
        
        aCoder.encode(readRecord, forKey: "readRecord")
        
        aCoder.encode(isLocalBook, forKey: "isLocalBook")
        
        aCoder.encode(resource, forKey: "resource")
    }
}
