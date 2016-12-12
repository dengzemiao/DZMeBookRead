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
    fileprivate var flipEffect:HJReadFlipEffect!
    
    /// 当前是否为这一章的最后一页
    var isLastPage:Bool = false
    
    /// 是否为手动拖动
    var isDragging:Bool = false
    
    /// 单独模式的时候显示的内容
    var content:String!
    
    /// 当前章节阅读记录
    var readRecord:HJReadRecord!
    
    /// 当前使用的阅读模型
    var readChapterModel:HJReadChapterModel!
    
    /// 底部状态栏
    fileprivate var readBottomStatusView:HJReadBottomStatusView!
    fileprivate var readTopStatusView:HJReadTopStatusView!
    
    /// 当前滚动经过的indexPath   UpAndDown 模式使用
    fileprivate var currentIndexPath:IndexPath!
    
    /// 当前是往上滚还是往下滚 default: 往上
    fileprivate var isScrollTop:Bool = true
    /// 用于计算返回cell高度使用
    fileprivate var isTempScrollTop:Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 设置背景颜色
        changeBGColor()
        
        // 设置翻页方式
        changeFlipEffect()
        
        // 设置头部名字 设置页码
        readPageController.readSetup.readUI.bottomView.slider.maximumValue = (readChapterModel.pageCount.floatValue - 1)
        readPageController.readSetup.readUI.bottomView.slider.value = readRecord.page.floatValue
        readTopStatusView.setLeftTitle(readChapterModel.chapterName)
        readBottomStatusView.setNumberPage(readRecord.page.intValue, tatolPage: readChapterModel.pageCount.intValue)
        
        // 通知在deinit 中会释放
        // 添加背景颜色改变通知
        NotificationCenter.default.addObserver(self, selector: #selector(HJReadViewController.changeBGColor), name: NSNotification.Name(rawValue: HJReadChangeBGColorKey), object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func initTableView(_ style: UITableViewStyle) {
        super.initTableView(.plain)
        
        tableView.backgroundColor = UIColor.clear
        
        tableView.frame = HJReadParser.GetReadViewFrame()
    }
    
    override func addSubviews() {
        super.addSubviews()
        
        readTopStatusView = HJReadTopStatusView()
        readTopStatusView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: HJReadTopStatusViewH)
        view.addSubview(readTopStatusView)
        
        readBottomStatusView = HJReadBottomStatusView()
        readBottomStatusView.frame = CGRect(x: 0, y: ScreenHeight - HJReadBottomStatusViewH, width: ScreenWidth, height: HJReadBottomStatusViewH)
        view.addSubview(readBottomStatusView)
    }
    
    // MARK: -- UITableViewDataSource
    
    func numberOfSectionsInTableView(_ tableView: UITableView) -> Int {
        
        if flipEffect == HJReadFlipEffect.none { // 无效果
            
            return 1
            
        }else if flipEffect == HJReadFlipEffect.translation { // 平滑
            
            return 1
            
        }else if flipEffect == HJReadFlipEffect.simulation { // 仿真
            
            return 1
            
        }else if flipEffect == HJReadFlipEffect.upAndDown { // 上下滚动
            
            return 1
            
        }else{}
        
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if flipEffect == HJReadFlipEffect.none { // 无效果
            
            return 1
            
        }else if flipEffect == HJReadFlipEffect.translation { // 平滑
            
            return 1
            
        }else if flipEffect == HJReadFlipEffect.simulation { // 仿真
            
            return 1
            
        }else if flipEffect == HJReadFlipEffect.upAndDown { // 上下滚动
            
        }else{}
        
        return readPageController.readModel.readChapterListModels.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = HJReadViewCell.cellWithTableView(tableView)
        
        cell.isLastPage = isLastPage
        
        if flipEffect == HJReadFlipEffect.none { // 无效果
            
            cell.content = content
            
        }else if flipEffect == HJReadFlipEffect.translation { // 平滑
            
            cell.content = content
            
        }else if flipEffect == HJReadFlipEffect.simulation { // 仿真
            
            cell.content = content
            
        }else if flipEffect == HJReadFlipEffect.upAndDown { // 上下滚动
            
            currentIndexPath = indexPath
            
            let readChapterListModel = readPageController.readModel.readChapterListModels[indexPath.row]
            
            let tempReadChapterModel = GetReadChapterModel(readChapterListModel)
            
            cell.readChapterModel = tempReadChapterModel
            
            cell.readChapterListModel = readChapterListModel
            
            // 第二种: 在停止拖拽 跟停止滚动 更新阅读记录 以及头部名称提示    ---- 设置页码
//            readBottomStatusView.setNumberPage(indexPath.row, tatolPage: readPageController.readModel.readChapterListModels.count)
            
        }else{}
        
        
        return cell
    }
    
    // MARK: -- UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as? HJReadViewCell
        
        cell?.clearCell()
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        readPageController.readModel.readRecord.contentOffsetY = scrollView.contentOffset.y as NSNumber?

        // 判断是滚上还是滚下
        let translation = scrollView.panGestureRecognizer.translation(in: view)
        
        if translation.y > 0 {
            
            isScrollTop = true
            
            isTempScrollTop = true
            
        }else if translation.y < 0 {
            
            isScrollTop = false
            
            isTempScrollTop = false
        }
        
        // 第一种: 滚动中 更新阅读记录 以及头部名称提示
        if (isDragging) {GetCurrentPage()}
    }
    
    // 第一种: 滚动中 更新阅读记录 以及头部名称提示
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        isDragging = true
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        isDragging = false
    }
    
//    // 第二种: 在停止拖拽 跟停止滚动 更新阅读记录 以及头部名称提示 还需要打开 (tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell） 中的设置页码
//    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
//        
//        GetCurrentPage()
//    }
//    
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        
//        GetCurrentPage()
//    }
    
    /**
     获取页码
     */
    func GetCurrentPage() {
        
        if flipEffect == HJReadFlipEffect.upAndDown { // 滚动模式
            
            if isScrollTop {
                
                currentIndexPath = tableView.minVisibleIndexPath()
                
            }else{
                
                currentIndexPath = tableView.maxVisibleIndexPath()
            }
            
            if currentIndexPath != nil {
                
                let cell = tableView.cellForRow(at: currentIndexPath) as? HJReadViewCell
                
                if cell != nil {
                    
                    let spaceH = tableView.contentOffset.y - cell!.y
                    
                    let redFrame = HJReadParser.GetReadViewFrame()
                    
                    let page = spaceH / redFrame.height
                    
                    
                    if (cell!.readChapterModel != nil) {
                        
                        readPageController.title = cell!.readChapterModel!.chapterName
                    
                        // 计算当前所在的页码
                        var tempPage = Int(page + 0.9)
                        
                        // 检查是否超过页码长度
                        if (tempPage >= cell!.readChapterModel!.pageCount.intValue) {
                            
                            tempPage = cell!.readChapterModel!.pageCount.intValue - 1
                        }
                        
                        // 获取正确的页码
                        let currentPage = NSNumber(value:tempPage)
                        
                        // 记录阅读页码
                        readPageController.readModel.readRecord.page = currentPage
                        
                        // 设置标题
                        readTopStatusView.setLeftTitle(cell!.readChapterListModel!.chapterName)
                        
                        // 设置阅读模型记录
                        readPageController.readModel.readRecord.readChapterModel = cell!.readChapterModel
                        
                        // 记录阅读章节
                        readPageController.readModel.readRecord.readChapterListModel = cell!.readChapterListModel
                        
                        // 设置页码
                        readTopStatusView.setLeftTitle(cell!.readChapterModel!.chapterName)
                        
                        // 设置显示page
                        readBottomStatusView.setNumberPage(currentPage.intValue, tatolPage: cell!.readChapterModel!.pageCount.intValue)
                        
                        // 设置进度条
                        readPageController.readSetup.readUI.bottomView.slider.maximumValue = (cell!.readChapterModel!.pageCount.floatValue - 1)
                        
                        readPageController.readSetup.readUI.bottomView.slider.value = Float(page)
                        
                        // 设置当前章节的索引
                        readPageController.readModel.readRecord.chapterIndex = NSNumber(value:currentIndexPath.row)
                        
                        // 左边章节列表进行滚动
                        readPageController.readSetup.readUI.leftView.scrollRow = currentIndexPath.row
                       
                        // 检查当前页面是否为书签页
                        readPageController.readConfigure.checkCurrentPageIsReadMark(readChapterModel: cell!.readChapterModel!, currentPage: currentPage.intValue)
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAtIndexPath indexPath: IndexPath) -> CGFloat {
        
        if flipEffect == HJReadFlipEffect.none { // 无效果
            
        }else if flipEffect == HJReadFlipEffect.translation { // 平滑
            
        }else if flipEffect == HJReadFlipEffect.simulation { // 仿真
            
        }else if flipEffect == HJReadFlipEffect.upAndDown { // 上下滚动
            
            let readChapterListModel = readPageController.readModel.readChapterListModels[indexPath.row]
           
            // 用于计算切换字体之后 往上滚动 上面的cell 会出现高度变化 会进行下推或者上拉的 问题
            if (isTempScrollTop && readChapterListModel.changeChapterHeight.boolValue) {
                
                tableView.contentOffset = CGPoint(x:tableView.contentOffset.x, y:tableView.contentOffset.y + CGFloat(readChapterListModel.changeChapterHeight.floatValue))
                
                readChapterListModel.changeChapterHeight = 0
                
            }else{
                
                readChapterListModel.changeChapterHeight = 0
            }
            
            // 不要广告可注销 删除 后面 HJAdvertisementButtonH 广告高度 以及 广告距离下一章空隙
            return CGFloat(readChapterListModel.chapterHeight.floatValue) + HJAdvertisementButtonH + HJAdvertisementBottomSpaceH
            
        }else{}
        
        return tableView.height
    }
    
    // MARK: -- 通知
    
    /// 修改背景颜色
    func changeBGColor() {
        
        if HJReadConfigureManger.shareManager.readColorInex.intValue == HJReadColors.index(of: HJColor_12) { // 牛皮黄
            
            let color:UIColor = UIColor(patternImage:UIImage(named: "icon_read_bg_0")!)
            
            readTopStatusView.backgroundColor = color
            
            view.backgroundColor = color
            
        }else{
            
            let color = HJReadColors[HJReadConfigureManger.shareManager.readColorInex.intValue]
            
            readTopStatusView.backgroundColor = color
            
            view.backgroundColor = color
        }
    }
    
    /// 修改阅读方式
    func changeFlipEffect() {
        
        flipEffect = HJReadConfigureManger.shareManager.flipEffect
        
        if flipEffect == HJReadFlipEffect.none { // 无效果
            
            tableView.isScrollEnabled = false
            
        }else if flipEffect == HJReadFlipEffect.translation { // 平滑
            
            tableView.isScrollEnabled = false
            
        }else if flipEffect == HJReadFlipEffect.simulation { // 仿真
            
            tableView.isScrollEnabled = false
            
        }else if flipEffect == HJReadFlipEffect.upAndDown { // 上下滚动
            
            tableView.isScrollEnabled = true
            
            // 获取当前章节
            let readChapterListModel = readPageController.readConfigure.GetReadChapterListModel(readRecord.readChapterListModel.chapterID)
            
            if (readChapterListModel != nil) { // 有章节
                
                // 刷新数据
                let index = readPageController.readModel.readChapterListModels.index(of: readChapterListModel!)
                
                let _ = GetReadChapterModel(readChapterListModel!)
                
                if readPageController.readModel.readRecord.contentOffsetY != nil {
                    
                    tableView.setContentOffset(CGPoint(x: tableView.contentOffset.x, y: CGFloat(readPageController.readModel.readRecord.contentOffsetY!.floatValue)), animated: false)
                    
                }else{
                    
                    // 滚到指定章节的cell
                    tableView.scrollToRow(at: IndexPath(row: index!,section: 0), at: UITableViewScrollPosition.top, animated: false)
                    
                    // 滚动到指定cell的指定位置
                    let redFrame = HJReadParser.GetReadViewFrame()
                    
                    tableView.setContentOffset(CGPoint(x: tableView.contentOffset.x, y: tableView.contentOffset.y + CGFloat(readPageController.readModel.readRecord.page.intValue) * (redFrame.height + HJSpaceThree)), animated: false)
                }
            }
            
            // 初始化显示页码
            GetCurrentPage()
            
        }else{}
    }
    
    /**
     获取阅读章节模型
     */
    func GetReadChapterModel(_ readChapterListModel:HJReadChapterListModel) ->HJReadChapterModel {
        
        // 从缓存里面获取文件
        let tempReadChapterModel = ReadKeyedUnarchiver(readPageController.readModel.bookID, fileName: readChapterListModel.chapterID) as! HJReadChapterModel
        
        // 更新字体
        tempReadChapterModel.updateFont()
        
        // 计算高度
//        readChapterListModel.chapterHeight = HJReadParser.parserReadContentHeight(tempReadChapterModel.chapterContent, configure: HJReadConfigureManger.shareManager, width: ScreenWidth - HJReadViewLeftSpace - HJReadViewRightSpace)
        
        readChapterListModel.chapterHeight = (CGFloat(tempReadChapterModel.pageCount.floatValue) * (tableView.height + HJSpaceThree)) as NSNumber
        
        return tempReadChapterModel
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    deinit{
        
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        readBottomStatusView.removeTimer()
    }
    
}
