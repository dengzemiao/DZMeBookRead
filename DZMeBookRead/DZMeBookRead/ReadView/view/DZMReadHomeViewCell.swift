//
//  DZMReadHomeViewCell.swift
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/5/7.
//  Copyright © 2019 DZM. All rights reserved.
//

import UIKit

class DZMReadHomeViewCell: UITableViewCell {

    /// 书籍首页视图
    private(set) var homeView:DZMReadHomeView!
    
    class func cell(_ tableView:UITableView) ->DZMReadHomeViewCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "DZMReadHomeViewCell")
        
        if cell == nil {
            
            cell = DZMReadHomeViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "DZMReadHomeViewCell")
        }
        
        return cell as! DZMReadHomeViewCell
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        backgroundColor = UIColor.clear
        
        addSubviews()
    }
    
    private func addSubviews() {
        
        // 书籍首页
        homeView = DZMReadHomeView()
        contentView.addSubview(homeView)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        homeView.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
