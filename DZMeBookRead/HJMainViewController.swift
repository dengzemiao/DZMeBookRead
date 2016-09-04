//
//  HJMainViewController.swift
//  DZMeBookRead
//
//  Created by 邓泽淼 on 16/8/31.
//  Copyright © 2016年 DZM. All rights reserved.
//

import UIKit

class HJMainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.whiteColor()
        
        
        let button = UIButton(type:UIButtonType.Custom)
        button.setTitle("点击阅读", forState: UIControlState.Normal)
        button.backgroundColor = UIColor.greenColor()
        button.frame = CGRectMake(100, 100, 100, 100)
        view.addSubview(button)
        button.addTarget(self, action: #selector(HJMainViewController.read), forControlEvents: UIControlEvents.TouchDown)
        
    }
    
    func read() {
        
        MBProgressHUD.showMessage()
        
        let fileURL = NSBundle.mainBundle().URLForResource("求魔", withExtension: "txt")
        
        let readVC = HJReadPageController()
        
        dispatch_async(dispatch_get_global_queue(0, 0)) {
            
            readVC.readModel = HJReadModel.readModelWithLocalBook(fileURL!)
            
            dispatch_async(dispatch_get_main_queue(), { [weak self] ()->() in
                
                MBProgressHUD.hideHUD()
                
                self?.navigationController?.pushViewController(readVC, animated: true)
                })
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
