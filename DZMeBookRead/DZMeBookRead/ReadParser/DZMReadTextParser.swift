//
//  DZMReadTextParser.swift
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/4/17.
//  Copyright © 2019年 DZM. All rights reserved.
//

import UIKit

class DZMReadTextParser: NSObject {

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
            
            // 解析内容并获得章节列表
            let chapterListModels = parser(bookID: bookID, content: content)
            
            // 解析内容失败
            if chapterListModels.isEmpty { return nil }
            
            // 阅读模型
            let readModel = DZMReadModel.model(bookID: bookID)
            
            // 书籍类型
            readModel.bookSourceType = .local
            
            // 小说名称
            readModel.bookName = bookName
            
            // 记录章节列表
            readModel.chapterListModels = chapterListModels
            
            // 设置第一个章节为阅读记录
            readModel.recordModel.modify(chapterID:  readModel.chapterListModels.first!.id, toPage: 0)
            
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
    ///   - bookID: 小说ID
    ///   - content: 小说内容
    /// - Returns: 章节列表
    private class func parser(bookID:String!, content:String!) ->[DZMReadChapterListModel] {
        
        // 章节列表
        var chapterListModels:[DZMReadChapterListModel] = []
        
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
            
        }catch{
            
            return chapterListModels
        }
        
        // 解析匹配结果
        if !results.isEmpty {
            
            // 章节数量
            let count = results.count
            
            // 记录最后一个Range
            var lastRange:NSRange!
            
            // 记录最后一个章节对象C
            var lastChapterModel:DZMReadChapterModel?
            
            // 有前言
            var isHavePreface:Bool = true
            
            // 便利
            for i in 0...count {
                
                // 章节数量分析:
                // count + 1  = 匹配到的章节数量 + 最后一个章节
                // 1 + count + 1  = 第一章前面的前言内容 + 匹配到的章节数量 + 最后一个章节
                DZMLog("章节总数: \(count + 1)  当前正在解析: \(i + 1)")
                
                var range = NSMakeRange(0, 0)
                
                var location = 0
                
                if i < count {
                    
                    range = results[i].range
                    
                    location = range.location
                }
                
                // 章节内容
                let chapterModel = DZMReadChapterModel()
                
                // 书ID
                chapterModel.bookID = bookID
                
                // 章节ID
                chapterModel.id = NSNumber(value: (i + NSNumber(value: isHavePreface).intValue))
                
                // 优先级
                chapterModel.priority = NSNumber(value: (i - NSNumber(value: !isHavePreface).intValue))
                
                if i == 0 { // 前言
                    
                    // 章节名
                    chapterModel.name = "开始"
                    
                    // 内容
                    chapterModel.content = content.substring(NSMakeRange(0, location))
                    
                    // 记录
                    lastRange = range
                    
                    // 没有内容则不需要添加列表
                    if chapterModel.content.isEmpty {
                        
                        isHavePreface = false
                        
                        continue
                    }
                    
                }else if i == count { // 结尾
                    
                    // 章节名
                    chapterModel.name = content.substring(lastRange)
                    
                    // 内容(不包含章节名)
                    chapterModel.content = content.substring(NSMakeRange(lastRange.location + lastRange.length, content.length - lastRange.location - lastRange.length))
                    
                }else { // 中间章节
                    
                    // 章节名
                    chapterModel.name = content.substring(lastRange)
                    
                    // 内容(不包含章节名)
                    chapterModel.content = content.substring(NSMakeRange(lastRange.location + lastRange.length, location - lastRange.location - lastRange.length))
                }
                
                // 章节开头双空格 + 章节纯内容
                chapterModel.content = DZM_READ_PH_SPACE + chapterModel.content.removeSEHeadAndTail
                
                // 设置上一个章节ID
                chapterModel.previousChapterID = lastChapterModel?.id ?? DZM_READ_NO_MORE_CHAPTER
                
                // 设置下一个章节ID
                if i == (count - 1) { // 最后一个章节了
                    
                    chapterModel.nextChapterID = DZM_READ_NO_MORE_CHAPTER

                }else{ lastChapterModel?.nextChapterID = chapterModel.id }
                
                // 保存
                chapterModel.save()
                lastChapterModel?.save()
                
                // 记录
                lastRange = range
                lastChapterModel = chapterModel
                
                // 通过章节内容生成章节列表
                chapterListModels.append(GetChapterListModel(chapterModel: chapterModel))
            }
            
        }else{
            
            // 章节内容
            let chapterModel = DZMReadChapterModel()
            
            // 书ID
            chapterModel.bookID = bookID
            
            // 章节ID
            chapterModel.id = NSNumber(value: 1)
            
            // 章节名
            chapterModel.name = "开始"
            
            // 优先级
            chapterModel.priority = NSNumber(value: 0)
            
            // 内容
            chapterModel.content = DZM_READ_PH_SPACE + content.removeSEHeadAndTail
            
            // 保存
            chapterModel.save()
            
            // 添加章节列表模型
            chapterListModels.append(GetChapterListModel(chapterModel: chapterModel))
        }
        
        // 返回
        return chapterListModels
    }
    
    /// 获取章节列表对象
    ///
    /// - Parameter chapterModel: 章节内容对象
    /// - Returns: 章节列表对象
    private class func GetChapterListModel(chapterModel:DZMReadChapterModel) ->DZMReadChapterListModel {
        
        let chapterListModel = DZMReadChapterListModel()
        
        chapterListModel.bookID = chapterModel.bookID
        
        chapterListModel.id = chapterModel.id
        
        chapterListModel.name = chapterModel.name
        
        return chapterListModel
    }
}
