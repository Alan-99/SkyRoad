//
//  RegisterViewController.m
//  SkyRoad
//
//  Created by alan on 2017/4/18.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import "RegisterViewController.h"
#import "AFNetworking.h"

#define JScreenWidth [[UIScreen mainScreen]bounds].size.width
#define JScreenHeight [[UIScreen mainScreen]bounds].size.height

@interface RegisterViewController () <UITextFieldDelegate>

@property (nonatomic,strong) UIImageView *logoV;
@property (nonatomic, strong) UITextField *phoneNumTxtField;
@property (nonatomic, strong) UITextField *createPSWTxtField;
@property (nonatomic, strong) UITextField *confirmPSWTxtField;
@property (nonatomic, strong) UIButton *registerBtn;
@property (nonatomic, strong) UIButton *deleteBtn;

@end

@implementation RegisterViewController

static NSString* account;
static NSString* password0;
static NSString* password1;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"注册";
    }
    return self;
}

- (void)setupViews
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(JScreenWidth/2 - 45, 64+8, 90, 90)];
    imageView.image = [UIImage imageNamed:@"Login_Register_logo"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    _logoV = imageView;
    
    // textfield的左侧空白view；
    UIView *view0 = [[UIView alloc]initWithFrame:CGRectMake(0,0,8,40)];
    UITextField *txtF0 = [[UITextField alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.logoV.frame)+8, JScreenWidth-40, 40)];
    txtF0.leftView = view0;
    txtF0.leftViewMode = UITextFieldViewModeAlways;
    txtF0.delegate = self;
    txtF0.layer.borderWidth = 1.0f;
    txtF0.layer.borderColor = [UIColor lightGrayColor].CGColor;
    txtF0.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtF0.placeholder = @"请输入手机号";
    txtF0.returnKeyType = UIReturnKeyDone;
    txtF0.keyboardType = UIKeyboardTypePhonePad;
    [self.view addSubview:txtF0];
    _phoneNumTxtField = txtF0;
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0,0,8,40)];
    UITextField *txtF1 = [[UITextField alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.phoneNumTxtField.frame)-1, JScreenWidth-40, 40)];
    txtF1.leftView = view1;
    txtF1.leftViewMode = UITextFieldViewModeAlways;
    txtF1.delegate = self;
    txtF1.layer.borderWidth = 1.0f;
    txtF1.layer.borderColor = [UIColor lightGrayColor].CGColor;
    txtF1.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtF1.placeholder = @"设置密码";
    txtF1.returnKeyType = UIReturnKeyDone;
    txtF1.keyboardType = UIKeyboardTypeASCIICapable;
    txtF1.secureTextEntry = YES;
    [self.view addSubview:txtF1];
    _createPSWTxtField = txtF1;

    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0,0,8,40)];
    UITextField *txtF2 = [[UITextField alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.createPSWTxtField.frame)-1, JScreenWidth-40, 40)];
    txtF2.leftView = view2;
    txtF2.leftViewMode = UITextFieldViewModeAlways;
    txtF2.delegate = self;
    txtF2.layer.borderWidth = 1.0f;
    txtF2.layer.borderColor = [UIColor lightGrayColor].CGColor;
    txtF2.clearButtonMode = UITextFieldViewModeWhileEditing;
    txtF2.placeholder = @"确认密码";
    txtF2.returnKeyType = UIReturnKeyDone;
    txtF2.keyboardType = UIKeyboardTypeASCIICapable;
    txtF2.secureTextEntry = YES;
    [self.view addSubview:txtF2];
    _confirmPSWTxtField = txtF2;
    
    UIButton *btn0 = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.confirmPSWTxtField.frame)+30, JScreenWidth-40, 50)];
    [btn0 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn0 setTitle:@"注册" forState:UIControlStateNormal];
    [btn0 setBackgroundColor:[UIColor colorWithRed:45/255.0 green:139/255.0 blue:226/255.0 alpha:1.0]];
    [self.view addSubview:btn0];
    [btn0 addTarget:self action:@selector(clickRegisterBtn) forControlEvents:UIControlEventTouchUpInside];
    _registerBtn = btn0;
    
//    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.registerBtn.frame)+10, JScreenWidth-40, 50)];
//    btn1.layer.borderWidth = 0.3;
//    btn1.layer.borderColor = [UIColor grayColor].CGColor;
//    [btn1 setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    [btn1 setTitle:@"删除账户" forState:UIControlStateNormal];
//    [btn1 setBackgroundColor:[UIColor whiteColor]];
//    [self.view addSubview:btn1];
//    _registerBtn = btn1;
//    [self.registerBtn addTarget:self action:@selector(deleteBtnClicked) forControlEvents:UIControlEventTouchUpInside];
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

// http GET方式添加用户
- (void)clickRegisterBtn {
    account = self.phoneNumTxtField.text;
    password0 = self.createPSWTxtField.text;
    password1 = self.confirmPSWTxtField.text;
    BOOL isPhoneNum = [self judgeMobileNum:account];
    BOOL isPassword = [self judgePassword:password0];
    if (!isPhoneNum) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"手机号格式错误" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    if (!isPassword) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"密码长度不能低于6位" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    if (![password0 isEqualToString:password1]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"密码两次输入不一致" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else {
        // 定义账户／密码接口
        NSString *domainStr = [NSString stringWithFormat:@"http://b.airlord.cn:31568/users/addUser?pid=%@&password=%@",account, password0];
        AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        
        [manager GET:domainStr parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            id resultObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"%@",resultObj);
            if ([resultObj isKindOfClass:[NSDictionary class]]) {
                NSString *codeStr = [(NSDictionary*)resultObj objectForKey:@"code"];
                if ([codeStr isEqualToString:@"1"]) {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"该手机号已注册" message:nil preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
                    [alert addAction:okAction];
                    [self presentViewController:alert animated:YES completion:nil];
                }
                else if ([codeStr isEqualToString:@"200"])
                {
                    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"账户注册成功！" preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self.navigationController popViewControllerAnimated:YES];
                    }];
                    [alert addAction:okAction];
                    [self presentViewController:alert animated:YES completion:nil];
                }
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"网络出错了..." message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
            NSLog(@"task:%@",task);
            NSLog(@"error:%@",error);
        }];
    }
}

- (void)deleteBtnClicked
{
    account = self.phoneNumTxtField.text;
    if (account.length) {
        NSString *domainStr = [NSString stringWithFormat:@"http://b.airlord.cn:31568/users/deleteUser?pid=%@",account];
        AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
        manager1.responseSerializer = [AFHTTPResponseSerializer serializer];
        [manager1 GET:domainStr parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"删除账户成功" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:nil];
            [alert addAction:okAction];
            [self presentViewController:alert animated:YES completion:nil];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"删除失败" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
            NSLog(@"task:%@",task);
            NSLog(@"error:%@",error);
        }];
    }
}

//- (void)clickRegisterBtn1 {
//    account = self.phoneNumTxtField.text;
//    password0 = self.createPSWTxtField.text;
//    password1 = self.confirmPSWTxtField.text;
//    
////    NSString *urlStr = @"http://b.airlord.cn:31568/users/addUser?";
//    NSString *domainStr = [NSString stringWithFormat:@"http://b.airlord.cn:31568/users/addUser?pid=%@&password=%@",account, password0];
//    NSURL *url = [NSURL URLWithString:domainStr];
//    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:url];
//    req.HTTPMethod = @"GET";
//    NSString *postParam = [NSString stringWithFormat:@"pid=%@&password=%@",account,password0];
//    NSData *postData = [postParam dataUsingEncoding:NSUTF8StringEncoding];
//    [req setHTTPBody:postData];
//    
//    NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
//    NSURLSession *session = [NSURLSession sessionWithConfiguration:config delegate:nil delegateQueue:nil];
//    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:req completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
//        id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
//        NSString* msg = [obj objectForKey:@"msg"];
//        NSLog(@"response:%@",response);
//        NSLog(@"data:%@,msg:%@",obj,msg);
//        NSLog(@"error:%@",error);
//    }];
//    [dataTask resume];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupViews];

    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.valueBlock != nil) {
        self.valueBlock(account);
    }
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
