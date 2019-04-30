//
//  DZMReadMenu.swift
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/4/17.
//  Copyright © 2019年 DZM. All rights reserved.
//

import UIKit

@objc protocol DZMReadMenuDelegate:NSObjectProtocol {
    
    /// 菜单将要显示
    @objc optional func readMenuWillDisplay(readMenu:DZMReadMenu!)
    
    /// 菜单完成显示
    @objc optional func readMenuDidDisplay(readMenu:DZMReadMenu!)
    
    /// 菜单将要隐藏
    @objc optional func readMenuWillEndDisplay(readMenu:DZMReadMenu!)
    
    /// 菜单完成隐藏
    @objc optional func readMenuDidEndDisplay(readMenu:DZMReadMenu!)
    
    /// 点击返回
    @objc optional func readMenuClickBack(readMenu:DZMReadMenu!)
    
    /// 点击书签
    @objc optional func readMenuClickMark(readMenu:DZMReadMenu!, topView:DZMRMTopView!, markButton:UIButton!)
    
    /// 点击目录
    @objc optional func readMenuClickCatalogue(readMenu:DZMReadMenu!)
    
    /// 点击切换日夜间
    @objc optional func readMenuClickDayAndNight(readMenu:DZMReadMenu!)
    
    /// 点击上一章
    @objc optional func readMenuClickPreviousChapter(readMenu:DZMReadMenu!)
    
    /// 点击下一章
    @objc optional func readMenuClickNextChapter(readMenu:DZMReadMenu!)
    
    /// 拖拽章节进度(分页进度)
    @objc optional func readMenuDraggingProgress(readMenu:DZMReadMenu!, toPage:NSInteger)
    
    /// 拖拽章节进度(总文章进度,网络文章也可以使用)
    @objc optional func readMenuDraggingProgress(readMenu:DZMReadMenu!, toChapterID:NSNumber, toPage:NSInteger)
    
    /// 点击切换背景颜色
    @objc optional func readMenuClickBGColor(readMenu:DZMReadMenu)
    
    /// 点击切换字体
    @objc optional func readMenuClickFont(readMenu:DZMReadMenu)
    
    /// 点击切换字体大小
    @objc optional func readMenuClickFontSize(readMenu:DZMReadMenu)
    
    /// 切换进度显示(分页 || 总进度)
    @objc optional func readMenuClickDisplayProgress(readMenu:DZMReadMenu)
    
    /// 点击切换间距
    @objc optional func readMenuClickSpacing(readMenu:DZMReadMenu)
    
    /// 点击切换翻页效果
    @objc optional func readMenuClickEffect(readMenu:DZMReadMenu)
}

class DZMReadMenu: NSObject,UIGestureRecognizerDelegate {

    /// 控制器
    private(set) weak var vc:DZMReadController!
    
    /// 阅读主视图
    private(set) weak var contentView:DZMReadContentView!
    
    /// 代理
    private(set) weak var delegate:DZMReadMenuDelegate!
    
    /// 菜单显示状态
    private(set) var isMenuShow:Bool = false
    
    /// 单击手势
    private(set) var singleTap:UITapGestureRecognizer!
    
    /// TopView
    private(set) var topView:DZMRMTopView!
    
    /// BottomView
    private(set) var bottomView:DZMRMBottomView!
    
    /// SettingView
    private(set) var settingView:DZMRMSettingView!
    
    /// 日夜间遮盖
    private(set) var cover:UIView!
    
    /// 禁用系统初始化
    private override init() { super.init() }
    
    /// 初始化
    convenience init(vc:DZMReadController!, delegate:DZMReadMenuDelegate!) {
        
        self.init()
        
        // 记录
        self.vc = vc
        self.contentView = vc.contentView
        self.delegate = delegate
        
        // 隐藏状态栏
        UIApplication.shared.setStatusBarHidden(!isMenuShow, with: .fade)
        
        // 允许获取电量信息
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        // 隐藏导航栏
        vc.fd_prefersNavigationBarHidden = true
        
        // 禁止手势返回
        vc.fd_interactivePopDisabled = true
        
        // 添加单机手势
        initTapGestureRecognizer()
        
        // 初始化日夜间遮盖
        initCover()
        
        // 初始化TopView
        initTopView()
        
        // 初始化SettingView
        initSettingView()
        
        // 初始化BottomView
        initBottomView()
    }
    
    // MARK: -- 添加单机手势
    
    /// 添加单机手势
    private func initTapGestureRecognizer() {
        
        // 单击手势
        singleTap = UITapGestureRecognizer(target: self, action: #selector(touchSingleTap))
        singleTap.numberOfTapsRequired = 1
        singleTap.delegate = self
        vc.contentView.addGestureRecognizer(singleTap)
    }
    
    // 触发单击手势
    @objc private func touchSingleTap() {
        
        showMenu(isShow: !isMenuShow)
    }
    
    // MARK: -- UIGestureRecognizerDelegate
    
    /// 点击这些控件不需要执行手势
    private let ClassStrings:[String] = ["DZMRMTopView","DZMRMBottomView","DZMRMSettingView","DZMRMFontSizeView", "DZMRMFontTypeView","DZMRMLightView","DZMRMSpacingView","DZMRMEffectTypeView","DZMRMBGColorView","DZMRMFuncView","DZMRMProgressView","UIControl","UISlider","ASValueTrackingSlider"]
    
    /// 手势拦截
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        let classString = String(describing: type(of: touch.view!))
        
        if ClassStrings.contains(classString) {
            
            return false
        }
        
        return true
    }
    
    // MARK: 日夜间遮盖
    
    /// 初始化日夜间遮盖
    private func initCover() {
        
        cover = UIView()
        cover.alpha = CGFloat(NSNumber(value: DZMUserDefaults.bool(DZM_READ_KEY_MODE_DAY_NIGHT)).floatValue)
        cover.isUserInteractionEnabled = false
        cover.backgroundColor = UIColor.black.withAlphaComponent(0.7)
        vc.view.addSubview(cover)
        cover.frame = vc.view.bounds
    }
    
    // MARK: -- TopView
    
    /// 初始化TopView
    private func initTopView() {
        
        topView = DZMRMTopView(readMenu: self)
        
        topView.isHidden = !isMenuShow
        
        contentView.addSubview(topView)
        
        let y = isMenuShow ? 0 : -DZM_READ_MENU_TOP_VIEW_HEIGHT
        
        topView.frame = CGRect(x: 0, y: y, width: DZM_READ_CONTENT_VIEW_WIDTH, height: DZM_READ_MENU_TOP_VIEW_HEIGHT)
    }
    
    // MARK: -- BottomView
    
    /// 初始化BottomView
    private func initBottomView() {
        
        bottomView = DZMRMBottomView(readMenu: self)
    
        bottomView.isHidden = !isMenuShow
        
        contentView.addSubview(bottomView)
        
        let y = isMenuShow ? (DZM_READ_CONTENT_VIEW_HEIGHT - DZM_READ_MENU_BOTTOM_VIEW_HEIGHT) : DZM_READ_CONTENT_VIEW_HEIGHT
        
        bottomView.frame = CGRect(x: 0, y: y, width: DZM_READ_CONTENT_VIEW_WIDTH, height: DZM_READ_MENU_BOTTOM_VIEW_HEIGHT)
        
        
        // 绘制中间虚线(如果不需要虚线可以去掉自己加个分割线)
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        
        shapeLayer.bounds = bottomView.bounds
        
        shapeLayer.position = CGPoint(x: bottomView.frame.width / 2, y: bottomView.frame.height / 2)
        
        shapeLayer.fillColor = UIColor.clear.cgColor
        
        shapeLayer.strokeColor = DZM_READ_COLOR_MENU_COLOR.cgColor
        
        shapeLayer.lineWidth = DZM_SPACE_LINE
        
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        
        shapeLayer.lineDashPhase = 0
        
        shapeLayer.lineDashPattern = [NSNumber(value: 1), NSNumber(value: 2)]
        
        let path:CGMutablePath = CGMutablePath()
        
        path.move(to: CGPoint(x: 0, y: DZM_READ_MENU_PROGRESS_VIEW_HEIGHT))
        
        path.addLine(to: CGPoint(x: bottomView.frame.width, y: DZM_READ_MENU_PROGRESS_VIEW_HEIGHT))
        
        shapeLayer.path = path
        
        bottomView.layer.addSublayer(shapeLayer)
    }
    
    // MARK: -- SettingView
    
    /// 初始化SettingView
    private func initSettingView() {
        
        settingView = DZMRMSettingView(readMenu: self)
        
        settingView.isHidden = true
        
        contentView.addSubview(settingView)
        
        settingView.frame = CGRect(x: 0, y: DZM_READ_CONTENT_VIEW_HEIGHT, width: DZM_READ_CONTENT_VIEW_WIDTH, height: DZM_READ_MENU_SETTING_VIEW_TOTAL_HEIGHT)
    }
    
    // MARK: 菜单展示
    
    /// 动画是否完成
    private var isAnimateComplete:Bool = true
    
    func showMenu(isShow:Bool) {
        
        if isMenuShow == isShow || !isAnimateComplete {return}
        
        isAnimateComplete = false
        
        if isShow { delegate?.readMenuWillDisplay?(readMenu: self)
            
        }else{ delegate?.readMenuWillEndDisplay?(readMenu: self) }
        
        isMenuShow = isShow
        
        showBottomView(isShow: isShow)

        showSettingView(isShow: false)
        
        showTopView(isShow: isShow) { [weak self] () in
            
            self?.isAnimateComplete = true
            
            if isShow { self?.delegate?.readMenuDidDisplay?(readMenu: self!)
                
            }else{ self?.delegate?.readMenuDidEndDisplay?(readMenu: self!) }
        }
    }
    
    /// TopView展示
    func showTopView(isShow:Bool, completion:DZMAnimationCompletion? = nil) {
        
        UIApplication.shared.setStatusBarHidden(!isShow, with: .slide)
        
        if isShow { topView.isHidden = false }
        
        UIView.animate(withDuration: DZM_READ_AD_TIME, delay: 0, options: .curveEaseOut, animations: { [weak self] () in
            
            let y = isShow ? 0 : -DZM_READ_MENU_TOP_VIEW_HEIGHT
            
            self?.topView.frame.origin = CGPoint(x: 0, y: y)
            
        }) { [weak self] (isOK) in
            
            if !isShow { self?.topView.isHidden = true }
            
            completion?()
        }
    }
    
    /// BottomView展示
    func showBottomView(isShow:Bool, completion:DZMAnimationCompletion? = nil) {
  
        if isShow { bottomView.isHidden = false }

        UIView.animate(withDuration: DZM_READ_AD_TIME, animations: { [weak self] () in
            
            let y = isShow ? (DZM_READ_CONTENT_VIEW_HEIGHT - DZM_READ_MENU_BOTTOM_VIEW_HEIGHT) : DZM_READ_CONTENT_VIEW_HEIGHT
            
            self?.bottomView.frame.origin = CGPoint(x: 0, y: y)
            
        }) { [weak self] (isOK) in
            
            if !isShow { self?.bottomView.isHidden = true }
            
            completion?()
        }
    }
    
    /// SettingView展示
    func showSettingView(isShow:Bool, completion:DZMAnimationCompletion? = nil) {
      
        if isShow { settingView.isHidden = false }
        
        UIView.animate(withDuration: DZM_READ_AD_TIME, delay: 0, options: .curveEaseOut, animations: { [weak self] () in
            
            let y = isShow ? (DZM_READ_CONTENT_VIEW_HEIGHT - DZM_READ_MENU_SETTING_VIEW_TOTAL_HEIGHT) : DZM_READ_CONTENT_VIEW_HEIGHT
            
            self?.settingView.frame.origin = CGPoint(x: 0, y: y)
            
        }) { [weak self] (isOK) in
            
            if !isShow { self?.settingView.isHidden = true }
            
            completion?()
        }
    }
}
