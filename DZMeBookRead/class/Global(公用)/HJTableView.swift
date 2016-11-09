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
        self.init(frame:CGRect.zero)
    }
    
    convenience init(frame: CGRect) {
        self.init(frame: frame, style: .plain)
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
        
        DispatchQueue.main.async { [weak self] ()->() in
            
            self?.isReloadData = false;
        }
    }
    
    
    
    // MARK: -- 获取当前显示的最大最小的IndexPath
    
    /**
     获取当前显示最小的IndexPath
     
     - returns: 最小的indexPath
     */
    func minVisibleIndexPath() ->IndexPath? {
        
        if indexPathsForVisibleRows != nil && !indexPathsForVisibleRows!.isEmpty {
            
            var minIndexPath:IndexPath! = indexPathsForVisibleRows!.first
            
            for indexPath in indexPathsForVisibleRows! {
                
                let reuslt = minIndexPath.compare(indexPath) // 比较
                
                if reuslt == ComparisonResult.orderedSame { // 相等
                    
                }else if reuslt == ComparisonResult.orderedDescending { // 左边的操作对象大于右边的对象
                    
                    minIndexPath = indexPath
                    
                }else if reuslt == ComparisonResult.orderedAscending { // 左边的操作对象小于右边的对象
                    
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
    func maxVisibleIndexPath() ->IndexPath? {
        
        if indexPathsForVisibleRows != nil && !indexPathsForVisibleRows!.isEmpty {
            
            var maxIndexPath:IndexPath! = indexPathsForVisibleRows!.first
            
            for indexPath in indexPathsForVisibleRows! {
                
                let reuslt = maxIndexPath.compare(indexPath) // 比较
                
                if reuslt == ComparisonResult.orderedSame { // 相等
                    
                }else if reuslt == ComparisonResult.orderedDescending { // 左边的操作对象大于右边的对象
                    
                }else if reuslt == ComparisonResult.orderedAscending { // 左边的操作对象小于右边的对象
                    
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
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        
        if openIntercept && gestureRecognizer.state != .possible {
            
            return true
        }
        
        return false
    }
    
    // MARK: -- 响应者拦截
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if openTouch {
            
            next?.touchesBegan(touches, with: event)
            
        }else{
            
            super.touchesBegan(touches, with: event)
        }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if openTouch {
            
            next?.touchesMoved(touches, with: event)
            
        }else{
            
            super.touchesMoved(touches, with: event)
        }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if openTouch {
            
            next?.touchesEnded(touches, with: event)
            
        }else{
            
            super.touchesEnded(touches, with: event)
        }
        
    }
}
