//
//  DZMReadLongPressView.swift
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/4/30.
//  Copyright © 2019年 DZM. All rights reserved.
//


/// Pan手势状态
enum DZMPanGesStatus:NSInteger {
    // 开始手势
    case begin
    // 变换中
    case changed
    // 结束手势
    case end
}

/// 监控阅读长按视图通知
func DZM_READ_NOTIFICATION_MONITOR(target:Any, action:Selector) {
    
    NotificationCenter.default.addObserver(target, selector: action, name: NSNotification.Name(DZM_READ_NOTIFICATION_LONG_PRESS_VIEW), object: nil)
}

/// 发送阅读长按视图通知
func DZM_READ_NOTIFICATION_PUSH(userInfo:[AnyHashable : Any]?) {
    
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: DZM_READ_NOTIFICATION_LONG_PRESS_VIEW), object: nil, userInfo: userInfo)
}

/// 移除阅读长按视图通知
func DZM_READ_NOTIFICATION_REMOVE(target:Any) {
    
    NotificationCenter.default.removeObserver(target, name: NSNotification.Name(rawValue: DZM_READ_NOTIFICATION_LONG_PRESS_VIEW), object: nil)
}

/// 长按阅读视图通知 info 数据 key
let DZM_READ_KEY_LONG_PRESS_VIEW:String = "DZM_READ_KEY_LONG_PRESS_VIEW"

/// 长按阅读视图通知
let DZM_READ_NOTIFICATION_LONG_PRESS_VIEW:String = "DZM_READ_LONG_PRESS_VIEW_NOTIFICATION"

/// 光标拖拽触发范围
let DZM_READ_LONG_PRESS_CURSOR_VIEW_OFFSET:CGFloat = -DZM_SPACE_20

import UIKit

class DZMReadLongPressView: DZMReadView {
    
    /// 开启拖拽
    private(set) var isOpenDrag:Bool = false
    
    /// 选中区域
    private var selectRange:NSRange!
    
    /// 选中区域CGRect数组
    private var rects:[CGRect] = []
    
    /// 长按
    private var longGes:UILongPressGestureRecognizer?
    
    /// 单击
    private var tapGes:UITapGestureRecognizer?
    
    /// 左光标
    private var LCursorView:DZMReadLongPressCursorView!
    
    /// 右光标
    private var RCursorView:DZMReadLongPressCursorView!
    
    /// 触摸的光标是左还是右
    private var isCursorLorR:Bool = true
    
    /// 是否触摸到左右光标
    private var isTouchCursor:Bool = false
    
    /// 动画时间
    private var duration:TimeInterval = DZM_READ_AD_TIME
    
    /// 放大镜
    private var magnifierView:DZMMagnifierView?
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        
        longGes = UILongPressGestureRecognizer(target: self, action: #selector(longAction(long:)))
        addGestureRecognizer(longGes!)
        
        tapGes = UITapGestureRecognizer(target: self, action: #selector(tapAction(tap:)))
        tapGes!.isEnabled = false
        addGestureRecognizer(tapGes!)
    }
    
    /// 创建放大镜
    private func creatMagnifierView(windowPoint: CGPoint) {
        
        if magnifierView == nil {
            
            magnifierView = DZMMagnifierView()
            magnifierView?.targetWindow = window
            magnifierView?.targetPoint = windowPoint
        }
    }
    
    // MARK: 手势事件
    
    /// 单击事件
    @objc private func tapAction(tap:UITapGestureRecognizer) {
        
        // 重置页面数据
        reset()
    }
    
    /// 长按事件
    @objc private func longAction(long:UILongPressGestureRecognizer) {
        
        // 触摸位置
        let point = long.location(in: self)

        // 触摸位置
        let windowPoint = long.location(in: window)

        // 触摸开始 触摸中
        if long.state == .began {

            // 发送通知
            DZM_READ_NOTIFICATION_PUSH(userInfo: [DZM_READ_KEY_LONG_PRESS_VIEW : NSNumber(value: true)])

            // 放大镜
            creatMagnifierView(windowPoint: windowPoint)

        }else if long.state == .changed {

            // 设置放大镜位置
            magnifierView?.targetPoint = windowPoint

        }else{ // 触摸结束

            // 获得选中区域
            selectRange = DZMCoreText.GetTouchLineRange(point: point, frameRef: frameRef)

            // 获得选中选中范围
            rects = DZMCoreText.GetRangeRects(range: selectRange!, frameRef: frameRef, content: pageModel.content?.string)

            // 显示光标
            cursor(isShow: true)

            // 设置放大镜位置
            magnifierView?.targetPoint = windowPoint

            // 移除
            magnifierView?.remove({ [weak self] () in

                // 清空
                self?.magnifierView = nil

                // 显示菜单
                self?.showMenu(isShow: true)
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
                DZM_READ_NOTIFICATION_PUSH(userInfo: [DZM_READ_KEY_LONG_PRESS_VIEW : NSNumber(value: false)])
            }
        }
    }
    
    // MARK: 页面触摸拖拽处理
    
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
    private func drag(touches: Set<UITouch>, status: DZMPanGesStatus) {
        
        if isOpenDrag {
            
            let touch:UITouch? = ((touches as NSSet).anyObject() as? UITouch)
            
            let point = touch?.location(in: self)
            
            let windowPoint = touch?.location(in: self.window)
            
            drag(status: status, point: point!, windowPoint: windowPoint!)
        }
    }
    
    /// 拖拽事件解析
    func drag(status:DZMPanGesStatus, point:CGPoint, windowPoint:CGPoint) {
   
        // 检查是否超出范围
        let point = CGPoint(x: min(max(point.x, 0), pageModel.contentSize.width), y: min(max(point.y, 0), pageModel.contentSize.height))

        // 触摸开始
        if status == .begin {
           
            // 隐藏菜单
            showMenu(isShow: false)
            
            if LCursorView.frame.insetBy(dx: DZM_READ_LONG_PRESS_CURSOR_VIEW_OFFSET, dy: DZM_READ_LONG_PRESS_CURSOR_VIEW_OFFSET).contains(point) { // 触摸到左边光标
                
                isCursorLorR = true
                
                isTouchCursor = true
                
            }else if RCursorView.frame.insetBy(dx: DZM_READ_LONG_PRESS_CURSOR_VIEW_OFFSET, dy: DZM_READ_LONG_PRESS_CURSOR_VIEW_OFFSET).contains(point) { // 触摸到右边光标
                
                isCursorLorR = false
                
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
                let location = DZMCoreText.GetTouchLocation(point: point, frameRef: frameRef)
                
                // 无结果
                if location == -1 { return }
             
                // 刷新选中区域
                updateSelectRange(location: location)
                
                // 获得选中选中范围
                rects = DZMCoreText.GetRangeRects(range: selectRange, frameRef: frameRef, content: pageModel.content?.string)
                
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
                    self?.showMenu(isShow: true)
                })
                
            }else{
                
                // 显示菜单
                showMenu(isShow: true)
            }
            
            // 结束触摸
            isTouchCursor = false
        }
        
        // 重绘
        setNeedsDisplay()
    }
    
    /// 刷新选中区域
    private func updateSelectRange(location:Int) {
        
        // 左右 Location 位置
        let LLocation = selectRange!.location
        let RLocation = selectRange!.location + selectRange!.length
        
        // 判断触摸
        if isCursorLorR { // 左边
            
            if location < RLocation {
                
                if location > LLocation {
                    
                    selectRange!.length -= location - LLocation
                    
                    selectRange!.location = location
                    
                }else if location < LLocation {
                    
                    selectRange!.length += LLocation - location
                    
                    selectRange!.location = location
                }
                
            }else{
                
                isCursorLorR = false
                
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
                
                isCursorLorR = true
                
                let tempLength = LLocation - location
                
                let length = (tempLength == 0 ? 1 : tempLength)
                
                selectRange?.length = length
                
                selectRange?.location = LLocation - tempLength
                
                updateSelectRange(location: location)
            }
        }
    }
    
    // MARK: 光标处理
    
    /// 隐藏或显示光标
    private func cursor(isShow:Bool) {
        
        if isShow {
            
            if !rects.isEmpty && LCursorView == nil {
                
                LCursorView = DZMReadLongPressCursorView()
                LCursorView.isTorB = true
                addSubview(LCursorView)
                
                RCursorView = DZMReadLongPressCursorView()
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
    
    // MARK: 重置页面
    
    /// 重置页面数据
    private func reset() {
        
        // 发送通知
        DZM_READ_NOTIFICATION_PUSH(userInfo: [DZM_READ_KEY_LONG_PRESS_VIEW : NSNumber(value: true)])
        
        // 手势状态
        tapGes?.isEnabled = false
        isOpenDrag = false
        longGes?.isEnabled = true
        
        // 移除菜单
        showMenu(isShow: false)
        
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
    
    // MARK: 菜单相关
    
    /// 隐藏或显示菜单
    private func showMenu(isShow:Bool) {
        
        if isShow { // 显示
            
            if !rects.isEmpty {
            
                let rect = DZMCoreText.GetMenuRect(rects: rects, viewFrame: bounds)
                
                becomeFirstResponder()
                
                let menuController = UIMenuController.shared
                
                let copy = UIMenuItem(title: "复制", action: #selector(clickCopy))
                
                menuController.menuItems = [copy]
                
                menuController.setTargetRect(rect, in: self)
                
                DelayHandle {
                    
                    menuController.setMenuVisible(true, animated: true)
                }
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
        
        return true
    }
    
    /// 复制事件
    @objc private func clickCopy() {
        
        if selectRange != nil {
            
            let temSelectRange = selectRange!
            
            let tempContent = pageModel.content
            
            DispatchQueue.global().async {
                
                UIPasteboard.general.string = tempContent?.string.substring(temSelectRange)
            }
            
            // 重置页面数据
            reset()
        }
    }
    
    // MARK: 绘制
    
    /// 绘制
    override func draw(_ rect: CGRect) {
        
        if (frameRef == nil) {return}
        
        let ctx = UIGraphicsGetCurrentContext()
        
        ctx?.textMatrix = CGAffineTransform.identity
        
        ctx?.translateBy(x: 0, y: bounds.size.height)
        
        ctx?.scaleBy(x: 1.0, y: -1.0)
        
        if selectRange != nil && !rects.isEmpty {
            
            let path = CGMutablePath()
            
            DZM_READ_COLOR_MAIN.withAlphaComponent(0.5).setFill()
            
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
    
    required init?(coder aDecoder: NSCoder) {
        
        fatalError("init(coder:) has not been implemented")
    }
}
