//
//  UITableView+Extension.swift
//  DZMeBookRead
//
//  Created by 邓泽淼 on 2017/5/17.
//  Copyright © 2017年 DZM. All rights reserved.
//

import UIKit

extension UITableView {

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
}
