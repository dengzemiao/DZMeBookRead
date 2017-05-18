//
//  DZMGlobalMethod.swift
//  DZMeBookRead
//
//  Created by 邓泽淼 on 2017/5/11.
//  Copyright © 2017年 DZM. All rights reserved.
//

import UIKit

// MARK: -- 颜色
/// RGB
func RGB(_ r:CGFloat,g:CGFloat,b:CGFloat) -> UIColor {
    return RGBA(r, g: g, b: b, a: 1.0)
}

/// RGBA
func RGBA(_ r:CGFloat,g:CGFloat,b:CGFloat,a:CGFloat) -> UIColor {
    return UIColor(red: r/255.0, green: g/255.0, blue: b/255.0, alpha: a)
}


// MARK: -- 尺寸计算 以iPhone6为比例
func DZMSizeW(_ size:CGFloat) ->CGFloat {
    return size * (ScreenWidth / 375)
}

func DZMSizeH(_ size:CGFloat) ->CGFloat{
    return size * (ScreenHeight / 667)
}

// MARK: -- 创建分割线

/**
 给一个视图 创建添加 一条分割线 高度 : HJSpaceLineHeight
 
 - parameter view:  需要添加的视图
 - parameter color: 颜色 可选
 
 - returns: 分割线view
 */
func SpaceLineSetup(view:UIView, color:UIColor? = nil) ->UIView {
    
    let spaceLine = UIView()
    
    spaceLine.backgroundColor = color != nil ? color : UIColor.lightGray
    
    view.addSubview(spaceLine)
    
    return spaceLine
}

// MARK: -- 获取时间

/// 获取当前时间传入 时间格式 "YYYY-MM-dd-HH-mm-ss"
func GetCurrentTimerString(dateFormat:String) ->String {
    
    let dateformatter = DateFormatter()
    
    dateformatter.dateFormat = dateFormat
    
    return dateformatter.string(from: Date())
}

/// 将 时间 根据 类型 转成 时间字符串
func GetTimerString(dateFormat:String, date:Date) ->String {
    
    let dateformatter = DateFormatter()
    
    dateformatter.dateFormat = dateFormat
    
    return dateformatter.string(from: date)
}

/// 获取当前的 TimeIntervalSince1970 时间字符串
func GetCurrentTimeIntervalSince1970String() -> String {
    
    return String(format: "%.0f",Date().timeIntervalSince1970)
}


// MARK: -- 阅读ViewFrame

/// 阅读TableView的位置
func GetReadTableViewFrame() ->CGRect {
    
    // Y = 屏幕高 - 状态View高 - 间距
    let y = ScreenHeight - DZMSpace_2 - DZMSpace_6
    
    return CGRect(x: DZMSpace_1, y: y, width: ScreenWidth - 2 * DZMSpace_1, height: ScreenHeight - 2 * y)
}

/* 阅读View的位置
 
 需要做横竖屏的可以在这里修改阅读View的大小
 
 GetReadViewFrame 会使用与 阅读View的Frame 以及计算分页的范围
 
 */
func GetReadViewFrame() ->CGRect {
   
    return CGRect(x: 0, y: 0, width: GetReadTableViewFrame().width, height: GetReadTableViewFrame().height)
}

// MARK: -- 文件操作
// MARK: -- 创建文件夹

/**
 创建文件夹 如果存在则不创建
 
 - parameter filePath: 文件路径
 
 return 是否有文件夹存在
 */
func CreatFilePath(_ filePath:String) ->Bool {
    
    let fileManager = FileManager.default
    
    // 文件夹是否存在
    if fileManager.fileExists(atPath: filePath) {
        
        return true
    }
    
    do{
        try fileManager.createDirectory(atPath: filePath, withIntermediateDirectories: true, attributes: nil)
        
        return true
        
    }catch{}
    
    return false
}


// MARK: -- 文件链接处理
/// 文件类型
func GetFileExtension(_ url:URL) ->String {
    
    return url.path.pathExtension()
}

/// 文件名称
func GetFileName(_ url:URL) ->String {
    
    return url.path.lastPathComponent().stringByDeletingPathExtension()
}


// MARK: -- 阅读页面获取文件方法

/// 主文件夹名称
private let ReadFolderName:String = "DZMeBookRead"

/// 归档阅读文件文件
func ReadKeyedArchiver(folderName:String,fileName:String,object:AnyObject) {
    
    var path = (NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last!) + "/\(ReadFolderName)/\(folderName)"
    
    if (CreatFilePath(path)) { // 创建文件夹成功或者文件夹存在
        
        path = path + "/\(fileName)"
        
        NSKeyedArchiver.archiveRootObject(object, toFile: path)
    }
}

/// 解档阅读文件文件
func ReadKeyedUnarchiver(folderName:String,fileName:String) ->AnyObject? {
    
    let path = ((NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last! as String) + "/\(ReadFolderName)/\(folderName)") + "/\(fileName)"
    
    return NSKeyedUnarchiver.unarchiveObject(withFile: path) as AnyObject?
}

/// 删除阅读归档文件
func ReadKeyedRemoveArchiver(folderName:String,fileName:String) {
    
    let path = ((NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last! as String) + "/\(ReadFolderName)/\(folderName)") + "/\(fileName)"
    
    do{
        try FileManager.default.removeItem(atPath: path)
    }catch{}
}

/// 是否存在了改归档文件
func ReadKeyedIsExistArchiver(folderName:String,fileName:String) ->Bool {
    
    let path = ((NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true).last! as String) + "/\(ReadFolderName)/\(folderName)") + "/\(fileName)"
    
    return FileManager.default.fileExists(atPath: path)
}
