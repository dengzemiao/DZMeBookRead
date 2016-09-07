//
//  HJReadRecord.swift
//  HJProject
//
//  Created by 邓泽淼 on 16/8/30.
//  Copyright © 2016年 HanJue. All rights reserved.
//

import UIKit

class HJReadRecord: NSObject,NSCoding {

    /// 只有在滚动模式下才使用别的都没有用
    var contentOffsetY:NSNumber?
    
    /// 当前阅读到的章节模型
    var readChapterListModel:HJReadChapterListModel!
    
    /// 当前阅读到章节的页码
    var page:NSNumber = 0
    
    /// 当前阅读到的章节索引
    var chapterIndex:NSNumber = 0
    
    /// 总章节数
    var chapterCount:NSNumber = 0
    
    override init() {
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init()
        
        contentOffsetY = aDecoder.decodeObjectForKey("contentOffsetY") as? NSNumber
        
        readChapterListModel = aDecoder.decodeObjectForKey("readChapterListModel") as? HJReadChapterListModel
        
        page = aDecoder.decodeObjectForKey("page") as! NSNumber
        
        chapterIndex = aDecoder.decodeObjectForKey("chapterIndex") as! NSNumber
        
        chapterCount = aDecoder.decodeObjectForKey("chapterCount") as! NSNumber
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(contentOffsetY, forKey: "contentOffsetY")
        
        aCoder.encodeObject(readChapterListModel, forKey: "readChapterListModel")
        
        aCoder.encodeObject(page, forKey: "page")
        
        aCoder.encodeObject(chapterIndex, forKey: "chapterIndex")
        
        aCoder.encodeObject(chapterCount, forKey: "chapterCount")
    }
}
