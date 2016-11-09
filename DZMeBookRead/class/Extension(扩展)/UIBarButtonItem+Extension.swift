//
//  UIBarButtonItem+Extension.swift
//  HJProject
//
//  Created by 邓泽淼 on 16/8/2.
//  Copyright © 2016年 HanJue. All rights reserved.
//

let ItemFont:UIFont = UIFont.fontOfSize(14)         // Item字体

import Foundation
import UIKit

extension UIBarButtonItem {
    
    // MARK: -- Item 文字
    
    /// Item 文字 左边
    class func itemTitleLeft(_ title:String,titleColor:UIColor,target:AnyObject?,action:Selector) ->UIBarButtonItem {
        
        return self.itemTitleLeft(title, titleColor: titleColor, titleEdgeInsets: UIEdgeInsetsMake(0, 0, 0, 0), target: target, action: action)
    }
    
    /// Item 文字 左边
    class func itemTitleLeft(_ title:String,titleColor:UIColor,titleEdgeInsets:UIEdgeInsets,target:AnyObject?,action:Selector) ->UIBarButtonItem {
        
        return self.item(title, titleColor: titleColor, contentHorizontalAlignment: UIControlContentHorizontalAlignment.left, titleEdgeInsets: titleEdgeInsets, target: target, action: action)
    }
    
    /// Item 文字 右边
    class func itemTitleRight(_ title:String,titleColor:UIColor,target:AnyObject?,action:Selector) ->UIBarButtonItem {
        
        return self.itemTitleRight(title, titleColor: titleColor, titleEdgeInsets: UIEdgeInsetsMake(0, 0, 0, 0), target: target, action: action)
    }
    
    /// Item 文字 右边
    class func itemTitleRight(_ title:String,titleColor:UIColor,titleEdgeInsets:UIEdgeInsets,target:AnyObject?,action:Selector) ->UIBarButtonItem {
        
        return self.item(title, titleColor: titleColor, contentHorizontalAlignment: UIControlContentHorizontalAlignment.right, titleEdgeInsets: titleEdgeInsets, target: target, action: action)
    }
    
    
    /**
     文字Item
     
     - parameter title:                      文字
     - parameter titleColor:                 文字颜色
     - parameter contentHorizontalAlignment: Label方位
     - parameter titleEdgeInsets:            Label偏移
     - parameter target:                     事件对象
     - parameter action:                     事件
     */
    class func item(_ title:String,titleColor:UIColor,contentHorizontalAlignment:UIControlContentHorizontalAlignment,titleEdgeInsets:UIEdgeInsets,target:AnyObject?,action:Selector) ->UIBarButtonItem {
        
        let itemButton = UIButton(type:UIButtonType.custom)
        itemButton.titleLabel!.font = ItemFont
        itemButton.setTitle(title, for: UIControlState())
        itemButton.setTitleColor(titleColor, for: UIControlState())
        itemButton.bounds = CGRect(x: 0, y: 0, width: 40, height: 40)
        itemButton.contentHorizontalAlignment = contentHorizontalAlignment
        itemButton.titleEdgeInsets = titleEdgeInsets
        itemButton.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        
        return UIBarButtonItem(customView: itemButton)
    }
    
    
    // MARK: -- Item Image
    
    /// ImageName Item
    class func itemImageName(_ imageName:String,target:AnyObject?,action:Selector) ->UIBarButtonItem {
        
        return self.itemImage(UIImage(named: imageName)!, target: target, action: action)
    }
    
    /// ImageName Item
    class func itemImageName(_ imageName:String,imageEdgeInsets:UIEdgeInsets,target:AnyObject?,action:Selector) ->UIBarButtonItem {
        
        return self.item(UIImage(named: imageName)!, imageEdgeInsets: imageEdgeInsets, target: target, action: action)
    }
    
    /// Image Item
    class func itemImage(_ image:UIImage,target:AnyObject?,action:Selector) ->UIBarButtonItem {
        
        return self.item(image, imageEdgeInsets: UIEdgeInsetsMake(0, 0, 0, 0), target: target, action: action)
    }
    
    /**
     图片Item
     
     - parameter image:  图片
     - parameter target: 事件对象
     - parameter imageEdgeInsets:            Image偏移
     - parameter action: 事件
     */
    class func item(_ image:UIImage,imageEdgeInsets:UIEdgeInsets,target:AnyObject?,action:Selector) ->UIBarButtonItem {
        
        let itemButton = UIButton(type:UIButtonType.custom)
        itemButton.setImage(image, for: UIControlState())
        itemButton.bounds = CGRect(x: 0, y: 0, width: image.size.width, height: image.size.height)
        itemButton.imageEdgeInsets = imageEdgeInsets
        itemButton.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        
        return UIBarButtonItem(customView: itemButton)
    }
    
    
    // MARK: -- 自定义 Item
    
    /// 自定义点击View
    class func itemControl(_ control:UIControl,target:AnyObject?,action:Selector) ->UIBarButtonItem {
        
        control.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        
        return UIBarButtonItem(customView: control)
    }
    
    class func itemButton(_ button:UIButton,target:AnyObject?,action:Selector) ->UIBarButtonItem {
        
        button.titleLabel?.font = ItemFont
        
        button.addTarget(target, action: action, for: UIControlEvents.touchUpInside)
        
        return UIBarButtonItem(customView: button)
    }
    
    
    // MARK: -- 返回按钮
    
    /// app 导航栏返回按钮 类型 1
    class func AppNavigationBarBackItemOne(_ imageEdgeInsets:UIEdgeInsets,target:AnyObject?,action:Selector) ->UIBarButtonItem {
        
        return self.itemImageName("Back_0", imageEdgeInsets: imageEdgeInsets, target: target, action: action)
    }
}
