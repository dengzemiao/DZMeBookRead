//
//  DZMPublic.swift
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/4/17.
//  Copyright © 2019年 DZM. All rights reserved.
//

import UIKit

/// 日志输出
func DZMLog<T>(_ message:T) {
    
    #if DEBUG
    
    print(message)

    #endif
}

// MARK: -- 屏幕属性

/// 屏幕Size
let ScreenSize:CGSize = UIScreen.main.bounds.size

/// 屏幕宽度
let ScreenWidth:CGFloat = UIScreen.main.bounds.size.width

/// 屏幕高度
let ScreenHeight:CGFloat = UIScreen.main.bounds.size.height

/// TabBar高度
let TabBarHeight:CGFloat = (IsX ? 83 : 49)

/// StatusBar高度 (IsX ? 44 : 20)
let StatusBarHeight:CGFloat = (IsX ? 44 : 20)

/// 导航栏高度
let NavgationBarHeight:CGFloat = (StatusBarHeight + 44)


// MARK: -- 判断系统设备

/// 是4
let Is4:Bool = (ScreenHeight == CGFloat(480) && ScreenWidth == CGFloat(320))

/// 是5
let Is5:Bool = (ScreenHeight == CGFloat(568) && ScreenWidth == CGFloat(320))

/// 是678
let Is678:Bool = (ScreenHeight == CGFloat(667) && ScreenWidth == CGFloat(375))

/// 是678P
let Is678P:Bool = (ScreenHeight == CGFloat(736) && ScreenWidth == CGFloat(414))

/// 是X系列
let IsX:Bool = (IsX_XS || IsXR_XSMAX)

/// 是X XS
let IsX_XS:Bool = (ScreenHeight == CGFloat(812) && ScreenWidth == CGFloat(375))

/// 是XR XSMAX
let IsXR_XSMAX:Bool = (ScreenHeight == CGFloat(896) && ScreenWidth == CGFloat(414))


// MARK: -- 屏幕适配

/// 以iPhone6为比例
func SA_SIZE(_ size:CGFloat) ->CGFloat {
    
    return size * (ScreenWidth / 375)
}

func SA(is45:CGFloat, _ other:CGFloat) ->CGFloat {
    
    return SA(is45, other, other, other, other)
}

func SA(isX:CGFloat, _ other:CGFloat) ->CGFloat {
    
    return SA(isX_XS: isX, isX, other)
}

func SA(is45:CGFloat, _ isX_XS:CGFloat, _ isXR_XSMAX:CGFloat,  _ other:CGFloat) ->CGFloat {
    
    return SA(is45, other, other, isX_XS, isXR_XSMAX)
}

func SA(isX_XS:CGFloat, _ isXR_XSMAX:CGFloat, _ other:CGFloat) ->CGFloat {
    
    return SA(other, other, other, isX_XS, isXR_XSMAX)
}

func SA(_ is45:CGFloat, _ is678:CGFloat, _ is678P:CGFloat, _ isX_XS:CGFloat, _ isXR_XSMAX:CGFloat) ->CGFloat {
    
    if (Is4 || Is5) { return is45
        
    }else if Is678 { return is678
        
    }else if Is678P { return is678P
        
    }else if IsX_XS { return isX_XS
        
    }else { return isXR_XSMAX }
}


// MARK: 颜色

/// RGB
func RGB(_ r:CGFloat, _ g:CGFloat, _ b:CGFloat) -> UIColor {
    
    return RGBA(r, g, b, 1.0)
}

/// RGBA
func RGBA(_ r:CGFloat, _ g:CGFloat, _ b:CGFloat, _ a:CGFloat) -> UIColor {
    
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}


// MARK: 时间

/// 获取指定时间字符串 (dateFormat: "YYYY-MM-dd-HH-mm-ss")
func TimerString(_ dateFormat:String, _ time:Date = Date()) ->String {
    
    let dateFormatter = DateFormatter()
    
    dateFormatter.dateFormat = dateFormat
    
    return dateFormatter.string(from: time)
}

/// 获得当前时间戳
func Timer1970(_ isMsec:Bool = false) ->TimeInterval {
    
    if isMsec { return Date().timeIntervalSince1970 * 1000
        
    }else{ return Date().timeIntervalSince1970 }
}


/// 计算显示时间
func TimerString(_ time:NSInteger) ->String {
    
    let currentTime = NSInteger(Timer1970())
    
    let spacing = currentTime - time
    
    if spacing < 60 {
        
        return "刚刚"
        
    }else if spacing < (60 * 60) {
        
        return "\(spacing / 60)分钟前"
        
    }else if spacing < (60 * 60 * 24) {
        
        return "\(spacing / 60 / 60)小时前"
        
    }else if spacing < (60 * 60 * 24 * 4) {
        
        return "\(spacing / 60 / 60 / 24)天前"
        
    }else{
        
        var timeString = TimerString("YYYY-MM-dd HH:mm", Date(timeIntervalSince1970: TimeInterval(time)))
        
        timeString = timeString.replacingOccurrences(of: TimerString("YYYY-"), with: "")
        
        return timeString
    }
}


// MARK: UI

/// 设置分割线
func SpaceLine(_ view:UIView, _ color:UIColor) ->UIView {
    
    let spaceLine = UIView()
    
    spaceLine.backgroundColor = color
    
    view.addSubview(spaceLine)
    
    return spaceLine
}

/// 对指定视图截屏
func ScreenCapture(_ view:UIView!, _ isSave:Bool = false) ->UIImage {
    
    UIGraphicsBeginImageContextWithOptions(view.frame.size, false, 0.0)
    
    view.layer.render(in: UIGraphicsGetCurrentContext()!)
    
    let image = UIGraphicsGetImageFromCurrentImageContext()
    
    UIGraphicsEndImageContext()
    
    if isSave { UIImageWriteToSavedPhotosAlbum(image!, nil, nil, nil) }
    
    return image!
}

/// 设置行间距
func TextLineSpacing(_ string:String, _ lineSpacing:CGFloat, _ attrs: [NSAttributedString.Key:Any]? = nil) ->NSMutableAttributedString {
    
    return TextLineSpacing(string, lineSpacing, .byTruncatingTail, attrs)
}

/// 设置行间距
func TextLineSpacing(_ string:String, _ lineSpacing:CGFloat, _ lineBreakMode:NSLineBreakMode, _ attrs: [NSAttributedString.Key:Any]? = nil) ->NSMutableAttributedString {
    
    var attrs = attrs ?? [:]
    
    let style = NSMutableParagraphStyle()
    
    style.lineSpacing = lineSpacing
    
    style.lineBreakMode = lineBreakMode
    
    attrs[.paragraphStyle] = style
    
    return NSMutableAttributedString(string: string, attributes: attrs)
}


// MARK: 延迟执行

/// 延迟执行
func DelayHandle(_ execute:@escaping ()->Void) { DelayHandle(0.01, execute) }

/// 延迟执行
func DelayHandle(_ delay:TimeInterval, _ execute:@escaping ()->Void) {
    
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + delay, execute: execute)
}


// MARK: Block

/// 动画完成
typealias DZMAnimationCompletion = ()->Void


// MARK: 其他属性

/// 没有章节了(可以指定为任意标识,默认是空则为没有更多章节)
let DZM_READ_NO_MORE_CHAPTER:NSNumber! = nil

/// 书籍首页-书名页
let DZM_READ_BOOK_HOME_PAGE:NSInteger = -1

/// 用于指定章节最后一页
let DZM_READ_LAST_PAGE:NSInteger = -1

/// 动画时间
let DZM_READ_AD_TIME:TimeInterval = 0.2

/// 段落头部双圆角空格
let DZM_READ_PH_SPACE:String = "　　"

/// 主文件夹名称
let DZM_READ_FOLDER_NAME:String = "DZMeBookRead"

/// Key - 配置
let DZM_READ_KEY_CONFIGURE:String = "DZM_READ_CONFIGURE"

/// Key - 阅读记录
let DZM_READ_KEY_RECORD:String = "DZM_READ_RECORD"

/// Key - 阅读对象
let DZM_READ_KEY_OBJECT:String = "DZM_READ_OBJECT"

/// Key - 日夜间模式 NO:日间 YES:夜间
let DZM_READ_KEY_MODE_DAY_NIGHT:String = "DZM_READ_MODE_DAY_NIGHT"

/// 沙河路径
let DZM_READ_DOCUMENT_DIRECTORY_PATH:String = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last! as String)

/// 需要处理的章节标题
func DZM_READ_CHAPTER_NAME(_ name:String) ->String { return "\n\(name)\n\n" }


// MARK: 范围

/// 阅读范围(阅读顶部状态栏 + 阅读View + 阅读底部状态栏)
var DZM_READ_RECT:CGRect! {
    
    // 适配 X 顶部
    let top = SA(isX: StatusBarHeight - DZM_SPACE_SA_15, 0)
    
    // 适配 X 底部
    let bottom = SA(isX: DZM_SPACE_SA_30, 0)
    
    return CGRect(x: DZM_SPACE_SA_15, y: top, width: ScreenWidth - DZM_SPACE_SA_30, height: ScreenHeight - top - bottom)
}

/// 阅读View范围
var DZM_READ_VIEW_RECT:CGRect! {
    
    let rect = DZM_READ_RECT!
    
    return CGRect(x: rect.minX, y: rect.minY + DZM_READ_STATUS_TOP_VIEW_HEIGHT, width: rect.width, height: rect.height - DZM_READ_STATUS_TOP_VIEW_HEIGHT - DZM_READ_STATUS_BOTTOM_VIEW_HEIGHT)
}

// MARK: 进度相关

/// 总进度字符串
func DZM_READ_TOTAL_PROGRESS_STRING(progress:Float) ->String {
    
    return String(format: "%.1f%%", (floor(progress * 1000) / 10))
}

/// 计算总进度
func DZM_READ_TOTAL_PROGRESS(readModel:DZMReadModel!,recordModel:DZMReadRecordModel!) ->Float {
    
    // 当前阅读进度
    var progress:Float = 0.0
    
    // 临时检查
    if readModel == nil || recordModel == nil { return progress }
    
    if recordModel.isLastChapter && recordModel.isLastPage { // 最后一章最后一页
        
        // 获得当前阅读进度
        progress = 1.0
        
    }else{
        
        // 当前章节在所有章节列表中的位置
        let chapterIndex:Float = recordModel.chapterModel.priority.floatValue
        
        // 章节总数量
        let chapterCount:Float = Float(readModel.chapterListModels.count)
        
        // 阅读记录首位置
        let locationFirst:Float = recordModel.locationFirst.floatValue
        
        // 阅读记录内容长度
        let fullContentLength:Float = Float(recordModel.chapterModel.fullContent.length)
        
        // 获得当前阅读进度
        progress = (chapterIndex / chapterCount + locationFirst / fullContentLength / chapterCount)
    }
    
    // 返回
    return progress
}
