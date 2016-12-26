//
//  HJMainViewController.swift
//  DZMeBookRead
//
//  Created by 邓泽淼 on 16/8/31.
//  Copyright © 2016年 DZM. All rights reserved.
//

import UIKit

class HJMainViewController: UIViewController {

    /* 
     
     项目思路： 通过一个txt文件解析成 无数个章节模型(也可以理解成无数个 章节.txt文件) 这些章节模型文件使用归档进行存储起来 (可以运行项目之后进入沙河路径看看我的文件夹结构就明白了) 
     
     然后在阅读中每次通过一个章节ID 就能快速获取以及解析出来一个章节模型 进行使用 不用了直接进行销毁 保证了内存问题
     在下载章节缓存小说方面 也是有利的 阅读的整个过程中面对的只有章节ID 通过章节ID就能知道这个章节是否存在以及能够拿出来解析阅读 同时还可以在后台在任何地方进行下载缓存 而不会出问题 因为你只需要去通过章节ID 去获取章节model归档文件即可
     
     同样 既然章节模型都有了归档 也需要一个正对整本书的 缓存 章节信息 书本信息 阅读记录 等等的BOOK模型 这个模型也使用归档进行存储 在重新进入阅读的时候 归档秒解析的速度能够无视觉的延迟的快速进入 然后获取阅读记录进行定位阅读 当然这样也是可以通过网络数据进行更新的
     
     以上的思路针对本地 网络数据都是可行的
     */
    
    var readVC:HJReadPageController!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = UIColor.white
        
        let button = UIButton(type:UIButtonType.custom)
        button.setTitle("点击阅读", for: UIControlState())
        button.backgroundColor = UIColor.green
        button.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
        view.addSubview(button)
        button.addTarget(self, action: #selector(HJMainViewController.read), for: UIControlEvents.touchDown)
        
    }
    
    func read() {
        
        // 发现除了 HJReadPageController 控制器还没找到什么原因  可能引用太多 造成没有释放 但是别的子控件什么都进行了释放 打印测试过 相当于就HJReadPageController 需要第二次点击进入才会释放 HJReadPageController 内部子控件会释放成功 这点不影响代码运行 跟内存问题 内存问题也进行了优化 每一章节都会进行清理看不见的
        
        // 方法一
        
        MBProgressHUD.showMessage("本地文件第一次解析慢,以后就会秒进了")
        
        let fileURL = Bundle.main.url(forResource: "求魔", withExtension: "txt")
        
        readVC = HJReadPageController()
        
        HJReadParser.separateLocalURL(fileURL!) { [weak self] (isOK) in
            
             MBProgressHUD.hide()
            
            if self != nil {
                
                self!.readVC!.readModel = HJReadModel.readModelWithFileName("求魔")
                
                self!.navigationController?.pushViewController(self!.readVC!, animated: true)
                
            }
        }
        
        // 方法一
        
//        MBProgressHUD.showMessage()
//        
//        let fileURL = NSBundle.mainBundle().URLForResource("求魔", withExtension: "txt")
//
//        let readVC = HJReadPageController()
//        
//        dispatch_async(dispatch_get_global_queue(0, 0)) {
//            
//            readVC.readModel = HJReadModel.readModelWithLocalBook(fileURL!)
//            
//            dispatch_async(dispatch_get_main_queue(), { [weak self] ()->() in
//                
//                MBProgressHUD.hideHUD()
//                
//                self?.navigationController?.pushViewController(readVC, animated: true)
//                })
//        }
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
