//
//  HJReadParser.swift
//  HJProject
//
//  Created by 邓泽淼 on 16/8/25.
//  Copyright © 2016年 HanJue. All rights reserved.
//


// MARK: -- 四周间距
let HJReadViewTopSpace:CGFloat = 40
let HJReadViewBottomSpace:CGFloat = 40
let HJReadViewLeftSpace:CGFloat = 20
let HJReadViewRightSpace:CGFloat = 20
let HJReadTextViewSpaceWH:CGFloat = 8

// MARK: -- 通知
let HJReadChangeBGColorKey:String = "HJReadChangeBGColorKey"

import UIKit

class HJReadParser: NSObject {

    
    // MARK: -- 解析文章字符串
    
    /**
     解析本地URL 保存阅读文件 判断是否已经有加入阅读列表,有则不加入,没有则加入
     
     - parameter url: 本地小说文本URL
     
     - parameter complete: 解析成功返回true  包含了返回false
     
     - returns: 解析出来的模型
     */
    class func separateLocalURL(_ url:URL,complete:((_ isOK:Bool)->Void)?) {
        
        let bookID = HJReadParser.GetBookName(url)
        
        if !ReadKeyedIsExistArchiver(bookID, fileName: bookID) {
            
            DispatchQueue.global().async {
                
                // 阅读模型
                let readModel = HJReadModel.readModelWithLocalBook(url)
                
                HJReadModel.updateReadModel(readModel)
                
                DispatchQueue.main.async(execute: {()->() in
                    
                    if complete != nil {complete!(true)}
                })

            }
            
        }else{
            
             if complete != nil {complete!(false)}
        }
    }
    
    /**
     解析字符串
     
     - parameter bookID:    bookID
     - parameter content:   内容
     - parameter bookID:    小说ID 本地导入小说可传小说名称
     - parameter localBook: 是否为本地小说
     
     - returns: 章节模型数组
     */
    class func separateContent(_ bookID:String,content:String) ->[HJReadChapterListModel] {
        
        var readChapterListModels:[HJReadChapterListModel] = []
        
        let parten = "第[0-9一二三四五六七八九十百千]*[章回].*"
        
        var results:[NSTextCheckingResult] = []
        
        do{
            let regularExpression:NSRegularExpression = try NSRegularExpression(pattern: parten, options: NSRegularExpression.Options.caseInsensitive)
            
            results = regularExpression.matches(in: content, options: NSRegularExpression.MatchingOptions.reportProgress, range: NSRange(location: 0, length: content.length))
            
        }catch{
            
            return readChapterListModels
        }
        
        // 有搜索解决
        if !results.isEmpty {
       
            var lastRange = NSMakeRange(0, 0)
            
            // 便利
            for index in 0..<(results.count + 1) {
                
                let range = results[(index == results.count) ? (index - 1) : index].range
                
                let location = range.location
                
                // 章节阅读内容模型
                
                let readChapterModel = HJReadChapterModel()
                
                readChapterModel.chapterID = "\(index + 1)"
                
                readChapterModel.volumeID = "0"
                
                if index == 0 { // 开始
                    
                    readChapterModel.chapterName = "开始"
                    
                    readChapterModel.chapterContent = repairsContent(content.substringWithRange(NSMakeRange(0, location)))
                    
                    // 优先记录一遍
                    lastRange = range
                    
                    // 没有内容不需要添加到缓存
                    if (readChapterModel.chapterContent.length == 0) {continue}
                    
                }else if index == results.count { // 结尾
                    
                    readChapterModel.chapterName = content.substringWithRange(lastRange)
                    
                    readChapterModel.chapterContent = repairsContent(content.substringWithRange(NSMakeRange(lastRange.location, content.length - location)))
                    
                }else{ // 中间章节
                    
                    readChapterModel.chapterName = content.substringWithRange(lastRange)
                    
                    readChapterModel.chapterContent = repairsContent(content.substringWithRange(NSMakeRange(lastRange.location, location - lastRange.location)))
                }
                
                readChapterModel.updateFont()
                
                // 阅读章节list模型
                let readChapterListModel = GetReadChapterListModelTransformation(readChapterModel)
                
                readChapterListModels.append(readChapterListModel)
                
                // 归档阅读文件
                ReadKeyedArchiver(bookID, fileName: readChapterModel.chapterID, object: readChapterModel)
                
                lastRange = range
            }
            
        }else{
            
            let readChapterModel = HJReadChapterModel()
            
            readChapterModel.chapterID = "1"
            
            readChapterModel.volumeID = "0"
            
            readChapterModel.chapterName = "开始"
            
            readChapterModel.chapterContent = repairsContent(content)
            
            readChapterModel.updateFont()
            
            // 阅读章节list模型
            let readChapterListModel = GetReadChapterListModelTransformation(readChapterModel)
            
            readChapterListModels.append(readChapterListModel)
            
            // 归档阅读文件
            ReadKeyedArchiver(bookID, fileName: readChapterModel.chapterID, object: readChapterModel)
            
        }
        
        return readChapterListModels
    }
    
    /// 修整字符串
    class func repairsContent(_ content:String) ->String {
        
        var str = content as NSString;
        
        let spaceStr = "    "
        
        str = str.replacingOccurrences(of: "\r\n", with: "\n") as NSString
        
        str = str.replacingOccurrences(of: " ", with: "") as NSString
        
        str = str.replacingOccurrences(of: "\n", with: "\n" + spaceStr) as NSString
        
        return (spaceStr + (str as String))
    }
    
    /// 通过阅读模型 转换章节list模型
    class func GetReadChapterListModelTransformation(_ readChapterModel:HJReadChapterModel) ->HJReadChapterListModel {
        
        let readChapterListModel = HJReadChapterListModel()
        
        // 计算高度
        readChapterListModel.chapterHeight = (CGFloat(readChapterModel.pageCount.floatValue) * (HJReadParser.GetReadViewFrame().height + HJSpaceThree)) as NSNumber!
    
//        readChapterListModel.chapterHeight = HJReadParser.parserReadContentHeight(readChapterModel.chapterContent, configure: HJReadConfigureManger.shareManager, width: ScreenWidth - HJReadViewLeftSpace - HJReadViewRightSpace) as NSNumber!
        
        readChapterListModel.chapterID = readChapterModel.chapterID
        
        readChapterListModel.volumeID = readChapterModel.volumeID
        
        readChapterListModel.isDownload = 1
        
        readChapterListModel.chapterName = readChapterModel.chapterName
        
        return readChapterListModel
    }
    
    
    // MARK: -- 本地链接处理
    
    /// 小说类型
    class func GetBookFormat(_ url:URL) ->String {
        
        return url.path.pathExtension()
    }
    
    /// 小说名称
    class func GetBookName(_ url:URL) ->String {
        
        return url.path.lastPathComponent().stringByDeletingPathExtension()
    }
    
    /// 解析URL
    class func encodeURL(_ url:URL) ->String {
        
        var content = ""
        
        // 检查URL是否有值
        if url.absoluteString.isEmpty {
            
            return content
        }
        
        // NSUTF8StringEncoding 解析
        
        content = self.encodeURL(url, encoding: String.Encoding.utf8.rawValue)
        
        // 进制编码解析
        
        if content.isEmpty {
            
            content = self.encodeURL(url, encoding: 0x80000632)
        }
        
        if content.isEmpty {
            
            content = self.encodeURL(url, encoding: 0x80000631)
        }
        
        if content.isEmpty {
            
            content = ""
        }
        
        return content
    }
    
    /// 解析URL
    fileprivate class func encodeURL(_ url:URL,encoding:UInt) ->String {
        
        do{
            return try NSString(contentsOf: url, encoding: encoding) as String
            
        }catch{}
        
        return ""
    }

    
    /**
     根据字体类型获取字体
     */
    class func GetReadFont(_ fontType:HJReadFont,fontSize:CGFloat) ->UIFont {
        
        var font:UIFont = UIFont.fontOfSize(fontSize)
        
        switch fontType {
            
        case .system:
            break
            
        case .one: // 黑体
            font = UIFont.fontOfNameSize("EuphemiaUCAS-Italic", size: fontSize)
            break
            
        case .two: // 楷体
            font = UIFont.fontOfNameSize("AmericanTypewriter-Light", size: fontSize)
            break
            
        case .three: // 宋体
            font = UIFont.fontOfNameSize("Papyrus", size: fontSize)
            break
            
        }
        
        return font
    }
    
    /**
     获取阅读view的Frame
     
     - returns: frame
     */
    class func GetReadViewFrame() ->CGRect {
        
        return CGRect(x: HJReadViewLeftSpace, y: HJReadViewTopSpace, width: ScreenWidth - HJReadViewLeftSpace - HJReadViewRightSpace, height: ScreenHeight - HJReadViewTopSpace - HJReadViewBottomSpace)
    }
    
    /**
     阅读试图frameRef
     
     - parameter content:   展示内容
     - parameter configure: 配置
     - parameter bounds:    范围
     
     - returns: CTFrameRef
     */
    class func parserRead(_ content:String,configure:HJReadConfigureManger,bounds:CGRect) ->CTFrame {
        
        let attributedString = NSMutableAttributedString(string: content,attributes: parserAttribute(configure))
        
        let framesetter = CTFramesetterCreateWithAttributedString(attributedString)
        
        let path = CGPath(rect: bounds, transform: nil)
        
        let frameRef = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
        
        return frameRef
    }
    
//    /**
//     计算字符串的高度
//     
//     - parameter content:   字符串内容
//     - parameter configure: 配置
//     - parameter width:     最大内容显示宽度
//     
//     - returns: 计算获得的内容高度
//     */
//    class func parserReadContentHeight(_ content:String,configure:HJReadConfigureManger,width:CGFloat) ->CGFloat {
//     
//        let attributedString = NSMutableAttributedString(string: content,attributes: parserAttribute(configure))
//        
//        let framesetter = CTFramesetterCreateWithAttributedString(attributedString)
//        
//        // 高要设置足够大
//        
//        let height:CGFloat = 100000
//        
//        let drawingRect = CGRect(x: 0, y: 0, width: width, height: height)
//        
//        let path = CGMutablePath()
//        
//        CGPathAddRect(path, nil, drawingRect)
//        
//        let frameRef = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
//        
//        let linesArray = CTFrameGetLines(frameRef) as NSArray
//        
//        var originsArray = [CGPoint](repeating: CGPoint.zero, count: linesArray.count)
//        
//        CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), &originsArray)
//        
//        // 最后一行line的原点y坐标
//        let line_y = originsArray[linesArray.count - 1].y
//        
//        var ascent:CGFloat = 0
//        var descent:CGFloat = 0
//        var leading:CGFloat = 0
//        
//        let line = linesArray.object(at: linesArray.count - 1) as! CTLine
//        
//        CTLineGetTypographicBounds(line, &ascent, &descent, &leading)
//        
//        // +1为了纠正descent转换成int小数点后舍去的值
//        let total_height = height - line_y + descent + 1
//        
//        return total_height
//    }
    
    /**
     获取字符串属性
     
     - parameter configure: 阅读配置对象
     
     - returns: 属性字典
     */
    class func parserAttribute(_ configure:HJReadConfigureManger) ->[String:AnyObject] {

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = configure.readSpaceLineH
        paragraphStyle.alignment = NSTextAlignment.justified
        let font = HJReadParser.GetReadFont(configure.readFont, fontSize: CGFloat(configure.readFontSize.floatValue))
        let dict = [NSForegroundColorAttributeName:configure.textColor,NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle]
        
        return dict as [String : AnyObject]
    }
}
