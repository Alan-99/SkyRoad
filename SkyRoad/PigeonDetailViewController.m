//
//  PigeonDetailViewController.m
//  SkyRoad
//
//  Created by alan on 17/3/29.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import "PigeonDetailViewController.h"
#import "SQLManager.h"
#import "PigeonDetailModel.h"
#import "UIView+Toast.h"
#import "AddPigeonViewController.h"

#define JScreenWidth [[UIScreen mainScreen]bounds].size.width
#define JScreenHeight [[UIScreen mainScreen]bounds].size.height
#define JNavigationBarHeight self.navigationController.navigationBar.frame.size.height


@interface PigeonDetailViewController () <UITextFieldDelegate>


@end

@implementation PigeonDetailViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // 导航栏右侧button为系统自带完成 button
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(addPigeonDetailToSQLManager)];
        self.navigationItem.rightBarButtonItem = bbi;
    }
    return self;
}

- (void)addPigeonDetailToSQLManager
{
    
    
    if ([[self.pigeonName.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0 || self.pigeonName.text == nil || self.pigeonName.text == NULL) {
        
        NSString *tip = @"信息无效，请按返回键退出";
        NSLog(@"%@",tip);
        CGPoint point = CGPointMake(JScreenWidth/2, CGRectGetMaxY(self.pigeonDescent.frame)+ 40 );
        NSValue *value = [NSValue valueWithCGPoint:point];
        [self.view makeToast:tip duration:1.0 position:value];
    }else {
        
        SQLManager *manager =  [SQLManager shareManager];
        [manager deleteWithName:self.model];
        // 写入数据库
        // 删除原model
        [manager deleteWithName:self.model];
        
        PigeonDetailModel *newModel = [[PigeonDetailModel alloc]init];

        newModel.pigeonName = self.pigeonName.text;
        newModel.pigeonRingNumber = self.pigeonRingNum.text;
        newModel.pigeonSex = self.pigeonSex.text;
        newModel.pigeonFurcolor = self.pigeonFurcolor.text;
        newModel.pigeonEyesand = self.pigeonEyesand.text;
        newModel.pigeonDescent = self.pigeonDescent.text;
        
        [manager insert:newModel];
        
        NSLog(@"name:%@, ringNum:%@, sex:%@, furcolor:%@, eyesand:%@, descent:%@",newModel.pigeonName, newModel.pigeonRingNumber, newModel.pigeonSex, newModel.pigeonFurcolor, newModel.pigeonEyesand, newModel.pigeonDescent);
        
        if (self.valueBlock != nil ) {
            self.valueBlock (manager);
        }

        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    
//    
//    _pigeonNameView = [[LabelAndTextFieldView alloc]initWithFrame:CGRectMake(0, 64 + 10 , JScreenWidth , 43)];
//    [_pigeonNameView setupLabelString:@"姓名" textFieldPlaceHolder:@"请输入鸽名"];
//    [self.view addSubview:_pigeonNameView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    // 取消当前的第一相应对象
    [self.view endEditing:YES];
    // 将修改 保存 至model对象
    PigeonDetailModel *model = self.model;
    model.pigeonName = self.pigeonName.text;
    model.pigeonRingNumber = self.pigeonRingNum.text;
    model.pigeonSex = self.pigeonSex.text;
    model.pigeonFurcolor = self.pigeonFurcolor.text;
    model.pigeonEyesand = self.pigeonEyesand.text;
    model.pigeonDescent = self.pigeonDescent.text;
    
    
    
//    NSLog(@"self.item:%@",self.item);
//    NSLog(@"itemC:%@",itemC);

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    PigeonDetailModel *model = self.model;
    
    self.pigeonName.text = model.pigeonName;
    self.pigeonRingNum.text = model.pigeonRingNumber;
    self.pigeonSex.text = model.pigeonSex;
    self.pigeonFurcolor.text = model.pigeonFurcolor;
    self.pigeonEyesand.text = model.pigeonEyesand;
    self.pigeonDescent.text = model.pigeonDescent;

    NSLog(@"self.model:%@",self.model);
    NSLog(@"self.model.name:%@",self.model.pigeonName);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
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
