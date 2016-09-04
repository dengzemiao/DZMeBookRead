//
//  HJReadBookModel.swift
//  HJProject
//
//  Created by 邓泽淼 on 16/8/24.
//  Copyright © 2016年 HanJue. All rights reserved.
//

import UIKit

class HJReadBookModel: NSObject {
    
    var selectStatus:Bool = false               // 书架-判断状态的 其他无用
    
    var bookAuthor: String = ""                 // 小说作者
    var bookCover: String = ""                  // 小说封面
    var bookID: String = ""                     // 小说ID
    var volumeID: String = "0"                  // 小说阅读记录的卷ID
    var chapterID: String = "1"                 // 小说阅读记录的章节ID
    var bookName: String = ""                   // 小说名称
    var readProgress: String = "0"              // 小说阅读进度
    var bookFormat: String = ""                 // 小说格式
    var isLocalBook: Bool = false               // 是否为本地小说章节 外部导入的小说
    var isUpdate: Bool = false                  // 小说是否有更新
    var isAddBookshelf:Bool = false             // 是否添加书架了
    var readTime: String = ""                   // 最新阅读时间记录
}
































