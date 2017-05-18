//
//  DZMCoverController.m
//  DZMCoverDemo
//
//  Created by 邓泽淼 on 16/10/8.
//  Copyright © 2016年 DZM. All rights reserved.
//

// View宽
#define ViewWidth self.view.frame.size.width

// View高
#define ViewHeight self.view.frame.size.height

// 动画时间
#define AnimateDuration 0.20

#import "DZMCoverController.h"

@interface DZMCoverController ()<UIGestureRecognizerDelegate>

/**
 *  左拉右拉手势
 */
@property (nonatomic,strong) UIPanGestureRecognizer *pan;

/**
 *  点击手势
 */
@property (nonatomic,strong) UITapGestureRecognizer *tap;

/**
 *  手势触发点在左边 辨认方向 左边拿上一个控制器  右边拿下一个控制器
 */
@property (nonatomic,assign) BOOL isLeft;

/**
 *  判断执行pan手势
 */
@property (nonatomic,assign) BOOL isPan;

/**
 *  手势是否重新开始识别
 */
@property (nonatomic,assign) BOOL isPanBegin;

/**
 *  临时控制器 通过代理获取回来的控制器 还没有完全展示出来的控制器
 */
@property (nonatomic,strong,nullable) UIViewController *pendingController;

@end

@implementation DZMCoverController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 完成初始化
    [self didInit];
}

/**
 *  初始化
 */
- (void)didInit
{
    // 动画效果开启
    self.openAnimate = YES;
    
    // 设置背景颜色
    self.view.backgroundColor = [UIColor whiteColor];
    
    // 添加手势
    self.pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(touchPan:)];
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchTap:)];
    [self.view addGestureRecognizer:self.pan];
    [self.view addGestureRecognizer:self.tap];
    self.pan.delegate = self;
    self.tap.delegate = self;
    
    // 启用手势
    self.gestureRecognizerEnabled = YES;
    
    // 开启裁剪
    self.view.layer.masksToBounds = YES;
}

/**
 *  手势开关
 */
- (void)setGestureRecognizerEnabled:(BOOL)gestureRecognizerEnabled
{
    _gestureRecognizerEnabled = gestureRecognizerEnabled;
    
    self.pan.enabled = gestureRecognizerEnabled;
    
    self.tapGestureRecognizerEnabled = gestureRecognizerEnabled;
}

- (void)setTapGestureRecognizerEnabled:(BOOL)tapGestureRecognizerEnabled
{
    _tapGestureRecognizerEnabled = tapGestureRecognizerEnabled;
    
    self.tap.enabled = tapGestureRecognizerEnabled;
}


#pragma mark - 手势处理

- (void)touchPan:(UIPanGestureRecognizer *)pan
{
    // 用于辨别方向
    CGPoint tempPoint = [pan translationInView:self.view];
    
    // 用于计算位置
    CGPoint touchPoint = [pan locationInView:self.view];
    
    if (pan.state == UIGestureRecognizerStateBegan) { // 手势开始
        
        // 正在动画
        if (self.isAnimateChange) { return; }
        
        self.isAnimateChange = YES;
        
        self.isPanBegin = YES;
        
        self.isPan = YES;
        
    }else if (pan.state == UIGestureRecognizerStateChanged) { // 手势移动
        
        if (fabs(tempPoint.x) > 0.01) { // 滚动有值了
            
            // 获取将要显示的控制器
            if (self.isPanBegin) {
                
                self.isPanBegin = NO;
                
                // 获取将要显示的控制器
                self.pendingController = [self GetPanControllerWithTouchPoint:tempPoint];
                
                // 将要显示的控制器
                if ([self.delegate respondsToSelector:@selector(coverController:willTransitionToPendingController:)]) {
                    
                    [self.delegate coverController:self willTransitionToPendingController:self.pendingController];
                }
                
                // 添加
                [self addController:self.pendingController];
            }
            
            // 判断显示
            if (self.openAnimate && self.isPan) {
                
                if (self.pendingController) {
                    
                    if (self.isLeft) {
                        
                        self.pendingController.view.frame = CGRectMake(touchPoint.x - ViewWidth, 0, ViewWidth, ViewHeight);
                        
                    }else{
                        
                        self.currentController.view.frame = CGRectMake(tempPoint.x > 0 ? 0 : tempPoint.x, 0, ViewWidth, ViewHeight);
                    }
                }
            }
        }
        
    }else{ // 手势结束
        
        if (self.isPan) {
            
            // 结束Pan手势
            self.isPan = NO;
            
            if (self.openAnimate) { // 动画
          
                if (self.pendingController) {
                    
                    BOOL isSuccess = YES;
                    
                    if (self.isLeft) {
                        
                        if (self.pendingController.view.frame.origin.x <= -(ViewWidth - ViewWidth*0.18)) {
                            
                            isSuccess = NO;
                        }
                        
                    }else{
                        
                        if (self.currentController.view.frame.origin.x >= -1) {
                            
                            isSuccess = NO;
                        }
                    }
                    
                    // 手势结束
                    [self GestureSuccess:isSuccess animated:YES];
                    
                }else{
                    
                    self.isAnimateChange = NO;
                }
                
            }else{ // 无动画
                
                // 手势结束
                [self GestureSuccess:YES animated:self.openAnimate];
            }
        }
    }
}

- (void)touchTap:(UITapGestureRecognizer *)tap
{
    // 正在动画
    if (self.isAnimateChange) { return; }
    
    self.isAnimateChange = YES;
    
    CGPoint touchPoint = [tap locationInView:self.view];
    
    // 获取将要显示的控制器
    self.pendingController = [self GetTapControllerWithTouchPoint:touchPoint];
    
    // 将要显示的控制器
    if ([self.delegate respondsToSelector:@selector(coverController:willTransitionToPendingController:)]) {
        
        [self.delegate coverController:self willTransitionToPendingController:self.pendingController];
    }
    
    // 添加
    [self addController:self.pendingController];
    
    // 手势结束
    [self GestureSuccess:YES animated:self.openAnimate];
}

/**
 *  手势结束
 */
- (void)GestureSuccess:(BOOL)isSuccess animated:(BOOL)animated
{
    if (self.pendingController) {
        
        if (self.isLeft) { // 左边
            
            if (animated) {
                
                __weak DZMCoverController *weakSelf = self;
                
                [UIView animateWithDuration:AnimateDuration animations:^{
                    
                    if (isSuccess) {
                        
                        weakSelf.pendingController.view.frame = CGRectMake(0, 0, ViewWidth, ViewHeight);
                        
                    }else{
                        
                        weakSelf.pendingController.view.frame = CGRectMake(-ViewWidth, 0, ViewWidth, ViewHeight);
                    }
                    
                } completion:^(BOOL finished) {
                    
                    [weakSelf animateSuccess:isSuccess];
                }];
                
            }else{
                
                if (isSuccess) {
                    
                    self.pendingController.view.frame = CGRectMake(0, 0, ViewWidth, ViewHeight);
                    
                }else{
                    
                    self.pendingController.view.frame = CGRectMake(-ViewWidth, 0, ViewWidth, ViewHeight);
                }
                
                [self animateSuccess:isSuccess];
            }
            
        }else{ // 右边
            
            if (animated) {
                
                __weak DZMCoverController *weakSelf = self;
                
                [UIView animateWithDuration:AnimateDuration animations:^{
                    
                    if (isSuccess) {
                        
                        weakSelf.currentController.view.frame = CGRectMake(-ViewWidth, 0, ViewWidth, ViewHeight);
                        
                    }else{
                        
                        weakSelf.currentController.view.frame = CGRectMake(0, 0, ViewWidth, ViewHeight);
                    }
                    
                } completion:^(BOOL finished) {
                    
                    [weakSelf animateSuccess:isSuccess];
                }];
                
            }else{
                
                if (isSuccess) {
                    
                    self.currentController.view.frame = CGRectMake(-ViewWidth, 0, ViewWidth, ViewHeight);
                    
                }else{
                    
                    self.currentController.view.frame = CGRectMake(0, 0, ViewWidth, ViewHeight);
                }
                
                [self animateSuccess:isSuccess];
            }
        }
    }
}

/**
 *  动画结束
 */
- (void)animateSuccess:(BOOL)isSuccess
{
    if (isSuccess) {
        
        [self.currentController.view removeFromSuperview];
        
        [self.currentController removeFromParentViewController];
        
        _currentController = self.pendingController;
        
        self.pendingController = nil;
        
        self.isAnimateChange = NO;
        
    }else{
        
        [self.pendingController.view removeFromSuperview];
        
        [self.pendingController removeFromParentViewController];
        
        self.pendingController = nil;
        
        self.isAnimateChange = NO;
    }
    
    // 代理回调
    if ([self.delegate respondsToSelector:@selector(coverController:currentController:finish:)]) {
        
        [self.delegate coverController:self currentController:self.currentController finish:isSuccess];
    }
}

/**
 *  根据手势触发的位置获取控制器
 *
 *  @param touchPoint 手势触发位置
 *
 *  @return 需要显示的控制器
 */
- (UIViewController * _Nullable)GetTapControllerWithTouchPoint:(CGPoint)touchPoint
{
    UIViewController *vc = nil;
    
    if (touchPoint.x < ViewWidth / 3) { // 左边
        
        self.isLeft = YES;
        
        // 获取上一个显示控制器
        if ([self.delegate respondsToSelector:@selector(coverController:getAboveControllerWithCurrentController:)]) {
            
            vc = [self.delegate coverController:self getAboveControllerWithCurrentController:self.currentController];
        }
        
    }else if (touchPoint.x > (ViewWidth - ViewWidth / 3)){ // 右边
        
        self.isLeft = NO;
        
        // 获取下一个显示控制器
        if ([self.delegate respondsToSelector:@selector(coverController:getBelowControllerWithCurrentController:)]) {
            
            vc = [self.delegate coverController:self getBelowControllerWithCurrentController:self.currentController];
        }
    }
    
    if (!vc) {
        
        self.isAnimateChange = NO;
    }
    
    return vc;
}

/**
 *  根据手势触发的位置获取控制器
 *
 *  @param touchPoint 手势触发位置
 *
 *  @return 需要显示的控制器
 */
- (UIViewController * _Nullable)GetPanControllerWithTouchPoint:(CGPoint)touchPoint
{
    UIViewController *vc = nil;
   
    if (touchPoint.x > 0) { // 左边
        
        self.isLeft = YES;
        
        // 获取上一个显示控制器
        if ([self.delegate respondsToSelector:@selector(coverController:getAboveControllerWithCurrentController:)]) {
            
            vc = [self.delegate coverController:self getAboveControllerWithCurrentController:self.currentController];
        }
        
    }else{ // 右边
        
        self.isLeft = NO;
        
        // 获取下一个显示控制器
        if ([self.delegate respondsToSelector:@selector(coverController:getBelowControllerWithCurrentController:)]) {
            
            vc = [self.delegate coverController:self getBelowControllerWithCurrentController:self.currentController];
        }
        
    }
    
    if (!vc) {
        
        self.isAnimateChange = NO;
    }
    
    return vc;
}

#pragma mark - 设置显示控制器

/**
 *  手动设置显示控制器 无动画
 *
 *  @param controller 设置显示的控制器
 */
- (void)setController:(UIViewController * _Nullable)controller
{
    [self setController:controller animated:NO isAbove:YES];
}

/**
 *  手动设置显示控制器
 *
 *  @param controller 设置显示的控制器
 *  @param animated   是否需要动画
 *  @param isAbove    动画是否从上面显示 YES   从下面显示 NO
 */
- (void)setController:(UIViewController * _Nullable)controller animated:(BOOL)animated isAbove:(BOOL)isAbove
{
    if (controller) { // 有值
        
        if (animated && self.currentController) { // 需要动画 同时有根控制器了
            
            // 正在动画
            if (self.isAnimateChange) { return; }
            
            self.isAnimateChange = YES;
            
            self.isLeft = isAbove;
            
            // 记录
            self.pendingController = controller;
            
            // 添加
            [self addController:controller];
            
            // 手势结束
            [self GestureSuccess:YES animated:YES];
            
        }else{
            
            // 添加
            [self addController:controller];
            
            // 修改frame
            controller.view.frame = self.view.bounds;
            
            // 当前控制器有值 进行删除
            if (_currentController) {
                
                [_currentController.view removeFromSuperview];
                
                [_currentController removeFromParentViewController];
            }
            
            // 赋值记录
            _currentController = controller;
        }
    }
}

/**
 *  添加控制器
 *
 *  @param controller 控制器
 */
- (void)addController:(UIViewController * _Nullable)controller
{
    if (controller) {
        
        [self addChildViewController:controller];
        
        if (self.isLeft) { // 左边
            
            [self.view addSubview:controller.view];
            
            controller.view.frame = CGRectMake(-ViewWidth, 0, ViewWidth, ViewHeight);
            
        }else{ // 右边
            
            if (self.currentController) { // 有值
                
                [self.view insertSubview:controller.view belowSubview:self.currentController.view];
                
            }else{ // 没值
                
                [self.view addSubview:controller.view];
            }
            
            controller.view.frame = CGRectMake(0, 0, ViewWidth, ViewHeight);
        }
        
        // 添加阴影
        [self setShadowController:controller];
    }
}

/**
 *  给控制器添加阴影
 */
- (void)setShadowController:(UIViewController * _Nullable)controller
{
    if (controller) {
        
        controller.view.layer.shadowColor = [UIColor blackColor].CGColor; // 阴影颜色
        controller.view.layer.shadowOffset = CGSizeMake(0, 0); // 偏移距离
        controller.view.layer.shadowOpacity = 0.5; // 不透明度
        controller.view.layer.shadowRadius = 10.0; // 半径
    }
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UITapGestureRecognizer class]] && [gestureRecognizer isEqual:self.tap]) {
        
        CGFloat tempX = ViewWidth / 3;
        
        CGPoint touchPoint = [self.tap locationInView:self.view];
        
        if (touchPoint.x > tempX && touchPoint.x < (ViewWidth - tempX)) {
            
            return YES;
        }
    }
    
    return NO;
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void)dealloc {
    
    // 移除手势
    [self.view removeGestureRecognizer:self.pan];
    [self.view removeGestureRecognizer:self.tap];
    
    // 移除当前控制器
    if (self.currentController) {
        [self.currentController.view removeFromSuperview];
        [self.currentController removeFromParentViewController];
        _currentController = nil;
    }
    
    // 移除临时控制器
    if (self.pendingController) {
        [self.pendingController.view removeFromSuperview];
        [self.pendingController removeFromParentViewController];
        self.pendingController = nil;
    }
}

@end
