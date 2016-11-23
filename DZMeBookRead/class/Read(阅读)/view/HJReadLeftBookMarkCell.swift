//
//  HJReadLeftBookMarkCell.swift
//  DZMeBookRead
//
//  Created by 邓泽淼 on 2016/11/23.
//  Copyright © 2016年 DZM. All rights reserved.
//

import UIKit

class HJReadLeftBookMarkCell: UITableViewCell {

    /// 分割线
    var spaceLine:UIView!
    
    // 标题Label
    var titleLabel:UILabel!
    
    // 时间
    var timeLabel:UILabel!
    
    // 内容
    var contentLabel:UILabel!
    
    var markModel:HJReadMarkModel! {
        didSet{
            
            titleLabel.text = markModel.chapterName
            
            timeLabel.text = GetTimerString("YYYY年MM月dd日 HH:mm:ss", date: markModel.time!)
            
            contentLabel.text = markModel.content
        }
    }
    
    class func cellWithTableView(_ tableView:UITableView) ->HJReadLeftBookMarkCell {
        
        let ID = "HJReadLeftBookMarkCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: ID) as? HJReadLeftBookMarkCell
        
        if (cell == nil) {
            
            cell = HJReadLeftBookMarkCell(style: UITableViewCellStyle.default, reuseIdentifier: ID);
        }
        
        return cell!
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = UITableViewCellSelectionStyle.none
        
        addSubViews()
    }
    
    func addSubViews() {
        
        // titleLabel
        titleLabel = UILabel()
        titleLabel.font = UIFont.systemFont(ofSize: 15)
        titleLabel.textColor = RGB(100, g: 100, b: 100)
        contentView.addSubview(titleLabel)
        
        // timeLabel
        timeLabel = UILabel()
        timeLabel.font = UIFont.systemFont(ofSize: 13)
        timeLabel.textColor = UIColor.gray
        contentView.addSubview(timeLabel)
        
        // contentLabel
        contentLabel = UILabel()
        contentLabel.numberOfLines = 0
        contentLabel.font = UIFont.systemFont(ofSize: 14)
        contentLabel.textColor = UIColor.gray
        contentView.addSubview(contentLabel)
        
        // 分割线
        spaceLine = SpaceLineSetup(contentView, color: HJColor_6)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        titleLabel.frame = CGRect(x: HJSpaceThree, y: HJSpaceThree, width: width - 2*HJSpaceThree, height: 25)
        
        timeLabel.frame = CGRect(x: HJSpaceThree, y: titleLabel.frame.maxY + HJSpaceThree, width: width - 2*HJSpaceThree, height: 15)
        
        let contentLabelY = timeLabel.frame.maxY + HJSpaceThree
        contentLabel.frame = CGRect(x: HJSpaceThree, y: contentLabelY, width: width - 2*HJSpaceThree, height: height - contentLabelY - HJSpaceThree)
        
        spaceLine.frame = CGRect(x: 0, y: height - HJSpaceLineHeight, width: width, height: HJSpaceLineHeight)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
