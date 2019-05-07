//
//  DZMReadRecordModel.swift
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/4/17.
//  Copyright © 2019年 DZM. All rights reserved.
//

import UIKit

/// 记录当前章节阅读到的坐标
var DZM_READ_RECORD_CURRENT_CHAPTER_LOCATION:NSNumber!

class DZMReadRecordModel: NSObject,NSCoding {

    /// 小说ID
    var bookID:String!
    
    /// 当前记录的阅读章节
    var chapterModel:DZMReadChapterModel!
    
    /// 阅读到的页码(上传阅读记录到服务器时传当前页面的 location 上去,从服务器拿回来 location 在转成页码。精准回到上次阅读位置)
    var page:NSNumber! = NSNumber(value: 0)
    
    
    // MARK: 快捷获取
    
    /// 当前记录分页模型
    var pageModel:DZMReadPageModel! { return  chapterModel.pageModels[page.intValue] }
    
    /// 当前记录起始坐标
    var locationFirst:NSNumber! { return chapterModel.locationFirst(page: page.intValue) }
    
    /// 当前记录末尾坐标
    var locationLast:NSNumber! { return chapterModel.locationLast(page: page.intValue) }
    
    /// 当前记录是否为第一个章节
    var isFirstChapter:Bool! { return chapterModel.isFirstChapter }
    
    /// 当前记录是否为最后一个章节
    var isLastChapter:Bool! { return chapterModel.isLastChapter }
    
    /// 当前记录是否为第一页
    var isFirstPage:Bool! { return (page.intValue == 0) }
    
    /// 当前记录是否为最后一页
    var isLastPage:Bool! { return (page.intValue == (chapterModel.pageCount.intValue - 1)) }
    
    /// 当前记录页码字符串
    var contentString:String! { return chapterModel.contentString(page: page.intValue) }
    
    /// 当前记录页码富文本
    var contentAttributedString:NSAttributedString! { return chapterModel.contentAttributedString(page: page.intValue) }
    
    /// 当前记录切到上一页
    func previousPage() { page = NSNumber(value: max(page.intValue - 1, 0)) }
    
    /// 当前记录切到下一页
    func nextPage() { page = NSNumber(value: min(page.intValue + 1, chapterModel.pageCount.intValue - 1)) }
    
    /// 当前记录切到第一页
    func firstPage() { page = NSNumber(value: 0) }
    
    /// 当前记录切到最后一页
    func lastPage() { page = NSNumber(value: chapterModel.pageCount.intValue - 1) }
    
    
    // MARK: 辅助
    
    /// 修改阅读记录为指定章节位置
    func modify(chapterModel:DZMReadChapterModel!, page:NSInteger, isSave:Bool = true) {
        
        self.chapterModel = chapterModel
        
        self.page = NSNumber(value: page)
        
        if isSave { save() }
    }
    
    /// 修改阅读记录为指定章节位置
    func modify(chapterID:NSNumber!, location:NSInteger, isSave:Bool = true) {
        
        if DZMReadChapterModel.isExist(bookID: bookID, chapterID: chapterID) {
            
            chapterModel = DZMReadChapterModel.model(bookID: bookID, chapterID: chapterID)
            
            page = chapterModel.page(location: location)
            
            if isSave { save() }
        }
    }
    
    /// 修改阅读记录为指定章节页码 (toPage == DZM_READ_LAST_PAGE 为当前章节最后一页)
    func modify(chapterID:NSNumber!, toPage:NSInteger, isSave:Bool = true) {
        
        if DZMReadChapterModel.isExist(bookID: bookID, chapterID: chapterID) {
            
            chapterModel = DZMReadChapterModel.model(bookID: bookID, chapterID: chapterID)
            
            if (toPage == DZM_READ_LAST_PAGE) { lastPage()
                
            }else{ page = NSNumber(value: toPage) }
            
            if isSave { save() }
        }
    }
    
    /// 更新字体
    func updateFont(isSave:Bool = true) {
        
        if chapterModel != nil {
            
            chapterModel.updateFont()
            
            page = chapterModel.page(location: DZM_READ_RECORD_CURRENT_CHAPTER_LOCATION.intValue)
            
            if isSave { save() }
        }
    }
    
    /// 拷贝阅读记录
    func copyModel() ->DZMReadRecordModel {
        
        let recordModel = DZMReadRecordModel()
        
        recordModel.bookID = bookID
        
        recordModel.chapterModel = chapterModel
        
        recordModel.page = page
        
        return recordModel
    }
    
    /// 保存记录
    func save() {
        
        DZMKeyedArchiver.archiver(folderName: bookID, fileName: DZM_READ_KEY_RECORD, object: self)
    }
    
    /// 是否存在阅读记录
    class func isExist(_ bookID:String!) ->Bool {
        
        return DZMKeyedArchiver.isExist(folderName: bookID, fileName: DZM_READ_KEY_RECORD)
    }
    
    
    // MARK: 构造
    
    /// 获取阅读记录对象,如果则创建对象返回
    class func model(bookID:String!) ->DZMReadRecordModel {
        
        var recordModel:DZMReadRecordModel!
        
        if DZMReadRecordModel.isExist(bookID) {
            
            recordModel = DZMKeyedArchiver.unarchiver(folderName: bookID, fileName: DZM_READ_KEY_RECORD) as? DZMReadRecordModel
            
            recordModel.chapterModel.updateFont()
            
        }else{
            
            recordModel = DZMReadRecordModel()
            
            recordModel.bookID = bookID
        }
        
        return recordModel
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init()
        
        bookID = aDecoder.decodeObject(forKey: "bookID") as? String
        
        chapterModel = aDecoder.decodeObject(forKey: "chapterModel") as? DZMReadChapterModel
        
        page = aDecoder.decodeObject(forKey: "page") as? NSNumber
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(bookID, forKey: "bookID")
        
        aCoder.encode(chapterModel, forKey: "chapterModel")
        
        aCoder.encode(page, forKey: "page")
    }
    
    init(_ dict:Any? = nil) {
        
        super.init()
        
        if dict != nil { setValuesForKeys(dict as! [String : Any]) }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) { }
}
