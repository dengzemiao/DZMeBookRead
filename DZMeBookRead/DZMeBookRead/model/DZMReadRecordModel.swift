//
//  DZMReadRecordModel.swift
//  DZMeBookRead
//
//  Created by 邓泽淼 on 2017/5/12.
//  Copyright © 2017年 DZM. All rights reserved.
//

/// 最后一页标示
let DZMReadLastPageValue:NSInteger = -1

import UIKit

class DZMReadRecordModel: NSObject,NSCoding {

    /// 是否存在记录
    var isRecord:Bool {get{return readChapterModel != nil}}
    
    /// 小说ID
    var bookID:String!
    
    /// 当前阅读到的章节模型
    var readChapterModel:DZMReadChapterModel?
    
    /// 当前章节阅读到的页码
    var page:NSNumber = NSNumber(value: 0)
    
    // MARK: -- init
    
    override init() {
        
        super.init()
    }
    
    /// 通过书ID 获得阅读记录模型 没有则进行创建传出
    class func readRecordModel(bookID:String, isUpdateFont:Bool = false, isSave:Bool = false) ->DZMReadRecordModel {
        
        var readModel:DZMReadRecordModel!
        
        if DZMReadRecordModel.IsExistReadRecordModel(bookID: bookID) { // 存在
            
            readModel = ReadKeyedUnarchiver(folderName: bookID, fileName: (bookID + "ReadRecord")) as! DZMReadRecordModel
            
            if isUpdateFont {readModel.updateFont(isSave: isSave)}
            
        }else{ // 不存在
            
            readModel = DZMReadRecordModel()
            
            readModel.bookID = bookID
        }
        
        return readModel!
    }
    
    // MARK: -- 操作
    
    /// 保存
    func save() {
        
        ReadKeyedArchiver(folderName: bookID, fileName: (bookID + "ReadRecord"), object: self)
    }
    
    /// 修改阅读记录为指定章节ID 指定页码 (toPage: -1 为最后一页 也可以使用 DZMReadLastPageValue)
    func modify(chapterID:String, toPage:NSInteger = 0, isUpdateFont:Bool = false, isSave:Bool = false) {
        
        if DZMReadChapterModel.IsExistReadChapterModel(bookID: bookID, chapterID: chapterID) {
            
            readChapterModel = DZMReadChapterModel.readChapterModel(bookID: bookID, chapterID: chapterID, isUpdateFont: isUpdateFont)
            
            page = (toPage == DZMReadLastPageValue) ? NSNumber(value: readChapterModel!.pageCount.intValue - 1) : NSNumber(value: toPage)
            
            if isSave {save()}
        }
    }
    
    /// 修改阅读记录为指定书签记录
    func modify(readMarkModel:DZMReadMarkModel, isUpdateFont:Bool = false, isSave:Bool = false) {
        
        if DZMReadChapterModel.IsExistReadChapterModel(bookID: readMarkModel.bookID, chapterID: readMarkModel.id) {
            
            readChapterModel = DZMReadChapterModel.readChapterModel(bookID: bookID, chapterID: readMarkModel.id, isUpdateFont: isUpdateFont)
            
            page = NSNumber(value: readChapterModel!.page(location: readMarkModel.location.intValue))
            
            if isSave {save()}
        }
    }
    
    /// 刷新字体 
    func updateFont(isSave:Bool = false) {
        
        if readChapterModel != nil {
            
            let location = readChapterModel!.rangeArray[page.intValue].location
            
            readChapterModel!.updateFont()
            
            page = NSNumber(value: readChapterModel!.page(location: location))
            
            readChapterModel!.save()
            
            if isSave {save()}
        }
    }
    
    /// 是否存在阅读记录模型
    class func IsExistReadRecordModel(bookID:String) ->Bool {
        
        return ReadKeyedIsExistArchiver(folderName: bookID, fileName: (bookID + "ReadRecord"))
    }
    
    // MARK: -- NSCoding
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init()
        
        bookID = aDecoder.decodeObject(forKey: "bookID") as! String
        
        readChapterModel = aDecoder.decodeObject(forKey: "readChapterModel") as? DZMReadChapterModel
        
        page = aDecoder.decodeObject(forKey: "page") as! NSNumber
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(bookID, forKey: "bookID")
        
        aCoder.encode(readChapterModel, forKey: "readChapterModel")
        
        aCoder.encode(page, forKey: "page")
    }
    
    // MARK: -- 拷贝
    func copySelf() ->DZMReadRecordModel {
        
        let readRecordModel = DZMReadRecordModel()
        
        readRecordModel.bookID = bookID
        
        readRecordModel.readChapterModel = readChapterModel
        
        readRecordModel.page = page
        
        return readRecordModel
    }
}
