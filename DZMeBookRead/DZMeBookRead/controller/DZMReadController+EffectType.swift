//
//  DZMReadController+EffectType.swift
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/4/17.
//  Copyright © 2019年 DZM. All rights reserved.
//

import UIKit

extension DZMReadController {

    /// 创建阅读视图
    func creatPageController(displayController:DZMReadViewController? = nil) {
        
        // 清理
        clearPageController()
        
        // 翻页类型
        let effectType = DZMReadConfigure.shared().effectType
        
        // 创建
        if effectType == .simulation { // 仿真
            
            if displayController == nil { return }
            
            // 创建
            let options = [UIPageViewController.OptionsKey.spineLocation : NSNumber(value: UIPageViewController.SpineLocation.min.rawValue)]
            
            pageViewController = DZMPageViewController(transitionStyle: .pageCurl,navigationOrientation: .horizontal,options: options)
            
            // 自定义tap手势的相关代理
            pageViewController.aDelegate = self
            
            pageViewController.delegate = self
            
            pageViewController.dataSource = self
            
            contentView.insertSubview(pageViewController.view, at: 0)
            
            pageViewController.view.backgroundColor = UIColor.clear
            
            pageViewController.view.frame = contentView.bounds
            
            // 翻页背部带文字效果
            pageViewController.isDoubleSided = true
            
            pageViewController.setViewControllers((displayController != nil ? [displayController!] : nil), direction: .forward, animated: false, completion: nil)
            
        }else if effectType == .translation { // 平移
            
            if displayController == nil { return }
            
            // 创建
            let options = [UIPageViewController.OptionsKey.spineLocation : NSNumber(value: UIPageViewController.SpineLocation.min.rawValue)]
            
            pageViewController = DZMPageViewController(transitionStyle: .scroll,navigationOrientation: .horizontal,options: options)
            
            // 自定义tap手势的相关代理
            pageViewController.aDelegate = self
            
            pageViewController.delegate = self
            
            pageViewController.dataSource = self
            
            contentView.insertSubview(pageViewController.view, at: 0)
            
            pageViewController.view.backgroundColor = UIColor.clear
            
            pageViewController.view.frame = contentView.bounds
            
            pageViewController.setViewControllers((displayController != nil ? [displayController!] : nil), direction: .forward, animated: false, completion: nil)
            
        }else if effectType == .scroll { // 滚动
            
            scrollController = DZMReadViewScrollController()
            
            scrollController.vc = self
            
            contentView.insertSubview(scrollController.view, at: 0)
            
            scrollController.view.frame = contentView.bounds
            
            scrollController.view.backgroundColor = UIColor.clear
            
            addChild(scrollController)
            
        }else{ // 覆盖 无效果
            
            if displayController == nil { return }
            
            coverController = DZMCoverController()
            
            coverController!.delegate = self
            
            contentView.insertSubview(coverController.view, at: 0)
            
            coverController.view.frame = contentView.bounds
            
            coverController.view.backgroundColor = UIColor.clear
            
            coverController!.setController(displayController)
            
            if DZMReadConfigure.shared().effectType == .no {
                
                coverController!.openAnimate = false
            }
        }
        
        // 记录
        currentDisplayController = displayController
    }
    
    /// 清理所有阅读控制器
    func clearPageController() {
        
        currentDisplayController?.removeFromParent()
        currentDisplayController = nil
        
        if pageViewController != nil {
            
            pageViewController?.view.removeFromSuperview()
            
            pageViewController?.removeFromParent()
            
            pageViewController = nil
        }
        
        if coverController != nil {
            
            coverController?.view.removeFromSuperview()
            
            coverController?.removeFromParent()
            
            coverController = nil
        }
        
        if scrollController != nil {
            
            scrollController?.view.removeFromSuperview()
            
            scrollController?.removeFromParent()
            
            scrollController = nil
        }
    }
    
    /// 手动设置翻页(注意: 非滚动模式调用)
    func setViewController(displayController:DZMReadViewController!, isAbove:Bool, animated:Bool) {
        
        if displayController != nil {
            
            // 仿真
            if pageViewController != nil {
                
                if (DZMReadConfigure.shared().effectType == .translation) { // 平移
                    
                    let direction:UIPageViewController.NavigationDirection = isAbove ? .reverse : .forward
                    
                    pageViewController.setViewControllers([displayController], direction: direction, animated: animated, completion: nil)
                    
                } else { // 仿真
                    
                    let direction:UIPageViewController.NavigationDirection = isAbove ? .reverse : .forward
                    
                    pageViewController.setViewControllers([displayController, GetReadViewBGController(recordModel: displayController?.recordModel, targetView: displayController?.view)], direction: direction, animated: animated, completion: nil)
                }
                
                return
            }
            
            // 覆盖 无效果
            if coverController != nil {
                
                coverController?.setController(displayController!, animated: animated, isAbove: isAbove)
                
                return
            }
            
            // 记录
            currentDisplayController = displayController
        }
    }
    
    
    // MARK: -- DZMCoverControllerDelegate
    
    /// 切换结果
    func coverController(_ coverController: DZMCoverController, currentController: UIViewController?, finish isFinish: Bool) {
        
        // 记录
        currentDisplayController = currentController as? DZMReadViewController
        
        // 更新阅读记录
        updateReadRecord(controller: currentDisplayController)
    }
    
    /// 将要显示的控制器
    func coverController(_ coverController: DZMCoverController, willTransitionToPendingController pendingController: UIViewController?) {
        
        readMenu.showMenu(isShow: false)
    }
    
    /// 获取上一个控制器
    func coverController(_ coverController: DZMCoverController, getAboveControllerWithCurrentController currentController: UIViewController?) -> UIViewController? {
        
        return GetAboveReadViewController()
    }
    
    /// 获取下一个控制器
    func coverController(_ coverController: DZMCoverController, getBelowControllerWithCurrentController currentController: UIViewController?) -> UIViewController? {
        
        return GetBelowReadViewController()
    }
    
    
    // MARK: -- UIPageViewControllerDelegate
    
    /// 切换结果
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        // 记录
        currentDisplayController = pageViewController.viewControllers?.first as? DZMReadViewController
        
        // 更新阅读记录
        updateReadRecord(controller: currentDisplayController)
    }
    
    /// 准备切换
    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        
        readMenu.showMenu(isShow: false)
    }
    
    // MARK: -- DZMPageViewControllerDelegate
    
    /// 获取上一页
    func pageViewController(_ pageViewController: DZMPageViewController, getViewControllerBefore viewController: UIViewController!) {
        
        // 获取上一页
        let readViewController = GetAboveReadViewController() as? DZMReadViewController
        
        // 手动设置
        setViewController(displayController: readViewController, isAbove: true, animated: true)
        
        // 更新阅读记录
        updateReadRecord(controller: readViewController)
        
        // 关闭菜单
        readMenu.showMenu(isShow: false)
    }
    
    /// 获取下一页
    func pageViewController(_ pageViewController: DZMPageViewController, getViewControllerAfter viewController: UIViewController!) {
        
        // 获取下一页
        let readViewController = GetBelowReadViewController() as? DZMReadViewController
        
        // 手动设置
        setViewController(displayController:readViewController, isAbove: false, animated: true)
        
        // 更新阅读记录
        updateReadRecord(controller: readViewController)
        
        // 关闭菜单
        readMenu.showMenu(isShow: false)
    }
    
    // MARK: -- UIPageViewControllerDataSource
    
    /// 获取上一页
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        if (DZMReadConfigure.shared().effectType == .translation) { // 平移
            
            return GetAboveReadViewController()
            
        } else { // 仿真
            
            // 翻页累计
            tempNumber -= 1
            
            // 获取当前页阅读记录
            var recordModel:DZMReadRecordModel? = (viewController as? DZMReadViewController)?.recordModel
            
            // 如果没有则从背面页面获取
            if recordModel == nil {
                
                recordModel = (viewController as? DZMReadViewBGController)?.recordModel
            }
            
            if abs(tempNumber) % 2 == 0 { // 背面
                
                recordModel = GetAboveReadRecordModel(recordModel: recordModel)
                
                return GetReadViewBGController(recordModel: recordModel)
                
            }else{ // 内容
                
                return GetReadViewController(recordModel: recordModel)
            }
        }
    }
    
    /// 获取下一页
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        if (DZMReadConfigure.shared().effectType == .translation) { // 平移
            
            return GetBelowReadViewController()
            
        } else { // 仿真
            
            // 翻页累计
            tempNumber += 1
            
            // 获取当前页阅读记录
            var recordModel:DZMReadRecordModel? = (viewController as? DZMReadViewController)?.recordModel
            
            // 如果没有则从背面页面获取
            if recordModel == nil {
                
                recordModel = (viewController as? DZMReadViewBGController)?.recordModel
            }
            
            if abs(tempNumber) % 2 == 0 { // 背面
                
                return GetReadViewBGController(recordModel: recordModel)
                
            }else{ // 内容
                
                recordModel = GetBelowReadRecordModel(recordModel: recordModel)
                
                return GetReadViewController(recordModel: recordModel)
            }
        }
    }
}
