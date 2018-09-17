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
    
    /// 记录当前已经加载或正在加载的章节列表 以免重复操作
    private var willLoadDataArray:[String] = []
    
    /// 当前阅读View(上下滚动不能使用)
    private weak var readView:DZMReadView?
    
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
        topStatusView.textColor = DZMColor_127_136_138
        topStatusView.font = DZMFont_12
        topStatusView.frame = CGRect(x: DZMSpace_15, y: (isX ? TopLiuHeight : 0), width: view.width - 2 * DZMSpace_15, height: DZMSpace_25)
        view.addSubview(topStatusView)
        
        // BottomStatusView
        bottomStatusView = DZMRMStatusView(frame:CGRect(x: DZMSpace_15, y: view.frame.height - DZMSpace_25, width: view.width - 2 * DZMSpace_15, height: DZMSpace_25))
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
        tableView.bounces = false
        tableView.estimatedRowHeight = 0
        tableView.estimatedSectionFooterHeight = 0
        tableView.estimatedSectionHeaderHeight = 0
        tableView.frame = GetReadTableViewFrame()
        view.addSubview(tableView)
        
        // 设置数据源
        if DZMReadConfigure.shared().effectType == DZMRMEffectType.upAndDown.rawValue && readRecordModel.readChapterModel != nil {
            
            dataArray.append(readRecordModel.readChapterModel!.id)
            
            willLoadDataArray.append(readRecordModel.readChapterModel!.id)
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
            
            tableView.clipsToBounds = false
            
        }else{ // 上下滚动
            
            tableView.isScrollEnabled = true
            
            tableView.clipsToBounds = true
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
            
            cell.content = readRecordModel.readChapterModel!.stringAttr(page: readRecordModel.page.intValue)
            
            readView = cell.readView
            
            readView?.openLongMenu = readController.openLongMenu
            
            return cell
            
        }else{ // 上下滚动
            
            let cell = DZMReadViewCell.cellWithTableView(tableView)
            
            let readChapterModel = DZMReadChapterModel.readChapterModel(bookID: readRecordModel.bookID, chapterID: dataArray[indexPath.section], isUpdateFont: true)
            
            cell.content = readChapterModel.stringAttr(page: indexPath.row)
            
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
        
        if DZMReadConfigure.shared().effectType == DZMRMEffectType.upAndDown.rawValue { // 上下滚动
            
            // 获得当前模型
            let readChapterModel = DZMReadChapterModel.readChapterModel(bookID: readRecordModel.bookID, chapterID: dataArray[section], isUpdateFont: true)
            
            // 预加载数据
            reloadDataArray(readChapterModel: readChapterModel)
        }
    }
    
    // MARK: -- 预处理数据源
    
    /// 动态添加数据源
    func reloadDataArray(readChapterModel:DZMReadChapterModel) {
        
        /*
         网络小说操作提示:
         
         再下面判断中 检查是否章节存在 不存在则请求回来之后再加入到列表
         
         提示: 这里都是预加载数据 所以网络请求可以不使用 HUD 阻挡
         */
        
        // 上一章ID
        let lastChapterId = readChapterModel.lastChapterId
        
        // 下一章ID
        let nextChapterId = readChapterModel.nextChapterId
        
        // 加载上一章
        if lastChapterId != nil && !willLoadDataArray.contains(lastChapterId!) {
            
            willLoadDataArray.append(lastChapterId!)
            
            // 异步处理
            DispatchQueue.global().async { [weak self] () in
                
                // 是否存在上一章ID
                if !self!.dataArray.contains(lastChapterId!) {
                    
                    // 获取上一章模型
                    let readChapterModel = DZMReadChapterModel.readChapterModel(bookID: readChapterModel.bookID, chapterID: lastChapterId!, isUpdateFont: true)
                    
                    // 回到主线程更新UI
                    DispatchQueue.main.async {
                        
                        self?.dataArray.insert(readChapterModel.id, at: 0)
                        
                        self?.tableView.reloadData()
                        
                        self?.tableView.contentOffset = CGPoint(x: 0,y: self!.tableView.contentOffset.y + CGFloat(readChapterModel.pageCount.intValue) * GetReadTableViewFrame().height)
                    }
                }
            }
        }
        
        // 加载下一章
        if nextChapterId != nil && !willLoadDataArray.contains(nextChapterId!) {
            
            willLoadDataArray.append(nextChapterId!)
            
            // 异步处理
            DispatchQueue.global().async { [weak self] () in
                
                // 是否存在上一章ID
                if !self!.dataArray.contains(nextChapterId!) {
                    
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
                var indexPath = tableView.indexPathsForRows(in: CGRect(x: 0, y: tableView.contentOffset.y + DZMSpace_15, width: rect.width, height: rect.height - DZMSpace_15))!.first!
                
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
    
    // MARK: 光标拖拽手势
    
    /// 触摸开始
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

        drag(touches: touches, status: .begin)
    }
    
    /// 触摸移动
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {

        drag(touches: touches, status: .changed)
    }
    
    /// 触摸结束
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {

        drag(touches: touches, status: .end)
    }
    
    /// 触摸取消
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {

        drag(touches: touches, status: .end)
    }
    
    /// 解析触摸事件
    private func drag(touches: Set<UITouch>, status: DZMPanStatus) {
        
        if readView?.isOpenDrag ?? false {
            
            let point = ((touches as NSSet).anyObject() as? UITouch)?.location(in: view)
            
            if point != nil {
                
                readView?.drag(status: status, point: view.convert(point!, to: readView), windowPoint: point!)
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
