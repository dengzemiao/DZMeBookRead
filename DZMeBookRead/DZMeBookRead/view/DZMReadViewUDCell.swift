//
//  DZMReadViewUDCell.swift
//  DZMeBookRead
//
//  Created by 邓泽淼 on 2017/5/16.
//  Copyright © 2017年 DZM. All rights reserved.
//

import UIKit

class DZMReadViewUDCell: UITableViewCell,UITableViewDelegate,UITableViewDataSource {
    
    /// UITableView
    var tableView:UITableView!
    
    /// DZMReadChapterModel
    var readChapterModel:DZMReadChapterModel? {
        
        didSet{
            
            tableView.reloadData()
            
            setNeedsLayout()
        }
    }
    
    class func cellWithTableView(_ tableView:UITableView) ->DZMReadViewUDCell {
        
        let ID = "DZMReadViewUDCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: ID) as? DZMReadViewUDCell
        
        if (cell == nil) {
            
            cell = DZMReadViewUDCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: ID)
        }
        
        return cell!
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        backgroundColor = UIColor.clear
        
        addSubViews()
    }
    
    func addSubViews() {
        
        // UITableView
        tableView = UITableView()
        tableView.backgroundColor = UIColor.clear
        tableView.isScrollEnabled = false
        tableView.separatorStyle = .none
        tableView.delegate = self
        tableView.dataSource = self
        contentView.addSubview(tableView)
    }
    
    // MARK: -- UITableViewDelegate,UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return readChapterModel != nil ? readChapterModel!.pageCount.intValue : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = DZMReadViewCell.cellWithTableView(tableView)
        
        cell.content = readChapterModel!.string(page: indexPath.row)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return GetReadTableViewFrame().height
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        tableView.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
    
}
