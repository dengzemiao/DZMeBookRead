//
//  DZMMainController.swift
//  DZMeBookRead
//
//  Created by 邓泽淼 on 2017/3/30.
//  Copyright © 2017年 DZM. All rights reserved.
//

import UIKit

/*
 
 1. 
 第三方介绍:(均可去掉去掉删除相关代码即可)
 YGPulseView: View添加光晕用的
 ASValueTrackingSlider: 带显示进度的进度条
 DZMCoverController: 翻页效果
 FDFullscreenPopGesture: 导航栏控制

 
 2.
 阅读设置选中颜色动画 DZMRMColorView
 如不需要动画 可注销动画代码
 
 */

class DZMMainController: DZMViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // 标题
        title = "DZMeBookRead"
        
        // 跳转
        let button = UIButton(type: .custom)
        button.setTitle("点击阅读", for: .normal)
        button.backgroundColor = UIColor.green
        button.addTarget(self, action: #selector(DZMMainController.read), for: .touchDown)
        view.addSubview(button)
        button.frame = CGRect(x: 100, y: 100, width: 100, height: 100)
    }
    
    // 跳转
    func read() {
        
        MBProgressHUD.showMessage("本地文件第一次解析慢,以后就会秒进了")
        
        let url = Bundle.main.url(forResource: "求魔", withExtension: "txt")
        
        
        DZMReadParser.ParserLocalURL(url: url!) {[weak self] (readModel) in
            
            MBProgressHUD.hide()
            
            let readController = DZMReadController()
            
            readController.readModel = readModel
            
            self?.navigationController?.pushViewController(readController, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }

}
