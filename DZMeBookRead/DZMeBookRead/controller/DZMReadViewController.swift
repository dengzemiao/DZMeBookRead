//
//  DZMReadViewController.swift
//  DZMeBookRead
//
//  Created by 邓泽淼 on 2017/5/12.
//  Copyright © 2017年 DZM. All rights reserved.
//

import UIKit

class DZMReadViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    /// 临时阅读记录
    var readRecordModel:DZMReadRecordModel!
    
    /// 阅读控制器
    weak var readController:DZMReadController!
    
    /// 顶部状态栏
    private(set) var topStatusView:UILabel!
    
    /// 底部状态栏
    private(set) var bottomStatusView:DZMRMStatusView!
    
    /// TableView
    private(set) var tableView:UITableView!
    
    /// 阅读列表
    private var dataArray:[String] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // 添加子控件
        addSubviews()
        
        // 配置背景颜色
        configureBGColor()
        
        // 配置阅读模式
        configureReadEffect()
        
        // 配置阅读记录
        configureReadRecordModel()
    }
    
    /// 创建UI
    func addSubviews() {
        
        // TopStatusView
        topStatusView = UILabel()
        topStatusView.text = readRecordModel.readChapterModel?.name
        topStatusView.lineBreakMode = .byTruncatingMiddle
        topStatusView.textColor = DZMColor_4
        topStatusView.font = DZMFont_12
        topStatusView.frame = CGRect(x: DZMSpace_1, y: 0, width: view.width - 2 * DZMSpace_1, height: DZMSpace_2)
        view.addSubview(topStatusView)
        
        // BottomStatusView
        bottomStatusView = DZMRMStatusView(frame:CGRect(x: DZMSpace_1, y: view.frame.height - DZMSpace_2, width: view.width - 2 * DZMSpace_1, height: DZMSpace_2))
        bottomStatusView.backgroundColor = UIColor.clear
        bottomStatusView.titleLabel.text = "\(readRecordModel.page.intValue + 1)/\(readRecordModel.readChapterModel!.pageCount.intValue)"
        view.addSubview(bottomStatusView)
        
        // UITableView
        tableView = UITableView()
        tableView.backgroundColor = UIColor.clear
        tableView.showsVerticalScrollIndicator = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.frame = GetReadTableViewFrame()
        view.addSubview(tableView)
        
        // 设置数据源
        if DZMReadConfigure.shared().effectType == DZMRMEffectType.upAndDown.rawValue && readRecordModel.readChapterModel != nil {
            
            dataArray.append(readRecordModel.readChapterModel!.id)
        }
    }
    
    // MARK: -- 配置背景颜色
    
    /// 配置背景颜色
    func configureBGColor() {
        
        view.backgroundColor = DZMReadConfigure.shared().readColor()
    }
    
    // MARK: -- 阅读模式
    
    /// 配置阅读效果
    func configureReadEffect() {
        
        if DZMReadConfigure.shared().effectType != DZMRMEffectType.upAndDown.rawValue { // 非上下滚动
            
            tableView.isScrollEnabled = false
            
        }else{ // 上下滚动
            
            tableView.isScrollEnabled = true
        }
    }
    
    // MARK: -- 滚动到阅读记录
    
    /// 配置阅读记录
    func configureReadRecordModel() {
        
        if DZMReadConfigure.shared().effectType == DZMRMEffectType.upAndDown.rawValue { // 上下滚动
           
            tableView.contentOffset = CGPoint(x: tableView.contentOffset.x, y: CGFloat(readRecordModel.page.intValue) * GetReadTableViewFrame().height)
        }
    }
    
    // MARK: -- UITableViewDelegate,UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if DZMReadConfigure.shared().effectType != DZMRMEffectType.upAndDown.rawValue { // 非上下滚动
            
            return 1
            
        }else{ // 上下滚动
            
            return dataArray.count
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if DZMReadConfigure.shared().effectType != DZMRMEffectType.upAndDown.rawValue { // 非上下滚动
            
            return 1
            
        }else{ // 上下滚动
            
            let readChapterModel = DZMReadChapterModel.readChapterModel(bookID: readRecordModel.bookID, chapterID: dataArray[section], isUpdateFont: true)
            
            return readChapterModel.pageCount.intValue
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if DZMReadConfigure.shared().effectType != DZMRMEffectType.upAndDown.rawValue { // 非上下滚动
            
            let cell = DZMReadViewCell.cellWithTableView(tableView)
            
            cell.content = readRecordModel.readChapterModel!.string(page: readRecordModel.page.intValue)
            
            return cell
            
        }else{ // 上下滚动
            
            let cell = DZMReadViewCell.cellWithTableView(tableView)
            
            let readChapterModel = DZMReadChapterModel.readChapterModel(bookID: readRecordModel.bookID, chapterID: dataArray[indexPath.section], isUpdateFont: true)
            
            cell.content = readChapterModel.string(page: indexPath.row)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        return UIView()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return GetReadTableViewFrame().height
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 0.01
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        if DZMReadConfigure.shared().effectType == DZMRMEffectType.upAndDown.rawValue { // 非上下滚动
            
            // 获得当前模型
            let readChapterModel = DZMReadChapterModel.readChapterModel(bookID: readRecordModel.bookID, chapterID: dataArray[section], isUpdateFont: true)
            
            // 预加载数据
            reloadDataArray(readChapterModel: readChapterModel)
        }
    }
    
    // MARK: -- 预处理数据源
    
    /// 动态添加数据源
    func reloadDataArray(readChapterModel:DZMReadChapterModel) {
        
        // 上一章ID
        let lastChapterId = readChapterModel.lastChapterId
        
        // 下一章ID
        let nextChapterId = readChapterModel.nextChapterId
        
        // 异步处理
        DispatchQueue.global().async { [weak self] () in
            
            // 是否存在上一章ID
            if lastChapterId != nil && !self!.dataArray.contains(lastChapterId!) {
                
                // 获取上一章模型
                let readChapterModel = DZMReadChapterModel.readChapterModel(bookID: readChapterModel.bookID, chapterID: lastChapterId!, isUpdateFont: true)
                
                // 回到主线程更新UI
                DispatchQueue.main.async {
                    
                    self?.dataArray.insert(readChapterModel.id, at: 0)
                    
                    self?.tableView.reloadData()
                    
                    self?.tableView.contentOffset = CGPoint(x: 0,y: self!.tableView.contentOffset.y + CGFloat(readChapterModel.pageCount.intValue) * GetReadTableViewFrame().height)
                }
            }
            
            if nextChapterId != nil && !self!.dataArray.contains(nextChapterId!) {
                
                // 获取上一章模型
                let readChapterModel = DZMReadChapterModel.readChapterModel(bookID: readChapterModel.bookID, chapterID: nextChapterId!, isUpdateFont: true)
                
                // 回到主线程更新UI
                DispatchQueue.main.async {
                    
                    self?.dataArray.append(readChapterModel.id)
                    
                    self?.tableView.reloadData()
                }
            }
        }
    }
    
    // MARK: -- 更新阅读记录
    
    /// 正在拖动
    private var isDragging:Bool = false
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {isDragging = true}
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {isDragging = false}
    
    /// 滚动中
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 刷新记录
        if isDragging {updateReadRecordModel()}
    }
    
    /// 刷新阅读记录
    func updateReadRecordModel() {
        
        if (DZMReadConfigure.shared().effectType == DZMRMEffectType.upAndDown.rawValue) { // 上下滚动
            
            if tableView.indexPathsForVisibleRows != nil && !tableView.indexPathsForVisibleRows!.isEmpty { // 有Cell
                
                // 范围
                let rect = GetReadTableViewFrame()
                
                // 显示章节Cell IndexPath
                var indexPath = tableView.indexPathsForRows(in: CGRect(x: 0, y: tableView.contentOffset.y, width: rect.width, height: rect.height))!.first!
                
                // 章节ID
                let chapterID:String = "\(dataArray[indexPath.section])"
                
                // 页码
                let toPage:NSInteger = indexPath.row
                
                DispatchQueue.global().async { [weak self] ()->Void in
                    
                    if self!.readRecordModel.readChapterModel!.id == chapterID {
                        
                        // 修改页码
                        self!.readRecordModel.page = NSNumber(value: toPage)
                        
                    }else{
                        
                        // 修改章节
                        self!.readRecordModel.modify(chapterID: chapterID, toPage: toPage)
                    }
                    
                    // 保存
                    self!.readController.readOperation.readRecordUpdate(readRecordModel: self!.readRecordModel)
                    
                    // 更新UI
                    DispatchQueue.main.async { [weak self] ()->Void in
                        
                        // 修改顶部显示
                        self!.topStatusView.text = self!.readRecordModel.readChapterModel!.name
                        
                        // 修改底部显示
                        self!.bottomStatusView.titleLabel.text = "\(self!.readRecordModel.page.intValue + 1)/\(self!.readRecordModel.readChapterModel!.pageCount.intValue)"
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    deinit {
        
        // 释放该临时模型
        readRecordModel = nil
        
        // 移除定时器
        bottomStatusView?.removeTimer()
    }
}
