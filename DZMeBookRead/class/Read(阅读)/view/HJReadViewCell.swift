//
//  HJReadViewCell.swift
//  HJProject
//
//  Created by 邓泽淼 on 16/8/29.
//  Copyright © 2016年 HanJue. All rights reserved.
//

import UIKit

class HJReadViewCell: UITableViewCell {
    
    var readView:HJReadView!
    
    // 章节信息
    var readChapterListModel:HJReadChapterListModel?
    
    // 只有在上下滚动的时候才用得到
    var contentH:CGFloat = 0
    
    var content:String? {
        
        didSet{
            
            if content != nil && !content!.isEmpty { // 字符串有值
                
                let redFrame = HJReadParser.GetReadViewFrame()
                
                if HJReadConfigureManger.shareManager.flipEffect == HJReadFlipEffect.UpAndDown { // 上下滚动
                    
                    readView.frameRef = HJReadParser.parserRead(content!, configure: HJReadConfigureManger.shareManager, bounds: CGRectMake(0, 0, redFrame.width, contentH))
                    
                }else{
                    
                    readView.frameRef = HJReadParser.parserRead(content!, configure: HJReadConfigureManger.shareManager, bounds: CGRectMake(0, 0, redFrame.width, redFrame.height))
                }
                
                setNeedsLayout()
            }
        }
    }
    
    
    class func cellWithTableView(tableView:UITableView) ->HJReadViewCell {
        
        let ID = "HJReadViewCell"
        
        var cell = tableView.dequeueReusableCellWithIdentifier(ID) as? HJReadViewCell
        
        cell?.readChapterListModel = nil
        
        cell?.content = nil
        
        if (cell == nil) {
            
            cell = HJReadViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: ID);
        }
        
        return cell!
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clearColor()
        
        selectionStyle = UITableViewCellSelectionStyle.None
        
        addSubViews()
    }
    
    func addSubViews() {
        
        readView = HJReadView()
        readView.backgroundColor = UIColor.clearColor()
        contentView.addSubview(readView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if HJReadConfigureManger.shareManager.flipEffect == HJReadFlipEffect.UpAndDown { // 上下滚动
            
            let redFrame = HJReadParser.GetReadViewFrame()
            
            readView.frame = CGRectMake(redFrame.origin.x, HJReadViewTopSpace, redFrame.size.width, contentH)
            
        }else{
            
            readView.frame = HJReadParser.GetReadViewFrame()
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
