//
//  DZMReadCatalogView.swift
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/4/25.
//  Copyright © 2019年 DZM. All rights reserved.
//

import UIKit

@objc protocol DZMReadCatalogViewDelegate:NSObjectProtocol {
    
    /// 点击章节
    @objc optional func catalogViewClickChapter(catalogView:DZMReadCatalogView, chapterListModel:DZMReadChapterListModel)
}

class DZMReadCatalogView: UIView,UITableViewDelegate,UITableViewDataSource {

    /// 代理
    weak var delegate:DZMReadCatalogViewDelegate!
    
    /// 数据源
    var readModel:DZMReadModel! {
        
        didSet{
            
            tableView.reloadData()
            
            scrollRecord()
        }
    }
    
    private(set) var tableView:DZMTableView!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        addSubviews()
    }
    
    private func addSubviews() {
        
        tableView = DZMTableView()
        tableView.delegate = self
        tableView.dataSource = self
        addSubview(tableView)
    }
    
    /// 滚动到阅读记录
    func scrollRecord() {
        
        if readModel != nil {
            
            tableView.reloadData()
       
            if !readModel.chapterListModels.isEmpty {
                
                let chapterListModel = (readModel.chapterListModels as NSArray).filtered(using: NSPredicate(format: "id == %@", readModel.recordModel.chapterModel.id)).first as? DZMReadChapterListModel
                
                if chapterListModel != nil {
                    
                    tableView.scrollToRow(at: IndexPath(row: readModel.chapterListModels.index(of: chapterListModel!)!, section: 0), at: .middle, animated: false)
                }
            }
        }
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        tableView.frame = bounds
    }
    
    // MARK: UITableViewDelegate,UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if readModel != nil { return readModel.chapterListModels.count }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = DZMReadCatalogCell.cell(tableView)
        
        // 章节
        let chapterListModel = readModel.chapterListModels[indexPath.row]
        
        // 章节名
        cell.chapterName.text = readModel.chapterListModels[indexPath.row].name
        
        // 日夜间
        if DZMUserDefaults.bool(DZM_READ_KEY_MODE_DAY_NIGHT) {
            
            cell.spaceLine.backgroundColor = DZM_COLOR_230_230_230.withAlphaComponent(0.1)
            
        }else{ cell.spaceLine.backgroundColor = DZM_COLOR_230_230_230 }
        
        // 阅读记录
        if readModel.recordModel.chapterModel.id == chapterListModel.id {
            
            cell.chapterName.textColor = DZM_READ_COLOR_MAIN
            
        }else{ cell.chapterName.textColor = DZM_COLOR_145_145_145 }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return DZM_SPACE_SA_50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        delegate?.catalogViewClickChapter?(catalogView: self, chapterListModel: readModel.chapterListModels[indexPath.row])
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
