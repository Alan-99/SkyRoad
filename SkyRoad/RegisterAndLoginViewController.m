//
//  RegisterAndLoginViewController.m
//  SkyRoad
//
//  Created by alan on 2017/4/18.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import "RegisterAndLoginViewController.h"
#import "JImageAndTxtfieldView.h"
#import "RegisterViewController.h"
#import "CreatNewPSWViewController.h"
#import "RootTabBarViewController.h"
#import "AFNetworking.h"

#import "AppDelegate.h"
#import "DeviceSQLManager.h"
#import "SQLManager.h"
#import "DeviceDetailModel.h"

#define JScreenWidth [[UIScreen mainScreen]bounds].size.width
#define JScreenHeight [[UIScreen mainScreen]bounds].size.height

@interface RegisterAndLoginViewController ()<UITextFieldDelegate>

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIImageView *logoImageView;
@property (nonatomic, strong) IBOutlet UIButton *LoginBtn;
@property (nonatomic, strong) IBOutlet UIButton *registerBtn;
@property (nonatomic, strong) IBOutlet UIButton *forgetPswBtn;

@end

@implementation RegisterAndLoginViewController

DeviceSQLManager *_mainManager;
SQLManager *_mainManager1;

static NSString* password;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // 定义子vc返回按键
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
        self.navigationItem.backBarButtonItem = backItem;
    }
    [self setNeedsStatusBarAppearanceUpdate];
    return self;
}
// 隐藏状态栏
//- (BOOL)prefersStatusBarHidden {
//    return YES ;
//}

- (void)backAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self initBackGroundImageView];
    [self initLogoImageView];
    [self initAccountAndPasswordView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setHidden:YES];
    self.password.txtField.text = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setHidden:NO];
}

- (void)initAccountAndPasswordView
{
    _account = [[JImageAndTxtfieldView alloc]initWithFrame:CGRectMake(JScreenWidth/8, JScreenHeight/3, JScreenWidth*3/4, 40)];
    [_account setupImageView:@"Login_account" txtfieldPlaceholder:@"请输入您的手机号"];
    _account.txtField.keyboardType = UIKeyboardTypePhonePad;
    _account.txtField.delegate = self;
    [self.view addSubview:_account];
    
    _password = [[JImageAndTxtfieldView alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.account.frame), CGRectGetMaxY(self.account.frame)+20, JScreenWidth*3/4, 40)];
    _password.txtField.secureTextEntry = YES;
    [_password setupImageView:@"Login_password" txtfieldPlaceholder:@"请输入您的密码"];
    _password.txtField.delegate = self;
    [self.view addSubview:_password];
    
    UIButton *btn0 = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.account.frame), CGRectGetMaxY(self.password.frame)+40, JScreenWidth*3/4, 50)];
    [btn0 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn0 setTitle:@"登录" forState:UIControlStateNormal];
    [btn0 setBackgroundColor:[UIColor colorWithRed:45/255.0 green:139/255.0 blue:226/255.0 alpha:1.0]];
    [self.view addSubview:btn0];
    _LoginBtn = btn0;
    [self.LoginBtn addTarget:self action:@selector(toRootTabBarVC) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMinX(self.account.frame), CGRectGetMaxY(self.LoginBtn.frame)+10, JScreenWidth*3/4, 50)];
    btn1.layer.borderWidth = 0.3;
    btn1.layer.borderColor = [UIColor grayColor].CGColor;
    [btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn1 setTitle:@"注册" forState:UIControlStateNormal];
    [btn1 setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:btn1];
    _registerBtn = btn1;
    [self.registerBtn addTarget:self action:@selector(toRigsterVC:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *btn2 = [[UIButton alloc]initWithFrame:CGRectMake(JScreenWidth/2-40, CGRectGetMaxY(self.registerBtn.frame), 80, 30)];
    [btn2 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn2 setTitle:@"忘记密码？" forState:UIControlStateNormal];
    btn2.titleLabel.font = [UIFont systemFontOfSize:13];
    [self.view addSubview:btn2];
    _forgetPswBtn = btn2;
    [self.forgetPswBtn addTarget:self action:@selector(toCreatNewPasswordVC) forControlEvents:UIControlEventTouchUpInside];
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
}
- (void)toRootTabBarVC
{
    _globalAccount = self.account.txtField.text;
    password = self.password.txtField.text;
    // 获取全局变量
    extern NSString* globalAccount;
    globalAccount = self.globalAccount;
    BOOL isPhoneNum = [self judgeMobileNum:self.globalAccount];
    BOOL isPassword = [self judgePassword:password];
    if (!isPhoneNum) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"手机号格式错误" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    if (!isPassword) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"密码不能低于六位" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else {
        // 获取所属账号密文信息
        NSString *domainStr = [NSString stringWithFormat:@"http://b.airlord.cn:31568/users/queryJM?des=muymimasibet&pid=%@",self.globalAccount];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager GET:domainStr parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSArray *resultArr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            if (resultArr.count == 0) {
                UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"账户不存在！" message:@"请先用手机号注册" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
                [alert addAction:okAction];
                [self presentViewController:alert animated:YES completion:nil];
            }
            else {
                NSDictionary *resultDic = [(NSArray *)resultArr objectAtIndex:0];
                NSDictionary *passwordDic = [resultDic objectForKey:@"password"];
                // 获取服务器上注册的密码array；为NSArray类型
                NSArray *passwordArrI = [passwordDic objectForKey:@"data"];
                /*** 把输入的密码转换成服务器密码存储的格式，进行判断是否相等 ***/
                // 计算密码长度
                NSInteger passwordLength = password.length;
                BOOL isEqual = false;
                if (passwordArrI.count == passwordLength) {
                    for (int i=0; i<passwordLength; i++) {
                        // 输入密码的ascii码，如果输入0，则为48，输入q，则为113
                        int ascii = [password characterAtIndex:i];
                        // 注册密码的字符 （long）类型
                        NSString *psw = [passwordArrI objectAtIndex:i];
                        // 把注册密码字符long类型转换成int类型
                        // 与输入密码的ascii int类型对比
                        NSInteger pswInt = (NSInteger)[psw longLongValue];
                        if (ascii == pswInt) {
                            isEqual = true;
                        }
                        else {
                            isEqual = false;
                            break;
                        }
                    }
                }
                if (isEqual) {
                    [self getDevsFromApiAccountEqualsTo:globalAccount];
                    [self getPigeonInfoFromApiAccountEqualsTo:globalAccount];
                    RootTabBarViewController *rtvc = [[RootTabBarViewController alloc]init];
                    [self presentViewController:rtvc animated:YES completion:nil];
                }
                else {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"账户密码错误" preferredStyle:UIAlertControllerStyleAlert];
                    [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil]];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"登录服务器失败" message:@"请检查您的网络状态" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }];
    }
}

- (void)toRigsterVC:(id)sender
{
    RegisterViewController *rvc = [[RegisterViewController alloc]init];
    rvc.view.backgroundColor = [UIColor whiteColor];
    rvc.valueBlock = ^(NSString *accountTxt) {
        self.account.txtField.text = accountTxt;
    };
    [self.navigationController pushViewController:rvc animated:YES];
}

- (void)toCreatNewPasswordVC
{
    CreatNewPSWViewController *cnpvc = [[CreatNewPSWViewController alloc]init];
    cnpvc.view.backgroundColor = [UIColor whiteColor];
    cnpvc.valueBlock = ^(NSString *accountTxt) {
        self.account.txtField.text = accountTxt;
    };
    [self.navigationController pushViewController:cnpvc animated:YES];
}

- (void)initBackGroundImageView
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetMaxX(self.view.frame), CGRectGetMaxY(self.view.frame))];
    imageView.image = [UIImage imageNamed:@"Login_bgImage"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    _bgImageView = imageView;
}

- (void)initLogoImageView
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(JScreenWidth/2 - 45, JScreenHeight/3 - 120, 90, 90)];
    imageView.image = [UIImage imageNamed:@"Login_logo"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    _logoImageView = imageView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/***  从web服务器获取用户所拥有的设备号  ***/
- (void)getDevsFromApiAccountEqualsTo:(NSString*)account
{
    NSMutableArray *devArr0 = [[NSMutableArray alloc]init];
    NSString *accountStr = account;
    NSString *urlStr = [NSString stringWithFormat:@"http://b.airlord.cn:31568/users/querysb?pid=%@",accountStr];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    // delegate设置为nil，因为session对象并不需要实现委托方法
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:nil];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data==nil) {
            // 网络状况不佳
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"无法同步网络数据" message:@"网络连接失败" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else {
            DeviceSQLManager *manager = [DeviceSQLManager shareManager];
            _mainManager = manager;
            [_mainManager deleteAll];
            NSMutableArray *arr = [_mainManager searchAll];
            DeviceDetailModel *model = [[DeviceDetailModel alloc]init];
            
            id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            long objCount = [(NSArray*)obj count];
            for (int i=0; i < objCount; i++) {
                NSDictionary *devDic = [(NSArray *)obj objectAtIndex:i];
                NSString *devStr = [(NSDictionary *)devDic objectForKey:@"sbid"];
                NSString *filterDevStr = [devStr substringFromIndex:2];
                [devArr0 addObject:filterDevStr];
                model.deviceNum = filterDevStr;
                model.deviceId = [arr count]+1+i;
                [_mainManager insert:model];
            }
//            NSMutableArray *arr1 = [_mainManager searchAll];
//            NSLog(@"devmanager的设备数:%lu", (unsigned long)arr1.count);
        }
    }];
    
    [dataTask resume];
}

/***  从web服务器获取用户所拥有的信鸽  ***/
- (void)getPigeonInfoFromApiAccountEqualsTo:(NSString*)account
{
    NSString *accountStr = account;
    NSString *urlStr = [NSString stringWithFormat:@"http://b.airlord.cn:31568/users/queryGZH?pid=%@",accountStr];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
    // delegate设置为nil，因为session对象并不需要实现委托方法
    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:nil];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (data==nil) {
            // 网络状况不佳
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"无法同步网络数据" message:@"网络连接失败" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
        else {
            SQLManager *manager = [SQLManager shareManager];
            _mainManager1 = manager;
            [_mainManager1 deleteAll];
            NSMutableArray *arr = [_mainManager1 searchAll];
            PigeonDetailModel *model = [[PigeonDetailModel alloc]init];
            
            id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            long objCount = [(NSArray*)obj count];
            for (int i=0; i < objCount; i++) {
                NSDictionary *pigeonDic = [(NSArray *)obj objectAtIndex:i];
                NSString *ringNumStr = [(NSDictionary *)pigeonDic objectForKey:@"gzhid"];
                NSString *sexStr = [(NSDictionary *)pigeonDic objectForKey:@"gzmale"];
                NSString *furcolorStr = [(NSDictionary *)pigeonDic objectForKey:@"gzcolor"];
                NSString *eyesandStr = [(NSDictionary *)pigeonDic objectForKey:@"gzsy"];
                NSString *descentStr = [(NSDictionary *)pigeonDic objectForKey:@"gzxt"];

                model.pigeonID = [arr count]+1+i;
                model.pigeonRingNumber = ringNumStr;
                model.pigeonSex = sexStr;
                model.pigeonFurcolor = furcolorStr;
                model.pigeonEyesand = eyesandStr;
                model.pigeonDescent = descentStr;
                [_mainManager1 insert:model];
            }
//            NSMutableArray *arr1 = [_mainManager1 searchAll];
            //            NSLog(@"devmanager的设备数:%lu", (unsigned long)arr1.count);
        }
    }];
    
    [dataTask resume];
}

// 屏幕上移
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect frame = self.forgetPswBtn.frame;
    // 忘记密码btn控件高度为30，间隔设置为10，弹出的键盘高度为216
    int offset = frame.origin.y + 30 + 10 - (JScreenHeight - 216.0);
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"LogVCResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    if (offset>0) {
        CGRect rect = CGRectMake(0.0f, -offset, width, height); //上推键盘操作，view大小始终没变
        self.view.frame = rect;
    }
    [UIView commitAnimations];
}

// 屏幕恢复
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    NSTimeInterval animationDuration = 0.30f;
    [UIView beginAnimations:@"LogVCResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    // 回复屏幕
    self.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
    [UIView commitAnimations];
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
