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
        
        /*
         
         现在有个BUG在iOS12以后，滚动模式 DZMReadViewScrollController -> chapterModels 字段里面章节model会提前释放，不会被强引用，很是郁闷, 低版本没有问题。
         拿到Demo的可以测试一下滚动模式下会不会有问题。其实就是章节Model提前释放了,但是我存放的是字典对象，理论上是强引用对象的，现在iOS12却出现这样的问题。
         
         (真机情况,模拟器不会出现)如果iOS12.2或者更高版本报这个错误 原因是MBProgressHUD导致的（暂不处理, 可以先注释MBProgressHUD使用,真机需要拔掉数据线不连接xcode使用就没事）
         
         https://github.com/jdg/MBProgressHUD/issues/552
         
         该问题以及解决 MBProgressHUD.m 503行 注释了报错代码。
         
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
        
        // 标题
        title = "DZMeBookRead"
        
        // 简介
        let hint = UITextView()
        hint.text = "如果需要单独测试【全文解析】跟【快速解析】,需要删除app重新点击\n\n目前项目内部颜色都是随机生成,需要到 DZMReadConfigure 文件顶部打开注释代码即可正常。 \n\n即将加入功能:\n1.epub阅读(暂缓,有时间加入)\n\n网络小说问题:\n全局搜索 搜索网络小说 找到位置进行更换请求接口,滚动模式支持预加载，但是如果预加载失败就需要一个上下拉加载上下章节,这个可以自行加上,也就是上下拉加载而已。\n\n调试区域问题:\n可以修改 DZMReadView 的背景颜色为随机颜色查看范围,尤其是滚动模式,查看上下间距\n\n阅读背景图片平铺问题:\n可以要求美工做一份iphoneX的图就不会平铺的情况了。我这边资源有限就随便找个图做阅读背景了。"
        hint.textColor = DZM_COLOR_124_126_128
        hint.font = UIFont.systemFont(ofSize: 15)
        hint.isEditable = false
        view.addSubview(hint)
        hint.frame = CGRect(x: DZM_SPACE_SA_15, y: NavgationBarHeight + DZM_SPACE_SA_15, width: ScreenWidth - DZM_SPACE_SA_30, height: DZM_SPACE_SA_350)
        
        // 全本解析
        let fullButton = UIButton(type: .custom)
        fullButton.setTitle("全本解析", for: .normal)
        fullButton.backgroundColor = UIColor.green
        fullButton.addTarget(self, action: #selector(fullRead), for: .touchDown)
        view.addSubview(fullButton)
        fullButton.frame = CGRect(x: (ScreenWidth / 2 - DZM_SPACE_SA_100) / 2, y: ScreenHeight - DZM_SPACE_SA_150, width: DZM_SPACE_SA_100, height: DZM_SPACE_SA_100)
        
        // 快速解析阅读
        let fastButton = UIButton(type: .custom)
        fastButton.setTitle("快速解析", for: .normal)
        fastButton.backgroundColor = UIColor.green
        fastButton.addTarget(self, action: #selector(fastRead), for: .touchDown)
        view.addSubview(fastButton)
        fastButton.frame = CGRect(x: ScreenWidth - DZM_SPACE_SA_100 - (ScreenWidth / 2 - DZM_SPACE_SA_100) / 2, y: ScreenHeight - DZM_SPACE_SA_150, width: DZM_SPACE_SA_100, height: DZM_SPACE_SA_100)
    }
    
    // 全本解析阅读
    @objc private func fullRead() {
        
        print("缓存文件地址:", DZM_READ_DOCUMENT_DIRECTORY_PATH)
        
        MBProgressHUD.showLoading("全本解析(第一次进入)速度慢", to: view)
      
        let url = Bundle.main.url(forResource: "求魔", withExtension: "txt")
        
        print("全本解析开始时间:",TimerString("YYYY-MM-dd-HH-mm-ss"), Date().timeIntervalSince1970)
        
        DZMReadTextParser.parser(url: url) { [weak self] (readModel) in
            
            print("全本解析结束时间:",TimerString("YYYY-MM-dd-HH-mm-ss"), Date().timeIntervalSince1970)
            
            MBProgressHUD.hide(self?.view)
            
            if readModel == nil {
                
                MBProgressHUD.showMessage("全本解析失败")
                
                return
            }
            
            let vc  = DZMReadController()
            
            vc.readModel = readModel
            
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // 快速解析阅读
    @objc private func fastRead() {
        
        print("缓存文件地址:", DZM_READ_DOCUMENT_DIRECTORY_PATH)
        
        MBProgressHUD.showLoading("正在快速解析全文...", to: view)
        
        let url = Bundle.main.url(forResource: "求魔", withExtension: "txt")
        
        print("快速解析开始时间:",TimerString("YYYY-MM-dd-HH-mm-ss"), Date().timeIntervalSince1970)
        
        DZMReadTextFastParser.parser(url: url) { [weak self] (readModel) in
            
            print("快速解析结束时间:",TimerString("YYYY-MM-dd-HH-mm-ss"), Date().timeIntervalSince1970)
            
            MBProgressHUD.hide(self?.view)
            
            if readModel == nil {
                
                MBProgressHUD.showMessage("快速解析失败")
                
                return
            }
            
            let vc  = DZMReadController()
            
            vc.readModel = readModel
            
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
//    // 跳转网络小说初次进入使用例子(按照这样进入阅读页之后,只需要全局搜索 "搜索网络小说" 的地方加入请求章节就好了)
//    @objc private func readNetwork() {
//
//        MBProgressHUD.showLoading(view)
//
//        // 获得阅读模型
//        // 网络小说的话, readModel 里面有个 chapterListModels 字段,这个是章节列表,我里面有数据是因为我是全本解析本地需要有个地方存储,网络小说可能一开始没有
//        // 运行会在章节列表UI定位的地方崩溃,直接注释就可以了,网络小说的章节列表可以直接在章节列表UI里面单独请求在定位处理。
//        let readModel = DZMReadModel.model(bookID: bookID)
//
//        // 检查是否当前将要阅读的章节是否等于阅读记录
//        if chapterID == readModel.recordModel.chapterModel?.id {
//
//            // 检查马上要阅读章节是否本地存在
//            if DZMReadChapterModel.isExist(bookID: bookID, chapterID: chapterID) { // 存在
//
//                MBProgressHUD.hide(view)
//
//                // 如果存在则修改阅读记录
//                readModel.recordModel.modify(chapterID: chapterID, location: 0)
//
//                let vc  = DZMReadController()
//
//                vc.readModel = readModel
//
//                navigationController?.pushViewController(vc, animated: true)
//
//            }else{ // 如果不存在则需要加载网络数据
//
//                // 获取当前需要阅读的章节
//                NJHTTPTool.request_novel_read(bookID, chapterID) { [weak self] (type, response, error) in
//
//                    MBProgressHUD.hide(self?.view)
//
//                    if type == .success {
//
//                        // 获取章节数据
//                        let data = HTTP_RESPONSE_DATA_DICT(response)
//
//                        // 解析章节数据
//                        let chapterModel = DZMReadChapterModel(data)
//
//                        // 章节类容需要进行排版一篇
//                        chapterModel.content = DZMReadParser.contentTypesetting(content: chapterModel.content)
//
//                        // 保存
//                        chapterModel.save()
//
//                        // 如果存在则修改阅读记录
//                        readModel.recordModel.modify(chapterID: chapterModel.chapterID, location: 0)
//
//                        let vc  = DZMReadController()
//
//                        vc.readModel = readModel
//
//                        self?.navigationController?.pushViewController(vc, animated: true)
//
//                    }else{
//
//                        // 加载失败
//                    }
//                }
//            }
//
//        }else{ // 如果是一致的就继续阅读。也可以在下面使用 readModel.recordModel.modify(xxx) 进行修改更新阅读页面或者位置
//
//            MBProgressHUD.hide(view)
//
//            let vc  = DZMReadController()
//
//            vc.readModel = readModel
//
//            navigationController?.pushViewController(vc, animated: true)
//        }
//    }
}
