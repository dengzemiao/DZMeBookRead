//
//  DZMReadParser.swift
//  DZMeBookRead
//
//  Created by 邓泽淼 on 2017/5/12.
//  Copyright © 2017年 DZM. All rights reserved.
//

import UIKit
import CoreText

class DZMReadParser: NSObject {
    
    // MARK: -- 解析文件
    
    /**
     异步线程 解析本地URL
     
     - parameter url: 本地小说文本URL
     
     - parameter complete: 成功返回true  失败返回false
     
     - returns: ReadModel
     */
    @objc class func ParserLocalURL(url:URL,complete:((_ readModel:DZMReadModel) ->Void)?) {
       
        DispatchQueue.global().async {
            
            let readModel = DZMReadParser.ParserLocalURL(url: url)
            
            DispatchQueue.main.async(execute: {()->() in
                
                if complete != nil {complete!(readModel)}
            })
            
        }
    }
    
    /**
     主线程 解析本地URL
     
     - parameter url: URL
     
     - returns: ReadModel
     */
    @objc class func ParserLocalURL(url:URL) ->DZMReadModel {
        
        let bookID = GetFileName(url)
        
        if !DZMReadModel.IsExistReadModel(bookID: bookID) { // 不存在
           
            // 阅读模型
            let readModel = DZMReadModel.readModel(bookID: bookID)
            
            // 解析数据
            let content = DZMReadParser.EncodeURL(url)
            
            // 获得章节列表
            readModel.readChapterListModels = ParserContent(bookID: bookID, content: content)
            
            // 设置阅读记录 第一个章节 为 首个章节ID
            readModel.modifyReadRecordModel(chapterID: readModel.readChapterListModels.first!.id)
            
            // 保存
            readModel.save()
            
            // 返回
            return readModel
            
        }else{ // 存在
            
            // 返回
            return DZMReadModel.readModel(bookID: bookID)
        }
    }
    
    // MARK: -- 解析Context
    
    /**
     解析Context
     
     - parameter bookID: 小说ID
     
     - parameter content: 内容
     
     - returns: 章节列表模型数组
     */
    private class func ParserContent(bookID:String, content:String) ->[DZMReadChapterListModel] {
        
        // 章节列表数组
        var readChapterListModels:[DZMReadChapterListModel] = []
        
        // 正则
        let parten = "第[0-9一二三四五六七八九十百千]*[章回].*"
        
        // 排版
        let content = ContentTypesetting(content: content)
        
        // 搜索
        var results:[NSTextCheckingResult] = []
        
        do{
            let regularExpression:NSRegularExpression = try NSRegularExpression(pattern: parten, options: .caseInsensitive)
            
            results = regularExpression.matches(in: content, options: .reportCompletion, range: NSRange(location: 0, length: content.length))
            
        }catch{
            
            return readChapterListModels
        }
        
        // 解析搜索结果
        if !results.isEmpty {
            
            // 记录最后一个Range
            var lastRange = NSMakeRange(0, 0)
            
            // 数量
            let count = results.count
            
            // 记录 上一章 模型
            var lastReadChapterModel:DZMReadChapterModel?
            
            // 有前言
            var isPreface:Bool = true
            
            // 便利
            for i in 0...count {
                
                // 章节数量分析:
                // count + 1  = 搜索到的章节数量 + 最后一个章节,
                // 1 + count + 1  = 第一章前面的前言内容 + 搜索到的章节数量 + 最后一个章节
                print("总章节数:\(count + 1)  当前解析到:\(i + 1)")
                
                // range
                var range = NSMakeRange(0, 0)
                
                var location = 0
                
                if i < count {
                    
                    range = results[i].range
                    
                    location = range.location
                }
                
                // 创建章节内容模型
                let readChapterModel = DZMReadChapterModel()
                
                // 书ID
                readChapterModel.bookID = bookID
                
                // 章节ID
                readChapterModel.id = "\(i + NSNumber(value: isPreface).intValue)"
                
                // 优先级
                readChapterModel.priority = NSNumber(value: (i - NSNumber(value: !isPreface).intValue))
                
                if i == 0 { // 开始
                    
                    // 章节名
                    readChapterModel.name = "开始"
                    
                    // 内容
                    readChapterModel.content = content.substring(NSMakeRange(0, location))
                    
                    // 记录
                    lastRange = range
                    
                    // 说不定没有内容 则不需要添加到列表
                    if readChapterModel.content.isEmpty {
                        
                        isPreface = false
                        
                        continue
                    }
                    
                }else if i == count { // 结尾
                    
                    // 章节名
                    readChapterModel.name = content.substring(lastRange)
                    
                    // 内容
                    readChapterModel.content = content.substring(NSMakeRange(lastRange.location, content.length - lastRange.location))
                    
                }else { // 中间章节
                    
                    // 章节名
                    readChapterModel.name = content.substring(lastRange)
                    
                    // 内容
                    readChapterModel.content = content.substring(NSMakeRange(lastRange.location, location - lastRange.location))
                }
                
                // 清空章节名,保留纯内容
                readChapterModel.content = DZMParagraphHeaderSpace + readChapterModel.content.replacingOccurrences(of: readChapterModel.name, with: "").removeSpaceHeadAndTailPro
                
                // 分页
                readChapterModel.updateFont()
                
                // 添加章节列表模型
                readChapterListModels.append(GetReadChapterListModel(readChapterModel: readChapterModel))
                
                // 设置上下章ID
                readChapterModel.lastChapterId = lastReadChapterModel?.id
                lastReadChapterModel?.nextChapterId = readChapterModel.id
                
                // 保存
                readChapterModel.save()
                lastReadChapterModel?.save()
                
                // 记录
                lastRange = range
                lastReadChapterModel = readChapterModel
            }
            
        }else{
            
            // 创建章节内容模型
            let readChapterModel = DZMReadChapterModel()
            
            // 书ID
            readChapterModel.bookID = bookID
            
            // 章节ID
            readChapterModel.id = "1"
            
            // 章节名
            readChapterModel.name = "开始"
            
            // 优先级
            readChapterModel.priority = NSNumber(value: 0)
            
            // 内容
            readChapterModel.content = DZMParagraphHeaderSpace + content.removeSpaceHeadAndTailPro
            
            // 分页
            readChapterModel.updateFont()
            
            // 添加章节列表模型
            readChapterListModels.append(GetReadChapterListModel(readChapterModel: readChapterModel))
            
            // 保存
            readChapterModel.save()
        }
        
        return readChapterListModels
    }
    
    /**
     通过阅读章节内容模型 获得 阅读章节列表模型
     
     - parameter readChapterModel: 阅读章节内容模型
     
     - returns: 阅读章节列表模型
     */
    private class func GetReadChapterListModel(readChapterModel:DZMReadChapterModel) ->DZMReadChapterListModel {
        
        let readChapterListModel = DZMReadChapterListModel()
        
        readChapterListModel.bookID = readChapterModel.bookID
        
        readChapterListModel.id = readChapterModel.id
        
        readChapterListModel.name = readChapterModel.name
        
        readChapterListModel.priority = readChapterModel.priority
        
        return readChapterListModel
    }
    
    // MARK: -- 内容分页
    
    /// 内容分页 (内容 + 显示范围)
    @objc class func ParserPageRange(attrString:NSAttributedString, rect:CGRect) ->[NSRange] {
        
        var rangeArray:[NSRange] = []
        
        let frameSetter = CTFramesetterCreateWithAttributedString(attrString as CFAttributedString)
        
        let path = CGPath(rect: rect, transform: nil)
        
        var range = CFRangeMake(0, 0)
        
        var rangeOffset:NSInteger = 0
        
        repeat{
            
            let frame = CTFramesetterCreateFrame(frameSetter, CFRangeMake(rangeOffset, 0), path, nil)
            
            range = CTFrameGetVisibleStringRange(frame)
            
            rangeArray.append(NSMakeRange(rangeOffset, range.length))
            
            rangeOffset += range.length
            
        }while(range.location + range.length < attrString.length)
        
        return rangeArray
    }
    
    // MARK: -- 对内容进行整理排版
    
    /// 内容排版整理 - 去除多余回车空格，段头留空。
    @objc class func ContentTypesetting(content:String) ->String {

        // 替换单换行
        var content = content.replacingOccurrences(of: "\r", with: "")
        
        // 替换换行 以及 多个换行 为 换行加空格
        content = content.replacingCharacters("\\s*\\n+\\s*", "\n" + DZMParagraphHeaderSpace)
        
        // 返回
        return content
    }
    
    // MARK: -- 解码URL
    
    /// 解码URL
    @objc class func EncodeURL(_ url:URL) ->String {
        
        var content = ""
        
        // 检查URL是否有值
        if url.absoluteString.isEmpty {
            
            return content
        }
        
        // NSUTF8StringEncoding 解析
        content = EncodeURL(url, encoding: String.Encoding.utf8.rawValue)
        
        // 进制编码解析
        if content.isEmpty {
            
            content = EncodeURL(url, encoding: 0x80000632)
        }
        
        if content.isEmpty {
            
            content = EncodeURL(url, encoding: 0x80000631)
        }
        
        if content.isEmpty {
            
            content = ""
        }
        
        return content
    }
    
    /// 解析URL
    private class func EncodeURL(_ url:URL,encoding:UInt) ->String {
        
        do{
            return try NSString(contentsOf: url, encoding: encoding) as String
            
        }catch{}
        
        return ""
    }
    
    // MARK: -- 获得 FrameRef CTFrame
    
    /// 获得 CTFrame
    @objc class func GetReadFrameRef(attrString:NSMutableAttributedString, rect:CGRect) ->CTFrame {
        
        let framesetter = CTFramesetterCreateWithAttributedString(attrString)
        
        let path = CGPath(rect: rect, transform: nil)
        
        let frameRef = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
        
        return frameRef
    }
}
