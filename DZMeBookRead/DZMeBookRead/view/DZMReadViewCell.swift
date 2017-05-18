//
//  DZMReadViewCell.swift
//  DZMeBookRead
//
//  Created by 邓泽淼 on 2017/5/15.
//  Copyright © 2017年 DZM. All rights reserved.
//

import UIKit

class DZMReadViewCell: UITableViewCell {
    
    /// 阅读View 显示使用
    private var readView:DZMReadView!
    
    /// 当前的显示的内容
    var content:String! {
        
        didSet{
            
            if !content.isEmpty { // 有值
                
                readView.content = content
            }
        }
    }
    
    class func cellWithTableView(_ tableView:UITableView) ->DZMReadViewCell {
        
        let ID = "DZMReadViewCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: ID) as? DZMReadViewCell
        
        if (cell == nil) {
            
            cell = DZMReadViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: ID)
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
        
        // 阅读View
        readView = DZMReadView()
        
        readView.backgroundColor = UIColor.clear
        
        contentView.addSubview(readView)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        // 布局
        readView.frame = GetReadViewFrame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
