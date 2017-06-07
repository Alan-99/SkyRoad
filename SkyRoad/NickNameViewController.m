//
//  NickNameViewController.m
//  SkyRoad
//
//  Created by alan on 17/3/24.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import "NickNameViewController.h"
#import "JTextFieldView.h"

@interface NickNameViewController () <UITextFieldDelegate>

@end

@implementation NickNameViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.navigationItem.title = @"昵称";
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(addNickNameDone)];
        self.navigationItem.rightBarButtonItem = bbi;
    }
    
    return self;
}

- (void)addNickNameDone
{
    _sub_nickName = self.NNtxtFiedView.txtField.text;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _NNtxtFiedView = [[JTextFieldView alloc]initWithFrame:CGRectMake(0, 79, self.view.frame.size.width, 40)];
    [self.view addSubview:_NNtxtFiedView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.valueBlock != nil ) {
        self.valueBlock(_sub_nickName);
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *str = self.sub_nickName;
    self.NNtxtFiedView.txtField.text = str;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
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
