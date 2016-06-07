//
//  UINavigationBar+Background.m
//  滚动隐藏&显示NavigationBar
//
//  Created by xiangxx on 16/5/11.
//  Copyright © 2016年 xiangxx. All rights reserved.
//

#import "UINavigationBar+Background.h"
#import <objc/runtime.h>

@implementation UINavigationBar (Background)

static char overlayKey;

- (UIView *)overlay{
    return objc_getAssociatedObject(self, &overlayKey);
}

- (void)setOverlay:(UIView *)overlay{
    
    objc_setAssociatedObject(self, &overlayKey,overlay,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)cnSetBackgroundColor:(UIColor *)backgroundColor{
    if (!self.overlay) {
        [self setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
        self.overlay = [[UIView alloc] initWithFrame:CGRectMake(0, -20, [UIScreen mainScreen].bounds.size.width, CGRectGetHeight(self.bounds)+20)];
        self.overlay.userInteractionEnabled = NO;
        self.overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [self insertSubview:self.overlay atIndex:0];
    }
    self.overlay.backgroundColor = backgroundColor;
}

/**
 *  释放
 */
- (void)cnReset{
    [self setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    [self.overlay removeFromSuperview];
     self.overlay = nil;
}

@end
