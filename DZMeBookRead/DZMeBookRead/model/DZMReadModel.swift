//
//  DZMReadModel.swift
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/4/17.
//  Copyright © 2019年 DZM. All rights reserved.
//

import UIKit

class DZMReadModel: NSObject,NSCoding {

    /// 小说ID
    var bookID:String!
    
    /// 小说名称
    var bookName:String!
    
    /// 小说来源类型
    var bookSourceType:DZMBookSourceType! = .network
    
    /// 当前阅读记录
    var recordModel:DZMReadRecordModel!
    
    /// 书签列表
    var markModels:[DZMReadMarkModel]! = []
    
    /// 章节列表(如果是网络小说可以不需要放在这里记录,直接在目录视图里面加载接口或者读取本地数据库就好了。)
    var chapterListModels:[DZMReadChapterListModel]! = []
    
    
    // MARK: 快速进入
    
    /// 本地小说全文
    var fullText:String!
    
    /// 章节内容范围数组 [章节ID:[章节优先级:章节内容Range]]
    var ranges:[String:[String:NSRange]]!
    
    
    // MARK: 辅助
    
    /// 保存
    func save() {
        
        recordModel.save()
        
        DZMKeyedArchiver.archiver(folderName: bookID, fileName: DZM_READ_KEY_OBJECT, object: self)
    }
    
    /// 是否存在阅读对象
    class func isExist(bookID:String!) ->Bool {
        
        return DZMKeyedArchiver.isExist(folderName: bookID, fileName: DZM_READ_KEY_OBJECT)
    }
    
    
    // MARK: 构造
    
    /// 获取阅读对象,如果则创建对象返回
    class func model(bookID:String!) ->DZMReadModel {
        
        var readModel:DZMReadModel!
        
        if DZMReadModel.isExist(bookID: bookID) {
            
            readModel = DZMKeyedArchiver.unarchiver(folderName: bookID, fileName: DZM_READ_KEY_OBJECT) as? DZMReadModel
            
        }else{
            
            readModel = DZMReadModel()
            
            readModel.bookID = bookID
        }
        
        // 获取阅读记录
        readModel.recordModel = DZMReadRecordModel.model(bookID: bookID)
        
        return readModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init()
        
        bookID = aDecoder.decodeObject(forKey: "bookID") as? String
        
        bookName = aDecoder.decodeObject(forKey: "bookName") as? String
        
        bookSourceType = DZMBookSourceType(rawValue: (aDecoder.decodeObject(forKey: "bookSourceType") as! NSNumber).intValue)
        
        chapterListModels = aDecoder.decodeObject(forKey: "chapterListModels") as? [DZMReadChapterListModel]
        
        markModels = aDecoder.decodeObject(forKey: "markModels") as? [DZMReadMarkModel]
        
        fullText = aDecoder.decodeObject(forKey: "fullText") as? String
        
        ranges = aDecoder.decodeObject(forKey: "ranges") as? [String:[String:NSRange]]
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(bookID, forKey: "bookID")
        
        aCoder.encode(bookName, forKey: "bookName")
        
        aCoder.encode(NSNumber(value: bookSourceType.rawValue), forKey: "bookSourceType")
        
        aCoder.encode(chapterListModels, forKey: "chapterListModels")
        
        aCoder.encode(markModels, forKey: "markModels")
        
        aCoder.encode(fullText, forKey: "fullText")
        
        aCoder.encode(ranges, forKey: "ranges")
    }
    
    init(_ dict:Any? = nil) {
        
        super.init()
        
        if dict != nil { setValuesForKeys(dict as! [String : Any]) }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) { }
}
