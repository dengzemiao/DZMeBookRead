//
//  DZMReadHomeView.swift
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/5/7.
//  Copyright © 2019 DZM. All rights reserved.
//

import UIKit

class DZMReadHomeView: UIView {
    
    /// 书籍名称
    private var name:UILabel!
    
    /// 当前阅读模型
    var readModel:DZMReadModel! {
        
        didSet{
            
            name.text = readModel.bookName
        }
    }

    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        addSubviews()
    }
    
    private func addSubviews() {
        
        // 书籍名称
        name = UILabel()
        name.textAlignment = .center
        name.font = DZM_FONT_BOLD_SA(50)
        name.textColor = DZMReadConfigure.shared().textColor
        addSubview(name)
    }
    
    override func layoutSubviews() {
        
        super.layoutSubviews()
        
        name.frame = bounds
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
