//
//  DZMReadMarkCell.swift
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/4/25.
//  Copyright © 2019年 DZM. All rights reserved.
//

import UIKit

/// mark cell 高度
let DZM_READ_MARK_CELL_HEIGHT:CGFloat = DZM_SPACE_SA_100

class DZMReadMarkCell: UITableViewCell {

    private var title:UILabel!
    
    private var time:UILabel!
    
    private var content:UILabel!
    
    private(set) var spaceLine:UIView!
    
    var markModel:DZMReadMarkModel! {
        
        didSet{
            
            title.text = markModel.name
            
            time.text = TimerString(markModel.time.intValue)
            
            content.attributedText = TextLineSpacing(markModel.content, DZM_SPACE_5)
        }
    }
    
    class func cell(_ tableView:UITableView) ->DZMReadMarkCell {
        
        var cell = tableView.dequeueReusableCell(withIdentifier: "DZMReadMarkCell")
        
        if cell == nil {
            
            cell = DZMReadMarkCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "DZMReadMarkCell")
        }
        
        return cell as! DZMReadMarkCell
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        
        backgroundColor = UIColor.clear
        
        addSubviews()
    }
    
    private func addSubviews() {
        
        title = UILabel()
        title.font = DZM_FONT_SA_14
        title.textColor = DZM_COLOR_145_145_145
        contentView.addSubview(title)
        
        time = UILabel()
        time.font = DZM_FONT_SA_12
        time.textColor = DZM_COLOR_145_145_145
        time.textAlignment = .right
        contentView.addSubview(time)
        
        content = UILabel()
        content.font = DZM_FONT_SA_14
        content.textColor = DZM_COLOR_145_145_145
        content.numberOfLines = 0
        contentView.addSubview(content)
   
        spaceLine = SpaceLine(contentView, DZM_COLOR_230_230_230)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        let w = frame.size.width
        let h = frame.size.height
        
        let itemX = DZM_SPACE_SA_15
        let itemY = DZM_SPACE_SA_15
        let itemH = DZM_SPACE_SA_20
        let contentW = w - 2*itemX
        let contentY = itemY + itemH + DZM_SPACE_SA_10
        let itemW = (contentW - DZM_SPACE_SA_10) / 2
        
        
        title.frame = CGRect(x: itemX, y: itemY, width: itemW, height: itemH)
        
        time.frame = CGRect(x: w - itemW - itemX, y: itemY, width: itemW, height: itemH)
        
        content.frame = CGRect(x: itemX, y: contentY, width: contentW, height: DZM_READ_MARK_CELL_HEIGHT - contentY - DZM_SPACE_SA_15)
        
        spaceLine.frame = CGRect(x: DZM_SPACE_SA_15, y: h - DZM_SPACE_LINE, width: w - DZM_SPACE_SA_30, height: DZM_SPACE_LINE)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
