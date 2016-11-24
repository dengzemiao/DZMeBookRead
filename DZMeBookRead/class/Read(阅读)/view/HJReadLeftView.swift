//
//  HJReadLeftView.swift
//  HJProject
//
//  Created by 邓泽淼 on 16/8/15.
//  Copyright © 2016年 HanJue. All rights reserved.
//

private let TableViewW:CGFloat = ScreenWidth * 0.6

import UIKit

@objc protocol HJReadLeftViewDelegate:NSObjectProtocol {
    
    /// 点击章节模型
    @objc optional func readLeftView(_ readLeftView:HJReadLeftView,clickReadChapterModel model:HJReadChapterListModel, chapterLookPageClear:Bool)
}

class HJReadLeftView: NSObject,UITableViewDelegate,UITableViewDataSource,HJReadLeftHeaderViewDelegate {
    
    /// 阅读控制器
    weak var readPageController:HJReadPageController! {
        
        didSet{ // 初始化创建的时候需要经过该方法
            
            showDataWithType()
        }
    }
    
    /// 当前页面的隐藏
    var hidden:Bool = false
    
    // 代理
    weak var delegate:HJReadLeftViewDelegate?
    
    // 显示数据类型
    var readLeftViewType: HJReadLeftViewType = HJReadLeftViewType.allChapters
        {
        didSet{ // 切换type进过该方法
           
            showDataWithType()
        }
    }
    
    // 根据类型显示数据
    func showDataWithType() {
        
        if (readPageController == nil) {return}
        
        if (readLeftViewType == HJReadLeftViewType.allChapters) {
            
            dataArray = readPageController.readModel.readChapterListModels
            
            tableView.reloadData()
            
            // 重新选中
            scrollToRow()
            
        }else{
            
            dataArray = readPageController.readModel.readBookMarks
            
            tableView.reloadData()
            
            tableView.contentOffset = CGPoint.zero
        }
    }
    
    // 刷新书签数据
    func readBookMarksReloaData() {
        
        if (readLeftViewType == HJReadLeftViewType.allBookMarks) {
            
            showDataWithType()
        }
    }
    
    /// 数据源
    var dataArray:[AnyObject] = [AnyObject]()
    
    /// 切换章节进行居中
    var scrollRow:Int = 0 {
        
        didSet{
            
            if (scrollRow == 0 || (scrollRow != oldValue)) {
                
                scrollToRow()
            }
        }
    }
    
    func scrollToRow() {
        
        if (readLeftViewType == HJReadLeftViewType.allChapters && !dataArray.isEmpty) { // 章节列表
            
            tableView.scrollToRow(at: IndexPath(row: scrollRow,section: 0), at: UITableViewScrollPosition.middle, animated: false)
        }
    }
    
    /// tableView
    lazy var tableView:HJTableView = {
        
        let tableView = HJTableView()
        
        tableView.backgroundColor = UIColor.white
        
        tableView.frame = CGRect(x: -TableViewW, y: 0, width: TableViewW, height: ScreenHeight)
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
        tableView.separatorStyle = .none
        
        tableView.showsVerticalScrollIndicator = false
        
        tableView.showsHorizontalScrollIndicator = false
        
        return tableView
        
    }()
    
    lazy var headerView:HJReadLeftHeaderView = {
       
        let headerView:HJReadLeftHeaderView = HJReadLeftHeaderView()
        
        return headerView
        
    }()
    
    override init() {
        super.init()
        
        // 合并
        myWindow.addSubview(coverButton)
        
        // 添加隐藏手势
        coverButton.addTarget(self, action: #selector(HJReadLeftView.clickCoverButton), for: UIControlEvents.touchUpInside)
        
        // 添加tableView
        myWindow.addSubview(tableView)
        
        // 顶部view
        headerView.delegate = self
    }
    
    // MARK: -- TableView
    
    // MARK: -- UITableViewDelegate UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if (readLeftViewType == HJReadLeftViewType.allChapters) { // 全部章节
            
            let cell = HJReadLeftViewCell.cellWithTableView(tableView)
            
            let model = dataArray[indexPath.row] as! HJReadChapterListModel
            
            cell.textLabel?.text = model.chapterName
            
            cell.textLabel?.textColor = HJReadTextColor

//            if (model.isDownload.boolValue) { // 下载了
//
//
//            }else{ // 该章节没下载
//
//                cell.textLabel?.textColor = UIColor.grayColor()
//            }
           
            return cell
            
        }else{ // 书签
            
            let cell = HJReadLeftBookMarkCell.cellWithTableView(tableView)
            
            cell.markModel = dataArray[indexPath.row] as! HJReadMarkModel
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if (readLeftViewType == HJReadLeftViewType.allChapters) { // 全部章节
            
            return 44
            
        }else{
            
            return 120
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return self.headerView
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        tableView.scrollViewWillDisplayCell(cell)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (readLeftViewType == HJReadLeftViewType.allChapters) { // 全部章节
            
            let model = dataArray[indexPath.row] as! HJReadChapterListModel
            
            delegate?.readLeftView?(self, clickReadChapterModel: model, chapterLookPageClear:true)
            
        }else{ // 书签
            
            let model = dataArray[indexPath.row] as! HJReadMarkModel
            let page = model.GetCurrentPage()
            
            readPageController.readModel.readRecord.page = NSNumber(value:page)
            
            readPageController.readSetup.readLeftView(self, clickReadChapterModel: readPageController.readConfigure.GetReadChapterListModel(model.chapterID)!, chapterLookPageClear:false)
            
            readPageController.readSetup.RFHidden(true)
        }
    }
    
    // MARK: -- 删除操作
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if (readLeftViewType == HJReadLeftViewType.allChapters) { // 全部章节
            
            return false
            
        }else{ // 书签
            
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        if (readLeftViewType == HJReadLeftViewType.allChapters) { // 全部章节
            
        }else{ // 书签
            
            if editingStyle == UITableViewCellEditingStyle.delete { // 删除
                
                // 删除记录数据
                readPageController.readModel.readBookMarks.remove(at: indexPath.row)
                
                // 删除当前数据
                dataArray.remove(at: indexPath.row)
                
                tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
                
                // 保存同步
                HJReadModel.updateReadModel(readPageController.readModel)
                
                // 刷新书签
                readPageController.readConfigure.checkCurrentPageIsReadMark()
            }
        }
    }
    
    // MARK: -- UIWindow 相关
    
    /// 创建Window
    fileprivate lazy var myWindow:UIWindow = {
        
        // 初始化window
       let myWindow = UIWindow(frame: UIScreen.main.bounds)
        
        myWindow.backgroundColor = UIColor.clear
        
        // 遮住状态 不需要遮住去掉即可
        myWindow.windowLevel = UIWindowLevelAlert
        
        myWindow.isHidden = true
    
        return myWindow
    }()
    
    /// 创建遮盖按钮
    fileprivate lazy var coverButton:UIButton = {
        
        // 初始化遮盖按钮
        let coverButton = UIButton(type:UIButtonType.custom)
        
        coverButton.frame = UIScreen.main.bounds
        
        coverButton.backgroundColor = UIColor.black
        
        coverButton.alpha = 0
        
        return coverButton
    }()
    
    /// 点击隐藏按钮
    func clickCoverButton() {
        
        leftView(true, animated: true)
    }
    
    /// 显示操作
    func leftView(_ hidden:Bool,animated:Bool) {
        
        self.hidden = hidden
        
        let animateDuration = animated ? AnimateDuration : 0
        
        if hidden {
            
            UIView.animate(withDuration: animateDuration, animations: { [weak self] ()->() in
                
                self?.tableView.frame = CGRect(x: -TableViewW, y: 0, width: TableViewW, height: ScreenHeight)
                self?.coverButton.alpha = 0
                
                }, completion: { [weak self] (isOK) in
                    
                    self?.myWindow.isHidden = hidden
            })
            
        }else{
            
            myWindow.isHidden = hidden
            
            UIView.animate(withDuration: animateDuration, animations: {[weak self] ()->() in
                
                self?.tableView.frame = CGRect(x: 0, y: 0, width: TableViewW, height: ScreenHeight)
                self?.coverButton.alpha = 0.6
            }) 
        }
    }
    
    // MARK: -- HJReadLeftHeaderViewDelegate
    
    func readLeftHeaderView(_ readLeftHeaderView: HJReadLeftHeaderView, type: HJReadLeftViewType) {
        
        readLeftViewType = type
    }
    
    deinit{
        myWindow.removeFromSuperview()
        coverButton.removeFromSuperview()
    }
}
