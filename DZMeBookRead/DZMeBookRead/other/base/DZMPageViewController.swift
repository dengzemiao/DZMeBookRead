//
//  DZMPageViewController.swift
//  DZMeBookRead
//
//  Created by dengzemiao on 2020/3/17.
//  Copyright © 2020 DZM. All rights reserved.
//

import UIKit

// 左边上一页点击区域
private let LeftWidth:CGFloat = ScreenWidth / 3

// 右边下一页点击区域
private let RightWidth:CGFloat = ScreenWidth / 3

@objc protocol DZMPageViewControllerDelegate: NSObjectProtocol {
    
    /// 获取上一页
    @objc optional func pageViewController(_ pageViewController: DZMPageViewController, getViewControllerBefore viewController: UIViewController!)
    
    /// 获取下一页
    @objc optional func pageViewController(_ pageViewController: DZMPageViewController, getViewControllerAfter viewController: UIViewController!)
}

class DZMPageViewController: UIPageViewController, UIGestureRecognizerDelegate {

    // 自定义tap手势的相关代理
    var aDelegate:DZMPageViewControllerDelegate?
    
    // 自定义Tap手势
    private(set) var customTapGestureRecognizer: UITapGestureRecognizer!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        tapGestureRecognizerEnabled = false
        
        customTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(touchTap(tap:)))

        customTapGestureRecognizer.delegate = self

        view.addGestureRecognizer(customTapGestureRecognizer)
    }
    
    // tap事件
    @objc func touchTap(tap: UIGestureRecognizer) {
        
        let touchPoint = tap.location(in: view)
        
        if (touchPoint.x < LeftWidth) { // 左边
            
            aDelegate?.pageViewController?(self, getViewControllerBefore: viewControllers?.first)
            
        }else if (touchPoint.x > (ScreenWidth - RightWidth)) { // 右边
            
            aDelegate?.pageViewController?(self, getViewControllerAfter: viewControllers?.first)
        }
    }
    
    // MARK: UIGestureRecognizerDelegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {

        if (gestureRecognizer.isKind(of: UITapGestureRecognizer.classForCoder()) && gestureRecognizer.isEqual(customTapGestureRecognizer)) {

            let touchPoint = customTapGestureRecognizer.location(in: view)

            if (touchPoint.x > LeftWidth && touchPoint.x < (ScreenWidth - RightWidth)) {

                return true
            }
        }

        return false
    }
}
