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
 
 3.获取章节的地方又获取网络小说章节的流程提示
 
 4.仿真背景颜色会跟着阅读颜色设置 不会是默认的UIPageViewController背景颜色(白色)
 
 特殊需求-定位建议: 如果阅读记录使用page觉得不好或者公司项目需求可以修改为location定位 通过location获得page更加精准 如果不是很懂可进群咨询群主
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
            
            /// 是否开启长按内容显示菜单 默认: true
            // readController.openLongMenu = false
            
            self?.navigationController?.pushViewController(readController, animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }

}
