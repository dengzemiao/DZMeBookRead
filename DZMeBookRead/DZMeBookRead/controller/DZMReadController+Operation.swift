//
//  DZMReadController+Operation.swift
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/4/17.
//  Copyright © 2019年 DZM. All rights reserved.
//

import UIKit

extension DZMReadController {
    
    /// 获取指定阅读记录阅读页
    func GetReadViewController(recordModel:DZMReadRecordModel!) ->DZMReadViewController? {
        
        if recordModel != nil {
            
            if DZMReadConfigure.shared().openLongPress { // 需要返回支持长按的控制器
                
                let controller = DZMReadLongPressViewController()
                
                controller.recordModel = recordModel
                
                controller.readModel = readModel
                
                return controller
                
            }else{ // 无长按功能
                
                let controller = DZMReadViewController()
                
                controller.recordModel = recordModel
                
                controller.readModel = readModel
                
                return controller
            }
        }
        
        return nil
    }
    
    /// 获取当前阅读记录阅读页
    func GetCurrentReadViewController(isUpdateFont:Bool = false) ->DZMReadViewController? {
        
        if DZMReadConfigure.shared().effectType != .scroll { // 滚动模式不需要创建
            
            if isUpdateFont { readModel.recordModel.updateFont() }
            
            return GetReadViewController(recordModel: readModel.recordModel.copyModel())
        }
        
        return nil
    }
    
    /// 获取上一页控制器
    func GetAboveReadViewController() ->UIViewController? {
        
        let recordModel = GetAboveReadRecordModel(recordModel: readModel.recordModel)
        
        if recordModel == nil { return nil }
        
        return GetReadViewController(recordModel: recordModel)
    }
    
    /// 获取仿真模式背面(只用于仿真模式背面显示)
    func GetReadViewBGController(recordModel:DZMReadRecordModel!, targetView:UIView? = nil) -> DZMReadViewBGController {
        
        let vc = DZMReadViewBGController()
        
        vc.recordModel = recordModel
        
        let targetView = targetView ?? GetReadViewController(recordModel: recordModel)?.view
        
        vc.targetView = targetView
        
        return vc
    }
    
    
    /// 获取下一页控制器
    func GetBelowReadViewController() ->UIViewController? {
        
        let recordModel = GetBelowReadRecordModel(recordModel: readModel.recordModel)
        
        if recordModel == nil { return nil }
        
        return GetReadViewController(recordModel: recordModel)
    }
    
    /// 跳转指定章节(指定页面)
    func GoToChapter(chapterID:NSNumber!, toPage:NSInteger = 0) {
        
        GoToChapter(chapterID: chapterID, number: toPage, isLocation: false)
    }
    
    /// 跳转指定章节(指定坐标)
    func GoToChapter(chapterID:NSNumber!, location:NSInteger) {
        
        GoToChapter(chapterID: chapterID, number: location, isLocation: true)
    }
    
    /// 跳转指定章节 number:页码或者坐标 isLocation:是页码(false)还是坐标(true)
    private func GoToChapter(chapterID:NSNumber!, number:NSInteger, isLocation:Bool) {
        
        // 复制阅读记录
        let recordModel = readModel.recordModel.copyModel()
        
        // 书籍ID
        let bookID = recordModel.bookID
       
        // 检查是否存在章节内容
        let isExist = DZMReadChapterModel.isExist(bookID: bookID, chapterID: chapterID)
        
        // 存在 || 不存在(但是为本地阅读)
        if isExist || readModel.bookSourceType == .local {
            
            if !isExist {
                
                // 获取章节数据
                _ = DZMReadTextFastParser.parser(readModel: readModel, chapterID: chapterID)
            }
            
            if isLocation {
                
                // 坐标定位
                recordModel.modify(chapterID: chapterID, location: number, isSave: false)
                
            }else{
                
                // 分页定位
                recordModel.modify(chapterID: chapterID, toPage: number, isSave: false)
            }
            
            // 阅读阅读记录
            updateReadRecord(recordModel: recordModel)
            
            // 展示阅读
            creatPageController(displayController: GetReadViewController(recordModel: recordModel))
            
        }else{ // 加载网络章节数据
                
                // ----- 搜索网络小说 -----
                
//            MBProgressHUD.showLoading(view)
//
//            // 加载章节数据
//            NJHTTPTool.request_novel_read(bookID, chapterID) { [weak self] (type, response, error) in
//
//                MBProgressHUD.hide(self?.view)
//
//                if type == .success {
//
//                    // 获取章节数据
//                    let data = HTTP_RESPONSE_DATA_DICT(response)
//
//                    // 解析章节数据
//                    let chapterModel = DZMReadChapterModel(data)
//
//                    // 章节类容需要进行排版一篇
//                    chapterModel.content = DZMReadParser.contentTypesetting(content: chapterModel.content)
//
//                    // 保存
//                    chapterModel.save()
//
//                    // 修改阅读记录
//                    recordModel.modify(chapterID: chapterModel.chapterID, toPage: toPage, isSave: false)
//
//                    // 更新阅读记录
//                    self?.updateReadRecord(recordModel: recordModel)
//
//                    // 展示阅读记录
//                    self?.creatPageController(displayController: GetReadViewController(recordModel: recordModel))
//                }
//            }
        }
        
        // ----- 搜索网络小说 -----
        
//        // 预加载下一章(可选)
//        if readModel.bookSourceType == .network { // 网络小说
//
//            if !recordModel.isLastChapter && !DZMReadChapterModel.isExist(bookID: bookID, chapterID: chapterID) {
//
//                // 加载章节数据
//                NJHTTPTool.request_novel_read(bookID, chapterID) { [weak self] (type, response, error) in
//
//                    if type == .success {
//
//                        // 获取章节数据
//                        let data = HTTP_RESPONSE_DATA_DICT(response)
//
//                        // 解析章节数据
//                        let chapterModel = DZMReadChapterModel(data)
//
//                        // 章节类容需要进行排版一篇
//                        chapterModel.content = DZMReadParser.contentTypesetting(content: chapterModel.content)
//
//                        // 保存
//                        chapterModel.save()
//                    }
//                }
//            }
//        }
    }
    
    /// 获取当前记录上一页阅读记录
    func GetAboveReadRecordModel(recordModel:DZMReadRecordModel!) ->DZMReadRecordModel? {
        
        // 阅读记录为空
        if recordModel.chapterModel == nil { return nil }
        
        // 复制
        let recordModel = recordModel.copyModel()
        
        // 书籍ID
        let bookID = recordModel.bookID
        
        // 章节ID
        let chapterID = recordModel.chapterModel.previousChapterID
        
        // 第一章 第一页
        if recordModel.isFirstChapter && recordModel.isFirstPage {
            
            DZMLog("已经是第一页了")
            
            return nil
        }
        
        // 第一页
        if recordModel.isFirstPage {
            
            // 检查是否存在章节内容
            let isExist = DZMReadChapterModel.isExist(bookID: bookID, chapterID: chapterID)
            
            // 存在 || 不存在(但是为本地阅读)
            if isExist || readModel.bookSourceType == .local {
                
                // 获取章节数据
                if !isExist { _ = DZMReadTextFastParser.parser(readModel: readModel, chapterID: chapterID) }
                
                // 修改阅读记录
                recordModel.modify(chapterID: chapterID, toPage: DZM_READ_LAST_PAGE, isSave: false)
                
            }else{ // 加载网络章节数据
                    
                // ----- 搜索网络小说 -----
                    
//                MBProgressHUD.showLoading(view)
//
//                // 加载章节数据
//                NJHTTPTool.request_novel_read(bookID, chapterID) { [weak self] (type, response, error) in
//
//                    MBProgressHUD.hide(self?.view)
//
//                    if type == .success {
//
//                        // 获取章节数据
//                        let data = HTTP_RESPONSE_DATA_DICT(response)
//
//                        // 解析章节数据
//                        let chapterModel = DZMReadChapterModel(data)
//
//                        // 章节类容需要进行排版一篇
//                        chapterModel.content = DZMReadParser.contentTypesetting(content: chapterModel.content)
//
//                        // 保存
//                        chapterModel.save()
//
//                        // 修改阅读记录
//                        recordModel.modify(chapterID: chapterModel.chapterID, toPage: DZM_READ_LAST_PAGE, isSave: false)
//
//                        // 更新阅读记录
//                        self?.updateReadRecord(recordModel: recordModel)
//
//                        // 展示阅读记录
//                        self?.setViewController(displayController: GetReadViewController(recordModel: recordModel), isAbove: true, animated: true)
//                    }
//                }

                return nil
            }
            
        }else{ recordModel.previousPage() }
        
        // ----- 搜索网络小说 -----
        
        // 预加载上一章(可选)(一般上一章就要他自己拉一下加载吧,看需求而定,上下滚动模式的就会提前加载好上下章节)
        
        return recordModel
    }
    
    /// 获取当前记录下一页阅读记录
    func GetBelowReadRecordModel(recordModel:DZMReadRecordModel!) ->DZMReadRecordModel?  {
        
        // 阅读记录为空
        if recordModel.chapterModel == nil { return nil }
        
        // 复制
        let recordModel = recordModel.copyModel()
        
        // 书籍ID
        let bookID = recordModel.bookID
        
        // 章节ID
        let chapterID = recordModel.chapterModel.nextChapterID
        
        // 最后一章 最后一页
        if recordModel.isLastChapter && recordModel.isLastPage {
            
            DZMLog("已经是最后一页了")
            
            return nil
        }
        
        // 最后一页
        if recordModel.isLastPage {
            
            // 检查是否存在章节内容
            let isExist = DZMReadChapterModel.isExist(bookID: bookID, chapterID: chapterID)
            
            // 存在 || 不存在(但是为本地阅读)
            if isExist || readModel.bookSourceType == .local {
                
                // 获取章节数据
                if !isExist { _ = DZMReadTextFastParser.parser(readModel: readModel, chapterID: chapterID) }
                
                // 修改阅读记录
                recordModel.modify(chapterID: chapterID, toPage: 0, isSave: false)
                
            }else{ // 加载网络章节数据
                    
                // ----- 搜索网络小说 -----
                    
//                MBProgressHUD.showLoading(view)
//
//                // 加载章节数据
//                NJHTTPTool.request_novel_read(bookID, chapterID) { [weak self] (type, response, error) in
//
//                    MBProgressHUD.hide(self?.view)
//
//                    if type == .success {
//
//                        // 获取章节数据
//                        let data = HTTP_RESPONSE_DATA_DICT(response)
//
//                        // 解析章节数据
//                        let chapterModel = DZMReadChapterModel(data)
//
//                        // 章节类容需要进行排版一篇
//                        chapterModel.content = DZMReadParser.contentTypesetting(content: chapterModel.content)
//
//                        // 保存
//                        chapterModel.save()
//
//                        // 修改阅读记录
//                        recordModel.modify(chapterID: chapterModel.chapterID, toPage: 0, isSave: false)
//
//                        // 更新阅读记录
//                        self?.updateReadRecord(recordModel: recordModel)
//
//                        // 展示阅读记录
//                        self?.setViewController(displayController: GetReadViewController(recordModel: recordModel), isAbove: false, animated: true)
//                    }
//                }
//
//                return nil
            }
            
        }else{ recordModel.nextPage() }
        
        // ----- 搜索网络小说 -----
        
//        // 预加载下一章(可选)
//        if readModel.bookSourceType == .network { // 网络小说
//
//            if !recordModel.isLastChapter && !DZMReadChapterModel.isExist(bookID: bookID, chapterID: chapterID) {
//
//                // 加载章节数据
//                NJHTTPTool.request_novel_read(bookID, chapterID) { [weak self] (type, response, error) in
//
//                    if type == .success {
//
//                        // 获取章节数据
//                        let data = HTTP_RESPONSE_DATA_DICT(response)
//
//                        // 解析章节数据
//                        let chapterModel = DZMReadChapterModel(data)
//
//                        // 章节类容需要进行排版一篇
//                        chapterModel.content = DZMReadParser.contentTypesetting(content: chapterModel.content)
//
//                        // 保存
//                        chapterModel.save()
//                    }
//                }
//            }
//        }
        
        return recordModel
    }
    
    /// 更新阅读记录(左右翻页模式)
    func updateReadRecord(controller:DZMReadViewController!) {
        
        updateReadRecord(recordModel: controller?.recordModel)
    }
    
    /// 更新阅读记录(左右翻页模式)
    func updateReadRecord(recordModel:DZMReadRecordModel!) {
        
        if recordModel != nil {
            
            readModel.recordModel = recordModel
            
            readModel.recordModel.save()
            
            DZM_READ_RECORD_CURRENT_CHAPTER_LOCATION = recordModel.locationFirst
        }
    }
}
