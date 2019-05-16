//
//  DZMReadTextFastParser.swift
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/5/15.
//  Copyright © 2019 DZM. All rights reserved.
//

import UIKit

class DZMReadTextFastParser: NSObject {
    
    /// 异步解析本地链接
    ///
    /// - Parameters:
    ///   - url: 本地文件地址
    ///   - completion: 解析完成
    @objc class func parser(url:URL!, completion:DZMParserCompletion!) {
        
        DispatchQueue.global().async {
            
            let readModel = parser(url: url)
            
            DispatchQueue.main.async {
                
                completion?(readModel)
            }
        }
    }
    
    /// 解析本地链接
    ///
    /// - Parameter url: 本地文件地址
    /// - Returns: 阅读对象
    private class func parser(url:URL!) ->DZMReadModel? {
        
        // 链接不为空且是本地文件路径
        if url == nil || url.absoluteString.isEmpty || !url.isFileURL { return nil }
        
        // 获取文件后缀名作为 bookName
        let bookName = url.absoluteString.removingPercentEncoding?.lastPathComponent.deletingPathExtension ?? ""
        
        // bookName 作为 bookID
        let bookID = bookName
        
        // bookID 为空
        if bookID.isEmpty { return nil }
        
        if !DZMReadModel.isExist(bookID: bookID) { // 不存在
            
            // 解析数据
            let content = DZMReadParser.encode(url: url)
            
            // 解析失败
            if content.isEmpty { return nil }
            
            // 阅读模型
            let readModel = DZMReadModel.model(bookID: bookID)
            
            // 书籍类型
            readModel.bookSourceType = .local
            
            // 小说名称
            readModel.bookName = bookName
            
            // 解析内容并获得章节列表
            parser(readModel: readModel, content: content)
            
            // 解析内容失败
            if readModel.chapterListModels.isEmpty { return nil }
            
            // 首章
            let chapterListModel = readModel.chapterListModels.first!
            
            // 加载首章
            _ = parser(readModel: readModel, chapterID: chapterListModel.id)
            
            // 设置第一个章节为阅读记录
            readModel.recordModel.modify(chapterID:  chapterListModel.id, toPage: 0)
            
            // 保存
            readModel.save()
            
            // 返回
            return readModel
            
        }else{ // 存在
            
            // 返回
            return DZMReadModel.model(bookID: bookID)
        }
    }
    
    /// 解析整本小说
    ///
    /// - Parameters:
    ///   - readModel: readModel
    ///   - content: 小说内容
    private class func parser(readModel:DZMReadModel, content:String!) {
        
        // 章节列表
        var chapterListModels:[DZMReadChapterListModel] = []
        
        // 章节范围列表 [章节ID:[章节优先级:章节内容Range]]
        var ranges:[String:[String:NSRange]] = [:]
        
        // 正则
        let parten = "第[0-9一二三四五六七八九十百千]*[章回].*"
        
        // 排版
        let content = DZMReadParser.contentTypesetting(content: content)
        
        // 正则匹配结果
        var results:[NSTextCheckingResult] = []
        
        // 开始匹配
        do{
            let regularExpression:NSRegularExpression = try NSRegularExpression(pattern: parten, options: .caseInsensitive)
            
            results = regularExpression.matches(in: content, options: .reportCompletion, range: NSRange(location: 0, length: content.length))
            
        }catch{ return  }
        
        // 解析匹配结果
        if !results.isEmpty {
            
            // 章节数量
            let count = results.count
            
            // 记录最后一个Range
            var lastRange:NSRange!
            
            // 有前言
            var isHavePreface:Bool = true
            
            // 便利
            for i in 0...count {
                
                // 章节数量分析:
                // count + 1  = 匹配到的章节数量 + 最后一个章节
                // 1 + count + 1  = 第一章前面的前言内容 + 匹配到的章节数量 + 最后一个章节
                // DZMLog("章节总数: \(count + 1)  当前正在解析: \(i + 1)")
                
                var range = NSMakeRange(0, 0)
                
                var location = 0
                
                if i < count {
                    
                    range = results[i].range
                    
                    location = range.location
                }
                
                // 章节列表
                let chapterListModel = DZMReadChapterListModel()
                
                // 书ID
                chapterListModel.bookID = readModel.bookID
                
                // 章节ID
                chapterListModel.id = NSNumber(value: (i + NSNumber(value: isHavePreface).intValue))
                
                // 优先级
                let priority = NSNumber(value: (i - NSNumber(value: !isHavePreface).intValue))
                
                if i == 0 { // 前言
                    
                    // 章节名
                    chapterListModel.name = "开始"
                    
                    // 内容Range
                    ranges[chapterListModel.id.stringValue] = [priority.stringValue:NSMakeRange(0, location)]
                    
                    // 内容
                    let content = content.substring(NSMakeRange(0, location))
                    
                    // 记录
                    lastRange = range
                    
                    // 没有内容则不需要添加列表
                    if content.isEmpty {
                        
                        isHavePreface = false
                        
                        continue
                    }
                    
                }else if i == count { // 结尾
                    
                    // 章节名
                    chapterListModel.name = content.substring(lastRange)
                    
                    // 内容Range
                    ranges[chapterListModel.id.stringValue] =  [priority.stringValue:NSMakeRange(lastRange.location + lastRange.length, content.length - lastRange.location - lastRange.length)]
                    
                }else { // 中间章节
                    
                    // 章节名
                    chapterListModel.name =  content.substring(lastRange)
                    
                    // 内容Range
                    ranges[chapterListModel.id.stringValue] = [priority.stringValue:NSMakeRange(lastRange.location + lastRange.length, location - lastRange.location - lastRange.length)]
                }
                
                // 记录
                lastRange = range
                
                // 通过章节内容生成章节列表
                chapterListModels.append(chapterListModel)
            }
            
        }else{
            
            // 章节列表
            let chapterListModel = DZMReadChapterListModel()
            
            // 章节名
            chapterListModel.name = "开始"
            
            // 书ID
            chapterListModel.bookID = readModel.bookID
            
            // 章节ID
            chapterListModel.id = NSNumber(value: 1)
            
            // 优先级
            let priority = NSNumber(value: 0)
            
            // 内容Range
            ranges[chapterListModel.id.stringValue] = [priority.stringValue:NSMakeRange(0, content.length)]
            
            // 添加章节列表模型
            chapterListModels.append(chapterListModel)
        }
        
        
        // 小说全文
        readModel.fullText = content
        
        // 章节列表
        readModel.chapterListModels = chapterListModels
        
        // 章节内容范围
        readModel.ranges = ranges
    }
    
    /// 获取单个指定章节
    class func parser(readModel:DZMReadModel!, chapterID:NSNumber!, isUpdateFont:Bool = true) ->DZMReadChapterModel? {
        
        // 获得[章节优先级:章节内容Range]
        let range = readModel.ranges[chapterID.stringValue]
      
        // 没有了
        if range != nil {
            
            // 当前优先级
            let priority = range!.keys.first!.integer
            
            // 章节内容范围
            let range = range!.values.first
            
            // 当前章节
            let chapterListModel = readModel.chapterListModels[priority]
            
            /// 第一个章节
            let isFirstChapter:Bool = (priority == 0)
            
            /// 最后一个章节
            let isLastChapter:Bool = (priority == (readModel.chapterListModels.count - 1))
            
            // 上一个章节ID
            let previousChapterID:NSNumber! = isFirstChapter ? DZM_READ_NO_MORE_CHAPTER : readModel.chapterListModels[priority - 1].id
            
            // 下一个章节ID
            let nextChapterID:NSNumber! = isLastChapter ? DZM_READ_NO_MORE_CHAPTER : readModel.chapterListModels[priority + 1].id
            
            // 章节内容
            let chapterModel = DZMReadChapterModel()
            
            // 书ID
            chapterModel.bookID = chapterListModel.bookID
            
            // 章节ID
            chapterModel.id = chapterListModel.id
            
            // 章节名
            chapterModel.name = chapterListModel.name
            
            // 优先级
            chapterModel.priority = NSNumber(value: priority)
            
            // 上一个章节ID
            chapterModel.previousChapterID = previousChapterID
            
            // 下一个章节ID
            chapterModel.nextChapterID = nextChapterID
            
            // 章节内容
            chapterModel.content = DZM_READ_PH_SPACE + readModel.fullText.substring(range!).removeSEHeadAndTail

            // 保存
            if isUpdateFont { chapterModel.updateFont()
                
            }else{ chapterModel.save() }
            
            // 返回
            return chapterModel
        }
        
        return nil
    }
}
