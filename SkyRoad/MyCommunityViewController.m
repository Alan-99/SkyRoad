//
//  MyCommunityViewController.m
//  SkyRoad
//
//  Created by alan on 2017/4/7.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import "MyCommunityViewController.h"

#define JScreenWidth [[UIScreen mainScreen]bounds].size.width
#define JScreenHeight [[UIScreen mainScreen]bounds].size.height

@interface MyCommunityViewController ()

@end

@implementation MyCommunityViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.navigationItem.title = @"我的社区";
    }
    
    return self;
}

- (void)setupViews
{
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(JScreenWidth/2-112, JScreenHeight/2-112, 225, 225)];
    imageV.image = [UIImage imageNamed:@"Mine_CommunityQRCode"];
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageV];
    
    UILabel *label0 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(imageV.frame), CGRectGetMinY(imageV.frame)-40, imageV.frame.size.width, 23)];
    label0.text = @"扫描二维码加入信鸽讨论群";
    label0.textAlignment = NSTextAlignmentCenter;
    label0.font = [UIFont systemFontOfSize:15.0];
    [self.view addSubview:label0];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews ];
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
