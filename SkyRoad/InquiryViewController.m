//
//  InquiryViewController.m
//  SkyRoad
//
//  Created by alan on 17/3/22.
//  Copyright © 2017年 sibet. All rights reserved.
//
//// test

#import "InquiryViewController.h"

@interface InquiryViewController ()

@end

@implementation InquiryViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"查询";
        UIImage *i = [UIImage imageNamed:@"Inquiry_BarItem.png"];
        self.tabBarItem.image = i;
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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
