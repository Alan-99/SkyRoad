//
//  CreatNewPSWViewController.m
//  SkyRoad
//
//  Created by alan on 2017/4/19.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import "CreatNewPSWViewController.h"
#import "JTextFieldView.h"
#import "AFNetworking.h"

#define JScreenWidth [[UIScreen mainScreen]bounds].size.width
#define JScreenHeight [[UIScreen mainScreen]bounds].size.height

@interface CreatNewPSWViewController ()

@property (nonatomic, strong) JTextFieldView *phoneNum;
@property (nonatomic, strong) JTextFieldView *verificationCode;
@property (nonatomic, strong) JTextFieldView *creatPSW;
@property (nonatomic, strong) JTextFieldView *conformPSW;
@property (nonatomic, strong) UIButton *confirmBtn;

@end

@implementation CreatNewPSWViewController

static NSString *phoneNumber;
static NSString *verificationCode;
static NSString *password0;
static NSString *password1;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"更改密码";
    }
    return self;
}

- (void)setupViews
{
    UIButton *getVerificationCodeBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    getVerificationCodeBtn.frame = CGRectMake(0, 0, 90, 43);
    [getVerificationCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
    [getVerificationCodeBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    getVerificationCodeBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    [getVerificationCodeBtn addTarget:self action:@selector(getVerificationCode) forControlEvents:UIControlEventTouchUpInside];
    
    JTextFieldView *txtF0 = [[JTextFieldView alloc]initWithFrame:CGRectMake(0, 84, JScreenWidth, 43)];
    txtF0.txtField.keyboardType = UIKeyboardTypeNumberPad;
    [txtF0 setupPlaceholder:@"请填写手机号"];
    txtF0.txtField.rightView = getVerificationCodeBtn;
    txtF0.txtField.rightViewMode = UITextFieldViewModeAlways;
    [self.view addSubview:txtF0];
    _phoneNum = txtF0;
    
    JTextFieldView *txtF1 = [[JTextFieldView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.phoneNum.frame)-1, JScreenWidth, 43)];
    txtF1.txtField.keyboardType = UIKeyboardTypeNumberPad;
    [txtF1 setupPlaceholder:@"请填写验证码"];
    [self.view addSubview:txtF1];
    _verificationCode = txtF1;
    
    JTextFieldView *txtF2 = [[JTextFieldView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.verificationCode.frame)-1, JScreenWidth, 43)];
    txtF2.txtField.keyboardType = UIKeyboardTypeASCIICapable;
    txtF2.txtField.secureTextEntry = YES;
    [txtF2 setupPlaceholder:@"设置新密码"];
    [self.view addSubview:txtF2];
    _creatPSW = txtF2;
    
    JTextFieldView *txtF3 = [[JTextFieldView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.creatPSW.frame)-1, JScreenWidth, 43)];
    txtF3.txtField.keyboardType = UIKeyboardTypeASCIICapable;
    txtF3.txtField.secureTextEntry = YES;
    [txtF3 setupPlaceholder:@"确认新密码"];
    [self.view addSubview:txtF3];
   _conformPSW = txtF3;
    
    UIButton *btn0 = [[UIButton alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.conformPSW.frame)+30, JScreenWidth-60, 43)];
    [btn0 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn0 setTitle:@"确定" forState:UIControlStateNormal];
    [btn0 setBackgroundColor:[UIColor colorWithRed:45/255.0 green:139/255.0 blue:226/255.0 alpha:1.0]];
    [btn0 addTarget:self action:@selector(confirmBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn0];
    _confirmBtn = btn0;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.valueBlock != nil) {
        self.valueBlock(phoneNumber);
    }
}

// 判断手机号格式是否正确
- (BOOL)judgeMobileNum:(NSString*)mobileNum
{
    /***  中国移动 China Mobile ***/
    // 移动：134[0-8]-139，150，151，157，158，159，182，187，188
    /***  中国联通 China Unicom ***/
    // 联通：130-132,152,155,156,185,186
    /***  中国电信 China Telecom ***/
    // 电信：133,1349,153,180,189
    // 正则表达式，判断手机号是否符合条件
    NSString *mobile = @"^1(3[0-9]|5[0-35-9]|8[025-9])\\d{8}$";
    NSPredicate *judgeCM = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", mobile];
    return [judgeCM evaluateWithObject:mobileNum];
}
// 判断密码长度是否合适
- (BOOL)judgePassword:(NSString*)password
{
    if (password.length>5) {
        return YES;
    }else {
        return NO;
    }
//    return nil;
}

- (NSString *)creatRandomNum
{
    // 创建随机数字字符串
    NSString *randomNum = [NSString stringWithFormat:@"%c%c%c%c%c%c",
                           '0'+ arc4random()%10,
                           '0'+ arc4random()%10,
                           '0'+ arc4random()%10,
                           '0'+ arc4random()%10,
                           '0'+ arc4random()%10,
                           '0'+ arc4random()%10];
    return randomNum;
}

- (void)getVerificationCode
{
    [self creatRandomNum];
    phoneNumber = self.phoneNum.txtField.text;
    verificationCode = [self creatRandomNum];
    NSLog(@"验证码是：%@",verificationCode);
    BOOL isPhoneNum = [self judgeMobileNum:phoneNumber];
    if (!phoneNumber.length) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请输入手机号" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    } else if (!isPhoneNum) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"手机号格式错误" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else {
        // 定义账户／密码接口
        NSString *domainStr = [NSString stringWithFormat:@"http://b.airlord.cn:31568/users/register?passwd=sibet&pid=%@&code=%@", phoneNumber,verificationCode];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:domainStr parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            id resultObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"验证码后台提示：%@",resultObj);
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"验证码发送成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:okAction];
            NSLog(@"task:%@",task);
            [self presentViewController:alert animated:YES completion:nil];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"发送失败" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
            NSLog(@"task:%@",task);
            NSLog(@"error:%@",error);
        }];
    }
}

- (void)confirmBtnClicked
{
    phoneNumber = self.phoneNum.txtField.text;
    NSString *vfCode = self.verificationCode.txtField.text;
    password0 = self.creatPSW.txtField.text;
    password1 = self.conformPSW.txtField.text;
    bool isPhoneNum = [self judgeMobileNum:phoneNumber];
    bool isPassword = [self judgePassword:password0];
    if (!isPhoneNum) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"手机号格式错误" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    if (![vfCode isEqualToString:verificationCode]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"验证码错误" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    if (!isPassword) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"密码长度为6-12位" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    if (![password0 isEqualToString:password1]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"密码两次输入不一致" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        return;
    }
    else {
        // 定义修改密码的接口
        NSString *domainStr = [NSString stringWithFormat:@"http://b.airlord.cn:31568/users/updateUser?pid=%@&password=%@",phoneNumber, password0];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:domainStr parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            id resultObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"%@",resultObj);
            if ([resultObj isKindOfClass:[NSDictionary class]]) {
                NSString *codeStr = [(NSDictionary*)resultObj objectForKey:@"code"];
                if ([codeStr isEqualToString:@"1"]) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"web API调用出错！" message:@"操作失败,code=1，请联系客服" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
                    [alert addAction:okAction];
                    [self presentViewController:alert animated:YES completion:nil];
                }
                else if ([codeStr isEqualToString:@"200"])
                {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"密码修改成功！" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                    [alert addAction:okAction];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"网络连接失败" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
            NSLog(@"task:%@",task);
            NSLog(@"error:%@",error);
        }];
    }
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
