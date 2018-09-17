//
//  DZMReadOperation.swift
//  DZMeBookRead
//
//  Created by 邓泽淼 on 2017/5/15.
//  Copyright © 2017年 DZM. All rights reserved.
//

import UIKit

class DZMReadOperation: NSObject {

    /// 阅读控制器
    weak var vc:DZMReadController!
    
    // MARK: -- init
    
    init(vc:DZMReadController) {
        
        super.init()
        
        self.vc = vc
    }
    
    // MARK: -- 获取阅读控制器 DZMReadViewController
    
    /// 获取阅读View控制器
    func GetReadViewController(readRecordModel:DZMReadRecordModel?) ->DZMReadViewController? {
        
        if readRecordModel != nil {
            
            let readViewController = DZMReadViewController()
            
            readViewController.readRecordModel = readRecordModel
            
            readViewController.readController = vc
            
            return readViewController
        }
        
        return nil
    }
    
    /// 获取当前阅读记录的阅读View控制器
    func GetCurrentReadViewController(isUpdateFont:Bool = false, isSave:Bool = false) ->DZMReadViewController? {
       
        if isUpdateFont {
           
            vc.readModel.readRecordModel.updateFont(isSave: true)
        }
        
        if isSave {
            
            readRecordUpdate(readRecordModel: vc.readModel.readRecordModel)
        }
        
        return GetReadViewController(readRecordModel: vc.readModel.readRecordModel.copySelf())
    }
    
    /// 获取上一页控制器
    func GetAboveReadViewController() ->DZMReadViewController? {
        
        // 没有阅读模型
        if vc.readModel == nil || !vc.readModel.readRecordModel.isRecord {return nil}
        
        // 阅读记录
        var readRecordModel:DZMReadRecordModel?
        
        // 判断
        if vc.readModel.isLocalBook.boolValue { // 本地小说
            
            // 获得阅读记录
            readRecordModel = vc.readModel.readRecordModel.copySelf()
            
            // 章节ID
            let id = vc.readModel.readRecordModel.readChapterModel!.id.integer
            
            // 页码
            let page = vc.readModel.readRecordModel.page.intValue
            
            // 到头了
            if id == 1 && page == 0 {return nil}
            
            if page == 0 { // 这一章到头了
                
                readRecordModel?.modify(chapterID: "\(id - 1)", toPage: DZMReadLastPageValue, isUpdateFont:true, isSave: false)
                
            }else{ // 没到头
                
                readRecordModel?.page = NSNumber(value: (page - 1))
            }
            
        }else{ // 网络小说
            
            /*
             网络小说操作提示:
             
             1. 获得阅读记录
             
             2. 获得当前章节ID
             
             3. 获得当前阅读章节 读到的页码
             
             4. 判断是否为这一章最后一页
             
             5. 1). 判断不是第一页则 page - 1 继续翻页
                2). 如果是第一页则判断上一章的章节ID是否有值,没值就是当前没有跟多章节（连载中）或者 全书完, 有值则判断是否存在缓存文件.
                    有缓存文件则拿出使用更新阅读记录, 没值则请求服务器获取，请求回来之后可动画展示出来
             
             提示：如果是请求回来之后并更新了阅读记录 可使用 GetCurrentReadViewController() 获得当前阅读记录的控制器 进行展示
             */
            
            readRecordModel = nil
        }
        
        return GetReadViewController(readRecordModel: readRecordModel)
    }
    
    
    /// 获得下一页控制器
    func GetBelowReadViewController() ->DZMReadViewController? {
        
        // 没有阅读模型
        if vc.readModel == nil || !vc.readModel.readRecordModel.isRecord {return nil}
        
        // 阅读记录
        var readRecordModel:DZMReadRecordModel?
        
        // 判断
        if vc.readModel.isLocalBook.boolValue { // 本地小说
            
            // 获得阅读记录
            readRecordModel = vc.readModel.readRecordModel.copySelf()
            
            // 章节ID
            let id = vc.readModel.readRecordModel.readChapterModel!.id.integer
            
            // 页码
            let page = vc.readModel.readRecordModel.page.intValue
            
            // 最后一页
            let lastPage = vc.readModel.readRecordModel.readChapterModel!.pageCount.intValue - 1
            
            // 到头了
            if id == vc.readModel.readChapterListModels.count && page == lastPage {return nil}
            
            if page == lastPage { // 这一章到头了
                
                readRecordModel?.modify(chapterID: "\(id + 1)", isUpdateFont: true)
                
            }else{ // 没到头
                
                readRecordModel?.page = NSNumber(value: (page + 1))
            }
            
        }else{ // 网络小说
            
            /*
             网络小说操作提示:
             
             1. 获得阅读记录
             
             2. 获得当前章节ID
             
             3. 获得当前阅读章节 读到的页码
             
             4. 判断是否为这一章最后一页
             
             5. 1). 判断不是最后一页则 page + 1 继续翻页
                2). 如果是最后一页则判断下一章的章节ID是否有值,没值就是当前没有跟多章节（连载中）或者 全书完, 有值则判断是否存在缓存文件.
                    有缓存文件则拿出使用更新阅读记录, 没值则请求服务器获取，请求回来之后可动画展示出来
             
             提示：如果是请求回来之后并更新了阅读记录 可使用 GetCurrentReadViewController() 获得当前阅读记录的控制器 进行展示
             */
            
            readRecordModel = nil
        }
        
        return GetReadViewController(readRecordModel: readRecordModel)
    }
    
    /// 跳转指定章节 指定页码 (toPage: -1 为最后一页 也可以使用 DZMReadLastPageValue)
    func GoToChapter(chapterID:String, toPage:NSInteger = 0) ->Bool {
        
        if vc.readModel != nil { // 有阅读模型
            
            if DZMReadChapterModel.IsExistReadChapterModel(bookID: vc.readModel.bookID, chapterID: chapterID) { //  存在
                
                vc.readModel.modifyReadRecordModel(chapterID: chapterID, page: toPage, isSave: false)
                
                vc.creatPageController(GetCurrentReadViewController(isUpdateFont: true, isSave: true))
                
                return true
                
            }else{ // 不存在

                /*
                 网络小说操作提示:
                 
                 1. 请求章节内容 并缓存
                 
                 2. 修改阅读记录 并展示
                 */
                
                return false
            }
        }
        
        return false
    }
    
    // MARK: -- 同步记录 
    
    /// 更新记录
    func readRecordUpdate(readViewController:DZMReadViewController?, isSave:Bool = true) {
       
        readRecordUpdate(readRecordModel: readViewController?.readRecordModel, isSave: isSave)
    }
    
    /// 更新记录
    func readRecordUpdate(readRecordModel:DZMReadRecordModel?, isSave:Bool = true) {
        
        if readRecordModel != nil {
            
            vc.readModel.readRecordModel = readRecordModel
            
            if isSave {
                
                // 保存
                vc.readModel.readRecordModel.save()
                
                // 更新UI
                DispatchQueue.main.async { [weak self] ()->Void in
                    
                    // 进度条数据初始化
                    self?.vc.readMenu.bottomView.sliderUpdate()
                }
            }
        }
    }
}
