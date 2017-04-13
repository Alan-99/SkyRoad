//
//  TypingDeviceViewController.m
//  SkyRoad
//
//  Created by alan on 2017/4/11.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import "TypingDeviceViewController.h"

@interface TypingDeviceViewController ()

@end

@implementation TypingDeviceViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"手动添加";
    }
    [self initTypingTextField];
    
    return self;
}

- (void)initTypingTextField
{
    UITextField *typingTxtField = [[UITextField alloc]initWithFrame:CGRectMake(0, 74, self.view.bounds.size.width, 40)];
    typingTxtField.borderStyle = UITextBorderStyleNone;
    typingTxtField.backgroundColor = [UIColor clearColor];
    typingTxtField.textAlignment = NSTextAlignmentLeft;
    typingTxtField.textColor = [UIColor blackColor];
    typingTxtField.returnKeyType = UIReturnKeyDone;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMinY(typingTxtField.frame), 10, 40)];
    typingTxtField.leftView = view;
    typingTxtField.leftViewMode = UITextFieldViewModeAlways;
    _deviceNumTextField = typingTxtField;
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, self.deviceNumTextField.frame.origin.y + 2, self.deviceNumTextField.frame.size.width, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.deviceNumTextField.frame) - 2, self.deviceNumTextField.frame.size.width, 1)];
    line1.backgroundColor = [UIColor lightGrayColor];

    
    [self.view addSubview:typingTxtField];
    [self.view addSubview:line];
    [self.view addSubview:line1];
}


- (void)viewDidLoad {
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
