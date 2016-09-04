//
//  HJReadPageController.swift
//  HJProject
//
//  Created by 邓泽淼 on 16/8/15.
//  Copyright © 2016年 HanJue. All rights reserved.
//

import UIKit

class HJReadPageController: HJViewController,UIPageViewControllerDelegate,UIPageViewControllerDataSource,HJAppDelegate {
    
    // 阅读主对象
    var readModel:HJReadModel!
    
    /// 翻页控制器
    var pageViewController:UIPageViewController!
    
    /// 阅读设置
    var readSetup:HJReadSetup!
    var readConfigure:HJReadPageDataConfigure!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初始化
        readConfigure = HJReadPageDataConfigure.setupWithReadController(self)
        readSetup = HJReadSetup.setupWithReadController(self)
        
        // 刷新章节列表
        readSetup.readUI.leftView.dataArray = readModel.readChapterListModels
        readSetup.readUI.bottomView.slider.maximumValue = Float(readModel.readChapterListModels.count - 1)
        
        // 初始化翻页效果
        readSetup.setFlipEffect(HJReadConfigureManger.shareManager.flipEffect,chapterLookPageClear: false)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // 设置回调代理
        (UIApplication.sharedApplication().delegate as! AppDelegate).delegate = self
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        navigationController?.setNavigationBarHidden(false, animated: false)
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: true)
        
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Fade)
    }
    
    // MARK: -- PageController
    
    func creatPageController(displayController:UIViewController,transitionStyle: UIPageViewControllerTransitionStyle, navigationOrientation: UIPageViewControllerNavigationOrientation) {
        
        if pageViewController != nil {
            
            pageViewController.removeFromParentViewController()
            
            pageViewController.view.removeFromSuperview()
        }
        
        let options = [UIPageViewControllerOptionSpineLocationKey:NSNumber(long: UIPageViewControllerSpineLocation.Min.rawValue)]
        
        pageViewController = UIPageViewController(transitionStyle:transitionStyle,navigationOrientation:navigationOrientation,options: options)
        
        pageViewController.delegate = self
        
        pageViewController.dataSource = self
        
        view.insertSubview(pageViewController.view, atIndex: 0)
        
        self.addChildViewController(pageViewController)
        
        pageViewController.setViewControllers([displayController], direction: UIPageViewControllerNavigationDirection.Forward, animated: true, completion: nil)
    }
    
    // MARK: -- UIPageViewControllerDelegate
    
    func pageViewController(pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        if !completed {
            
            if pageViewController.transitionStyle == UIPageViewControllerTransitionStyle.PageCurl {
                
                // 重置阅读记录
                
                let vc  = previousViewControllers.first as! HJReadViewController
                
                synchronizationPageViewControllerData(vc)
            }
            
        }else{
            
            if pageViewController.transitionStyle == UIPageViewControllerTransitionStyle.PageCurl {
            
                // 刷新阅读记录
                readConfigure.synchronizationChangeData()
                
            }else{
                
            }
        }
    }
    
    func pageViewController(pageViewController: UIPageViewController, willTransitionToViewControllers pendingViewControllers: [UIViewController]) {
        
    }
    
    
    // MARK: -- UIPageViewControllerDataSource
    
    /// 获取上一页
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        if pageViewController.transitionStyle == UIPageViewControllerTransitionStyle.Scroll {
            
            synchronizationPageViewControllerData(viewController)
        }
        
        return readConfigure.GetReadPreviousPage()
    }
    
    /// 获取下一页
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        if pageViewController.transitionStyle == UIPageViewControllerTransitionStyle.Scroll {
       
            synchronizationPageViewControllerData(viewController)
        }
        
        return readConfigure.GetReadNextPage()
    }
    
    /// 同步PageViewController 当前显示的控制器的内容
    func synchronizationPageViewControllerData(viewController: UIViewController){
        
        let vc  = viewController as! HJReadViewController
        readConfigure.changeReadChapterListModel = vc.readRecord.readChapterListModel
        readConfigure.changeReadChapterModel = vc.readChapterModel
        readConfigure.changeLookPage = vc.readRecord.page.integerValue
        readModel.readRecord.chapterIndex = vc.readRecord.chapterIndex
        title = vc.readChapterModel.chapterName
        
        // 刷新阅读记录
        readConfigure.synchronizationChangeData()
    }
    
    // MARK: -- 返回以及同步数据
    
    override func initNavigationBarSubviews() {
        super.initNavigationBarSubviews()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem.AppNavigationBarBackItemOne(UIEdgeInsetsMake(0, 0, 0, 0), target: self, action: #selector(HJNavigationController.clickBack))
    }
    
    
    // MARK: -- HJAppDelegate 保存阅读记录
    
    /// app 即将退出
    func applicationWillTerminate(application: UIApplication) {
        
        readConfigure.updateReadRecord()
    }
    
    /// app 内存警告可能要终止程序
    func applicationDidReceiveMemoryWarning(application: UIApplication) {
        
        readConfigure.updateReadRecord()
    }
    
    override func clickBack() {
        super.clickBack()
        
        // 保存记录
        readConfigure.updateReadRecord()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
        // 内存警告保存记录
        readConfigure.updateReadRecord()
    }
    

}
