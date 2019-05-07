//
//  DZMReadPageModel.swift
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/4/17.
//  Copyright © 2019年 DZM. All rights reserved.
//

import UIKit

class DZMReadPageModel: NSObject,NSCoding {

    // MARK: 常用属性
    
    /// 当前页内容
    var content:NSAttributedString!
    
    /// 当前页范围
    var range:NSRange!
    
    /// 当前页序号
    var page:NSNumber!
    
    
    // MARK: 滚动模式使用
    
    /// 根据开头类型返回开头高度 (目前主要是滚动模式使用)
    var headTypeHeight:CGFloat! = 0
    
    /// 当前内容Size (目前主要是(滚动模式 || 长按模式)使用)
    var contentSize:CGSize! = CGSize.zero
    
    /// 当前内容头部类型 (目前主要是滚动模式使用)
    var headTypeIndex:NSNumber!
    
    /// 当前内容头部类型 (目前主要是滚动模式使用)
    var headType:DZMPageHeadType! {
        
        set{ headTypeIndex = NSNumber(value: newValue.rawValue) }
        
        get{ return DZMPageHeadType(rawValue: headTypeIndex.intValue) }
    }
    
    /// 当前内容总高(cell 高度)
    var cellHeight:CGFloat! {
        
        // 内容高度 + 头部高度
        return contentSize.height + headTypeHeight
    }
    
    
    // MARK: 快捷获取
    
    /// 书籍首页
    var isHomePage:Bool { return range.location == DZM_READ_BOOK_HOME_PAGE }
    
    /// 获取显示内容(考虑可能会变换字体颜色的情况)
    var showContent:NSAttributedString! {
        
        let textColor = DZMReadConfigure.shared().textColor!
        let tempShowContent = NSMutableAttributedString(attributedString: content)
        tempShowContent.addAttributes([.foregroundColor : textColor], range: NSMakeRange(0, content.length))
        return tempShowContent
    }
    
    // MARK: -- NSCoding
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init()
        
        content = aDecoder.decodeObject(forKey: "content") as? NSAttributedString
        
        range = aDecoder.decodeObject(forKey: "range") as? NSRange
        
        page = aDecoder.decodeObject(forKey: "page") as? NSNumber
        
        headTypeHeight = aDecoder.decodeObject(forKey: "headTypeHeight") as? CGFloat
        
        contentSize = aDecoder.decodeObject(forKey: "contentSize") as? CGSize
        
        headTypeIndex = aDecoder.decodeObject(forKey: "headTypeIndex") as? NSNumber
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(content, forKey: "content")
        
        aCoder.encode(range, forKey: "range")
        
        aCoder.encode(page, forKey: "page")
        
        aCoder.encode(headTypeHeight, forKey: "headTypeHeight")
        
        aCoder.encode(contentSize, forKey: "contentSize")
        
        aCoder.encode(headTypeIndex, forKey: "headTypeIndex")
    }
    
    init(_ dict:Any? = nil) {
        
        super.init()
        
        if dict != nil { setValuesForKeys(dict as! [String : Any]) }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) { }
}
