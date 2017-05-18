//
//  UIView+YGPulseView.m
//  YGPulseView
//
//  Created by YGeorge on 22/11/2016.
//  Copyright (c) 2016 YGeorge. All rights reserved.
//

#import "UIView+YGPulseView.h"

NSString *const YGPulseKey = @"YGPulseKey";
NSString *const YGRadarKey = @"YGRadarKey";
NSString *const YGLayerName = @"YGLayerName";

@implementation UIView (YGPulseView)

- (void)startPulseWithColor:(UIColor *)color {
    [self startPulseWithColor:color scaleFrom:1.1f to:1.3f frequency:1.0f opacity:0.5f animation:YGPulseViewAnimationTypeRegularPulsing];
}

- (void)startPulseWithColor:(UIColor *)color animation:(YGPulseViewAnimationType)animationType {
    CGFloat frequency = animationType == YGPulseViewAnimationTypeRadarPulsing ? 1.5f : 1.0f;
    CGFloat startScale = animationType == YGPulseViewAnimationTypeRadarPulsing ? 1.0f : 1.2f;
    [self startPulseWithColor:color scaleFrom:startScale to:1.4f frequency:frequency opacity:0.7f animation:animationType];
}

- (void)startPulseWithColor:(UIColor *)color scaleFrom:(CGFloat)initialScale to:(CGFloat)finishScale frequency:(CGFloat)frequency opacity:(CGFloat)opacity animation:(YGPulseViewAnimationType)animationType {
    
    // 停止一遍
    [self stopPulse];
    
    // 进行动画
    CALayer *externalBorder = [CALayer layer];
    externalBorder.frame = self.frame;
    externalBorder.cornerRadius = self.layer.cornerRadius;
    externalBorder.backgroundColor = color.CGColor;
    externalBorder.opacity = opacity;
    externalBorder.name = YGLayerName;
    self.layer.masksToBounds = NO;
    [self.layer.superlayer insertSublayer:externalBorder below:self.layer];

    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    scaleAnimation.fromValue = @(initialScale);
    scaleAnimation.toValue = @(finishScale);
    scaleAnimation.duration = frequency;
    scaleAnimation.autoreverses = animationType == YGPulseViewAnimationTypeRegularPulsing;
    scaleAnimation.repeatCount = INT32_MAX;
    [externalBorder addAnimation:scaleAnimation forKey:YGPulseKey];

    if (animationType == YGPulseViewAnimationTypeRadarPulsing) {
        CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.fromValue = @(opacity);
        opacityAnimation.toValue = @(0.0);
        opacityAnimation.duration = frequency;
        opacityAnimation.autoreverses = NO;
        opacityAnimation.repeatCount = INT32_MAX;
        [externalBorder addAnimation:opacityAnimation forKey:YGRadarKey];
    }
}

- (void)stopPulse {
    [self.layer removeAnimationForKey:YGPulseKey];
    [self.layer removeAnimationForKey:YGRadarKey];
    CALayer *externalBorderLayer = [self externalBorderLayer];
    if (externalBorderLayer) {
        [externalBorderLayer removeFromSuperlayer];
    }
}

- (CALayer *)externalBorderLayer {
    for (CALayer *layer in self.layer.superlayer.sublayers) {
        if ([layer.name isEqualToString:YGLayerName]) {
            return layer;
        }
    }
    return nil;
}

@end
