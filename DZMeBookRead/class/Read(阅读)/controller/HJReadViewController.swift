//
//  HJReadViewController.swift
//  HJProject
//
//  Created by 邓泽淼 on 16/8/25.
//  Copyright © 2016年 HanJue. All rights reserved.
//

import UIKit

private let HJReadCellID:String = "HJReadCellID"

class HJReadViewController: HJTableViewController {
    
    weak var readPageController:HJReadPageController!
    
    /// 当前阅读形式
    private var flipEffect:HJReadFlipEffect!
    
    /// 当前是否为这一章的最后一页
    var isLast:Bool = false
    
    /// 单独模式的时候显示的内容
    var content:String!
    
    /// 当前章节阅读记录
    var readRecord:HJReadRecord!
    
    /// 当前使用的阅读模型
    var readChapterModel:HJReadChapterModel!
    
    /// 底部状态栏
    private var readBottomStatusView:HJReadBottomStatusView!
    
    /// 当前滚动经过的indexPath   UpAndDown 模式使用
    private var currentIndexPath:NSIndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置背景颜色
        changeBGColor()
        
        // 设置翻页方式
        changeFlipEffect()
        
        // 设置页码
        if flipEffect != HJReadFlipEffect.None {
            
            readBottomStatusView.setNumberPage(readRecord.page.integerValue, tatolPage: readChapterModel.pageCount.integerValue)
            
            isLast = (readRecord.page.integerValue == (readChapterModel.pageCount.integerValue - 1))
        }
        
        // 通知在deinit 中会释放
        // 添加背景颜色改变通知
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(HJReadViewController.changeBGColor), name: HJReadChangeBGColorKey, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func initTableView(style: UITableViewStyle) {
        super.initTableView(.Plain)
        
        tableView.backgroundColor = UIColor.clearColor()
        
        tableView.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight - HJReadBottomStatusViewH)
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        readBottomStatusView = HJReadBottomStatusView()
        readBottomStatusView.frame = CGRectMake(0, ScreenHeight - HJReadBottomStatusViewH, ScreenWidth, HJReadBottomStatusViewH)
        view.addSubview(readBottomStatusView)
    }
    
    // MARK: -- UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        if flipEffect == HJReadFlipEffect.None { // 无效果
            
            return 1
            
        }else if flipEffect == HJReadFlipEffect.Translation { // 平滑
            
            return 1
            
        }else if flipEffect == HJReadFlipEffect.Simulation { // 仿真
            
            return 1
            
        }else if flipEffect == HJReadFlipEffect.UpAndDown { // 上下滚动
            
            return 1
            
        }else{}
        
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if flipEffect == HJReadFlipEffect.None { // 无效果
            
            return 1
            
        }else if flipEffect == HJReadFlipEffect.Translation { // 平滑
            
            return 1
            
        }else if flipEffect == HJReadFlipEffect.Simulation { // 仿真
            
            return 1
            
        }else if flipEffect == HJReadFlipEffect.UpAndDown { // 上下滚动
            
        }else{}
        
        return readPageController.readModel.readChapterListModels.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = HJReadViewCell.cellWithTableView(tableView)
        
        cell.isLast = isLast
        
        if flipEffect == HJReadFlipEffect.None { // 无效果
            
            cell.content = content
            
        }else if flipEffect == HJReadFlipEffect.Translation { // 平滑
            
            cell.content = content
            
        }else if flipEffect == HJReadFlipEffect.Simulation { // 仿真
            
            cell.content = content
            
        }else if flipEffect == HJReadFlipEffect.UpAndDown { // 上下滚动
            
            currentIndexPath = indexPath
            
            let readChapterListModel = readPageController.readModel.readChapterListModels[indexPath.row]
            
            let tempReadChapterModel = GetReadChapterModel(readChapterListModel)
            
            cell.contentH = CGFloat(readChapterListModel.chapterHeight.floatValue)
            
            cell.content = tempReadChapterModel.chapterContent
            
            readPageController.title = readChapterListModel.chapterName
            
            // 设置页码
            readBottomStatusView.setNumberPage(indexPath.row, tatolPage: readPageController.readModel.readChapterListModels.count)
            
        }else{}
        
        
        return cell
    }
    
    // MARK: -- UITableViewDelegate
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        
//        if flipEffect == HJReadFlipEffect.UpAndDown { // 滚动模式
        
            readPageController.readModel.readRecord.contentOffsetY = scrollView.contentOffset.y
//        }
    }
    
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
        GetCurrentPage()
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        
        GetCurrentPage()
    }
    
    /**
     获取页码
     */
    func GetCurrentPage() {
        
        if flipEffect == HJReadFlipEffect.UpAndDown { // 滚动模式
            
            if  currentIndexPath != nil {
                
                let cell = tableView.cellForRowAtIndexPath(currentIndexPath) as? HJReadViewCell
                
                if cell != nil {
                    
                    let spaceH = tableView.contentOffset.y - cell!.y
                    
                    let redFrame = HJReadParser.GetReadViewFrame()
                    
                    let page = spaceH / redFrame.height
                    
                    readPageController.readModel.readRecord.page = (page + 0.5)
                    
                    readPageController.readModel.readRecord.readChapterListModel = cell!.readChapterListModel
                }
            }
        }
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        if flipEffect == HJReadFlipEffect.None { // 无效果
            
        }else if flipEffect == HJReadFlipEffect.Translation { // 平滑
            
        }else if flipEffect == HJReadFlipEffect.Simulation { // 仿真
            
        }else if flipEffect == HJReadFlipEffect.UpAndDown { // 上下滚动
            
            let readChapterListModel = readPageController.readModel.readChapterListModels[indexPath.row]
            
            if CGFloat(readChapterListModel.chapterHeight.floatValue) < ScreenHeight {
                
                return ScreenHeight
            }
            
            // 不要广告可注销 删除 后面 HJAdvertisementButtonH 广告高度
            return CGFloat(readChapterListModel.chapterHeight.floatValue) + HJReadViewTopSpace + HJAdvertisementButtonH
            
        }else{}
        
        return ScreenHeight
    }
    
    // MARK: -- 通知
    
    /// 修改背景颜色
    func changeBGColor() {
        
        view.backgroundColor = HJReadConfigureManger.shareManager.readColor
    }
    
    /// 修改阅读方式
    func changeFlipEffect() {
        
        flipEffect = HJReadConfigureManger.shareManager.flipEffect
        
        if flipEffect == HJReadFlipEffect.None { // 无效果
            
            tableView.scrollEnabled = false
            
        }else if flipEffect == HJReadFlipEffect.Translation { // 平滑
            
            tableView.scrollEnabled = false
            
        }else if flipEffect == HJReadFlipEffect.Simulation { // 仿真
            
            tableView.scrollEnabled = false
            
        }else if flipEffect == HJReadFlipEffect.UpAndDown { // 上下滚动
            
            tableView.scrollEnabled = true
            
            // 获取当前章节
            let readChapterListModel = readPageController.readConfigure.GetReadChapterListModel(readRecord.readChapterListModel.chapterID)
            
            if (readChapterListModel != nil) { // 有章节
                
                // 刷新数据
                let index = readPageController.readModel.readChapterListModels.indexOf(readChapterListModel!)
                
                GetReadChapterModel(readChapterListModel!)
                
                if readPageController.readModel.readRecord.contentOffsetY != nil {
                    
                    tableView.setContentOffset(CGPointMake(tableView.contentOffset.x, CGFloat(readPageController.readModel.readRecord.contentOffsetY!.floatValue)), animated: false)
                    
                }else{
                    
                    // 滚到指定章节的cell
                    tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: index!,inSection: 0), atScrollPosition: UITableViewScrollPosition.Top, animated: false)
                    
                    // 滚动到指定cell的指定位置
                    let redFrame = HJReadParser.GetReadViewFrame()
                    
                    tableView.setContentOffset(CGPointMake(tableView.contentOffset.x, tableView.contentOffset.y + CGFloat(readPageController.readModel.readRecord.page.integerValue) * redFrame.height), animated: false)
                }
                
                // 获取准确页面
                GetCurrentPage()
            }
            
        }else{}
    }
    
    /**
     获取阅读章节模型
     */
    func GetReadChapterModel(readChapterListModel:HJReadChapterListModel) ->HJReadChapterModel {
        
        // 从缓存里面获取文件
        let tempReadChapterModel = ReadKeyedUnarchiver(readPageController.readModel.bookID, fileName: readChapterListModel.chapterID) as! HJReadChapterModel
        
        // 更新字体
        tempReadChapterModel.updateFont()
        
        // 计算高度
        readChapterListModel.chapterHeight = HJReadParser.parserReadContentHeight(tempReadChapterModel.chapterContent, configure: HJReadConfigureManger.shareManager, width: ScreenWidth - HJReadViewLeftSpace - HJReadViewRightSpace)
        
        return tempReadChapterModel
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit{
        
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
}
