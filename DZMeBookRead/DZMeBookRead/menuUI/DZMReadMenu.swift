//
//  DZMReadMenu.swift
//  DZMeBookRead
//
//  Created by 邓泽淼 on 2017/5/11.
//  Copyright © 2017年 DZM. All rights reserved.
//

/// 翻页类型
enum DZMRMEffectType:NSInteger {
    case none               // 无效果
    case translation        // 平移
    case simulation         // 仿真
    case upAndDown          // 上下
}

/// 字体类型
enum DZMRMFontType:NSInteger {
    case system             // 系统
    case one                // 黑体
    case two                // 楷体
    case three              // 宋体
}

import UIKit

@objc protocol DZMReadMenuDelegate:NSObjectProtocol {
    
    /// 状态栏 将要 - 隐藏以及显示状态改变
    @objc optional func readMenuWillShowOrHidden(readMenu:DZMReadMenu, isShow:Bool)
    
    /// 状态栏 完成 - 隐藏以及显示状态改变
    @objc optional func readMenuDidShowOrHidden(readMenu:DZMReadMenu, isShow:Bool)
    
    /// 点击下载
    @objc optional func readMenuClickDownload(readMenu:DZMReadMenu)
    
    /// 点击书签按钮
    @objc optional func readMenuClickMarkButton(readMenu:DZMReadMenu, button:UIButton)
    
    /// 点击上一章（上一话）
    @objc optional func readMenuClickPreviousChapter(readMenu:DZMReadMenu)
    
    /// 点击下一章（下一话）
    @objc optional func readMenuClickNextChapter(readMenu:DZMReadMenu)
    
    /// 停止滚动进度条
    @objc optional func readMenuSliderEndScroll(readMenu:DZMReadMenu,slider:ASValueTrackingSlider)
    
    /// 点击背景颜色
    @objc optional func readMenuClickSetuptColor(readMenu:DZMReadMenu,index:NSInteger,color:UIColor)
    
    /// 点击翻书动画
    @objc optional func readMenuClickSetuptEffect(readMenu:DZMReadMenu,index:NSInteger)
    
    /// 点击字体
    @objc optional func readMenuClickSetuptFont(readMenu:DZMReadMenu,index:NSInteger)
    
    /// 点击字体大小
    @objc optional func readMenuClickSetuptFontSize(readMenu:DZMReadMenu,fontSize:CGFloat)
    
    /// 点击日间夜间
    @objc optional func readMenuClickLightButton(readMenu:DZMReadMenu,isDay:Bool)
    
    /// 点击章节列表
    @objc optional func readMenuClickChapterList(readMenu:DZMReadMenu,readChapterListModel:DZMReadChapterListModel)
    
    /// 点击书签列表
    @objc optional func readMenuClickMarkList(readMenu:DZMReadMenu,readMarkModel:DZMReadMarkModel)
    
}

class DZMReadMenu: NSObject,UIGestureRecognizerDelegate {
    
    /// 控制器
    private(set) weak var vc:DZMReadController!
    
    /// 代理
    private(set) weak var delegate:DZMReadMenuDelegate!
    
    /// 阅读页面动画的时间
    private var animateDuration:TimeInterval = 0.20
    
    /// 菜单显示
    private(set) var menuShow:Bool = false
    
    /// 单击手势
    private(set) var singleTap:UITapGestureRecognizer!
    
    /// LeftView
    private(set) var leftView:DZMRMLeftView!
    
    /// TopView
    private(set) var topView:DZMRMTopView!
    
    /// BottomView
    private(set) var bottomView:DZMRMBottomView!
    
    /// 亮度
    private(set) var lightView:DZMRMLightView!
    
    /// 遮盖亮度
    private var coverView:UIView!
    
    /// 亮度按钮
    private var lightButton:DZMHaloButton!
    
    /// 小说阅读设置
    private var novelsSettingView:DZMRMSettingView!
    
    /// BottomView 高
    private let BottomViewH:CGFloat = isX ? 150 : 112
    
    /// LightView 高
    private let LightViewH:CGFloat = isX ? 80 : 64
    
    /// LightButton 宽高
    private let lightButtonWH:CGFloat = 84
    
    /// NovelsSettingView 高
    private let NovelsSettingViewH:CGFloat = isX ? 250 : 218
    
    /// 初始化
    class func readMenu(vc:DZMReadController,delegate:DZMReadMenuDelegate) ->DZMReadMenu {
        
        let readMenu = DZMReadMenu(vc:vc,delegate:delegate)
        
        return readMenu
    }
    
    /// 初始化函数
    private init(vc:DZMReadController,delegate:DZMReadMenuDelegate) {
        
        super.init()
        
        // 记录
        self.vc = vc
        self.delegate = delegate
        
        // 隐藏状态栏
        UIApplication.shared.setStatusBarHidden(!menuShow, with: .fade)
        
        // 允许获取电量信息
        UIDevice.current.isBatteryMonitoringEnabled = true
        
        // 隐藏导航栏
        vc.fd_prefersNavigationBarHidden = true
        
        // 禁止手势返回
        vc.fd_interactivePopDisabled = true
        
        // 添加手势
        initTapGestureRecognizer()
        
        // 创建UI
        creatUI()
        
        // 初始化数据
        initData()
    }
    
    /// 创建UI
    private func creatUI() {
        
        // 初始化公用按钮
        initLightButton()
        
        // 初始化TopView
        initTopView()
        
        // 初始化BottomView
        initBottomView()
        
        // 初始化LightView
        initLightView()
    
        // 初始化NovelsSettingView
        initNovelsSettingView()
        
        // 初始化LeftView
        initLeftView()
        
        // 初始化遮盖亮度
        initCoverView()
        
        // 设置为日夜间 默认日间
        lightButton.isSelected = DZMUserDefaults.boolForKey(DZMKey_IsNighOrtDay)
    }
    
    /// 初始化数据
    func initData() {
        
        // 进度条数据初始化
        bottomView.sliderUpdate()
    }
    
    // MARK: -- TapGestureRecognizer
    
    /// 初始化TapGestureRecognizer
    private func initTapGestureRecognizer() {
    
        // 单击手势
        singleTap = UITapGestureRecognizer(target: self, action: #selector(DZMReadMenu.touchSingleTap))
        singleTap.numberOfTapsRequired = 1
        singleTap.delegate = self
        vc.view.addGestureRecognizer(singleTap)
    }
    
    // 触发单击手势
    @objc private func touchSingleTap() {
        
        menuSH()
    }
    
    // MARK: -- UIGestureRecognizerDelegate
    
    /// 点击这些控件不需要执行手势
    private let ClassString:[String] = ["ASValueTrackingSlider","UITableViewCellContentView","UISlider","DZMRMLeftView","DZMRMTopView","DZMRMBottomView","DZMHaloButton","DZMRMLightView","DZMRMColorView","DZMRMFuncView","DZMSettingView","UIButton"]
    
    /// 手势拦截
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        
        let classString = String(describing: type(of: touch.view!))
        
        if ClassString.contains(classString) {
            
            return false
        }
        
        return true
    }
    
    // MARK: -- LeftView
    
    /// 初始化LeftView
    private func initLeftView() {
        
        leftView = DZMRMLeftView(frame:CGRect(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight),readMenu:self)
        
        leftView.isHidden = true
        
        leftView.backgroundColor = UIColor.clear
        
        vc.view.addSubview(leftView)
        
        leftView.addTarget(self, action: #selector(DZMReadMenu.clickLeftView), for: .touchUpInside)
        
    }
    
    /// 点击事件
    @objc private func clickLeftView() {
        
        leftView(isShow: false, complete: nil)
    }
    
    // MARK: -- SettingView
    
    /// 初始化NovelsSettingView
    private func initNovelsSettingView() {
        
        novelsSettingView = DZMRMSettingView(frame:CGRect(x: 0, y: ScreenHeight, width: ScreenWidth, height: NovelsSettingViewH),readMenu:self)
        
        novelsSettingView.isHidden = true
        
        vc.view.addSubview(novelsSettingView)
        
    }
    
    // MARK: -- CoverView
    
    /// 初始化CoverView
    private func initCoverView() {
        
        coverView = UIView()
        
        coverView.isUserInteractionEnabled = false
        
        coverView.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        coverView.alpha = DZMUserDefaults.boolForKey(DZMKey_IsNighOrtDay) ? 1.0 : 0
        
        vc.view.addSubview(coverView)
        
        coverView.frame = vc.view.bounds
    }
    
    
    // MARK: -- LightView
    
    /// 初始化LightView
    private func initLightView() {
        
        lightView = DZMRMLightView(readMenu:self)
        
        lightView.isHidden = true
        
        vc.view.addSubview(lightView)
        
        lightView.frame = CGRect(x: 0, y: ScreenHeight, width: ScreenWidth, height: LightViewH)
    }
    
    // MARK: -- LightButton
    
    /// 初始化LightButton
    private func initLightButton() {
        
        lightButton = DZMHaloButton(CGRect(x: ScreenWidth - lightButtonWH - DZMSpace_15, y: ScreenHeight, width: lightButtonWH, height: lightButtonWH), haloColor:UIColor.black.withAlphaComponent(0.75))
        
        lightButton.nomalImage = UIImage(named:"RM_14")
        
        lightButton.selectImage = UIImage(named:"RM_13")
        
        lightButton.isHidden = !menuShow
        
        vc.view.addSubview(lightButton)
        
        lightButton.addTarget(self, action: #selector(DZMReadMenu.clickLightButton), for: .touchUpInside)
    }
    
    /// 点击按钮
    @objc func clickLightButton(button:UIButton) {
        
        button.isSelected = !button.isSelected
        
        if button.isSelected {
            
            UIView.animate(withDuration: animateDuration, animations: { [weak self] ()->Void in
                
                self?.coverView.alpha = 1.0
            })
            
        }else{
            
            UIView.animate(withDuration: animateDuration, animations: { [weak self] ()->Void in
                
                self?.coverView.alpha = 0
            })
        }
        
        DZMUserDefaults.setBool(button.isSelected, key: DZMKey_IsNighOrtDay)
        
        delegate?.readMenuClickLightButton?(readMenu: self, isDay: button.isSelected)
    }
    
    // MARK: -- TopView
    
    /// 初始化TopView
    private func initTopView() {
        
        topView = DZMRMTopView(readMenu:self)
        
        topView.isHidden = !menuShow
        
        vc.view.addSubview(topView)
        
        topView.frame = CGRect(x: 0, y: -NavgationBarHeight, width: ScreenWidth, height: NavgationBarHeight)
        
        topView.back.addTarget(self, action: #selector(DZMReadMenu.clickBack), for: .touchUpInside)
    }
    
    /// 返回
    @objc func clickBack() {
        
        let _ = vc.navigationController?.popViewController(animated: true)
    }
    
    // MARK: -- BottomView
    private func initBottomView() {
        
        bottomView = DZMRMBottomView(readMenu:self)
        
        bottomView.isHidden = !menuShow
        
        vc.view.addSubview(bottomView)
        
        bottomView.frame = CGRect(x: 0, y: ScreenHeight, width: ScreenWidth, height: BottomViewH)
    }
    
    
    // MARK: -- 展示 Func
    
    /// 动画是否完成
    private var isAnimateComplete:Bool = true
    
    /// 菜单 show hidden
    func menuSH() {
        
        menuSH(isShow: !menuShow)
    }
    
    /// 菜单 show hidden
    func menuSH(isShow:Bool) {
        
        if isAnimateComplete {
            
            UIApplication.shared.setStatusBarHidden(!isShow, with: .fade)
        }
      
        menu(isShow: isShow)
    }
    
    /// 总控制
    private func menu(isShow:Bool) {
        
        if menuShow == isShow || !isAnimateComplete {return}
        
        isAnimateComplete = false
        
        menuShow = isShow
        
        // 将要动画
        delegate?.readMenuWillShowOrHidden?(readMenu: self, isShow: menuShow)
        
        bottomView(isShow: isShow, complete:nil)
        
        lightView(isShow: false, complete:nil)
        
        novelsSettingView(isShow: false, complete:nil)
        
        publicButton(isShow: isShow, complete:nil)
        
        topView(isShow: isShow) { [weak self] ()->Void in
            
            self?.isAnimateComplete = true
            
            // 完成动画
            self?.delegate?.readMenuDidShowOrHidden?(readMenu: self!, isShow: self!.menuShow)
        }
    }
    
    /// LeftView 展示
    func leftView(isShow:Bool,complete:(()->Void)?) {
        
        if leftView.isHidden == !isShow {return}
        
        if isShow {
            
            leftView.isHidden = false
            
            leftView.scrollReadRecord()
        }
        
        let rect = leftView.contentView.frame
        
        UIView.animate(withDuration: animateDuration, animations: { [weak self] ()->Void in
            
            if isShow {
                
                self?.leftView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
                
                self?.leftView.contentView.frame = CGRect(x: 0, y: 0, width: rect.width, height: rect.height)
                
            }else{
                
                self?.leftView.backgroundColor = UIColor.clear
                
                self?.leftView.contentView.frame = CGRect(x: -rect.width, y: 0, width: rect.width, height: rect.height)
            }
            
        }) {[weak self] (isOK) in
            
            if !isShow {self?.leftView.isHidden = true}
            
            if complete != nil {complete!()}
        }
    }
    
    /// TopView 展示
    func topView(isShow:Bool,complete:(()->Void)?) {
        
        if topView.isHidden == !isShow {return}
        
        if isShow {topView.isHidden = false}
       
        UIView.animate(withDuration: animateDuration, animations: { [weak self] ()->Void in
            
            if isShow {
                
                self?.topView.frame = CGRect(x: 0, y: 0, width: ScreenWidth, height: NavgationBarHeight)
                
            }else{
                
                self?.topView.frame = CGRect(x: 0, y: -NavgationBarHeight, width: ScreenWidth, height: NavgationBarHeight)
            }
            
        }) {[weak self] (isOK) in
            
            if !isShow {self?.topView.isHidden = true}
            
            if complete != nil {complete!()}
        }
    }
    
    /// BottomView 展示
    func bottomView(isShow:Bool,complete:(()->Void)?) {
        
        if bottomView.isHidden == !isShow {return}
        
        if isShow {bottomView.isHidden = false}
        
        UIView.animate(withDuration: animateDuration, animations: { [weak self] ()->Void in
            
            if isShow {
                
                self?.bottomView.frame = CGRect(x: 0, y: ScreenHeight - self!.BottomViewH, width: ScreenWidth, height: self!.BottomViewH)
                
            }else{
                
                self?.bottomView.frame = CGRect(x: 0, y: ScreenHeight, width: ScreenWidth, height: self!.BottomViewH)
            }
            
        }) {[weak self] (isOK) in
            
            if !isShow {self?.bottomView.isHidden = true}
            
            if complete != nil {complete!()}
        }
    }
    
    /// PublicButton 展示
    func publicButton(isShow:Bool,complete:(()->Void)?) {
        
        if lightButton.isHidden == !isShow {return}
        
        if isShow {
            
            if isShow {lightButton.isHidden = false}
            
            lightButton.frame = CGRect(x: ScreenWidth - lightButtonWH - DZMSpace_15, y: ScreenHeight, width: lightButtonWH, height: lightButtonWH)
            
            UIView.animate(withDuration: animateDuration, delay: 0.0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.0, options: .curveEaseInOut, animations: { [weak self] ()->Void in
                
                self?.lightButton.frame = CGRect(x: ScreenWidth - self!.lightButtonWH - DZMSpace_15, y: ScreenHeight - self!.BottomViewH - self!.lightButtonWH - DZMSpace_15, width: self!.lightButtonWH, height: self!.lightButtonWH)
                
                }, completion: { (isOK) in
                    
                    if complete != nil {complete!()}
            })
            
        }else{
            
            UIView.animate(withDuration: animateDuration, animations: { [weak self] ()->Void in
                
                self?.lightButton.frame = CGRect(x: ScreenWidth, y: self!.lightButton.y, width: self!.lightButtonWH, height: self!.lightButtonWH)
                
            }) {[weak self] (isOK) in
                
                if !isShow {self?.lightButton.isHidden = true}
                
                if complete != nil {complete!()}
            }
        }
    }
    
    /// 根据View 修改 PublicButton 的底部Y值
    func publicButtonBottomY(view:UIView) {
        
        UIView.animate(withDuration: animateDuration) { [weak self] ()->Void in
            
            self?.lightButton.frame = CGRect(x: self!.lightButton.x, y: ScreenHeight - view.height - self!.lightButtonWH - DZMSpace_15, width: self!.lightButtonWH, height: self!.lightButtonWH)
        }
    }
    
    /// LightView 展示
    func lightView(isShow:Bool,complete:(()->Void)?) {
        
        if lightView.isHidden == !isShow {return}
        
        if isShow {lightView.isHidden = false}
        
        UIView.animate(withDuration: animateDuration, animations: { [weak self] ()->Void in
            
            if isShow {
                
                self?.lightView.frame = CGRect(x: 0, y: ScreenHeight - self!.LightViewH, width: ScreenWidth, height: self!.LightViewH)
                
            }else{
                
                self?.lightView.frame = CGRect(x: 0, y: ScreenHeight, width: ScreenWidth, height: self!.LightViewH)
            }
            
        }) {[weak self] (isOK) in
            
            if !isShow {self?.lightView.isHidden = true}
            
            if complete != nil {complete!()}
        }
    }
    
    /// NovelsSettingView 展示
    func novelsSettingView(isShow:Bool,complete:(()->Void)?) {
        
        if novelsSettingView.isHidden == !isShow {return}
        
        if isShow {novelsSettingView.isHidden = false}
        
        UIView.animate(withDuration: animateDuration, animations: { [weak self] ()->Void in
            
            if isShow {
                
                self?.novelsSettingView.frame = CGRect(x: 0, y: ScreenHeight - self!.NovelsSettingViewH, width: ScreenWidth, height: self!.NovelsSettingViewH)
                
            }else{
                
                self?.novelsSettingView.frame = CGRect(x: 0, y: ScreenHeight, width: ScreenWidth, height: self!.NovelsSettingViewH)
            }
            
        }) {[weak self] (isOK) in
            
            if !isShow {self?.novelsSettingView.isHidden = true}
            
            if complete != nil {complete!()}
        }
    }
}
