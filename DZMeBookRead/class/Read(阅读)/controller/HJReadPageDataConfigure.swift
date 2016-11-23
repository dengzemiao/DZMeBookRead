//
//  HJReadPageDataConfigure.swift
//  HJProject
//
//  Created by 邓泽淼 on 16/8/31.
//  Copyright © 2016年 HanJue. All rights reserved.
//

/*
    
    主要存放阅读页面的数据方法
 
 */

import UIKit

class HJReadPageDataConfigure: NSObject {

    /// 阅读控制器
    fileprivate weak var readPageController:HJReadPageController!
    
    // 当前书签模型记录 有值则表示当前显示的 段落中有标签  没有值则表示没有
    var readMarkModel:HJReadMarkModel?
    
    /// 临时记录值
    var changeReadChapterModel:HJReadChapterModel!
    var changeReadChapterListModel:HJReadChapterListModel!
    var changeLookPage:Int = 0
    var changeChapterID:Int = 0
    
    /// 阅读控制器配置
    class func setupWithReadController(_ readPageController:HJReadPageController) ->HJReadPageDataConfigure {
        
        let readPageDataConfigure = HJReadPageDataConfigure()
        
        readPageDataConfigure.readPageController = readPageController
        
        return readPageDataConfigure
    }
    
    // MARK: -- 阅读控制器
    
    /**
     获取阅读控制器
     
     - parameter readChapterModel: 当前阅读的章节模型
     - parameter page:             当前章节阅读到page
     */
    func GetReadViewController(_ readChapterModel:HJReadChapterModel,currentPage:Int) ->HJReadViewController {
        
        let readVC = HJReadViewController()
        readVC.readPageController = readPageController
        
        // 正对当前控制器的阅读记录
        let readRecord = HJReadRecord()
        readRecord.readChapterListModel = changeReadChapterListModel
        readRecord.page = NSNumber(value: currentPage)
        readRecord.chapterIndex = readPageController.readModel.readRecord.chapterIndex
        readVC.readChapterModel = readChapterModel
        readVC.readRecord = readRecord
        
        readVC.content = readChapterModel.stringOfPage(currentPage)
        
        return readVC
    }
    
    // MARK: -- 阅读指定章节
    
    /**
     跳转指定章节
     
     - parameter chapterID:            章节ID
     - parameter isInit:               是否为初始化true 还是跳转章节false
     - parameter chapterLookPageClear: 阅读到的章节页码是否清0
     - parameter transitionStyle:      PageController 样式
     - parameter result:               跳转结果
     */
    func GoToReadChapter(_ chapterID:String,chapterLookPageClear:Bool,result:((_ isOK:Bool)->Void)?) {
        
        if !readPageController.readModel.readChapterListModels.isEmpty {
            
            let readChapterModel = GetReadChapterModel(chapterID)
            
            if readChapterModel != nil { // 有这个章节
                
                GoToReadChapter(readChapterModel!, chapterLookPageClear: chapterLookPageClear, result: result)
                
            }else{ // 没有章节
                
                if readPageController.readModel.isLocalBook.boolValue { // 本地小说
                    
                    if result != nil {result!(false)}
                    
                }else{ // 网络小说
                    
                }
            }
        }
    }
    
    /**
     跳转指定章节
     
     - parameter readChapterModel:     章节模型
     - parameter isInit:               是否为初始化true 还是跳转章节false
     - parameter chapterLookPageClear: 阅读到的章节页码是否清0
     - parameter transitionStyle:      PageController 样式
     - parameter result:               跳转结果
     */
    fileprivate func GoToReadChapter(_ readChapterModel:HJReadChapterModel, chapterLookPageClear:Bool,result:((_ isOK:Bool)->Void)?) {
        
        changeLookPage = readPageController.readModel.readRecord.page.intValue
        
        if chapterLookPageClear {
            
            readPageController.readModel.readRecord.page = 0
            
            changeLookPage = 0
        }
        
        readPageController.creatPageController(GetReadViewController(readChapterModel, currentPage: readPageController.readModel.readRecord.page.intValue))
        
        // 同步本地进度
        synchronizationChangeData()
        
        if result != nil {result!(true)}
    }
    
    // MARK: -- 通过章节ID 获取 数组索引
    
    func GetReadChapterListModel(_ chapterID:String) ->HJReadChapterListModel? {
        
        let pre = NSPredicate(format: "chapterID == %@",chapterID)
        
        let results = (readPageController.readModel.readChapterListModels as NSArray).filtered(using: pre)
        
        return results.first as? HJReadChapterListModel
    }
    
    
    // 通过章节ID获取章节模型 需要滚动到的 获取到阅读章节
    func GetReadChapterModel(_ chapterID:String) ->HJReadChapterModel? {
        
        let pre = NSPredicate(format: "chapterID == %@",chapterID)
        
        let results = (readPageController.readModel.readChapterListModels as NSArray).filtered(using: pre)
        
        if !results.isEmpty { // 获取当前数组位置
            
            let readChapterListModel = results.first as! HJReadChapterListModel
            
            // 获取阅读章节文件
            let readChapterModel = ReadKeyedUnarchiver(readPageController.readModel.bookID, fileName: readChapterListModel.chapterID) as? HJReadChapterModel
            
            if readChapterModel != nil {
                
                changeReadChapterListModel = readChapterListModel
                
                changeReadChapterModel = readChapterModel
                
                // 刷新字体
                readPageController.readConfigure.updateReadRecordFont()
                
                readPageController.title = readChapterListModel.chapterName
                
                // 章节list 进行滚动
                let index = readPageController.readModel.readChapterListModels.index(of: readChapterListModel)
                
                readPageController.readModel.readRecord.chapterIndex = NSNumber(value: index!)
                
                readPageController.readSetup.readUI.leftView.scrollRow = index!
                
                return readChapterModel
            }
        }
        
        return nil
    }
    
    // MARK: -- 上一页
    
    func GetReadPreviousPage() ->HJReadViewController? {
        
        changeChapterID = readPageController.readModel.readRecord.readChapterListModel.chapterID.integerValue()
        
        changeLookPage = readPageController.readModel.readRecord.page.intValue
        
        changeReadChapterListModel = readPageController.readModel.readRecord.readChapterListModel
        
        if readPageController.readModel.isLocalBook.boolValue { // 本地小说
            
            if changeChapterID == 1 && changeLookPage == 0 {
                
                return nil
            }
            
            if changeLookPage == 0 { // 这一章到头部了
                
                changeChapterID -= 1
                
                let readChapterModel = GetReadChapterModel("\(changeChapterID)")
                
                if readChapterModel != nil { // 有上一张
                    
                    changeLookPage = changeReadChapterModel!.pageCount.intValue - 1
                    
                }else{ // 没有上一章
                    
                    return nil
                }
                
            }else{
                
                changeLookPage -= 1
            }
            
        }else{ // 网络小说阅读
            
            
        }
        
        return GetReadViewController(changeReadChapterModel, currentPage: changeLookPage)
    }
    
    // MARK: -- 下一页
    
    func GetReadNextPage() ->HJReadViewController? {
        
        changeChapterID = readPageController.readModel.readRecord.readChapterListModel.chapterID.integerValue()
        
        changeLookPage = readPageController.readModel.readRecord.page.intValue
        
        changeReadChapterListModel = readPageController.readModel.readRecord.readChapterListModel
        
        if readPageController.readModel.isLocalBook.boolValue { // 本地小说
            
            if changeChapterID == readPageController.readModel.readChapterListModels.count && changeLookPage == (changeReadChapterModel.pageCount.intValue - 1) {
                
                return nil
            }
            
            if changeLookPage == (changeReadChapterModel.pageCount.intValue - 1) { // 这一章到尾部了
            
                changeChapterID += 1
                
                let chapterModel = GetReadChapterModel("\(changeChapterID)")
                
                if chapterModel != nil { // 有下一章
                    
                    changeLookPage = 0
                    
                }else{ // 没有下一章
                    
                    return nil
                }
                
            }else{
                
                changeLookPage += 1
            }
            
        }else{ // 网络小说阅读
            
            
        }
        
        return GetReadViewController(changeReadChapterModel, currentPage: changeLookPage)
    }
    
    // MARK: -- 刷新字体
    
    func updateReadRecordFont() {
        
        // 刷新字体
        changeReadChapterModel.updateFont()
        
        // 重新展示
        
        let oldPage:Int = readPageController.readModel.readRecord.page.intValue
        
        let newPage = changeReadChapterModel.pageCount.intValue
        
        readPageController.readModel.readRecord.page = NSNumber(value: (oldPage > (newPage - 1) ? (newPage - 1) : oldPage))
        
    }
    
    // MARK: -- 阅读记录
    
    /// 同步临时数据
    func synchronizationChangeData() {
        
        readPageController.readModel.readRecord.readChapterModel = changeReadChapterModel
        
        readPageController.readModel.readRecord.readChapterListModel = changeReadChapterListModel
        
        readPageController.readModel.readRecord.page = NSNumber(value:changeLookPage)
        
        // 检查当前页面是否为书签页
        checkCurrentPageIsReadMark(readChapterModel: changeReadChapterModel, currentPage: changeLookPage)
    }
    
    /// 刷新保存阅读记录
    
    /**
     保存记录 默认是更具条件是否属于书架进行保存b
     */
    func updateReadRecord() {
        
        // 同步阅读记录
        HJReadModel.updateReadModel(readPageController.readModel)
    }
    
    // MARK: -- 书签
    
    // 添加书签
    func addBookMark() {
        
        // 书签模型
        let readMarkModel = HJReadMarkModel()
        readMarkModel.bookID = readPageController.readModel.bookID
        readMarkModel.chapterID = readPageController.readModel.readRecord.readChapterListModel.chapterID
        readMarkModel.volumeID = readPageController.readModel.readRecord.readChapterListModel.volumeID
        readMarkModel.chapterName = readPageController.readModel.readRecord.readChapterListModel.chapterName
        readMarkModel.time = Date()
        let page = readPageController.readModel.readRecord.page.intValue
        readMarkModel.location = NSNumber(value:readPageController.readModel.readRecord.readChapterModel!.pageLocationArray[page])
        readMarkModel.content = readPageController.readModel.readRecord.readChapterModel!.stringOfPage(page)
        
        // 添加
        addBookMark(readMarkModel: readMarkModel)
        
        // 记录
        self.readMarkModel = readMarkModel
    }
    
    // 添加书签
    func addBookMark(readMarkModel:HJReadMarkModel) {
        
        // 添加
        readPageController.readModel.readBookMarks.insert(readMarkModel, at: 0);
        
        // 保存
        HJReadModel.updateReadModel(readPageController.readModel);
        
        // 刷新
        readPageController.readSetup.readUI.leftView.readBookMarksReloaData()
    }
    
    // 删除书签
    func removeBookMark() {
      
        // 删除
        removeBookMark(readMarkModel: readMarkModel)
        
        // 清空
        readMarkModel = nil
        
        // 保存
        HJReadModel.updateReadModel(readPageController.readModel);
        
        // 删除之后需要再次 检查当前页面是否为书签页
        checkCurrentPageIsReadMark(readChapterModel: changeReadChapterModel, currentPage: changeLookPage)
    }
    
    // 删除书签
    func removeBookMark(readMarkModel:HJReadMarkModel?) {
        
        if (readMarkModel != nil) {
            
            // 移除
            readPageController.readModel.readBookMarks.remove(at: readPageController.readModel.readBookMarks.index(of: readMarkModel!)!)
            
            // 刷新
            readPageController.readSetup.readUI.leftView.readBookMarksReloaData()
        }
    }
    
    // 变更字体 删除书签 之后更新指定章节的书签
    func checkCurrentPageIsReadMark() {
        
        checkCurrentPageIsReadMark(readChapterModel: readPageController.readModel.readRecord.readChapterModel!, currentPage: readPageController.readModel.readRecord.page.intValue)
    }
    
    func checkCurrentPageIsReadMark(readChapterModel:HJReadChapterModel,currentPage:Int) {
        
        let pre = NSPredicate(format: "chapterID == %@",readChapterModel.chapterID)
        
        let results = (readPageController.readModel.readBookMarks as NSArray).filtered(using: pre)
        
        if !results.isEmpty { // 有数据
            
            // 获取当前页码的range
            let currentRange = readChapterModel.getRangeWithPage(currentPage)
            
            for i in 0..<results.count { // 进行便利
                
                // 取出书签模型
                let readBookMark = results[i] as! HJReadMarkModel;
                
                // 大于等于 当前页码的location   小于等于当前页面的loction + length
                if (readBookMark.location.intValue >= currentRange.location && readBookMark.location.intValue <= (currentRange.location + currentRange.length)) {
                    
                    readPageController.readSetup.rightItem.isSelected = true
                    readMarkModel = readBookMark;
                    return
                    
                }else{
                    
                    readPageController.readSetup.rightItem.isSelected = false
                    readMarkModel = nil;
                }
            }
        }else{
            
            readPageController.readSetup.rightItem.isSelected = false
            readMarkModel = nil;
        }
    }
}
