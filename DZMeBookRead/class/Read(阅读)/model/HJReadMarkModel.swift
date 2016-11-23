//
//  HJReadMarkModel.swift
//  DZMeBookRead
//
//  Created by 邓泽淼 on 2016/11/7.
//  Copyright © 2016年 DZM. All rights reserved.
//

import UIKit

class HJReadMarkModel: NSObject,NSCoding {
    
    var bookID:String!
    var chapterID: String!          // 章节ID
    var volumeID: String!           // 卷ID
    var chapterName: String!        // 章节名称
    var time:Date!                  // 保存时间
    var content:String!             // 当前标签内容
    var location:NSNumber = 0       // 当前书签的起始位置
    
    // 获取当前书签所在的页码
    func GetCurrentPage() ->Int {
        
        // 获取阅读章节文件
        let readChapterModel = ReadKeyedUnarchiver(bookID, fileName: chapterID) as? HJReadChapterModel
        
        readChapterModel?.updateFont()
        
        let currentLocation = location.intValue + 1
        
        if (readChapterModel != nil) {
            
            for i in 0..<readChapterModel!.pageCount.intValue {
                
                // 获取range
                let range = readChapterModel!.getRangeWithPage(i)
                
                // 进行判断
                // 大于等于 当前页码的location   小于等于当前页面的loction + length
                if (currentLocation >= range.location && currentLocation <= (range.location + range.length)) {
        
                    return i
                }
            }
        }
        
        return 0
    }
    
    // MARK: -- aDecoder
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init()
        
        bookID = aDecoder.decodeObject(forKey: "bookID") as! String
        
        chapterID = aDecoder.decodeObject(forKey: "chapterID") as! String
        
        volumeID = aDecoder.decodeObject(forKey: "volumeID") as! String
        
        chapterName = aDecoder.decodeObject(forKey: "chapterName") as! String
        
        time = aDecoder.decodeObject(forKey: "time") as! Date
        
        content = aDecoder.decodeObject(forKey: "content") as! String
        
        location = aDecoder.decodeObject(forKey: "location") as! NSNumber
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(bookID, forKey: "bookID")
        
        aCoder.encode(chapterID, forKey: "chapterID")
        
        aCoder.encode(volumeID, forKey: "volumeID")
        
        aCoder.encode(chapterName, forKey: "chapterName")
        
        aCoder.encode(time, forKey: "time")
        
        aCoder.encode(content, forKey: "content")
        
        aCoder.encode(location, forKey: "location")
    }
}
