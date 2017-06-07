//
//  RootTabBarViewController.m
//  SkyRoad
//
//  Created by alan on 2017/4/21.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import "RegisterAndLoginViewController.h"

#import "RootTabBarViewController.h"
#import "TrackViewController.h"
#import "InquiryViewController.h"
#import "MineViewController.h"

@interface RootTabBarViewController ()

@end

@implementation RootTabBarViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        UINavigationController *tvcNav = [[UINavigationController alloc] initWithRootViewController:[[TrackViewController alloc] init]];
        UINavigationController *ivcNav = [[UINavigationController alloc] initWithRootViewController:[[InquiryViewController alloc] init]];
        UINavigationController *mvcNav = [[UINavigationController alloc] initWithRootViewController:[[MineViewController alloc] init]];
        self.viewControllers = @[tvcNav, ivcNav, mvcNav];
    }
    return self;
}

- (void)viewDidLoad {
    extern NSString * globalTest;
    globalTest = @"123qqq";
    NSLog(@"测试：全局变量:%@",globalTest);
    
    [super viewDidLoad];

    // Do any additional setup after loading the view.
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
