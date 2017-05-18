//
//  DZMRMLeftView.swift
//  DZMeBookRead
//
//  Created by 邓泽淼 on 2017/5/15.
//  Copyright © 2017年 DZM. All rights reserved.
//

import UIKit

class DZMRMLeftView: DZMRMBaseView,DZMSegmentedControlDelegate,UITableViewDelegate,UITableViewDataSource {
    
    /// topView
    private(set) var topView:DZMSegmentedControl!
    
    /// UITableView
    private(set) var tableView:UITableView!
    
    /// contentView
    private(set) var contentView:UIView!
    
    /// 类型 0: 章节 1: 书签
    private var type:NSInteger = 0
    
    override func addSubviews() {
        
        super.addSubviews()
        
        // contentView
        contentView = UIView()
        contentView.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        addSubview(contentView)
        
        // UITableView
        tableView = UITableView()
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = GetReadTableViewFrame()
        contentView.addSubview(tableView)
        
        // topView
        topView = DZMSegmentedControl()
        topView.delegate = self
        topView.normalTitles = ["章节","书签"]
        topView.selectTitles = ["章节","书签"]
        topView.horizontalShowTB = false
        topView.backgroundColor = UIColor.clear
        topView.normalTitleColor = DZMColor_6
        topView.selectTitleColor = DZMColor_2
        topView.setup()
        contentView.addSubview(topView)
    }
    
    // MARK: -- DZMSegmentedControlDelegate
    func segmentedControl(segmentedControl: DZMSegmentedControl, clickButton button: UIButton, index: NSInteger) {
        
        type = index
        
        tableView.reloadData()
    }
    
    /// 布局
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        // contentView
        let contentViewW:CGFloat = width * 0.6
        contentView.frame = CGRect(x: -contentViewW, y: 0, width: contentViewW, height: height)
        
        // topView
        let topViewH:CGFloat = 33
        topView.frame = CGRect(x: 0, y: 0, width: contentViewW, height: topViewH)
        
        // tableView
        tableView.frame = CGRect(x: 0, y: topViewH, width: contentView.width, height: height - topViewH)
    }
    
    // MARK: -- UITableViewDelegate,UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if type == 0 { // 章节
            
            return (readMenu.vc.readModel != nil ? readMenu.vc.readModel.readChapterListModels.count : 0)
            
        }else{ // 书签
            
            return (readMenu.vc.readModel != nil ? readMenu.vc.readModel.readMarkModels.count : 0)
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "DZMRMLeftViewCell")
        
        if cell == nil {
            
            cell = UITableViewCell(style: .default, reuseIdentifier: "DZMRMLeftViewCell")
            
            cell?.selectionStyle = .none
            
            cell?.backgroundColor = UIColor.clear
        }
        
        if type == 0 { // 章节
            
            cell?.textLabel?.text = readMenu.vc.readModel.readChapterListModels[indexPath.row].name
            
            cell?.textLabel?.numberOfLines = 1
            
            cell?.textLabel?.font = DZMFont_18
            
        }else{ // 书签
            
            let readMarkModel = readMenu.vc.readModel.readMarkModels[indexPath.row]
            
            cell?.textLabel?.text = "\n\(readMarkModel.name!)\n\(GetTimerString(dateFormat: "YYYY-MM-dd HH:mm:ss", date: readMarkModel.time!))\n\(readMarkModel.content!))"
            
            cell?.textLabel?.numberOfLines = 0
            
            cell?.textLabel?.font = DZMFont_12
        }
        
        cell?.textLabel?.textColor = DZMColor_6
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        if type == 0 { // 章节
            
            return 44
            
        }else{ // 书签
            
            return 120
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if type == 0 { // 章节
            
            readMenu.delegate?.readMenuClickChapterList?(readMenu: readMenu, readChapterListModel: readMenu.vc.readModel.readChapterListModels[indexPath.row])
            
        }else{ // 书签
            
            readMenu.delegate?.readMenuClickMarkList?(readMenu: readMenu, readMarkModel: readMenu.vc.readModel.readMarkModels[indexPath.row])
        }
        
        // 隐藏
        readMenu.leftView(isShow: false, complete: nil)
    }
    
    // MARK: -- 删除操作
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        if type == 0 { // 章节
            
            return false
            
        }else{ // 书签
            
            return true
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let _ = readMenu.vc.readModel.removeMark(readMarkModel: nil, index: indexPath.row)
        
        tableView.deleteRows(at: [indexPath], with: UITableViewRowAnimation.fade)
    }
}
