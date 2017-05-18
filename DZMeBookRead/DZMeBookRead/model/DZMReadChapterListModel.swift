//
//  DZMReadChapterListModel.swift
//  DZMeBookRead
//
//  Created by 邓泽淼 on 2017/5/12.
//  Copyright © 2017年 DZM. All rights reserved.
//

import UIKit

class DZMReadChapterListModel: NSObject,NSCoding {
    
    /// 小说ID
    var bookID:String!
    
    /// 章节ID
    var id:String!
    
    /// 章节名称
    var name:String!
    
    /// 优先级 (一般章节段落都带有排序的优先级 从 0 开始)
    var priority:NSNumber!
    
    // MARK: -- 操作
    func readChapterModel(isUpdateFont:Bool = false) ->DZMReadChapterModel? {
        
        if DZMReadChapterModel.IsExistReadChapterModel(bookID: bookID, chapterID: id) {
            
            return DZMReadChapterModel.readChapterModel(bookID: bookID, chapterID: id, isUpdateFont: isUpdateFont)
        }
        
        return nil
    }
    
    // MARK: -- NSCoding
    
    override init() {
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init()
        
        priority = aDecoder.decodeObject(forKey: "priority") as! NSNumber
        
        bookID = aDecoder.decodeObject(forKey: "bookID") as! String
        
        id = aDecoder.decodeObject(forKey: "id") as! String
        
        name = aDecoder.decodeObject(forKey: "name") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(priority, forKey: "priority")
        
        aCoder.encode(bookID, forKey: "bookID")
        
        aCoder.encode(id, forKey: "id")
        
        aCoder.encode(name, forKey: "name")
    }
    
    // MARK: -- 临时记录使用 (在上下滚动模式才会使用)
    
    /// 分页数量
    var pageCount:NSNumber = NSNumber(value: 1) {didSet{changePageCount = NSNumber(value: pageCount.intValue - oldValue.intValue)}}
    
    /// 记录分页数据变化值
    var changePageCount:NSNumber = NSNumber(value: 0)
    
    /// 获得阅读内容模型
    func readChapterModel(readRecordModel:DZMReadRecordModel) ->DZMReadChapterModel {
        
        if readRecordModel.readChapterModel!.id == id {
            
            pageCount = readRecordModel.readChapterModel!.pageCount
            
            changePageCount = NSNumber(value: 0)
            
            return readRecordModel.readChapterModel!
            
        }else{
            
            let readChapterModel = self.readChapterModel(isUpdateFont: true)!
            
            pageCount = readChapterModel.pageCount
            
            return readChapterModel
        }
    }
    
    /// 清理
    func clearPageCount(readRecordModel:DZMReadRecordModel) {
        
        if readRecordModel.readChapterModel!.id == id {
            
            pageCount = readRecordModel.readChapterModel!.pageCount
            
            changePageCount = NSNumber(value: 0)
            
        }else{
            
            pageCount = NSNumber(value: 1)
            
            changePageCount = NSNumber(value: 0)
        }
    }
}
