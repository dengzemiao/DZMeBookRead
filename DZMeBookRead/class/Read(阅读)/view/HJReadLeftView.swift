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
    @objc optional func readLeftView(_ readLeftView:HJReadLeftView,clickReadChapterModel model:HJReadChapterListModel)
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
    
    override init() {
        super.init()
        
        // 合并
        myWindow.addSubview(coverButton)
        
        // 添加隐藏手势
        coverButton.addTarget(self, action: #selector(HJReadLeftView.clickCoverButton), for: UIControlEvents.touchUpInside)
        
        // 添加tableView
        myWindow.addSubview(tableView)
    }
    
    // MARK: -- TableView
    
    // MARK: -- UITableViewDelegate UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        return 30
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let sectionHeader = HJReadLeftHeaderView()
        
        return sectionHeader
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        tableView.scrollViewWillDisplayCell(cell)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let model = dataArray[indexPath.row]
        
        delegate?.readLeftView?(self, clickReadChapterModel: model)
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
    
    deinit{
        myWindow.removeFromSuperview()
        coverButton.removeFromSuperview()
    }
}
