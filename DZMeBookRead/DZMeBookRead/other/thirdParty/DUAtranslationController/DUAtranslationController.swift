//
//  DUAtranslationController.swift
//  DUATranslationController
//
//  Created by mengminduan on 2018/1/10.
//  Copyright © 2018年 nothot. All rights reserved.
//
/// 本文件为独立的UI控件，实现页面切换，可用于阅读器平移翻页，无动画翻页
import UIKit

let animationDuration = 0.2
let limitRate: CGFloat = 0.05
let screenWidth = UIScreen.main.bounds.width
let screenHeight = UIScreen.main.bounds.height



enum translationControllerNavigationDirection {
    case left
    case right
}

protocol DUATranslationProtocol: NSObjectProtocol {
    func translationController(translationController: DUAtranslationController, controllerAfter controller: UIViewController) -> UIViewController?
    func translationController(translationController: DUAtranslationController, controllerBefore controller: UIViewController) -> UIViewController?
    func translationController(translationController: DUAtranslationController, willTransitionTo controller: UIViewController) -> Void
    func translationController(translationController: DUAtranslationController, didFinishAnimating finished: Bool, previousController: UIViewController, transitionCompleted completed: Bool) -> Void
}



class DUAtranslationController: UIViewController, UIGestureRecognizerDelegate {
    
    var delegate: DUATranslationProtocol?
    
    var pendingController: UIViewController?
    
    var currentController: UIViewController?
    
    var startPoint: CGPoint!
    
    var scrollDirection = 0 // 0 is unknown, 1 is right, -1 is left
    
    var allowRequestNewController = true
    
    var isPanning = false
    
    var allowAnimating = true // true 平移效果，false 无效果
    
    
    
    //    MARK: 对外方法
    
    func setViewController(viewController: UIViewController, direction: translationControllerNavigationDirection, animated: Bool, completionHandler: ((Bool) -> Void)?) -> Void {
        if animated == false {
            for controller in self.children {
                self.removeController(controller: controller)
            }
            self.addController(controller: viewController)
            if completionHandler != nil {
                completionHandler!(true)
            }
        }else {
            let oldController = self.children.first
            self.addController(controller: viewController)
            
            var newVCEndTransform: CGAffineTransform
            var oldVCEndTransform: CGAffineTransform
            viewController.view.transform = .identity
            if direction == .left {
                viewController.view.transform = CGAffineTransform(translationX: screenWidth, y: 0)
                newVCEndTransform = .identity
                oldController?.view.transform = .identity
                oldVCEndTransform = CGAffineTransform(translationX: -screenWidth, y: 0)
            }else {
                viewController.view.transform = CGAffineTransform(translationX: -screenWidth, y: 0)
                newVCEndTransform = .identity
                oldController?.view.transform = .identity
                oldVCEndTransform = CGAffineTransform(translationX: screenWidth, y: 0)
            }
            
            UIView.animate(withDuration: animationDuration, animations: {
                oldController?.view.transform = oldVCEndTransform
                viewController.view.transform = newVCEndTransform
            }, completion: { (complete) in
                if complete {
                    self.removeController(controller: oldController!)
                }
                if completionHandler != nil {
                    completionHandler!(complete)
                }
                
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.lightGray
        
        if allowAnimating {
            let panGes = UIPanGestureRecognizer.init(target: self, action: #selector(handlePanGes(gesture:)))
            self.view.addGestureRecognizer(panGes)
        }
        
        let tapGes = UITapGestureRecognizer.init(target: self, action: #selector(handleTapGes(gesture:)))
        self.view.addGestureRecognizer(tapGes)
        tapGes.delegate = self
    }
    
    //    MARK: 手势处理
    
    /// 处理拖动手势
    ///
    /// - Parameter gesture: 拖动手势识别器
    @objc func handlePanGes(gesture: UIPanGestureRecognizer) -> Void {
        
        let basePoint = gesture.translation(in: gesture.view)
        
        if gesture.state == .began {
            
            currentController = self.children.first
            startPoint = gesture.location(in: gesture.view)
            isPanning = true
            allowRequestNewController = true
        }
        else if gesture.state == .changed {
            
            if basePoint.x > 0 {
                if scrollDirection == 0 {
                    scrollDirection = 1
                }
                else if scrollDirection == -1 {
                    scrollDirection = 1
                    self.removeController(controller: pendingController!)
                    allowRequestNewController = true
                }
                // go to right
                if allowRequestNewController {
                    allowRequestNewController = false
                    pendingController = self.delegate?.translationController(translationController: self, controllerBefore: currentController!)
                    pendingController?.view.transform = CGAffineTransform(translationX: -screenWidth, y: 0)
                    if pendingController != nil {
                        self.delegate?.translationController(translationController: self, willTransitionTo: pendingController!)
                        self.addController(controller: pendingController!)
                    }
                }
                
            }
            else if basePoint.x < 0 {
                if scrollDirection == 0 {
                    scrollDirection = -1
                }
                else if scrollDirection == 1 {
                    scrollDirection = -1
                    self.removeController(controller: pendingController!)
                    allowRequestNewController = true
                }
                // go to left
                if allowRequestNewController {
                    allowRequestNewController = false
                    pendingController = self.delegate?.translationController(translationController: self, controllerAfter: currentController!)
                    pendingController?.view.transform = CGAffineTransform(translationX: screenWidth, y: 0)
                    if pendingController != nil {
                        self.delegate?.translationController(translationController: self, willTransitionTo: pendingController!)
                        self.addController(controller: pendingController!)
                    }
                }
                
            }
            
            if pendingController == nil {
                return
            }
            
            
            let walkingPoint = gesture.location(in: gesture.view)
            let offsetX = walkingPoint.x - startPoint.x
            currentController?.view.transform = CGAffineTransform(translationX: offsetX, y: 0)
            pendingController?.view.transform = offsetX < 0 ? CGAffineTransform(translationX: screenWidth + offsetX, y: 0) : CGAffineTransform(translationX: -screenWidth + offsetX, y: 0)
        }
        else{
            
            isPanning = false
            allowRequestNewController = true
            scrollDirection = 0
            if pendingController == nil {
                return
            }
            
            let endPoint = gesture.location(in: gesture.view)
            let finalOffsetRate = (endPoint.x - startPoint.x)/screenWidth
            var currentEndTransform: CGAffineTransform = .identity
            var pendingEndTransform: CGAffineTransform = .identity
            var removeController: UIViewController? = nil
            var transitionFinished = false
            
            if finalOffsetRate >= limitRate {
                transitionFinished = true
                currentEndTransform = CGAffineTransform(translationX: screenWidth, y: 0)
                removeController = self.currentController
            }
            else if finalOffsetRate < limitRate && finalOffsetRate >= 0 {
                pendingEndTransform = CGAffineTransform(translationX: -screenWidth, y: 0)
                removeController = pendingController
            }
            else if finalOffsetRate < 0 && finalOffsetRate > -limitRate {
                pendingEndTransform = CGAffineTransform(translationX: screenWidth, y: 0)
                removeController = pendingController
            }
            else {
                transitionFinished = true
                currentEndTransform = CGAffineTransform(translationX: -screenWidth, y: 0)
                removeController = self.currentController
            }
            
            UIView.animate(withDuration: animationDuration, animations: {
                self.pendingController?.view.transform = pendingEndTransform
                self.currentController?.view.transform = currentEndTransform
            }, completion: { (complete) in
                if complete {
                    self.removeController(controller: removeController!)
                }
                self.delegate?.translationController(translationController: self, didFinishAnimating: complete, previousController: self.currentController!, transitionCompleted: transitionFinished)
            })
            
        }
    }
    
    /// 处理点击手势
    ///
    /// - Parameter gesture: 点击手势识别器
    @objc func handleTapGes(gesture: UITapGestureRecognizer) -> Void {
        let hitPoint = gesture.location(in: gesture.view)
        let curController = self.children.first!
        
        if hitPoint.x < gesture.view!.frame.size.width/3 {
            //            滑向上一个controller
            let lastController = self.delegate?.translationController(translationController: self, controllerBefore: curController)
            if lastController != nil {
                self.delegate?.translationController(translationController: self, willTransitionTo: lastController!)
                self.setViewController(viewController: lastController!, direction: .right, animated: allowAnimating, completionHandler: {(complete) in
                    self.delegate?.translationController(translationController: self, didFinishAnimating: complete, previousController: curController, transitionCompleted: complete)
                })
            }
            
        }
        if hitPoint.x > gesture.view!.frame.size.width*2/3 {
            //            滑向下一个controller
            let nextController: UIViewController? = self.delegate?.translationController(translationController: self, controllerAfter: self.children.first!)
            if nextController != nil {
                self.delegate?.translationController(translationController: self, willTransitionTo: nextController!)
                self.setViewController(viewController: nextController!, direction: .left, animated: allowAnimating, completionHandler: {(complete) in
                    
                    self.delegate?.translationController(translationController: self, didFinishAnimating: complete, previousController: curController, transitionCompleted: complete)
                })
            }
            
        }
        
    }
    
    //    MAEK: 添加删除controller
    func addController(controller: UIViewController) -> Void {
        self.addChild(controller)
        controller.didMove(toParent: self)
        self.view.addSubview(controller.view)
    }
    
    func removeController(controller: UIViewController) -> Void {
        controller.view.removeFromSuperview()
        controller.willMove(toParent: nil)
        controller.removeFromParent()
    }
    
    
    //    MARK: gesture delegate
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UITapGestureRecognizer {
            let tempWidth = screenWidth/3
            let hitPoint = gestureRecognizer.location(in: gestureRecognizer.view)
            if hitPoint.x > tempWidth && hitPoint.x < (screenWidth - tempWidth) {
                return true
            }
        }
        
        return false
    }
}
