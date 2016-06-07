# XXNavigationBarColor
XXNavigationBarColor 针对NavigationBar进行分类扩展实现滚动渐变效果。

//1、 去掉navigationbar 上的背景图片
  [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
//1.1、 去掉navigationbar 上图片下面的线
  self.navigationController.navigationBar.shadowImage = [UIImage new];

/**
     *  处理Navigationbar 背景图片渐变效果
     */
    UIColor *color = [UIColor colorWithRed:0.5 green:0.5 blue:1 alpha:1];
    CGFloat offsetY = scrollView.contentOffset.y + headerImageHeight;
    // Y轴大于0 设置navigationbar的透明度
    if (offsetY >0) {
        CGFloat alpha = MIN(1, offsetY/(headerImageHeight - 64));
        [self.navigationController.navigationBar cnSetBackgroundColor:[color colorWithAlphaComponent:alpha]];
     
        [self setNavigationColor:offsetY];
        
    } else {
        [self.navigationController.navigationBar cnSetBackgroundColor:[color colorWithAlphaComponent:0]];
        [self setNavigationColor:offsetY];
    }


// 类扩展中
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

