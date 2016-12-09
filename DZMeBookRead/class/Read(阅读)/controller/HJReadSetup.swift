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
    fileprivate weak var readPageController:HJReadPageController!
    
    // rightItem 书签按钮
    var rightItem:UIButton!
    
    /// UI 设置
    var readUI:HJReadUI!
    
    /// 单击手势
    fileprivate var singleTap:UITapGestureRecognizer!
    
    // 当前功能view 显示状态 默认隐藏
    fileprivate var isRFHidden:Bool = true
    
    /// 阅读控制器设置
    class func setupWithReadController(_ readPageController:HJReadPageController) ->HJReadSetup {
        
        let readSetup = HJReadSetup()
        
        readSetup.readPageController = readPageController
        
        readSetup.readUI = HJReadUI.readUIWithReadController(readPageController)
        
        readSetup.setupSubviews()
        
        return readSetup
    }
    
    
    /// 初始化子控件相关
    func setupSubviews() {
        
        // rightItem
        rightItem = UIButton(type:UIButtonType.custom)
        rightItem.imageView?.contentMode = UIViewContentMode.scaleAspectFit
        rightItem.setImage(UIImage(named:"book_mark_nomal")!, for: UIControlState.normal)
        rightItem.setImage(UIImage(named:"book_mark_select")!, for: UIControlState.selected)
        rightItem.contentHorizontalAlignment = .right
        rightItem.bounds = CGRect(x: 0, y: 0, width: 30, height: 30)
        readPageController.navigationItem.rightBarButtonItem = UIBarButtonItem.itemButton(rightItem, target: self, action: #selector(HJReadSetup.clickBookMark))
        
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
    func singleTap(_ tap:UITapGestureRecognizer) {
        
        let point = tap.location(in: readPageController.view)
        
        // 无效果
        if (HJReadConfigureManger.shareManager.flipEffect == HJReadFlipEffect.none || HJReadConfigureManger.shareManager.flipEffect == HJReadFlipEffect.translation) && isRFHidden  {
            
            if point.x < HJTempW { // 左边
                
                let previousPageVC = readPageController.readConfigure.GetReadPreviousPage()
                
                if previousPageVC != nil { // 有上一页
                    
                    readPageController.coverController.setController(previousPageVC!, animated: (HJReadConfigureManger.shareManager.flipEffect.rawValue != 0), isAbove: true)
                    
                    // 记录
                    readPageController.readConfigure.synchronizationChangeData()
                }
                
            }else if point.x > (HJTempW * 2) { // 右边
                
                let nextPageVC = readPageController.readConfigure.GetReadNextPage()
                
                if nextPageVC != nil { // 有下一页
                    
                    readPageController.coverController.setController(nextPageVC!, animated: (HJReadConfigureManger.shareManager.flipEffect.rawValue != 0), isAbove: false)
                    
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
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
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
    func RFHidden(_ isHidden:Bool) {
        
        if (isRFHidden == isHidden) {return}
        
        isRFHidden = isHidden
        
        readUI.topView(isHidden, animated: true)
        
        readUI.bottomView(isHidden, animated: true, completion: nil)
        
        if !readUI.lightView.isHidden { // 亮度view 显示着
            
            readUI.lightView(true, animated: true, completion: nil)
        }
        
        if !readUI.settingView.isHidden { // 设置view 显示着
            
            readUI.settingView(true, animated: true, completion: nil)
        }
        
        if !readUI.leftView.hidden { // 设置view 显示着
            
            readUI.leftView.clickCoverButton()
        }
    }
    
    
    
    // MARK: -- HJReadLeftViewDelegate
    
    func readLeftView(_ readLeftView: HJReadLeftView, clickReadChapterModel model: HJReadChapterListModel, chapterLookPageClear: Bool) {
        
        setFlipEffect(HJReadConfigureManger.shareManager.flipEffect,chapterID: model.chapterID,chapterLookPageClear: chapterLookPageClear,contentOffsetYClear: true)
        
        RFHidden(!isRFHidden)
    }
    
    // MARK: -- HJReadSettingColorViewDelegate
    
    func readSettingColorView(_ readSettingColorView: HJReadSettingColorView, changeReadColor readColor: UIColor) {
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: HJReadChangeBGColorKey), object: nil)
    }
    
    // MARK: -- HJReadSettingFlipEffectViewDelegate
    
    func readSettingFlipEffectView(_ readSettingFlipEffectView: HJReadSettingFlipEffectView, changeFlipEffect flipEffect: HJReadFlipEffect) {
     
        setFlipEffect(flipEffect,chapterLookPageClear: false)
    }
    
    /// 设置翻页效果
    func setFlipEffect(_ flipEffect: HJReadFlipEffect,chapterLookPageClear:Bool) {
        
        setFlipEffect(flipEffect, chapterID: readPageController.readModel.readRecord.readChapterListModel.chapterID,chapterLookPageClear:chapterLookPageClear, contentOffsetYClear: false)
    }
    
    /// 设置翻页效果
    func setFlipEffect(_ flipEffect: HJReadFlipEffect,chapterID:String,chapterLookPageClear:Bool,contentOffsetYClear:Bool) {
        
        if flipEffect != HJReadFlipEffect.upAndDown || contentOffsetYClear { // 上下滚动
            
            readPageController.readModel.readRecord.contentOffsetY = nil
        }
        
        // 跳转章节
        readPageController.readConfigure.GoToReadChapter(chapterID, chapterLookPageClear: chapterLookPageClear, result: nil)
        
    }
    
    // MARK: -- HJReadSettingFontViewDelegate
    
    func readSettingFontView(_ readSettingFontView: HJReadSettingFontView, changeFont font: HJReadFont) {
        
        updateFont()
    }
    
    // MARK: -- HJReadSettingFontSizeViewDelegate
    
    func readSettingFontSizeView(_ readSettingFontSizeView: HJReadSettingFontSizeView, changeFontSize fontSize: Int) {
        
        updateFont()
    }
    
    /// 刷新字体 字号
    func updateFont() {
        
        // 刷新字体
        readPageController.readConfigure.updateCurrentShowReadRecordFont(readChapterModel: readPageController.readModel.readRecord.readChapterModel!)
        
        // 防止上下滚动模式通过 contentOffsetY 定位
        readPageController.readModel.readRecord.contentOffsetY = nil
        
        // 重新展示
        let previousPageVC = readPageController.readConfigure.GetReadViewController(readPageController.readModel.readRecord.readChapterModel!, currentPage: readPageController.readModel.readRecord.page.intValue)
        
        if (HJReadConfigureManger.shareManager.flipEffect == HJReadFlipEffect.simulation) { // 仿真
            
            readPageController.pageViewController.setViewControllers([previousPageVC], direction: UIPageViewControllerNavigationDirection.forward, animated: false, completion: nil)
            
        }else{
            
            readPageController.coverController.setController(previousPageVC, animated: false, isAbove: true)
        }
    }
    
    // MARK: -- 书签按钮
    
    func clickBookMark() {
        
        if (!rightItem.isSelected) { // 添加书签
            
            rightItem.isSelected = true
            
            readPageController.readConfigure.addBookMark()
            
            MBProgressHUD.showSuccess("添加书签成功")
            
        }else{ // 取消书签
            
            rightItem.isSelected = false;
            
            readPageController.readConfigure.removeBookMark()
            
            MBProgressHUD.showSuccess("删除书签成功")
        }
        
        // 隐藏
        RFHidden(true)
    }
}
