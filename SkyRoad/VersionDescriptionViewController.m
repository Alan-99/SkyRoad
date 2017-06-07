//
//  VersionDescriptionViewController.m
//  SkyRoad
//
//  Created by alan on 2017/4/25.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import "VersionDescriptionViewController.h"

#define descriptionStr @"此app配合信鸽脚环可以实现信鸽飞行状态的实时跟踪。app操作简单易用，用户可以有效管理所属脚环设备与信鸽信息。app可为广大信鸽爱好者提供信鸽飞行数据的采集和分析服务。"

#define bgColor [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1]

static const NSString *desStr = @"此app配合信鸽脚环可以实现信鸽飞行状态的实时跟踪。app操作简单易用，用户可以有效管理所属脚环设备与信鸽信息。app可为广大信鸽爱好者提供信鸽飞行数据的采集和分析服务。";

@interface VersionDescriptionViewController () <UITextViewDelegate>

@end

@implementation VersionDescriptionViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.navigationItem.title = @"相关介绍";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITextView *textV = [[UITextView alloc]initWithFrame:CGRectMake(8, 80, self.view.frame.size.width-16, 90)];
    textV.delegate = self;
    textV.backgroundColor = [UIColor whiteColor];
    textV.text = descriptionStr;
    textV.scrollEnabled = NO;
    textV.contentInset = UIEdgeInsetsMake(-60, 0, 0, 0);
    textV.font = [UIFont systemFontOfSize:14.0];
    textV.layoutManager.allowsNonContiguousLayout = NO;
    textV.textColor = [UIColor blackColor];
    [self.view addSubview:textV];
    
    UIView *blankV0 = [[UIView alloc]initWithFrame:CGRectMake(0, 80, 8, textV.frame.size.height)];
    blankV0.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:blankV0];
    UIView *blankV1 = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(textV.frame), 80, 8, textV.frame.size.height)];
    blankV1.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:blankV1];
    
//    self.view.backgroundColor = bgColor;
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
