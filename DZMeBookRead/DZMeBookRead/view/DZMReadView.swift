//
//  DZMReadView.swift
//  DZMeBookRead
//
//  Created by 邓泽淼 on 2017/5/15.
//  Copyright © 2017年 DZM. All rights reserved.
//

/// Pan手势状态
enum DZMPanStatus {
    case begin
    case changed
    case end
}

import UIKit

class DZMReadView: UIView {
    
    /// 内容
    var content:NSMutableAttributedString? {
        
        didSet{
            
            if content != nil && (content!.length > 0) {
                
                frameRef = DZMReadParser.GetReadFrameRef(attrString: content!, rect: GetReadViewFrame())
            }
        }
    }
    
    /// CTFrame
    var frameRef:CTFrame? {
        
        didSet{
            
            if frameRef != nil { setNeedsDisplay() }
        }
    }
    
    /// 开启长按菜单
    var openLongMenu:Bool = true {
        
        didSet{
            
            longGes?.isEnabled = openLongMenu
        }
    }
    
    /// 选中区域
    private var selectRange:NSRange?
    
    /// 选中区域范围数组
    private var rects:[CGRect] = []
    
    /// 长按
    private var longGes:UILongPressGestureRecognizer?
    
    /// 单击
    private var tapGes:UITapGestureRecognizer?
    
    /// 开启拖拽
    private(set) var isOpenDrag:Bool = false
    
    /// 左光标
    private var LCursorView:DZMCursorView!
    
    /// 右光标
    private var RCursorView:DZMCursorView!
    
    /// 触摸的光标
    private var isLorR_Cursor:Bool = true
    
    /// 是否触摸到光标
    private var isTouchCursor:Bool = false
    
    /// 动画时间
    private var animateDuration:TimeInterval = 0.25
    
    /// 放大镜
    private var magnifierView:DZMMagnifierView?
    
    /// 初始化
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        longGes = UILongPressGestureRecognizer(target: self, action: #selector(longAction(long:)))
        longGes?.isEnabled = openLongMenu
        addGestureRecognizer(longGes!)
        
        tapGes = UITapGestureRecognizer(target: self, action: #selector(tapAction(tap:)))
        tapGes!.isEnabled = false
        addGestureRecognizer(tapGes!)
    }
    
    // MARK: 手势事件相关
    
    /// 长按事件
    @objc private func longAction(long:UILongPressGestureRecognizer) {
        
        // 禁止上下滚动使用
        if DZMReadConfigure.shared().effectType == DZMRMEffectType.upAndDown.rawValue { return }
        
        // 触摸位置
        let point = long.location(in: self)
        
        // 触摸位置
        let windowPoint = long.location(in: self.window)
        
        // 触摸开始 触摸中
        if long.state == .began {
            
            // 发送通知
            DZMReadView.PostNotification(userInfo: [DZMKey_ReadView_Ges_isOpen: NSNumber(value: true)])
            
            // 放大镜
            creatMagnifierView(windowPoint: windowPoint)
            
        }else if long.state == .changed {
            
            // 设置放大镜位置
            magnifierView?.targetPoint = windowPoint
            
        }else{ // 触摸结束
            
            // 获得选中区域
            selectRange = DZMReadAuxiliary.GetTouchLineRange(point: point, frameRef: frameRef)
            
            // 获得选中选中范围
            rects = DZMReadAuxiliary.GetRangeRects(range: selectRange!, frameRef: frameRef, content: content?.string)
            
            // 显示光标
            cursor(isShow: true)
            
            // 设置放大镜位置
            magnifierView?.targetPoint = windowPoint
            
            // 移除
            magnifierView?.remove({ [weak self] () in
                
                // 清空
                self?.magnifierView = nil
                
                // 显示菜单
                self?.menu(isShow: true)
            })
            
            // 重绘
            setNeedsDisplay()
            
            // 开启手势
            if !rects.isEmpty {
                
                // 手势状态
                longGes?.isEnabled = false
                tapGes?.isEnabled = true
                isOpenDrag = true
                
                // 发送通知
                DZMReadView.PostNotification(userInfo: [DZMKey_ReadView_Ges_isOpen: NSNumber(value: false)])
            }
        }
    }
    
    /// 单击事件
    @objc private func tapAction(tap:UITapGestureRecognizer) {
        
        // 重置页面数据
        reset()
    }
    
    /// 触摸开始
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        drag(touches: touches, status: .begin)
    }
    
    /// 触摸移动
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        drag(touches: touches, status: .changed)
    }
    
    /// 触摸结束
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        drag(touches: touches, status: .end)
    }
    
    /// 触摸取消
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        drag(touches: touches, status: .end)
    }
    
    /// 解析触摸事件
    private func drag(touches: Set<UITouch>, status: DZMPanStatus) {
        
        if isOpenDrag {
            
            let touch:UITouch? = ((touches as NSSet).anyObject() as? UITouch)
            
            let point = touch?.location(in: self)
            
            let windowPoint = touch?.location(in: self.window)
            
            drag(status: status, point: point!, windowPoint: windowPoint!)
        }
    }
    
    /// 拖拽事件解析
    func drag(status:DZMPanStatus, point:CGPoint, windowPoint:CGPoint) {
        
        // 触摸开始
        if status == .begin {
            
            // 隐藏菜单
            menu(isShow: false)
            
            if LCursorView.frame.insetBy(dx: DZMCursorOffset, dy: DZMCursorOffset).contains(point) { // 触摸到左边光标
                
                isLorR_Cursor = true
                
                isTouchCursor = true
                
            }else if RCursorView.frame.insetBy(dx: DZMCursorOffset, dy: DZMCursorOffset).contains(point) { // 触摸到右边光标
                
                isLorR_Cursor = false
                
                isTouchCursor = true
                
            }else{ // 没有触摸到光标
                
                isTouchCursor = false
            }
            
            // 触摸到了光标
            if isTouchCursor {
                
                // 放大镜
                creatMagnifierView(windowPoint: windowPoint)
            }
            
        }else if status == .changed { // 触摸中
            
            // 触摸到光标
            if isTouchCursor {
                
                // 设置放大镜位置
                magnifierView?.targetPoint = windowPoint
            }
            
            // 判断触摸
            if isTouchCursor && selectRange != nil {
                
                // 触摸到的位置
                let location = DZMReadAuxiliary.GetTouchLocation(point: point, frameRef: frameRef)
                
                // 无结果
                if location == -1 { return }
                
                // 刷新选中区域
                updateSelectRange(location: location)
                
                // 获得选中选中范围
                rects = DZMReadAuxiliary.GetRangeRects(range: selectRange!, frameRef: frameRef, content: content?.string)
                
                // 更新光标位置
                updateCursorFrame()
            }
            
        }else{ // 触摸结束
            
            // 触摸到光标
            if isTouchCursor {
                
                // 设置放大镜位置
                magnifierView?.targetPoint = windowPoint
                
                // 移除
                magnifierView?.remove({ [weak self] () in
                    
                    // 清空
                    self?.magnifierView = nil
                    
                    // 显示菜单
                    self?.menu(isShow: true)
                })
                
            }else{
                
                // 显示菜单
                menu(isShow: true)
            }
            
            // 结束触摸
            isTouchCursor = false
        }
        
        // 重绘
        setNeedsDisplay()
    }
    
    /// 创建放大镜
    private func creatMagnifierView(windowPoint: CGPoint) {
        
        if magnifierView == nil {
            
            magnifierView = DZMMagnifierView()
            magnifierView?.targetWindow = window
            magnifierView?.targetPoint = windowPoint
        }
    }
    
    /// 刷新选中区域
    private func updateSelectRange(location:Int) {
        
        // 左右 Location 位置
        let LLocation = selectRange!.location
        let RLocation = selectRange!.location + selectRange!.length
        
        // 判断触摸
        if isLorR_Cursor { // 左边
            
            if location < RLocation {
                
                if location > LLocation {
                    
                    selectRange!.length -= location - LLocation
                    
                    selectRange!.location = location
                    
                }else if location < LLocation {
                    
                    selectRange!.length += LLocation - location
                    
                    selectRange!.location = location
                }
                
            }else{
                
                isLorR_Cursor = false
                
                var length = location - RLocation
                
                let tempLength = (length == 0 ? 1 : 0)
                
                length = (length == 0 ? 1 : length)
                
                selectRange?.length = length
                
                selectRange?.location = RLocation - tempLength
                
                updateSelectRange(location: location)
            }
            
        }else{ // 右边
            
            if location > LLocation {
                
                if location > RLocation {
                    
                    selectRange!.length += location - RLocation
                    
                }else if location < RLocation {
                    
                    selectRange!.length -= RLocation - location
                }
                
            }else{
                
                isLorR_Cursor = true
                
                let tempLength = LLocation - location
               
                let length = (tempLength == 0 ? 1 : tempLength)
                
                selectRange?.length = length
                
                selectRange?.location = LLocation - tempLength
                
                updateSelectRange(location: location)
            }
        }
    }
    
    /// 隐藏或显示光标
    private func cursor(isShow:Bool) {

        if isShow {
            
            if !rects.isEmpty && LCursorView == nil {
                
                LCursorView = DZMCursorView()
                LCursorView.isTorB = true
                addSubview(LCursorView)
                
                RCursorView = DZMCursorView()
                RCursorView.isTorB = false
                addSubview(RCursorView)
                
                updateCursorFrame()
            }
            
        }else{
            
            if LCursorView != nil {
                
                LCursorView.removeFromSuperview()
                LCursorView = nil
                
                RCursorView.removeFromSuperview()
                RCursorView = nil
            }
        }
    }
    
    /// 更新光标位置
    private func updateCursorFrame() {
        
        if !rects.isEmpty && LCursorView != nil {
            
            let cursorViewW:CGFloat = 10
            let cursorViewSpaceW:CGFloat = cursorViewW / 4
            let cursorViewSpaceH:CGFloat = cursorViewW / 1.1
            let first = rects.first!
            let last = rects.last!
            
            LCursorView.frame = CGRect(x: first.minX - cursorViewW + cursorViewSpaceW, y: bounds.height - first.minY - first.height - cursorViewSpaceH, width: cursorViewW, height: first.height + cursorViewSpaceH)
            
            RCursorView.frame = CGRect(x: last.maxX - cursorViewSpaceW, y: bounds.height - last.minY - last.height, width: cursorViewW, height: last.height + cursorViewSpaceH)
        }
    }
    
    /// 重置页面数据
    private func reset() {
        
        // 发送通知
        DZMReadView.PostNotification(userInfo: [DZMKey_ReadView_Ges_isOpen: NSNumber(value: true)])
        
        // 手势状态
        tapGes?.isEnabled = false
        isOpenDrag = false
        longGes?.isEnabled = true
        
        // 移除菜单
        menu(isShow: false)
        
        // 清空选中
        selectRange = nil
        rects.removeAll()
        
        // 移除光标
        cursor(isShow: false)
        
        // (如果有放大镜)移除放大镜
        magnifierView?.remove({ [weak self] () in
            
            // 清空
            self?.magnifierView = nil
        })
        
        // 重绘
        setNeedsDisplay()
    }
    
    // MARK: 释放绘制相关
    
    /// 绘制
    override func draw(_ rect: CGRect) {
        
        if (frameRef == nil) {return}
        
        let ctx = UIGraphicsGetCurrentContext()
        
        ctx?.textMatrix = CGAffineTransform.identity
        
        ctx?.translateBy(x: 0, y: bounds.size.height)
        
        ctx?.scaleBy(x: 1.0, y: -1.0)
        
        if selectRange != nil && !rects.isEmpty {
            
            let path = CGMutablePath()
            
            DZMColor_253_85_103.withAlphaComponent(0.5).setFill()
            
            path.addRects(rects)
            
            ctx?.addPath(path)
            
            ctx?.fillPath()
        }
        
        CTFrameDraw(frameRef!, ctx!)
    }
    
    /// 释放
    deinit {
        
        tapGes?.removeTarget(self, action: #selector(tapAction(tap:)))
        tapGes = nil
        
        longGes?.removeTarget(self, action: #selector(longAction(long:)))
        longGes = nil
    }
    
    // MARK: 菜单相关
    
    /// 隐藏或显示菜单
    private func menu(isShow:Bool) {
        
        if isShow { // 显示
            
            if !rects.isEmpty {
                
                let rect = DZMReadAuxiliary.GetMenuRect(rects: rects, viewFrame: bounds)
                
                becomeFirstResponder()
                
                let menuController = UIMenuController.shared
                
                let copy = UIMenuItem(title: "复制", action: #selector(clickCopy))
                
                menuController.menuItems = [copy]
                
                menuController.setTargetRect(rect, in: self)
                
                menuController.setMenuVisible(true, animated: true)
            }
            
        }else{ // 隐藏
            
            UIMenuController.shared.setMenuVisible(false, animated: true)
        }
    }
    
    /// 允许菜单事件
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        
        if action == #selector(clickCopy) { return true }
        
        return false
    }
    
    /// 允许成为响应者
    override var canBecomeFirstResponder: Bool {
        
        get{ return true }
    }
    
    /// 复制事件
    @objc private func clickCopy() {
        
        if selectRange != nil {
            
            let selectRange = self.selectRange!
            
            let content = self.content
            
            DispatchQueue.global().async {
                
                UIPasteboard.general.string = content?.string.substring(selectRange)
            }
            
            // 重置页面数据
            reset()
        }
    }
    
    // MARK: 通知相关
    
    /// 注册通知
    class func RegisterNotification(observer:Any, selector:Selector) {
        
        NotificationCenter.default.addObserver(observer, selector: selector, name: NSNotification.Name(rawValue: DZMNotificationName_ReadView_Ges), object: nil)
    }
    
    /// 移除通知
    class func RemoveNotification(observer:Any) {
        
        NotificationCenter.default.removeObserver(observer, name: NSNotification.Name(rawValue: DZMNotificationName_ReadView_Ges), object: nil)
    }
    
    /// 发送通知
    class func PostNotification(userInfo:[AnyHashable : Any]?) {
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: DZMNotificationName_ReadView_Ges), object: nil, userInfo: userInfo)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}

