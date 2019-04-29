//
//  DZMViewController.swift
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/4/17.
//  Copyright © 2019年 DZM. All rights reserved.
//

import UIKit

class DZMViewController: UIViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        initialize()
        
        addSubviews()
        
        addComplete()
    }
    
    func initialize() {
        
        view.backgroundColor = UIColor.white
        
        extendedLayoutIncludesOpaqueBars = true
        
        if #available(iOS 11.0, *) { } else {
            
            automaticallyAdjustsScrollViewInsets = false
        }
    }
    
    func addSubviews() { }
    
    func addComplete() { }
}
