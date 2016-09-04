//
//  UIImage+Extension.swift
//  HJProject
//
//  Created by 邓泽淼 on 16/8/2.
//  Copyright © 2016年 HanJue. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    
    // MARK: -- 绘制一张颜色图片
    
    class func imageWithColor(color:UIColor,size:CGSize) ->UIImage {
        
        let rect = CGRectMake(0, 0, size.width, size.height);
        
        UIGraphicsBeginImageContext(rect.size);
        
        let context = UIGraphicsGetCurrentContext();
        
        CGContextSetFillColorWithColor(context, color.CGColor);
        
        CGContextFillRect(context, rect);
        
        let image = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
        
        return image
    }
    
    // MARK: - 返回一张自由拉伸的图片
    
    class func resizedImageName(name:String) ->UIImage {
        
        return self.resizedImage(UIImage(named: name)!, left: 0.5, top: 0.5)
    }
    
    class func resizedImageName(name:String,left:CGFloat,top:CGFloat) ->UIImage {
        
        return self.resizedImage(UIImage(named: name)!, left: left, top: top)
    }
    
    class func resizedImage(image:UIImage) ->UIImage {
        
        return self.resizedImage(image, left: 0.5, top: 0.5)
    }
    
    class func resizedImage(image:UIImage,left:CGFloat,top:CGFloat) ->UIImage {
        
        return image.stretchableImageWithLeftCapWidth(Int(image.size.width * left), topCapHeight: Int(image.size.height * top))
    }
    
    // MARK: - 对图片尺寸进行压缩
    
    class func imageSizeCompress(image:UIImage,maxSize:CGSize) ->UIImage {
        
        let imageNewSize = UIImage.imageSize(image.size, maxSize: maxSize)
        
        return self.imageNew(image, newSize: imageNewSize)
    }
    
    // MARK: -  根据图片size  和  给予的最大范围size  进行等比例计算size
    
    class func imageSize(imageSize:CGSize,maxSize:CGSize) ->CGSize {
        
        var imageNewSize:CGSize = maxSize
        
        if imageSize.width < maxSize.width && imageSize.height < maxSize.height {
            
            return imageSize
            
        }else if imageSize.width > imageSize.height {
            
            let scale = maxSize.width / imageSize.width
            
            imageNewSize.width = maxSize.width
            
            imageNewSize.height = imageSize.height * scale
            
        }else{
            let scale = maxSize.height / imageSize.height
            
            imageNewSize.height = maxSize.height
            
            imageNewSize.width = imageSize.width * scale
        }
        
        return imageNewSize
    }
    
    // MARK: -- 重新绘制一张图片生成UIImage对象
    
    class func imageNew(image:UIImage,newSize:CGSize) ->UIImage {
        
        UIGraphicsBeginImageContext(newSize)
        
        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return newImage
    }
}