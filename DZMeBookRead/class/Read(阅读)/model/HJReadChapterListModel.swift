//
//  HJReadChapterListModel.swift
//  HJProject
//
//  Created by 邓泽淼 on 16/9/2.
//  Copyright © 2016年 HanJue. All rights reserved.
//

import UIKit

class HJReadChapterListModel: NSObject {
    
    var changeChapterHeight:NSNumber! = 0
    var chapterHeight:NSNumber! = NSNumber(value:Float(HJReadParser.GetReadViewFrame().height)) {  // 上下滚动使用
        
        didSet{
            
            if oldValue.intValue != 0 {
                
                changeChapterHeight = NSNumber(value:chapterHeight.floatValue - oldValue.floatValue)
            }
        }
    }

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
        
        changeChapterHeight = aDecoder.decodeObject(forKey: "changeChapterHeight") as! NSNumber
        
        chapterHeight = aDecoder.decodeObject(forKey: "chapterHeight") as! NSNumber
        
        chapterID = aDecoder.decodeObject(forKey: "chapterID") as! String
        
        chapterName = aDecoder.decodeObject(forKey: "chapterName") as! String
        
        volumeID = aDecoder.decodeObject(forKey: "volumeID") as! String
        
        isDownload = aDecoder.decodeObject(forKey: "isDownload") as! NSNumber
        
        isVIPChapter = aDecoder.decodeObject(forKey: "isVIPChapter") as! NSNumber
        
        isPayChapter = aDecoder.decodeObject(forKey: "isPayChapter") as! NSNumber
        
        isBuyChapter = aDecoder.decodeObject(forKey: "isBuyChapter") as! NSNumber
        
        price = aDecoder.decodeObject(forKey: "price") as! NSNumber
    }
    
    func encodeWithCoder(_ aCoder: NSCoder) {
        
        aCoder.encode(changeChapterHeight, forKey: "changeChapterHeight")
        
        aCoder.encode(chapterHeight, forKey: "chapterHeight")
        
        aCoder.encode(chapterID, forKey: "chapterID")
        
        aCoder.encode(chapterName, forKey: "chapterName")
        
        aCoder.encode(volumeID, forKey: "volumeID")
        
        aCoder.encode(isDownload, forKey: "isDownload")
        
        aCoder.encode(isVIPChapter, forKey: "isVIPChapter")
        
        aCoder.encode(isPayChapter, forKey: "isPayChapter")
        
        aCoder.encode(isBuyChapter, forKey: "isBuyChapter")
        
        aCoder.encode(price, forKey: "price")
    }
}
