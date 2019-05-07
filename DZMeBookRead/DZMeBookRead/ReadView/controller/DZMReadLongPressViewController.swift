//
//  DZMReadLongPressViewController.swift
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/4/30.
//  Copyright © 2019年 DZM. All rights reserved.
//

import UIKit

class DZMReadLongPressViewController: DZMReadViewController {

    /// 阅读视图
    private var readView:DZMReadLongPressView!
    
    // 初始化阅读视图
    override func initReadView() {
        
        // 是否为书籍首页
        if recordModel.pageModel.isHomePage {
            
            super.initReadView()
            
        }else{
            
            // 阅读视图范围
            let rect = DZM_READ_VIEW_RECT!
            
            // 长按功能需要内容高度防止拖拽超出界限
            let pageModel = recordModel.pageModel!
            
            // 阅读视图
            readView = DZMReadLongPressView()
            readView.pageModel = pageModel
            view.addSubview(readView)
            readView.frame = CGRect(x: rect.minX, y: rect.minY, width: rect.width, height: pageModel.contentSize.height)
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
        
        // 是否为书籍首页
        if recordModel.pageModel.isHomePage { return }
        
        if readView?.isOpenDrag ?? false {
            
            let windowPoint = ((touches as NSSet).anyObject() as? UITouch)?.location(in: view)
      
            if windowPoint != nil {
                
                let point = view.convert(windowPoint!, to: readView)
        
                readView?.drag(status: status, point: point, windowPoint: windowPoint!)
            }
        }
    }
}
