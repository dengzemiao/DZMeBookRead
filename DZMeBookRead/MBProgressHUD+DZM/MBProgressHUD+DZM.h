//
//  MBProgressHUD+DZM.h
//  MBProgressHUD+DZM
//
//  Created by 邓泽淼 on 2018/5/2.
//  Copyright © 2018年 邓泽淼. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (DZM)

#pragma MARK Success

/// Success
+ (nonnull MBProgressHUD *)showSuccess;

/// Success - 可附带:文字
+ (nonnull MBProgressHUD *)showSuccess:(NSString * _Nullable)message;

/// Success - 可附带:文字
+ (nullable MBProgressHUD *)showSuccess:(NSString * _Nullable)message toView:(UIView * _Nullable)view;

#pragma MARK Error

/// Error
+ (nonnull MBProgressHUD *)showError;

/// Error - 可附带:文字
+ (nonnull MBProgressHUD *)showError:(NSString * _Nullable)message;

/// Error - 可附带:文字
+ (nullable MBProgressHUD *)showError:(NSString * _Nullable)message toView:(UIView * _Nullable)view;

#pragma MARK Message

/// Message - 可附带:文字
+ (nonnull MBProgressHUD *)showMessage:(NSString * _Nullable)message;

/// Message - 可附带:文字
+ (nullable MBProgressHUD *)showMessage:(NSString * _Nullable)message toView:(UIView * _Nullable)view;

/// Message - 可附带:文字+偏移调整
+ (nullable MBProgressHUD *)showMessage:(NSString * _Nullable)message offset:(CGPoint)offset toView:(UIView * _Nullable)view;

#pragma MARK Loading

/// Loading (MBProgressHUDModeIndeterminate)
+ (nonnull MBProgressHUD *)showLoading;

/// Loading (MBProgressHUDModeIndeterminate)
+ (nullable MBProgressHUD *)showLoading:(UIView * _Nullable)view;

/// Loading (MBProgressHUDModeIndeterminate) - 可附带:文字
+ (nullable MBProgressHUD *)showLoading:(NSString * _Nullable)message toView:(UIView * _Nullable)view;

#pragma MARK Hide

/// Hide
+ (void)hide;

/// Hide
+ (void)hide:(UIView * _Nullable)view;

#pragma MARK 公用HUD对象

/// HUD
+ (nullable MBProgressHUD *)HUD:(UIView * _Nullable)view;

/// HUD - 可附带:自定义View
+ (nullable MBProgressHUD *)HUD:(UIView * _Nullable)view customView:(UIView * _Nullable)customView;

/// HUD (自动隐藏) - 可附带:文字+图片
+ (nullable MBProgressHUD *)HUD:(UIView * _Nullable)view text:(NSString * _Nullable)text icon:(NSString * _Nullable)icon;

#pragma MARK CustomView

/// CustomView - ImageView
+ (nonnull UIImageView *)Custom_ImageView:(NSString *)icon;

/// CustomView - Right
+ (nonnull UIView *)Custom_Right;

/// CustomView - Error
+ (nonnull UIView *)Custom_Error;

@end
