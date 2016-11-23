//
//  HJReadUI.swift
//  HJProject
//
//  Created by 邓泽淼 on 16/8/15.
//  Copyright © 2016年 HanJue. All rights reserved.
//

/*
 
 主要存放阅读页面的 UI 创建
 
 */

import UIKit

class HJReadUI: NSObject,HJReadBottomViewDelegate,HJReadLightViewDelegate {
    
    /// 阅读控制器
    fileprivate weak var readPageController:HJReadPageController!
    
    /// UI布局
    var bottomView:HJReadBottomView!
    fileprivate var lightCoverView:UIView!
    var leftView:HJReadLeftView!
    var lightView:HJReadLightView!
    var settingView:HJReadSettingView!
    
    /// 阅读控制器设置
    class func readUIWithReadController(_ readPageController:HJReadPageController) ->HJReadUI {
        
        let readUI = HJReadUI()
        
        readUI.readPageController = readPageController
        
        readUI.addSubviews()
        
        return readUI
    }
    
    /// 添加子控件
    func addSubviews() {
        
        // lightCoverView
        lightCoverView = SpaceLineSetup(readPageController.view, color: UIColor.black)
        lightCoverView.isUserInteractionEnabled = false
        setLightCoverView(HJReadConfigureManger.shareManager.lightType)
        
        // bottomView
        bottomView = HJReadBottomView()
        bottomView.delegate = self
        readPageController.view.addSubview(bottomView)
        bottomView.slider.maximumValue = Float(readPageController.readModel.readChapterListModels.count - 1) // 设置页码
        
        // leftView
        leftView = HJReadLeftView()
        leftView.readPageController = readPageController
        
        // lightView
        lightView = HJReadLightView()
        lightView.delegate = self
        readPageController.view.addSubview(lightView)
        
        // settingView
        settingView = HJReadSettingView()
        readPageController.view.addSubview(settingView)
        
        // frame
        lightCoverView.frame = readPageController.view.bounds
        topView(true,animated: false)
        bottomView(true, animated: false, completion: nil)
        lightView(true, animated: false, completion: nil)
        settingView(true, animated: false, completion: nil)
    }
    
    
    // MARK: -- HJReadLightViewDelegate
    
    func readLightView(_ readLightView: HJReadLightView, lightType: HJReadLightType) {
        
        setLightCoverView(lightType)
    }
    
    
    // MARK: -- HJReadBottomViewDelegate
    
    /// 上一章
    func readBottomViewLastChapter(_ readBottomView: HJReadBottomView) {
        
        readPageController.readSetup.setFlipEffect(HJReadConfigureManger.shareManager.flipEffect,chapterID: "\(readPageController.readModel.readRecord.readChapterListModel.chapterID.integerValue() - 1)", chapterLookPageClear: true, contentOffsetYClear: true)
    }
    
    /// 下一章
    func readBottomViewNextChapter(_ readBottomView: HJReadBottomView) {
        
        readPageController.readSetup.setFlipEffect(HJReadConfigureManger.shareManager.flipEffect,chapterID: "\(readPageController.readModel.readRecord.readChapterListModel.chapterID.integerValue() + 1)", chapterLookPageClear: true,contentOffsetYClear: true)
    }
    
    /// 拖动进度
    func readBottomViewChangeSlider(_ readBottomView: HJReadBottomView, slider: UISlider) {
        
        readPageController.readModel.readRecord.page = NSNumber(value:Int(slider.value))
       
        readPageController.readSetup.setFlipEffect(HJReadConfigureManger.shareManager.flipEffect,chapterID: readPageController.readModel.readRecord.readChapterModel!.chapterID,chapterLookPageClear: false, contentOffsetYClear: true)
    }
    
    
    func readBottomView(_ readBottomView: HJReadBottomView, clickBarButtonIndex index: NSInteger) {
        
        if (index == 0) { // 目录
            
            leftView(false, animated: true)
            
        }else if (index == 1) { // 亮度
            
            bottomView(true, animated: true, completion: { [weak self] ()->() in
                
                self?.lightView(false, animated: true, completion: nil)
                
                })
            
        }else if (index == 2) { // 设置
            
            bottomView(true, animated: true, completion: { [weak self] ()->() in
                
                self?.settingView(false, animated: true, completion: nil)
                
                })
            
        }else{ // 下载
            
            MBProgressHUD.showMessage("下载存成章节文件,进入沙河看下文件格式")
            
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(Int64(2.0 * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC)) {
               
                MBProgressHUD.hide()
            }
        }
    }
    
    /// 设置亮度颜色
    func setLightCoverView(_ lightType:HJReadLightType) {
        
        if lightType == HJReadLightType.day {
            
            UIView.animate(withDuration: AnimateDuration, animations: {[weak self] ()->() in
                
                self?.lightCoverView.alpha = 0
                })
            
        }else{
            
            UIView.animate(withDuration: AnimateDuration, animations: {[weak self] ()->() in
                
                self?.lightCoverView.alpha = 0.6
                })
        }
    }
    
    // MARK: -- UI 显示
    
    /// topView
    func topView(_ hidden:Bool,animated:Bool) {
        
        // 导航栏操作
        readPageController.navigationController?.setNavigationBarHidden(hidden, animated: animated)
        UIApplication.shared.setStatusBarHidden(hidden, with: UIStatusBarAnimation.slide)
    }
    
    
    /// bottomView
    func bottomView(_ hidden:Bool,animated:Bool,completion:(() -> Void)?) {
        
        setupView(bottomView, viewHeight: 106, hidden: hidden, animated: animated, completion: completion)
    }
    
    
    /// lightView
    func lightView(_ hidden:Bool,animated:Bool,completion:(() -> Void)?) {
        
        setupView(lightView, viewHeight: 70, hidden: hidden, animated: animated, completion: completion)
    }
    
    
    /// settingView
    func settingView(_ hidden:Bool,animated:Bool,completion:(() -> Void)?) {
        
        setupView(settingView, viewHeight: 215, hidden: hidden, animated: animated, completion: completion)
    }
    
    /// setupView frame hidden show 只适用用于底部出现的view 其他不支持 看下代码显示在使用
    func setupView(_ view:UIView,viewHeight:CGFloat,hidden:Bool,animated:Bool,completion:(() -> Void)?) {
        
        if view.isHidden == hidden {return}
        
        let animateDuration = animated ? AnimateDuration : 0
        
        let viewH:CGFloat = viewHeight
        
        if hidden {
            
            UIView.animate(withDuration: animateDuration, animations: { ()->() in
                
                view.frame = CGRect(x: 0, y: ScreenHeight, width: ScreenWidth, height: viewH)
                
                }, completion: { (isOK) in
                    
                    view.isHidden = hidden
                    
                    if completion != nil {completion!()}
            })
            
            
        }else{
            
            view.isHidden = hidden
            
            UIView.animate(withDuration: animateDuration, animations: { ()->() in
                
                view.frame = CGRect(x: 0, y: ScreenHeight - viewH, width: ScreenWidth, height: viewH)
                
                }, completion: { (isOK) in
                    
                    if completion != nil {completion!()}
            })
        }
    }
    
    /// leftView
    func leftView(_ hidden:Bool,animated:Bool) {
        
        leftView.leftView(hidden, animated: animated)
    }
}
