//
//  HJReadChapterModel.swift
//  HJProject
//
//  Created by 邓泽淼 on 16/8/25.
//  Copyright © 2016年 HanJue. All rights reserved.
//

import UIKit
import CoreText

class HJReadChapterModel: NSObject,NSCoding {
    
    var chapterID: String!                 // 章节ID
    var previousChapterId: String?         // 上一章ID
    var nextChapterId:String?              // 下一章ID
    var chapterName: String!               // 章节名称
    var volumeID: String!                  // 卷ID
    var chapterContent: String! = ""       // 章节内容
    
    var pageCount:NSNumber = 0             // 本章有多少页
    var pageLocationArray:[Int] = []       // 分页的起始位置
    
    /// 刷新字体
    func updateFont() {
        
        pageRangeWithBounds(HJReadParser.GetReadViewFrame())
    }
    
    fileprivate func pageRangeWithBounds(_ bounds:CGRect) {
        
        pageLocationArray.removeAll()
        
        // 拼接字符串
        let attrString = NSMutableAttributedString(string: chapterContent,attributes: HJReadParser.parserAttribute(HJReadConfigureManger.shareManager))
        
        let frameSetter = CTFramesetterCreateWithAttributedString(attrString as CFAttributedString)

        let path = CGPath(rect: bounds, transform: nil)
        
        var currentOffset = 0
        
        var currentInnerOffset = 0
        
        var hasMorePages:Bool = true
        
        // 防止死循环，如果在同一个位置获取CTFrame超过2次，则跳出循环
        let preventDeadLoopSign = currentOffset
        
        var samePlaceRepeatCount = 0
        
        while hasMorePages {
            
            if preventDeadLoopSign == currentOffset {
                
                samePlaceRepeatCount += 1
                
            }else{
                
                samePlaceRepeatCount = 0
            }
            
            if samePlaceRepeatCount > 1 {
                
                if pageLocationArray.count == 0 {
                    
                    pageLocationArray.append(currentOffset)
                    
                }else{
                    
                    let lastOffset = pageLocationArray.last
                    
                    if lastOffset != currentOffset {
                        
                        pageLocationArray.append(currentOffset)
                    }
                }
                
                break
            }
            
            pageLocationArray.append(currentOffset)
            
            let frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(currentInnerOffset, 0), path, nil)
            let range = CTFrameGetVisibleStringRange(frame)
            
            if (range.location + range.length) != attrString.length {
                
                currentOffset += range.length
                
                currentInnerOffset += range.length
                
            }else{
                
                // 已经分完，提示跳出循环
                
                hasMorePages = false
            }
            
            pageCount = NSNumber(value:pageLocationArray.count)
        }
    }
    
    /**
     根据index 页码返回对应的字符串
     
     - parameter page: 页码索引
     */
    func stringOfPage(_ page:Int) ->String {
        
        let range = getRangeWithPage(page)
        
        return chapterContent.substringWithRange(range)
    }
    
    // 获取指定索引的range
    func getRangeWithPage(_ page:Int) ->NSRange {
        
        let local = pageLocationArray[page]
        
        var length = 0
        
        if page < pageCount.intValue - 1 {
            
            length = pageLocationArray[page + 1] - pageLocationArray[page]
            
        }else{
            
            length = chapterContent.length - pageLocationArray[page]
        }
        
        return NSMakeRange(local, length)
    }
    
    // MARK: -- aDecoder
    
    override init() {
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init()
        
        chapterID = aDecoder.decodeObject(forKey: "chapterID") as! String
        
        nextChapterId = aDecoder.decodeObject(forKey: "nextChapterId") as? String
        
        previousChapterId = aDecoder.decodeObject(forKey: "previousChapterId") as? String
        
        chapterName = aDecoder.decodeObject(forKey: "chapterName") as! String
        
        volumeID = aDecoder.decodeObject(forKey: "volumeID") as! String
        
        pageCount = aDecoder.decodeObject(forKey: "pageCount") as! NSNumber
        
        pageLocationArray = aDecoder.decodeObject(forKey: "pageLocationArray") as! [Int]
        
        chapterContent = aDecoder.decodeObject(forKey: "chapterContent") as! String
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(chapterID, forKey: "chapterID")
        
        aCoder.encode(nextChapterId, forKey: "nextChapterId")
        
        aCoder.encode(previousChapterId, forKey: "previousChapterId")
        
        aCoder.encode(chapterName, forKey: "chapterName")
        
        aCoder.encode(volumeID, forKey: "volumeID")
        
        aCoder.encode(pageCount, forKey: "pageCount")
        
        aCoder.encode(pageLocationArray, forKey: "pageLocationArray")
        
        aCoder.encode(chapterContent, forKey: "chapterContent")
    }

}
