//
//  DZMReadMarkView.swift
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/4/25.
//  Copyright © 2019年 DZM. All rights reserved.
//

import UIKit

@objc protocol DZMReadMarkViewDelegate:NSObjectProtocol {
    
    /// 点击章节
    @objc optional func markViewClickMark(markView:DZMReadMarkView, markModel:DZMReadMarkModel)
}

class DZMReadMarkView: UIView,UITableViewDelegate,UITableViewDataSource {
    
    /// 代理
    weak var delegate:DZMReadMarkViewDelegate!
    
    /// 数据源
    var readModel:DZMReadModel! {
        
        didSet{ tableView.reloadData() }
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
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        tableView.frame = bounds
    }
    
    // MARK: UITableViewDelegate,UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if readModel != nil { return readModel.markModels.count }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = DZMReadMarkCell.cell(tableView)
        
        // 设置数据
        cell.markModel = readModel.markModels[indexPath.row]
        
        // 日夜间
        if DZMUserDefaults.bool(DZM_READ_KEY_MODE_DAY_NIGHT) {

            cell.spaceLine.backgroundColor = DZM_COLOR_230_230_230.withAlphaComponent(0.1)

        }else{ cell.spaceLine.backgroundColor = DZM_COLOR_230_230_230 }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return DZM_READ_MARK_CELL_HEIGHT
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        delegate?.markViewClickMark?(markView: self, markModel: readModel.markModels[indexPath.row])
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        _ = readModel.removeMark(index: indexPath.row)
        
        if readModel.markModels.isEmpty { tableView.reloadData()
            
        }else{ tableView.deleteRows(at: [indexPath], with: .fade) }
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
