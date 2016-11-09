//
//  HJReadViewCell.swift
//  HJProject
//
//  Created by 邓泽淼 on 16/8/29.
//  Copyright © 2016年 HanJue. All rights reserved.
//

// 不要广告可注销
let HJAdvertisementButtonH:CGFloat = 70
let HJAdvertisementBottomSpaceH:CGFloat = 30

import UIKit

class HJReadViewCell: UITableViewCell {
    
    /// 当前是否为这一章的最后一页
    var isLastPage:Bool = false
    
    // 章节信息
    var readChapterListModel:HJReadChapterListModel?

    // 广告按钮
    var advertisementButton:UIButton!
    
    // 阅读显示View数组
    fileprivate var readViews:[HJReadView] = []
    
    var content:String? {
        
        didSet{
            
            if content != nil && !content!.isEmpty { // 字符串有值
                
                let redFrame = HJReadParser.GetReadViewFrame()
                
                if HJReadConfigureManger.shareManager.flipEffect != HJReadFlipEffect.upAndDown { // 非上下滚动
                    
                    // 创建阅读view
                    creatReadViews(1)
                    
                    // 显示
                    readViews.first!.frameRef = HJReadParser.parserRead(content!, configure: HJReadConfigureManger.shareManager, bounds: CGRect(x: 0, y: 0, width: redFrame.width, height: redFrame.height))
                }
                
                setNeedsLayout()
            }
        }
    }
    
    
    // 章节数据
    var readChapterModel:HJReadChapterModel? {
        
        didSet {
            
            if (readChapterModel != nil) {
                
                if HJReadConfigureManger.shareManager.flipEffect == HJReadFlipEffect.upAndDown { // 上下滚动
                    
                    let redFrame = HJReadParser.GetReadViewFrame()
                    
                    // 创建阅读view
                    creatReadViews(readChapterModel!.pageCount.intValue)
                    
                    // 显示
                    for i in 0..<readViews.count {
                        
                        let readView = readViews[i];
                        
                        readView.frameRef = HJReadParser.parserRead(readChapterModel!.stringOfPage(i), configure: HJReadConfigureManger.shareManager, bounds: CGRect(x: 0, y: 0, width: redFrame.width, height: redFrame.height))
                    }
                    
                    setNeedsLayout()
                }
            }
        }
    }
    
    // 创建阅读view
    fileprivate func creatReadViews(_ count:NSInteger) {
        
        for i in 0..<count {
            
            let readView = HJReadView()
            readView.tag = i
            readView.backgroundColor = UIColor.clear
//            readView.backgroundColor = RGB(CGFloat(arc4random() % 255), g: CGFloat(arc4random() % 255), b: CGFloat(arc4random() % 255))
            contentView.addSubview(readView)
            readViews.append(readView)
        }
    }
    
    // 清理阅读view
    fileprivate func removeReadViews() {
        
        for readView in readViews {
            
            readView.removeFromSuperview()
        }
        
        readViews.removeAll()
    }
    
    class func cellWithTableView(_ tableView:UITableView) ->HJReadViewCell {
        
        let ID = "HJReadViewCell"
        
        var cell = tableView.dequeueReusableCell(withIdentifier: ID) as? HJReadViewCell
        
        cell?.removeReadViews()
        
        cell?.readChapterModel = nil
        
        cell?.readChapterListModel = nil
        
        cell?.content = nil
        
        cell?.advertisementButton.isHidden = true
        
        if (cell == nil) {
            
            cell = HJReadViewCell(style: UITableViewCellStyle.subtitle, reuseIdentifier: ID);
        }
        
        return cell!
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = UIColor.clear
        
        selectionStyle = UITableViewCellSelectionStyle.none
        
        layer.masksToBounds = true
        
        addSubViews()
    }
    
    func addSubViews() {
        
        // 不要广告可注销
        advertisementButton = UIButton(type:UIButtonType.custom)
        advertisementButton.setImage(UIImage(named: "advertisementIon")!, for: UIControlState())
        advertisementButton.isHidden = true
        advertisementButton.backgroundColor = UIColor.clear
        contentView.addSubview(advertisementButton)
        advertisementButton.addTarget(self, action: #selector(HJReadViewCell.clickAdvertisementButton), for: UIControlEvents.touchUpInside)
    }
    
    /// 点击广告
    func clickAdvertisementButton() {
        
        MBProgressHUD.showSuccess("点击了章节广告")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        // 如果不要广告的写法 取掉 AdvertisementButton 相关的  搜索 "不要广告可注销"
        if HJReadConfigureManger.shareManager.flipEffect == HJReadFlipEffect.upAndDown { // 上下滚动
            
            let redFrame = HJReadParser.GetReadViewFrame()
            
            // 显示
            var readViewMaxY:CGFloat = 0
            
            for i in 0..<readViews.count {
                
                let readView = readViews[i];
                
                 readView.frame = CGRect(x: 0, y: readViewMaxY, width: width, height: redFrame.size.height)
                
                readViewMaxY = readView.frame.maxY + HJSpaceThree
            }
            
            advertisementButton.frame = CGRect(x: HJSpaceTwo, y: height - HJAdvertisementButtonH - HJAdvertisementBottomSpaceH, width: ScreenWidth - 2*HJSpaceTwo, height: HJAdvertisementButtonH)
            
            advertisementButton.isHidden = false
            
        }else{
            
            readViews.first!.frame = bounds
            
            if isLastPage && content != nil && content!.length < 250 {
                
                advertisementButton.frame = CGRect(x: HJSpaceTwo, y: height - HJAdvertisementButtonH - 30, width: ScreenWidth - 2*HJSpaceTwo, height: HJAdvertisementButtonH)
                
                advertisementButton.isHidden = false
                
            }else{
                
                advertisementButton.isHidden = true
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
