//
//  MainNavViewController.m
//  IMLottery
//
//  Created by feng-Mac on 16/8/19.
//  Copyright © 2016年 feng-Mac. All rights reserved.
//

#import "MainNavViewController.h"

@interface MainNavViewController ()

@end

@implementation MainNavViewController

//之所以在这个方法里设置因为这个方法只调用一次，而viewdidload调用次数和导航控制器自控制器的次数相同
+ (void)initialize{
    //设置导航栏的背景
    //    UINavigationBar *navBar = [UINavigationBar appearance];
    
    //    [self.navigationBar setBackgroundImage:[UIImage imageNamed:@"NavBar64"] forBarMetrics:UIBarMetricsDefault];
    //    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    //    attr[NSForegroundColorAttributeName] = [UIColor whiteColor];
    //    [self.navigationBar setTitleTextAttributes:attr];
    
    //设置导航栏的背景和文字样式（方法二）
    UINavigationBar *navBar = [UINavigationBar appearance];
    [navBar setBackgroundImage:[UIImage imageNamed:@"NavBar64"] forBarMetrics:UIBarMetricsDefault];
    NSMutableDictionary *attr = [NSMutableDictionary dictionary];
    attr[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [navBar setTitleTextAttributes:attr];
    //设置返回按钮的颜色：
    navBar.tintColor = [UIColor whiteColor];
    //    navBar.barTintColor = [UIColor blueColor];
    
    //设置BarButtonItem的文字样式
    UIBarButtonItem *item = [UIBarButtonItem appearance];
    NSMutableDictionary *itemAttr = [NSMutableDictionary dictionary];
    itemAttr[NSForegroundColorAttributeName] = [UIColor whiteColor];
    [item setTitleTextAttributes:itemAttr forState:UIControlStateNormal];
    //设置BarButtonItem的背景图片(ios7以下版本需要)
    //    [item setBackgroundImage:[UIImage imageNamed:@"NavButton"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //    [item setBackgroundImage:[UIImage imageNamed:@"NavButtonPressed"] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    //设置返回按钮的背景颜色(ios7以下版本需要)
    //    [item setBackButtonBackgroundImage:[UIImage imageNamed:@"NavBack"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

//重写push方法拦截所有push操作并隐藏底层工具栏
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    viewController.hidesBottomBarWhenPushed = YES;
    [super pushViewController:viewController animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
