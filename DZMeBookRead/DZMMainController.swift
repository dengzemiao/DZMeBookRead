//
//  DZMMainController.swift
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/4/17.
//  Copyright © 2019年 DZM. All rights reserved.
//

import UIKit

class DZMMainController: DZMViewController {

    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        // 标题
        title = "DZMeBookRead"
        
        // 简介
        let hint = UITextView()
        hint.text = "发现一个比较重要的问题: 就是归档缓存文件,我发现太耗时,其实整本书解析到阅读,单独不算归档文件,只需要3-4秒钟,但是归档文件缺导致耗费大量时间。目前还在想办法是否有别的存储方式,但是针对一章来说归档是很快的,针对整本来说却很慢。 \n\n目前项目内部颜色都是随机生成,需要到 DZMReadConfigure 文件顶部打开注释代码即可正常。 \n\n即将加入功能:\n1.书籍首页展示\n2.本地快速进入功能(马上着手写分析器加入,简单使用)\n\n网络小说问题:\n全局搜索 搜索网络小说 找到位置进行更换请求接口,滚动模式支持预加载，但是如果预加载失败就需要一个上下拉加载上下章节,这个可以自行加上,也就是上下拉加载而已。\n\n快速进入问题:\n先出整本解析,马上找时间加速补上快速进入代码。急的可参考我GitHub上的快速进入思路,自己补上先用!\n\n调试区域问题:\n可以修改 DZMReadView 的背景颜色为随机颜色查看范围,尤其是滚动模式,查看上下间距\n\n阅读背景图片平铺问题:\n可以要求美工做一份iphoneX的图就不会平铺的情况了。我这边资源有限就随便找个图做阅读背景了。"
        hint.textColor = DZM_COLOR_124_126_128
        hint.font = UIFont.systemFont(ofSize: 15)
        hint.isEditable = false
        view.addSubview(hint)
        hint.frame = CGRect(x: DZM_SPACE_SA_15, y: NavgationBarHeight + DZM_SPACE_SA_15, width: ScreenWidth - DZM_SPACE_SA_30, height: DZM_SPACE_SA_300)
        
        // 跳转
        let button = UIButton(type: .custom)
        button.setTitle("点击阅读", for: .normal)
        button.backgroundColor = UIColor.green
        button.addTarget(self, action: #selector(read), for: .touchDown)
        view.addSubview(button)
        button.frame.size = CGSize(width: DZM_SPACE_SA_100, height: DZM_SPACE_SA_100)
        button.center = CGPoint(x: view.center.x, y: ScreenHeight - DZM_SPACE_SA_150)
    }
    
    // 跳转
    @objc private func read() {
        
        /*
         
         (真机情况,模拟器不会出现)如果iOS12.2或者更高版本报这个错误 原因是MBProgressHUD导致的（暂不处理, 可以先注释MBProgressHUD使用,真机需要拔掉数据线不连接xcode使用就没事）

         https://github.com/jdg/MBProgressHUD/issues/552
         
         Main Thread Checker: UI API called on a background thread: -[UIApplication applicationState]
         PID: 11304, TID: 942122, Thread name: com.apple.CoreMotion.MotionThread, Queue name: com.apple.root.default-qos.overcommit, QoS: 0
         Backtrace:
         4   libobjc.A.dylib                     0x00000001809a76f4 <redacted> + 56
         5   CoreMotion                          0x00000001870f1638 CoreMotion + 292408
         6   CoreMotion                          0x00000001870f1b68 CoreMotion + 293736
         7   CoreMotion                          0x00000001870f1a78 CoreMotion + 293496
         8   CoreMotion                          0x000000018711f8a8 CoreMotion + 481448
         9   CoreMotion                          0x000000018711f8ec CoreMotion + 481516
         10  CoreFoundation                      0x000000018173378c <redacted> + 28
         11  CoreFoundation                      0x0000000181733074 <redacted> + 276
         12  CoreFoundation                      0x000000018172e368 <redacted> + 2276
         13  CoreFoundation                      0x000000018172d764 CFRunLoopRunSpecific + 452
         14  CoreFoundation                      0x000000018172e498 CFRunLoopRun + 84
         15  CoreMotion                          0x000000018711f280 CoreMotion + 479872
         16  libsystem_pthread.dylib             0x00000001813ad920 <redacted> + 132
         17  libsystem_pthread.dylib             0x00000001813ad87c _pthread_start + 48
         18  libsystem_pthread.dylib             0x00000001813b5dcc thread_start + 4
         
         */
        
        print("缓存文件地址:", DZM_READ_DOCUMENT_DIRECTORY_PATH)
        
        MBProgressHUD.showLoading("整本解析速度慢,以后则秒进!", to: view)
      
        let url = Bundle.main.url(forResource: "求魔", withExtension: "txt")
        
        print("解析开始时间:",TimerString("YYYY-MM-dd-HH-mm-ss"), Date().timeIntervalSince1970)
        
        DZMReadTextParser.parser(url: url) { [weak self] (readModel) in
            
            print("解析结束时间:",TimerString("YYYY-MM-dd-HH-mm-ss"), Date().timeIntervalSince1970)
            
            MBProgressHUD.hide(self?.view)
            
            if readModel == nil {
                
                MBProgressHUD.showMessage("解析失败")
                
                return
            }
            
            let vc  = DZMReadController()
            
            vc.readModel = readModel
            
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}
