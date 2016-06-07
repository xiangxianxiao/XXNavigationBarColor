//
//  MYTableViewViewController.m
//  XXNavigationBarColor
//
//  Created by xiangxx on 16/6/7.
//  Copyright © 2016年 xiangxx. All rights reserved.
//

#import "XXTableViewViewController.h"
#import "UINavigationBar+Background.h"

#define SCREEN_RECT [UIScreen mainScreen].bounds
static const CGFloat headerImageHeight = 260.0f;

@interface XXTableViewViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    // 拉伸的底图
    UIImageView *headerImageView;
}
@end

@implementation XXTableViewViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.mTableView.delegate = self;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.mTableView.delegate = nil;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"呵呵呵呵~~";
    
    //1、 去掉navigationbar 上的背景图片
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //1.1、 去掉navigationbar 上图片下面的线
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    self.mTableView.contentInset = UIEdgeInsetsMake(headerImageHeight, 0, 0, 0);
    self.mTableView.tableHeaderView = [[UIView alloc] init];
    
    
    headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                    -headerImageHeight,
                                                                    CGRectGetWidth(SCREEN_RECT), headerImageHeight)];
    headerImageView.image = [UIImage imageNamed:@"headerImage"];
    // 高度改变  宽高也跟着改变
    headerImageView.contentMode = UIViewContentModeScaleToFill;//重点（不设置拿奖只会被纵向拉伸）
    // 设置autoresizesSubView让子类自动布局。
    headerImageView.autoresizesSubviews = YES;
    [self.mTableView addSubview:headerImageView];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *string = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:string];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:string];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"========>%ld",(long)indexPath.row];
    return cell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    /**
     *  处理头部图片拉伸放大效果
     */
    CGFloat y = scrollView.contentOffset.y + 64;
    if (y < -headerImageHeight) {
        CGRect rect = headerImageView.frame;
        rect.origin.y = y;
        rect.size.height =  - y;
        headerImageView.frame = rect;
    }
    
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
}

#pragma mark 重写状态栏的方法
/**
 
 为了适配IOS9 需要在 .pList文件里添加
 View controller-based status bar appearance 设置为 NO  
 默认为 YES
 
 */
- (void)setNavigationColor:(CGFloat)floatY{
    if (floatY >= 180) {
        //状态栏˝˝
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        //标题颜色
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor whiteColor]};
        //导航栏子控件颜色
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
        
    }else{
        //状态栏
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
        //标题颜色
        self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor]};
        //导航栏子控件颜色
        self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
