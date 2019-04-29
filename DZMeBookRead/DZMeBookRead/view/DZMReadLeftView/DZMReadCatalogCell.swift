//
//  DZMReadCatalogCell.swift
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/4/25.
//  Copyright © 2019年 DZM. All rights reserved.
//

import UIKit

class DZMReadCatalogCell: UITableViewCell {

    private(set) var chapterName:UILabel!
    
    private(set) var spaceLine:UIView!
    
    class func cell(_ tableView:UITableView) ->DZMReadCatalogCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "DZMReadCatalogCell")
        
        if cell == nil {
            
            cell = DZMReadCatalogCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "DZMReadCatalogCell")
        }
        
        return cell as! DZMReadCatalogCell
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        backgroundColor = UIColor.clear
        
        addSubviews()
    }
    
    private func addSubviews() {
        
        chapterName = UILabel()
        chapterName.font = DZM_FONT_SA_14
        chapterName.textColor = DZM_COLOR_145_145_145
        contentView.addSubview(chapterName)
        
        spaceLine = SpaceLine(contentView, DZM_COLOR_230_230_230)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let w = frame.size.width
        let h = frame.size.height
        
        chapterName.frame = CGRect(x: DZM_SPACE_SA_15, y: 0, width: w - DZM_SPACE_SA_30, height: h)
        
        spaceLine.frame = CGRect(x: DZM_SPACE_SA_15, y: h - DZM_SPACE_LINE, width: w - DZM_SPACE_SA_30, height: DZM_SPACE_LINE)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
