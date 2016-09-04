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
    optional func readLeftView(readLeftView:HJReadLeftView,clickReadChapterModel model:HJReadChapterListModel)
}

class HJReadLeftView: NSObject,UITableViewDelegate,UITableViewDataSource {
    
    /// 当前页码的隐藏
    var hidden:Bool = false
    
    weak var delegate:HJReadLeftViewDelegate?
    
    /// 数据
    var dataArray:[HJReadChapterListModel] = [] {
        
        didSet{
            
            tableView.reloadData()
        }
    }
    
    /// 切换章节进行居中
    var scrollRow:Int = 0 {
        
        didSet{
            
            tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: scrollRow,inSection: 0), atScrollPosition: UITableViewScrollPosition.Middle, animated: false)
        }
    }
    
    /// tableView
    lazy var tableView:HJTableView = {
        
        let tableView = HJTableView()
        
        tableView.backgroundColor = UIColor.whiteColor()
        
        tableView.frame = CGRectMake(-TableViewW, 0, TableViewW, ScreenHeight)
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
        tableView.separatorStyle = .None
        
        tableView.showsVerticalScrollIndicator = false
        
        tableView.showsHorizontalScrollIndicator = false
        
        return tableView
        
    }()
    
    override init() {
        super.init()
        
        // 合并
        myWindow.addSubview(coverButton)
        
        // 添加隐藏手势
        coverButton.addTarget(self, action: #selector(HJReadLeftView.clickCoverButton), forControlEvents: UIControlEvents.TouchUpInside)
        
        // 添加tableView
        myWindow.addSubview(tableView)
    }
    
    // MARK: -- TableView
    
    // MARK: -- UITableViewDelegate UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = HJReadLeftViewCell.cellWithTableView(tableView)
        
        let model = dataArray[indexPath.row]
        
        cell.textLabel?.text = model.chapterName
        
        cell.textLabel?.textColor = HJReadTextColor
//        
//        if (model.isDownload.boolValue) { // 下载了
//            
//            
//        }else{ // 该章节没下载
//            
//            cell.textLabel?.textColor = UIColor.grayColor()
//        }
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionHeader = HJReadLeftHeaderView()
        
        return sectionHeader
    }
    
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        tableView.scrollViewWillDisplayCell(cell)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let model = dataArray[indexPath.row]
        
        delegate?.readLeftView?(self, clickReadChapterModel: model)
    }
    
    // MARK: -- UIWindow 相关
    
    /// 创建Window
    private lazy var myWindow:UIWindow = {
        
        // 初始化window
       let myWindow = UIWindow(frame: UIScreen.mainScreen().bounds)
        
        myWindow.backgroundColor = UIColor.clearColor()
        
        // 遮住状态 不需要遮住去掉即可
        myWindow.windowLevel = UIWindowLevelAlert
        
        myWindow.hidden = true
    
        return myWindow
    }()
    
    /// 创建遮盖按钮
    private lazy var coverButton:UIButton = {
        
        // 初始化遮盖按钮
        let coverButton = UIButton(type:UIButtonType.Custom)
        
        coverButton.frame = UIScreen.mainScreen().bounds
        
        coverButton.backgroundColor = UIColor.blackColor()
        
        coverButton.alpha = 0
        
        return coverButton
    }()
    
    /// 点击隐藏按钮
    func clickCoverButton() {
        
        leftView(true, animated: true)
    }
    
    /// 显示操作
    func leftView(hidden:Bool,animated:Bool) {
        
        self.hidden = hidden
        
        let animateDuration = animated ? AnimateDuration : 0
        
        if hidden {
            
            UIView.animateWithDuration(animateDuration, animations: { [weak self] ()->() in
                
                self?.tableView.frame = CGRectMake(-TableViewW, 0, TableViewW, ScreenHeight)
                self?.coverButton.alpha = 0
                
                }, completion: { [weak self] (isOK) in
                    
                    self?.myWindow.hidden = hidden
            })
            
        }else{
            
            myWindow.hidden = hidden
            
            UIView.animateWithDuration(animateDuration) {[weak self] ()->() in
                
                self?.tableView.frame = CGRectMake(0, 0, TableViewW, ScreenHeight)
                self?.coverButton.alpha = 0.6
            }
        }
    }
    
    deinit{
        myWindow.removeFromSuperview()
        coverButton.removeFromSuperview()
    }
}
