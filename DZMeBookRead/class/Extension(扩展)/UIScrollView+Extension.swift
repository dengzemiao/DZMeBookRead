//
//  UIScrollView+Extension.swift
//  HJProject
//
//  Created by 邓泽淼 on 16/8/5.
//  Copyright © 2016年 HanJue. All rights reserved.
//
private var IsHaveDataID = "isHaveDataID"
private var IsPreloadingID = "isPreloadingID"
private var IsReloadDataID = "isReloadDataID"
private var IsRefreshDataID = "isRefreshDataID"

import Foundation
import UIKit

extension UIScrollView {
    
    // MARK: -- 刷新判断相关
    
    /// 是否正在加载数据过程中
    var isRefreshData:Bool {
        
        get{
            let obj = objc_getAssociatedObject(self, &IsRefreshDataID) as? NSNumber
            return  obj == nil ? false : obj!.boolValue
        }
        
        set{
            objc_setAssociatedObject(self, &IsRefreshDataID,NSNumber(value: newValue as Bool), objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    
    // MARK: -- 动画相关
    
    /// 是否正在刷新过程中
    var isReloadData:Bool {
        
        get{
            let obj = objc_getAssociatedObject(self, &IsReloadDataID) as? NSNumber
            return  obj == nil ? false : obj!.boolValue
        }
        
        set{
            objc_setAssociatedObject(self, &IsReloadDataID,NSNumber(value: newValue as Bool), objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    
    // MARK: -- 预加载相关
    
    /// 是否该接口还有数据加载
    var isHaveData:Bool {
        
        get{
            let obj = objc_getAssociatedObject(self, &IsHaveDataID) as? NSNumber
            return  obj == nil ? false : obj!.boolValue
        }
        
        set{
            objc_setAssociatedObject(self, &IsHaveDataID,NSNumber(value: newValue as Bool), objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    /// 是否正在预加载过程中
    var isPreloading:Bool {
        
        get{
            let obj = objc_getAssociatedObject(self, &IsPreloadingID) as? NSNumber
            return  obj == nil ? false : obj!.boolValue
        }
        
        set{
            objc_setAssociatedObject(self, &IsPreloadingID,NSNumber(value: newValue as Bool), objc_AssociationPolicy.OBJC_ASSOCIATION_ASSIGN)
        }
    }
    
    /**
     检查当前的数据源数量是否==总数据数量了
     等于表示分页没有数据 不需要继续使用预加载请求 设置 isHaveData = false
     不等于表示分页有数据 可以继续使用预加载请求 设置 isHaveData = true
     
     - parameter totalCount:   总数据长度
     - parameter currentCount: 当前数据长度
     
     - returns: isHaveData
     */
    func preloadingCheckIsHaveData(_ totalCount:NSInteger,currentCount:NSInteger) ->Bool {
        
        isHaveData = (totalCount > currentCount)
        
        return isHaveData
    }
    
    /**
     在滚动中根据设置的Y值进行预加载
     
     - parameter y:      距离底部距离
     - parameter target: 事件对象
     - parameter action: 事件
     */
    func preloading(_ preloadingY:CGFloat,target:AnyObject,action:Selector) {
        
        if isHaveData && isPreloading { // 有数据允许预加载 同时不再预加载过程中
            
            // 内容没有超过屏幕高度
            if contentSize.height <= height {
                
                if contentOffset.y > preloadingY {
                    
                    isPreloading = true
                    
                    target.perform(action)
                }
                
            }else{
                
                // 内容超过控件高度
                if (contentOffset.y + height) > (contentSize.height - preloadingY) {
                    
                    isPreloading = true
                    
                    target.perform(action)
                }
            }
        }
    }
    
    // MARK: -- 滚动置顶
    
    /// 动画滚动到顶部
    func scrollTop() {
        
        scrollTop(true)
    }
    
    /// 滚动到顶部
    func scrollTop(_ animated:Bool) {
        
        setContentOffset(CGPoint(x: 0, y: 0), animated: animated)
    }
    
    // MARK: -- 显示动画
    
    /**
     滚动过程中开始显示cell 建议用于TableView CollectionView
     
     - parameter cell: cell
     */
    func scrollViewWillDisplayCell(_ cell:UIView) {
        
        if !isReloadData {
            cell.transform = cell.transform.scaledBy(x: 0.8, y: 0.9)
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationDuration(AnimateDuration)
            cell.transform = CGAffineTransform.identity
            UIView.commitAnimations()
        }
    }
}
