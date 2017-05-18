//
//  DZMReadModel.swift
//  DZMeBookRead
//
//  Created by 邓泽淼 on 2017/5/12.
//  Copyright © 2017年 DZM. All rights reserved.
//

import UIKit

class DZMReadModel: NSObject,NSCoding {
    
    /// 小说ID
    var bookID:String!
    
    /// 是否为本地小说
    var isLocalBook:NSNumber = NSNumber(value: 1)

    /// 章节列表数组
    var readChapterListModels:[DZMReadChapterListModel] = [DZMReadChapterListModel]()
    
    /// 阅读记录
    var readRecordModel:DZMReadRecordModel!
    
    /// 书签列表
    private(set) var readMarkModels:[DZMReadMarkModel] = [DZMReadMarkModel]()
    
    /// 当前书签(用于记录使用)
    private(set) var readMarkModel:DZMReadMarkModel?
    
    // MARK: -- init
    
    private override init() {
        
        super.init()
    }
    
    /// 获得阅读模型
    class func readModel(bookID:String) ->DZMReadModel {
        
        var readModel:DZMReadModel!
        
        if DZMReadModel.IsExistReadModel(bookID: bookID) { // 存在
            
            readModel = ReadKeyedUnarchiver(folderName: bookID, fileName: bookID) as! DZMReadModel
            
        }else{ // 不存在
            
            readModel = DZMReadModel()
            
            readModel.bookID = bookID
        }
        
        // 阅读记录 刷新字体是以防在别的小说修改了字体
        readModel!.readRecordModel = DZMReadRecordModel.readRecordModel(bookID: bookID, isUpdateFont: true, isSave: true)
        
        // 返回
        return readModel!
    }
    
    // MARK: -- 操作
    
    /// 修改阅读记录为 指定章节ID 指定页码
    func modifyReadRecordModel(chapterID:String, page:NSInteger = 0, isUpdateFont:Bool = false, isSave:Bool = false) {
        
        readRecordModel.modify(chapterID: chapterID, toPage: page, isUpdateFont: isUpdateFont, isSave: isSave)
    }
    
    /// 修改阅读记录到书签模型
    func modifyReadRecordModel(readMarkModel:DZMReadMarkModel, isUpdateFont:Bool = false, isSave:Bool = false) {
        
        readRecordModel.modify(readMarkModel: readMarkModel, isUpdateFont: isUpdateFont, isSave: isSave)
    }
    
    /// 保存
    func save() {
        
        // 阅读模型
        ReadKeyedArchiver(folderName: bookID, fileName: bookID, object: self)
        
        // 阅读记录
        readRecordModel.save()
    }
    
    /// 是否存在阅读模型
    class func IsExistReadModel(bookID:String) ->Bool {
        
        return ReadKeyedIsExistArchiver(folderName: bookID, fileName: bookID)
    }
    
    /// 通过ID获得章节列表模型
    func GetReadChapterListModel(chapterID:String) ->DZMReadChapterListModel? {
        
        return (readChapterListModels as NSArray).filtered(using: NSPredicate(format: "id == %@",chapterID)).first as? DZMReadChapterListModel
    }
    
    // MARK: -- 操作 - 书签
    
    /// 添加书签 默认使用当前阅读记录作为书签
    func addMark(readRecordModel:DZMReadRecordModel? = nil) {
        
        let readRecordModel = (readRecordModel != nil ? readRecordModel : self.readRecordModel)!
        
        let readMarkModel = DZMReadMarkModel()
        
        readMarkModel.bookID = readRecordModel.readChapterModel!.bookID
        
        readMarkModel.id = readRecordModel.readChapterModel!.id
        
        readMarkModel.name = readRecordModel.readChapterModel!.name
        
        readMarkModel.location = NSNumber(value: readRecordModel.readChapterModel!.rangeArray[readRecordModel.page.intValue].location)
        
        readMarkModel.content = readRecordModel.readChapterModel!.string(page: readRecordModel.page.intValue)
        
        readMarkModel.time = Date()
        
        readMarkModels.append(readMarkModel)
        
        save()
    }
    
    /// 删除书签 默认使用当前存在的书签
    func removeMark(readMarkModel:DZMReadMarkModel? = nil, index:NSInteger? = nil) ->Bool {
        
        if index != nil {
           
            readMarkModels.remove(at: index!)
            
            save()
            
            return true
            
        }else{
            
            let readMarkModel = (readMarkModel != nil ? readMarkModel : self.readMarkModel)
            
            if readMarkModel != nil && readMarkModels.contains(readMarkModel!) {
                
                readMarkModels.remove(at: readMarkModels.index(of: readMarkModel!)!)
                
                save()
                
                return true
            }
        }
        
        return false
    }
    
    /// 检查当前页面是否存在书签 默认使用当前阅读记录作为检查对象
    func checkMark(readRecordModel:DZMReadRecordModel? = nil) ->Bool {
        
        let readRecordModel = (readRecordModel != nil ? readRecordModel : self.readRecordModel)!
        
        let pre = NSPredicate(format: "id == %@",readRecordModel.readChapterModel!.id)
        
        let result = (readMarkModels as NSArray).filtered(using: pre) as! [DZMReadMarkModel]
        
        if !result.isEmpty {
            
            // 当前显示页面的Range
            let range = readRecordModel.readChapterModel!.rangeArray[readRecordModel.page.intValue]
            
            // 便利
            for readMarkModel in readMarkModels {
                
                let location = readMarkModel.location.intValue
                
                if location >= range.location && location < (range.location + range.length) {
                    
                    self.readMarkModel = readMarkModel
                    
                    return true
                }
            }
        }
        
        // 清空
        readMarkModel = nil
        
        return false
    }
    
    // MARK: -- NSCoding
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init()
        
        bookID = aDecoder.decodeObject(forKey: "bookID") as! String
        
        isLocalBook = aDecoder.decodeObject(forKey: "isLocalBook") as! NSNumber
        
        readChapterListModels = aDecoder.decodeObject(forKey: "readChapterListModels") as! [DZMReadChapterListModel]
        
        readMarkModels = aDecoder.decodeObject(forKey: "readMarkModels") as! [DZMReadMarkModel]
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(bookID, forKey: "bookID")
        
        aCoder.encode(isLocalBook, forKey: "isLocalBook")
        
        aCoder.encode(readChapterListModels, forKey: "readChapterListModels")
        
        aCoder.encode(readMarkModels, forKey: "readMarkModels")
    }
}
