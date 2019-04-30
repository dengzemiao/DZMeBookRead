//
//  DZMMagnifierView.h
//  DZMeBookRead
//
//  Created by dengzemiao on 2019/4/30.
//  Copyright © 2019年 DZM. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface DZMMagnifierView : UIWindow

/// 目标视图Window (注意: 传视图的Window 例子: self.view.window)
@property (nonatomic, weak, nullable) UIView *targetWindow;

/// 目标视图展示位置 (放大镜需要展示的位置)
@property (nonatomic, assign) CGPoint targetPoint;

/// 放大镜位置偏移调整 (调整放大镜在原始位置上的偏移 默认: CGPointMake(0, -40))
@property (nonatomic, assign) CGPoint offsetPoint;

/// 放大比例 默认: DZM_MV_SCALE
@property (nonatomic, assign) CGFloat scale;

/// 弱引用接收对象 (内部已经强引用,如果外部也强引用需要自己释放)
+ (nonnull instancetype)magnifierView;

/// 移除 (移除对象 并释放内部强引用)
- (void)remove:(nullable void (^)(void))complete;

@end

NS_ASSUME_NONNULL_END
