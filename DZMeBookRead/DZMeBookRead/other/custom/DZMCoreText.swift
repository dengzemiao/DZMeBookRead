//
//  DZMCoreText.swift
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/4/17.
//  Copyright © 2019年 DZM. All rights reserved.
//

import UIKit

class DZMCoreText: NSObject {
    
    /// 获得 CTFrame
    ///
    /// - Parameters:
    ///   - attrString: 内容
    ///   - rect: 显示范围
    /// - Returns: CTFrame
    @objc class func GetFrameRef(attrString:NSAttributedString, rect:CGRect) ->CTFrame {
        
        let framesetter = CTFramesetterCreateWithAttributedString(attrString)
        
        let path = CGPath(rect: rect, transform: nil)
        
        let frameRef = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
        
        return frameRef
    }
    
    /// 获得内容分页列表
    ///
    /// - Parameters:
    ///   - attrString: 内容
    ///   - rect: 显示范围
    /// - Returns: 内容分页列表
    @objc class func GetPageingRanges(attrString:NSAttributedString, rect:CGRect) ->[NSRange] {
        
        var rangeArray:[NSRange] = []
        
        let framesetter = CTFramesetterCreateWithAttributedString(attrString as CFAttributedString)
        
        let path = CGPath(rect: rect, transform: nil)
        
        var range = CFRangeMake(0, 0)
        
        var rangeOffset:NSInteger = 0
        
        repeat{
            
            let frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(rangeOffset, 0), path, nil)
            
            range = CTFrameGetVisibleStringRange(frame)
            
            rangeArray.append(NSMakeRange(rangeOffset, range.length))
            
            rangeOffset += range.length
            
        }while(range.location + range.length < attrString.length)
        
        return rangeArray
    }

    
    /// 获得触摸位置文字的Location
    ///
    /// - Parameters:
    ///   - point: 触摸位置
    ///   - frameRef: CTFrame
    /// - Returns: 触摸位置的Index
    @objc class func GetTouchLocation(point:CGPoint, frameRef:CTFrame?) ->CFIndex {
        
        var location:CFIndex = -1
        
        let line = GetTouchLine(point: point, frameRef: frameRef)
        
        if line != nil {
            
            location = CTLineGetStringIndexForPosition(line!, point)
        }
        
        return location
    }
    
    
    /// 获得触摸位置那一行文字的Range
    ///
    /// - Parameters:
    ///   - point: 触摸位置
    ///   - frameRef: CTFrame
    /// - Returns: CTLine
    @objc class func GetTouchLineRange(point:CGPoint, frameRef:CTFrame?) ->NSRange {
        
        var range:NSRange = NSMakeRange(NSNotFound, 0)
        
        let line = GetTouchLine(point: point, frameRef: frameRef)
        
        if line != nil {
            
            let lineRange = CTLineGetStringRange(line!)
            
            range = NSMakeRange(lineRange.location == kCFNotFound ? NSNotFound : lineRange.location, lineRange.length)
        }
        
        return range
    }
    
    /// 获得触摸位置在哪一行
    ///
    /// - Parameters:
    ///   - point: 触摸位置
    ///   - frameRef: CTFrame
    /// - Returns: CTLine
    @objc class func GetTouchLine(point:CGPoint, frameRef:CTFrame?) ->CTLine? {
        
        var line:CTLine? = nil
        
        if frameRef == nil { return line }
        
        let frameRef:CTFrame = frameRef!
        
        let path:CGPath = CTFrameGetPath(frameRef)
        
        let bounds:CGRect = path.boundingBox
        
        let lines:[CTLine] = CTFrameGetLines(frameRef) as! [CTLine]
        
        if lines.isEmpty { return line }
        
        let lineCount = lines.count
        
        let origins = malloc(lineCount * MemoryLayout<CGPoint>.size).assumingMemoryBound(to: CGPoint.self)
        
        CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), origins)
        
        for i in 0..<lineCount {
            
            let origin:CGPoint = origins[i]
            
            let tempLine:CTLine = lines[i]
            
            var lineAscent:CGFloat = 0
            
            var lineDescent:CGFloat = 0
            
            var lineLeading:CGFloat = 0
            
            CTLineGetTypographicBounds(tempLine, &lineAscent, &lineDescent, &lineLeading)
            
            let lineWidth:CGFloat = bounds.width
            
            let lineheight:CGFloat = lineAscent + lineDescent + lineLeading
            
            var lineFrame = CGRect(x: origin.x, y: bounds.height - origin.y - lineAscent, width: lineWidth, height: lineheight)
            
            lineFrame = lineFrame.insetBy(dx: -DZM_SPACE_5, dy: -DZM_SPACE_5)
            
            if lineFrame.contains(point) {
                
                line = tempLine
                
                break
            }
        }
        
        free(origins)
        
        return line
    }
    
    /// 通过 range 返回字符串所覆盖的位置 [CGRect]
    ///
    /// - Parameter range: NSRange
    /// - Parameter frameRef: CTFrame
    /// - Parameter content: 内容字符串(有值则可以去除选中每一行区域内的 开头空格 - 尾部换行符 - 所占用的区域,不传默认返回每一行实际占用区域)
    /// - Returns: 覆盖位置
    @objc class func GetRangeRects(range:NSRange, frameRef:CTFrame?, content:String? = nil) -> [CGRect] {
        
        var rects:[CGRect] = []
        
        if frameRef == nil { return rects }
        
        if range.length == 0 || range.location == NSNotFound { return rects }
        
        let frameRef = frameRef!
        
        let lines:[CTLine] = CTFrameGetLines(frameRef) as! [CTLine]
        
        if lines.isEmpty { return rects }
        
        let lineCount:Int = lines.count
        
        let origins = malloc(lineCount * MemoryLayout<CGPoint>.size).assumingMemoryBound(to: CGPoint.self)
        
        CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), origins)
        
        for i in 0..<lineCount {
            
            let line:CTLine = lines[i]
            
            let lineCFRange = CTLineGetStringRange(line)
            
            let lineRange = NSMakeRange(lineCFRange.location == kCFNotFound ? NSNotFound : lineCFRange.location, lineCFRange.length)
            
            var contentRange:NSRange = NSMakeRange(NSNotFound, 0)
            
            if (lineRange.location + lineRange.length) > range.location && lineRange.location < (range.location + range.length) {
                
                contentRange.location = max(lineRange.location, range.location)
                
                let end = min(lineRange.location + lineRange.length, range.location + range.length)
                
                contentRange.length = end - contentRange.location
            }
            
            if contentRange.length > 0 {
                
                // 去掉 -> 开头空格 - 尾部换行符 - 所占用的区域
                
                if content != nil && !content!.isEmpty {
                    
                    let tempContent:String = content!.substring(contentRange)
                    
                    let spaceRanges:[NSTextCheckingResult] = tempContent.matches("\\s\\s")
                    
                    if !spaceRanges.isEmpty {
                        
                        let spaceRange = spaceRanges.first!.range
                        
                        contentRange = NSMakeRange(contentRange.location + spaceRange.length, contentRange.length - spaceRange.length)
                    }
                    
                    let enterRanges:[NSTextCheckingResult] = tempContent.matches("\\n")
                    
                    if !enterRanges.isEmpty {
                        
                        let enterRange = enterRanges.first!.range
                        
                        contentRange = NSMakeRange(contentRange.location, contentRange.length - enterRange.length)
                    }
                }
                
                // 正常使用(如果不需要排除段头空格跟段尾换行符可将上面代码删除)
                
                let xStart:CGFloat = CTLineGetOffsetForStringIndex(line, contentRange.location, nil)
                
                let xEnd:CGFloat = CTLineGetOffsetForStringIndex(line, contentRange.location + contentRange.length, nil)
                
                let origin:CGPoint = origins[i]
                
                var lineAscent:CGFloat = 0
                
                var lineDescent:CGFloat = 0
                
                var lineLeading:CGFloat = 0
                
                CTLineGetTypographicBounds(line, &lineAscent, &lineDescent, &lineLeading)
                
                let contentRect:CGRect = CGRect(x: origin.x + xStart, y: origin.y - lineDescent, width: fabs(xEnd - xStart), height: lineAscent + lineDescent + lineLeading)
                
                rects.append(contentRect)
            }
        }
        
        free(origins)
        
        return rects
    }
    
    /// 通过 range 获得合适的 MenuRect
    ///
    /// - Parameter rects: [CGRect]
    /// - Parameter frameRef: CTFrame
    /// - Parameter viewFrame: 目标ViewFrame
    /// - Parameter content: 内容字符串
    /// - Returns: MenuRect
    @objc class func GetMenuRect(range:NSRange, frameRef:CTFrame?, viewFrame:CGRect, content:String? = nil) ->CGRect {
        
        let rects = GetRangeRects(range: range, frameRef: frameRef, content: content)
        
        return GetMenuRect(rects: rects, viewFrame: viewFrame)
    }
    
    /// 通过 [CGRect] 获得合适的 MenuRect
    ///
    /// - Parameter rects: [CGRect]
    /// - Parameter viewFrame: 目标ViewFrame
    /// - Returns: MenuRect
    @objc class func GetMenuRect(rects:[CGRect], viewFrame:CGRect) ->CGRect {
        
        var menuRect:CGRect = CGRect.zero
        
        if rects.isEmpty { return menuRect }
        
        if rects.count == 1 {
            
            menuRect = rects.first!
            
        }else{
            
            menuRect = rects.first!
            
            let count = rects.count
            
            for i in 1..<count  {
                
                let rect = rects[i]
                
                let minX = min(menuRect.origin.x, rect.origin.x)
                
                let maxX = max(menuRect.origin.x + menuRect.size.width, rect.origin.x + rect.size.width)
                
                let minY = min(menuRect.origin.y, rect.origin.y)
                
                let maxY = max(menuRect.origin.y + menuRect.size.height, rect.origin.y + rect.size.height)
                
                menuRect.origin.x = minX
                
                menuRect.origin.y = minY
                
                menuRect.size.width = maxX - minX
                
                menuRect.size.height = maxY - minY
            }
        }
        
        menuRect.origin.y = viewFrame.height - menuRect.origin.y - menuRect.size.height
        
        return menuRect
    }
    
    
    /// 获取指定内容高度
    ///
    /// - Parameters:
    ///   - attrString: 内容
    ///   - maxW: 最大宽度
    /// - Returns: 当前高度
    class func GetAttrStringHeight(attrString:NSAttributedString, maxW:CGFloat) ->CGFloat {
        
        var height:CGFloat = 0
        
        if attrString.length > 0 {
            
            // 注意设置的高度必须大于文本高度
            let maxH:CGFloat = 1000
            
            let framesetter = CTFramesetterCreateWithAttributedString(attrString)
            
            let drawingRect = CGRect(x: 0, y: 0, width: maxW, height: maxH)
            
            let path = CGPath(rect: drawingRect, transform: nil)
            
            let frameRef = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, nil)
            
            let lines = CTFrameGetLines(frameRef) as! [CTLine]
            
            var origins:[CGPoint] = Array(repeating: CGPoint.zero, count: lines.count)
            
            CTFrameGetLineOrigins(frameRef, CFRangeMake(0, 0), &origins)
            
            let lineY = origins.last!.y
            
            var lineAscent:CGFloat = 0
            
            var lineDescent:CGFloat = 0
            
            var lineLeading:CGFloat = 0
            
            CTLineGetTypographicBounds(lines.last!, &lineAscent, &lineDescent, &lineLeading)
            
            height = maxH - lineY + CGFloat(ceilf(Float(lineDescent)))
        }

        return height
    }
    
    /// 获取行高
    ///
    /// - Parameter line: CTLine
    /// - Returns: 行高
    @objc class func GetLineHeight(frameRef:CTFrame?) ->CGFloat {
        
        if frameRef == nil { return 0 }
        
        let frameRef:CTFrame = frameRef!
        
        let lines:[CTLine] = CTFrameGetLines(frameRef) as! [CTLine]
        
        if lines.isEmpty { return 0 }
        
        return GetLineHeight(line: lines.first)
    }
    
    /// 获取行高
    ///
    /// - Parameter line: CTLine
    /// - Returns: 行高
    @objc class func GetLineHeight(line:CTLine?) ->CGFloat {
        
        if line == nil { return 0 }
        
        var lineAscent:CGFloat = 0
        
        var lineDescent:CGFloat = 0
        
        var lineLeading:CGFloat = 0
        
        CTLineGetTypographicBounds(line!, &lineAscent, &lineDescent, &lineLeading)
        
        return lineAscent + lineDescent + lineLeading
    }
}
