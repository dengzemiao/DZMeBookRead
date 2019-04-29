//
//  MBProgressHUD+DZM.m
//  MBProgressHUD+DZM
//
//  Created by 邓泽淼 on 2018/5/2.
//  Copyright © 2018年 邓泽淼. All rights reserved.
//

/// 图片地址
#define HUD_ICON_PATH(icon) [NSString stringWithFormat:@"MBProgressHUD.bundle/%@",icon]

/// 隐藏延迟
#define HUD_HIDE_AFTERDELAY 2.0

/// 默认现实目标视图
#define HUD_TO_VIEW [UIApplication sharedApplication].keyWindow

#import "MBProgressHUD+DZM.h"

@implementation MBProgressHUD (DZM)

#pragma MARK 公用HUD对象

/// HUD
+ (nullable MBProgressHUD *)HUD:(UIView * _Nullable)view {
    
    if (view == nil) { return nil; }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    
    hud.bezelView.style = MBProgressHUDBackgroundStyleSolidColor;
    
    hud.contentColor = [UIColor whiteColor];
    
    hud.bezelView.color = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    return hud;
}

/// HUD - 可附带:自定义View
+ (nullable MBProgressHUD *)HUD:(UIView * _Nullable)view customView:(UIView * _Nullable)customView {
    
    if (view == nil) { return nil; }
    
    MBProgressHUD *hud = [MBProgressHUD HUD:view];
    
    hud.mode = MBProgressHUDModeCustomView;
    
    hud.customView = customView;
    
    return hud;
}

/// HUD (自动隐藏) - 可附带:文字+图片
+ (nullable MBProgressHUD *)HUD:(UIView * _Nullable)view text:(NSString * _Nullable)text icon:(NSString * _Nullable)icon {
    
    if (view == nil) { return nil; }
    
    MBProgressHUD *hud = [MBProgressHUD HUD:view customView:[MBProgressHUD Custom_ImageView:icon]];
    
    hud.label.text = text;
    
    [hud hideAnimated:YES afterDelay:HUD_HIDE_AFTERDELAY];
    
    return hud;
}

#pragma MARK CustomView

/// CustomView - ImageView
+ (nonnull UIImageView *)Custom_ImageView:(NSString *)icon {
    
    UIImage *image = [[UIImage imageNamed:icon] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    
    return imageView;
}

/// CustomView - Right
+ (nonnull UIView *)Custom_Right {
    
    return [MBProgressHUD Custom_ImageView:HUD_ICON_PATH(@"right")];
}

/// CustomView - Error
+ (nonnull UIView *)Custom_Error {
    
    return [MBProgressHUD Custom_ImageView:HUD_ICON_PATH(@"error")];
}

#pragma MARK Success

/// Success
+ (nonnull MBProgressHUD *)showSuccess {
    
    return [MBProgressHUD showSuccess:nil];
}

/// Success
+ (nonnull MBProgressHUD *)showSuccess:(NSString * _Nullable )message {
    
    return [MBProgressHUD showSuccess:message toView:HUD_TO_VIEW];
}

/// Success - 可附带:文字
+ (nullable MBProgressHUD *)showSuccess:(NSString * _Nullable)message toView:(UIView * _Nullable)view {
    
    MBProgressHUD *hud = [MBProgressHUD HUD:view text:message icon:HUD_ICON_PATH(@"right")];
    
    hud.userInteractionEnabled = NO;
    
    return hud;
}

#pragma MARK Error

/// Error
+ (nonnull MBProgressHUD *)showError {
    
    return [MBProgressHUD showError:nil];
}

/// Error
+ (nonnull MBProgressHUD *)showError:(NSString * _Nullable)message {
    
    return [MBProgressHUD showError:message toView:HUD_TO_VIEW];
}

/// Error - 可附带:文字
+ (nullable MBProgressHUD *)showError:(NSString * _Nullable)message toView:(UIView * _Nullable)view {
    
    MBProgressHUD *hud = [MBProgressHUD HUD:view text:message icon:HUD_ICON_PATH(@"error")];
    
    hud.userInteractionEnabled = NO;
    
    return hud;
}

#pragma MARK Message

/// Message - 可附带:文字
+ (nonnull MBProgressHUD *)showMessage:(NSString * _Nullable)message {
    
    return [MBProgressHUD showMessage:message toView:HUD_TO_VIEW];
}

/// Message - 可附带:文字
+ (nullable MBProgressHUD *)showMessage:(NSString * _Nullable)message toView:(UIView * _Nullable)view {
    
    return [MBProgressHUD showMessage:message offset:CGPointZero toView:view];
}

/// Message - 可附带:文字+偏移调整
+ (nullable MBProgressHUD *)showMessage:(NSString * _Nullable)message offset:(CGPoint)offset toView:(UIView * _Nullable)view {
    
    if (view == nil) { return nil; }
    
    MBProgressHUD *hud = [MBProgressHUD HUD:view];
    
    hud.mode = MBProgressHUDModeText;
    
    hud.label.text = message;
    
    hud.offset = offset; // 例子: CGPointMake(0.f, MBProgressMaxOffset)
    
    hud.userInteractionEnabled = NO;
    
    [hud hideAnimated:YES afterDelay:HUD_HIDE_AFTERDELAY];
    
    return hud;
}

#pragma MARK Loading

/// Loading (MBProgressHUDModeIndeterminate)
+ (nonnull MBProgressHUD *)showLoading {
    
    return [MBProgressHUD showLoading:HUD_TO_VIEW];
}

/// Loading (MBProgressHUDModeIndeterminate)
+ (nullable MBProgressHUD *)showLoading:(UIView * _Nullable)view {
    
    return [MBProgressHUD showLoading:nil toView:view];
}

/// Loading (MBProgressHUDModeIndeterminate) - 可附带:文字
+ (nullable MBProgressHUD *)showLoading:(NSString * _Nullable)message toView:(UIView * _Nullable)view {
    
    if (view == nil) { return nil; }
    
    MBProgressHUD *tempHUD = [MBProgressHUD HUD:view];;
    
    tempHUD.label.text = message;
    
    return tempHUD;
}

#pragma MARK Hide

/// Hide
+ (void)hide {
    
    [MBProgressHUD hide:HUD_TO_VIEW];
}

/// Hide
+ (void)hide:(UIView * _Nullable)view {
    
    if (view == nil) { return ; }
    
    [MBProgressHUD hideHUDForView:view animated:YES];
}

@end
