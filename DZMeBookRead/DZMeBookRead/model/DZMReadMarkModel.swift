//
//  DZMReadMarkModel.swift
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/4/17.
//  Copyright © 2019年 DZM. All rights reserved.
//

import UIKit

class DZMReadMarkModel: NSObject,NSCoding {

    /// 小说ID
    var bookID:String!
    
    /// 章节ID
    var chapterID:NSNumber!
    
    /// 章节名称
    var name:String!
    
    /// 内容
    var content:String!
    
    /// 时间戳
    var time:NSNumber! = NSNumber(value: 0)
    
    /// 位置
    var location:NSNumber! = NSNumber(value: 0)
    
    // MARK: -- 构造
    
    override init() {
        
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init()
        
        bookID = aDecoder.decodeObject(forKey: "bookID") as? String
        
        chapterID = aDecoder.decodeObject(forKey: "chapterID") as? NSNumber
        
        name = aDecoder.decodeObject(forKey: "name") as? String
        
        content = aDecoder.decodeObject(forKey: "content") as? String
        
        time = aDecoder.decodeObject(forKey: "time") as? NSNumber
        
        location = aDecoder.decodeObject(forKey: "location") as? NSNumber
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(bookID, forKey: "bookID")
        
        aCoder.encode(chapterID, forKey: "chapterID")
        
        aCoder.encode(name, forKey: "name")
        
        aCoder.encode(content, forKey: "content")
        
        aCoder.encode(time, forKey: "time")
        
        aCoder.encode(location, forKey: "location")
    }
    
    init(_ dict:Any? = nil) {
        
        super.init()
        
        if dict != nil { setValuesForKeys(dict as! [String : Any]) }
    }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) { }
}
