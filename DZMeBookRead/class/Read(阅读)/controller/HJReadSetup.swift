//
//  HJReadSetup.swift
//  HJProject
//
//  Created by 邓泽淼 on 16/8/15.
//  Copyright © 2016年 HanJue. All rights reserved.
//

/*
 
 主要存放阅读页面操作逻辑 UI
 
 */

/// 点击手势区分
private let HJTempW:CGFloat = ScreenWidth / 3

import UIKit

class HJReadSetup: NSObject,UIGestureRecognizerDelegate,HJReadSettingColorViewDelegate,HJReadSettingFlipEffectViewDelegate,HJReadSettingFontViewDelegate,HJReadSettingFontSizeViewDelegate,HJReadLeftViewDelegate {

    /// 阅读控制器
    private weak var readPageController:HJReadPageController!
    
    /// UI 设置
    var readUI:HJReadUI!
    
    /// 单击手势
    private var singleTap:UITapGestureRecognizer!
    
    // 当前功能view 显示状态 默认隐藏
    private var isRFHidden:Bool = true
    
    /// 阅读控制器设置
    class func setupWithReadController(readPageController:HJReadPageController) ->HJReadSetup {
        
        let readSetup = HJReadSetup()
        
        readSetup.readPageController = readPageController
        
        readSetup.readUI = HJReadUI.readUIWithReadController(readPageController)
        
        readSetup.setupSubviews()
        
        return readSetup
    }
    
    
    /// 初始化子控件相关
    func setupSubviews() {
        
        // 添加手势
        singleTap = UITapGestureRecognizer(target: self, action:#selector(HJReadSetup.singleTap(_:)))
        singleTap.numberOfTapsRequired = 1
        singleTap.delegate = self
        readPageController.view.addGestureRecognizer(singleTap)
        
        // 设置代理
        readUI.settingView.colorView.aDelegate = self
        readUI.settingView.flipEffectView.delegate = self
        readUI.settingView.fontView.delegate = self
        readUI.settingView.fontSizeView.delegate = self
        readUI.leftView.delegate = self
    }
    
    /// 单击手势
    func singleTap(tap:UITapGestureRecognizer) {
        
        let point = tap.locationInView(readPageController.view)
        
        // 无效果
        if (HJReadConfigureManger.shareManager.flipEffect == HJReadFlipEffect.None || HJReadConfigureManger.shareManager.flipEffect == HJReadFlipEffect.Translation) && isRFHidden  {
            
            if point.x < HJTempW { // 左边
                
                let previousPageVC = readPageController.readConfigure.GetReadPreviousPage()
                
                if previousPageVC != nil { // 有上一页
                    
                    readPageController.coverController.setController(previousPageVC!, animated: Bool(HJReadConfigureManger.shareManager.flipEffect.rawValue), isAbove: true)
                    
                    // 记录
                    readPageController.readConfigure.synchronizationChangeData()
                }
                
            }else if point.x > (HJTempW * 2) { // 右边
                
                let nextPageVC = readPageController.readConfigure.GetReadNextPage()
                
                if nextPageVC != nil { // 有下一页
                    
                    readPageController.coverController.setController(nextPageVC!, animated: Bool(HJReadConfigureManger.shareManager.flipEffect.rawValue), isAbove: false)
                    
                    // 记录
                    readPageController.readConfigure.synchronizationChangeData()
                }
                
            }else{ // 中间
                
                RFHidden(!isRFHidden)
            }
            
        }else{
            
            RFHidden(!isRFHidden)
        }
        
        
    }
    
    // MARK: -- UIGestureRecognizerDelegate
    
    // 点击这些view 不需要执行手势
    let ClassString:[String] = ["UISlider","HJProject.HJReadSettingView","HJProject.HJReadSettingColorView","HJProject.HJReadSettingFlipEffectView","HJProject.HJReadSettingFontView","HJProject.HJReadSettingFontSizeView"]
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        
        let classString = NSStringFromClass(touch.view!.classForCoder)
        
        if classString == "HJProject.HJReadView" || classString == "UITableViewCellContentView" { // 触摸到了阅读view
            
            if !isRFHidden {
                
                RFHidden(!isRFHidden)
                
                return false
            }
        }
        
        if ClassString.contains(classString) {
            
            return false
        }
        
        return true
    }
    
    // MARK: -- 设置方法
    
    /// 隐藏显示功能view
    func RFHidden(isHidden:Bool) {
        
        if (isRFHidden == isHidden) {return}
        
        isRFHidden = isHidden
        
        readUI.topView(isHidden, animated: true)
        
        readUI.bottomView(isHidden, animated: true, completion: nil)
        
        if !readUI.lightView.hidden { // 亮度view 显示着
            
            readUI.lightView(true, animated: true, completion: nil)
        }
        
        if !readUI.settingView.hidden { // 设置view 显示着
            
            readUI.settingView(true, animated: true, completion: nil)
        }
        
        if !readUI.leftView.hidden { // 设置view 显示着
            
            readUI.leftView.clickCoverButton()
        }
    }
    
    
    
    // MARK: -- HJReadLeftViewDelegate
    
    func readLeftView(readLeftView: HJReadLeftView, clickReadChapterModel model: HJReadChapterListModel) {
        
        setFlipEffect(HJReadConfigureManger.shareManager.flipEffect,chapterID: model.chapterID,chapterLookPageClear: true,contentOffsetYClear: true)
        
        RFHidden(!isRFHidden)
    }
    
    // MARK: -- HJReadSettingColorViewDelegate
    
    func readSettingColorView(readSettingColorView: HJReadSettingColorView, changeReadColor readColor: UIColor) {
        
        NSNotificationCenter.defaultCenter().postNotificationName(HJReadChangeBGColorKey, object: nil)
    }
    
    // MARK: -- HJReadSettingFlipEffectViewDelegate
    
    func readSettingFlipEffectView(readSettingFlipEffectView: HJReadSettingFlipEffectView, changeFlipEffect flipEffect: HJReadFlipEffect) {
     
        setFlipEffect(flipEffect,chapterLookPageClear: false)
    }
    
    /// 设置翻页效果
    func setFlipEffect(flipEffect: HJReadFlipEffect,chapterLookPageClear:Bool) {
        
        setFlipEffect(flipEffect, chapterID: readPageController.readModel.readRecord.readChapterListModel.chapterID,chapterLookPageClear:chapterLookPageClear, contentOffsetYClear: false)
    }
    
    /// 设置翻页效果
    func setFlipEffect(flipEffect: HJReadFlipEffect,chapterID:String,chapterLookPageClear:Bool,contentOffsetYClear:Bool) {
        
        if flipEffect != HJReadFlipEffect.UpAndDown || contentOffsetYClear { // 上下滚动
            
            readPageController.readModel.readRecord.contentOffsetY = nil
        }
        
        // 跳转章节
        readPageController.readConfigure.GoToReadChapter(chapterID, chapterLookPageClear: chapterLookPageClear, result: nil)
        
    }
    
    // MARK: -- HJReadSettingFontViewDelegate
    
    func readSettingFontView(readSettingFontView: HJReadSettingFontView, changeFont font: HJReadFont) {
        
        updateFont()
    }
    
    // MARK: -- HJReadSettingFontSizeViewDelegate
    
    func readSettingFontSizeView(readSettingFontSizeView: HJReadSettingFontSizeView, changeFontSize fontSize: Int) {
        
        updateFont()
    }
    
    /// 刷新字体 字号
    func updateFont() {
        
        // 刷新字体
        readPageController.readConfigure.updateReadRecordFont()
        
        // 重新展示
        let previousPageVC = readPageController.readConfigure.GetReadViewController(readPageController.readModel.readRecord.readChapterModel!, currentPage: readPageController.readModel.readRecord.page.integerValue)
        
        if (HJReadConfigureManger.shareManager.flipEffect == HJReadFlipEffect.Simulation) { // 仿真
            
            readPageController.pageViewController.setViewControllers([previousPageVC], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
            
        }else{
            
            readPageController.coverController.setController(previousPageVC, animated: false, isAbove: true)
        }
    }
}
