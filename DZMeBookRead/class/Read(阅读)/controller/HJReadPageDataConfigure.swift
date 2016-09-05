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
    private weak var readPageController:HJReadPageController!
    
    /// 当前的阅读章节模型
    var readChapterModel:HJReadChapterModel!
    
    /// 临时记录值
    var changeReadChapterModel:HJReadChapterModel!
    var changeReadChapterListModel:HJReadChapterListModel!
    var changeLookPage:Int = 0
    var changeChapterID:Int = 0
    
    /// 阅读控制器配置
    class func setupWithReadController(readPageController:HJReadPageController) ->HJReadPageDataConfigure {
        
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
    func GetReadViewController(readChapterModel:HJReadChapterModel,currentPage:Int) ->HJReadViewController {
        
        let readVC = HJReadViewController()

        readVC.readPageController = readPageController
        
        // 正对当前控制器的阅读记录
        let readRecord = HJReadRecord()
        readRecord.readChapterListModel = changeReadChapterListModel
        readRecord.page = currentPage
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
    func GoToReadChapter(chapterID:String,isInit:Bool,chapterLookPageClear:Bool,transitionStyle: UIPageViewControllerTransitionStyle,result:((isOK:Bool)->Void)?) {
        
        if !readPageController.readModel.readChapterListModels.isEmpty {
            
            let readChapterModel = GetReadChapterModel(chapterID)
            
            if readChapterModel != nil { // 有这个章节
                
                GoToReadChapter(readChapterModel!, isInit: isInit, chapterLookPageClear: chapterLookPageClear, transitionStyle: transitionStyle, result: result)
                
            }else{ // 没有章节
                
                if readPageController.readModel.isLocalBook.boolValue { // 本地小说
                    
                    if result != nil {result!(isOK: false)}
                    
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
    private func GoToReadChapter(readChapterModel:HJReadChapterModel,isInit:Bool,chapterLookPageClear:Bool,transitionStyle: UIPageViewControllerTransitionStyle,result:((isOK:Bool)->Void)?) {
        
        changeLookPage = readPageController.readModel.readRecord.page.integerValue
        
        if chapterLookPageClear {
            
            readPageController.readModel.readRecord.page = 0
            
            changeLookPage = 0
        }
        
        // 跳转
        if isInit {
            
            readPageController.creatPageController(GetReadViewController(readChapterModel, currentPage: readPageController.readModel.readRecord.page.integerValue),transitionStyle: transitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal)
        }else{
            
            readPageController.pageViewController.setViewControllers([GetReadViewController(readChapterModel, currentPage: readPageController.readModel.readRecord.page.integerValue)], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        }
        
        // 同步本地进度
        synchronizationChangeData()
        
        if result != nil {result!(isOK: true)}
    }
    
    // MARK: -- 通过章节ID 获取 数组索引
    
    func GetReadChapterListModel(chapterID:String) ->HJReadChapterListModel? {
        
        let pre = NSPredicate(format: "chapterID == %@",chapterID)
        
        let results = (readPageController.readModel.readChapterListModels as NSArray).filteredArrayUsingPredicate(pre)
        
        return results.first as? HJReadChapterListModel
    }
    
    
    // 通过章节ID获取章节模型 需要滚动到的 获取到阅读章节
    func GetReadChapterModel(chapterID:String) ->HJReadChapterModel? {
        
        let pre = NSPredicate(format: "chapterID == %@",chapterID)
        
        let results = (readPageController.readModel.readChapterListModels as NSArray).filteredArrayUsingPredicate(pre)
        
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
                let index = readPageController.readModel.readChapterListModels.indexOf(readChapterListModel)
                
                readPageController.readModel.readRecord.chapterIndex = index!
                
                readPageController.readSetup.readUI.leftView.scrollRow = index!
                
                readPageController.readSetup.readUI.bottomView.slider.value = Float(index!)
                
                return readChapterModel
            }
        }
        
        return nil
    }
    
    // MARK: -- 上一页
    
    func GetReadPreviousPage() ->HJReadViewController? {
        
        changeChapterID = readPageController.readModel.readRecord.readChapterListModel.chapterID.integerValue()
        
        changeLookPage = readPageController.readModel.readRecord.page.integerValue
        
        changeReadChapterListModel = readPageController.readModel.readRecord.readChapterListModel
        
        if readPageController.readModel.isLocalBook.boolValue { // 本地小说
            
            if changeChapterID == 1 && changeLookPage == 0 {
                
                return nil
            }
            
            if changeLookPage == 0 { // 这一章到头部了
                
                changeChapterID -= 1
                
                let readChapterModel = GetReadChapterModel("\(changeChapterID)")
                
                if readChapterModel != nil { // 有上一张
                    
                    changeLookPage = changeReadChapterModel!.pageCount.integerValue - 1
                    
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
        
        changeLookPage = readPageController.readModel.readRecord.page.integerValue
        
        changeReadChapterListModel = readPageController.readModel.readRecord.readChapterListModel
        
        if readPageController.readModel.isLocalBook.boolValue { // 本地小说
            
            if changeChapterID == readPageController.readModel.readChapterListModels.count && changeLookPage == (changeReadChapterModel.pageCount.integerValue - 1) {
                
                return nil
            }
            
            if changeLookPage == (changeReadChapterModel.pageCount.integerValue - 1) { // 这一章到尾部了
            
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
        
        let oldPage:Int = readPageController.readModel.readRecord.page.integerValue
        
        let newPage = changeReadChapterModel.pageCount.integerValue
        
        readPageController.readModel.readRecord.page = (oldPage > (newPage - 1) ? (newPage - 1) : oldPage)
        
    }
    
    // MARK: -- 阅读记录
    
    /// 同步临时数据
    func synchronizationChangeData() {
        
        readChapterModel = changeReadChapterModel
        readPageController.readModel.readRecord.readChapterListModel = changeReadChapterListModel
        readPageController.readModel.readRecord.page = changeLookPage
    }
    
    /// 刷新保存阅读记录
    
    /**
     保存记录 默认是更具条件是否属于书架进行保存b
     */
    func updateReadRecord() {
        
        // 同步阅读记录
        HJReadModel.updateReadModel(readPageController.readModel)
    }
}
