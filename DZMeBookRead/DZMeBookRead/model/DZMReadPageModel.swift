//
//  DZMReadPageModel.swift
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/4/16.
//  Copyright © 2019年 DZM. All rights reserved.
//

import UIKit

class DZMReadPageModel: NSObject, NSCoding {

    var content:NSAttributedString!
    
    var range:NSRange!
    
    var page:NSNumber!
    
    // MARK: -- NSCoding
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init()
        
        content = aDecoder.decodeObject(forKey: "content") as? NSAttributedString
        
        range = aDecoder.decodeObject(forKey: "range") as? NSRange
        
        page = aDecoder.decodeObject(forKey: "page") as? NSNumber
    }
    
    func encode(with aCoder: NSCoder) {
        
        aCoder.encode(content, forKey: "content")
        
        aCoder.encode(range, forKey: "range")
        
        aCoder.encode(page, forKey: "page")
    }
    
    init(_ dict:Any? = nil) {
        
        super.init()
        
        if dict != nil { setValuesForKeys(dict as! [String : Any]) }
    }
    
    class func model(_ dict:Any?) ->DZMReadPageModel  { return DZMReadPageModel(dict) }
    
    override func setValue(_ value: Any?, forUndefinedKey key: String) { }
}
