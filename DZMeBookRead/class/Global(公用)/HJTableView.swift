//
//  HJTableView.swift
//  HJProject
//
//  Created by 邓泽淼 on 16/8/5.
//  Copyright © 2016年 HanJue. All rights reserved.
//

import UIKit

class HJTableView: UITableView {
    
    convenience init() {
        self.init(frame:CGRectZero)
    }
    
    convenience init(frame: CGRect) {
        self.init(frame: frame, style: .Plain)
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        
        // 初始化预加载是有数据的
        isHaveData = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func reloadData() {
        
        isReloadData = true
        
        super.reloadData()
        
        dispatch_async(dispatch_get_main_queue()) { [weak self] ()->() in
            
            self?.isReloadData = false;
        }
    }
    
    
    
    // MARK: -- 获取当前显示的最大最小的IndexPath
    
    /**
     获取当前显示最小的IndexPath
     
     - returns: 最小的indexPath
     */
    func minVisibleIndexPath() ->NSIndexPath? {
        
        if indexPathsForVisibleRows != nil && !indexPathsForVisibleRows!.isEmpty {
            
            var minIndexPath:NSIndexPath! = indexPathsForVisibleRows!.first
            
            for indexPath in indexPathsForVisibleRows! {
                
                let reuslt = minIndexPath.compare(indexPath) // 比较
                
                if reuslt == NSComparisonResult.OrderedSame { // 相等
                    
                }else if reuslt == NSComparisonResult.OrderedDescending { // 左边的操作对象大于右边的对象
                    
                    minIndexPath = indexPath
                    
                }else if reuslt == NSComparisonResult.OrderedAscending { // 左边的操作对象小于右边的对象
                    
                }else{}
            }
            
            return minIndexPath
        }
        
        return nil
    }
    
    /**
     获取当前显示最大的IndexPath
     
     - returns: 最大的indexPath
     */
    func maxVisibleIndexPath() ->NSIndexPath? {
        
        if indexPathsForVisibleRows != nil && !indexPathsForVisibleRows!.isEmpty {
            
            var maxIndexPath:NSIndexPath! = indexPathsForVisibleRows!.first
            
            for indexPath in indexPathsForVisibleRows! {
                
                let reuslt = maxIndexPath.compare(indexPath) // 比较
                
                if reuslt == NSComparisonResult.OrderedSame { // 相等
                    
                }else if reuslt == NSComparisonResult.OrderedDescending { // 左边的操作对象大于右边的对象
                    
                }else if reuslt == NSComparisonResult.OrderedAscending { // 左边的操作对象小于右边的对象
                    
                    maxIndexPath = indexPath
                    
                }else{}
            }
            
            return maxIndexPath
        }
        
        return nil
    }
    
    
    
    // MARK: -- 手势处理 可选项 一般不需要使用
    
    /// 是否开启不拦截当前父视图的touch事件  default: false
    var openTouch:Bool = false
    
    /// 当多个滚动控件控件一起使用的时候 开始手势拦截 开启之后当前滚动控件上的子控件手势 父滚动也会触发使用
    var openIntercept:Bool = false
    
    
    
    // MARK: -- 拦截手势
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if openIntercept && gestureRecognizer.state != .Possible {
            
            return true
        }
        
        return false
    }
    
    // MARK: -- 响应者拦截
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if openTouch {
            
            nextResponder()?.touchesBegan(touches, withEvent: event)
            
        }else{
            
            super.touchesBegan(touches, withEvent: event)
        }
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if openTouch {
            
            nextResponder()?.touchesMoved(touches, withEvent: event)
            
        }else{
            
            super.touchesMoved(touches, withEvent: event)
        }
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
        if openTouch {
            
            nextResponder()?.touchesEnded(touches, withEvent: event)
            
        }else{
            
            super.touchesEnded(touches, withEvent: event)
        }
        
    }
}
