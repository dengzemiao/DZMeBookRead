//
//  HJReadChapterListModel.swift
//  HJProject
//
//  Created by 邓泽淼 on 16/9/2.
//  Copyright © 2016年 HanJue. All rights reserved.
//

import UIKit

class HJReadChapterListModel: NSObject {
    
    var chapterHeight:NSNumber! = ScreenHeight    // 上下滚动使用

    var chapterID: String!                 // 章节ID
    var chapterName: String!               // 章节名称
    var volumeID: String!                  // 卷ID
    var isDownload:NSNumber = 0            // 章节是否下载
    var isVIPChapter:NSNumber = 0          // 是否属于VIP章节
    var isPayChapter:NSNumber = 0          // 是否属于付费章节
    var isBuyChapter:NSNumber = 0          // 是否已购买该章节
    var price:NSNumber = 0                 // 价钱
    
    // MARK: -- aDecoder
    
    override init() {
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init()
        
        chapterHeight = aDecoder.decodeObjectForKey("chapterHeight") as! NSNumber
        
        chapterID = aDecoder.decodeObjectForKey("chapterID") as! String
        
        chapterName = aDecoder.decodeObjectForKey("chapterName") as! String
        
        volumeID = aDecoder.decodeObjectForKey("volumeID") as! String
        
        isDownload = aDecoder.decodeObjectForKey("isDownload") as! NSNumber
        
        isVIPChapter = aDecoder.decodeObjectForKey("isVIPChapter") as! NSNumber
        
        isPayChapter = aDecoder.decodeObjectForKey("isPayChapter") as! NSNumber
        
        isBuyChapter = aDecoder.decodeObjectForKey("isBuyChapter") as! NSNumber
        
        price = aDecoder.decodeObjectForKey("price") as! NSNumber
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        
        aCoder.encodeObject(chapterHeight, forKey: "chapterHeight")
        
        aCoder.encodeObject(chapterID, forKey: "chapterID")
        
        aCoder.encodeObject(chapterName, forKey: "chapterName")
        
        aCoder.encodeObject(volumeID, forKey: "volumeID")
        
        aCoder.encodeObject(isDownload, forKey: "isDownload")
        
        aCoder.encodeObject(isVIPChapter, forKey: "isVIPChapter")
        
        aCoder.encodeObject(isPayChapter, forKey: "isPayChapter")
        
        aCoder.encodeObject(isBuyChapter, forKey: "isBuyChapter")
        
        aCoder.encodeObject(price, forKey: "price")
    }
}
