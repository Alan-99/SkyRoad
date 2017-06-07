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
#import "AFNetworking.h"
#import "JLableAndButtonView.h"

#define JScreenWidth [[UIScreen mainScreen]bounds].size.width
#define JScreenHeight [[UIScreen mainScreen]bounds].size.height
#define JNavigationBarHeight self.navigationController.navigationBar.frame.size.height


@interface PigeonDetailViewController () <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic,strong) UIImageView *logoV;
@property (nonatomic, strong) UIPickerView *furcolorPicker;
@property (nonatomic, strong) NSArray *furcolorArray;

@end

@implementation PigeonDetailViewController

// 获取全局变量,即账号信息
extern NSString* globalAccount;

NSString *pigeonSexStr;
NSString *pigeonFurcolorStr;
NSString *pigeonEyesandStr;
NSString *pigeonDescentStr;


- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // 导航栏右侧button为系统自带完成 button
//        UIBarButtonItem *bbi = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(addPigeonDetailToSQLManager)];
        UIBarButtonItem *bbi0 = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(addPigeonDetailToSQLManager)];
        self.navigationItem.rightBarButtonItem = bbi0;
    }
    return self;
}

- (void)setupViews
{
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(JScreenWidth/2 - 45, 64+10, 90, 90)];
    imageView.image = [UIImage imageNamed:@"Login_Register_logo"];
    imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageView];
    _logoV = imageView;
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(45, CGRectGetMaxY(self.logoV.frame)+10, 8, 33)];
    label2.text = @"*";
    label2.textColor = [UIColor redColor];
    [self.view addSubview:label2];
    UILabel *label3 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label2.frame), CGRectGetMinY(label2.frame), 100, 33)];
    label3.text = @"为必填项";
    label3.textColor = [UIColor blackColor];
    [self.view addSubview:label3];
    
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(label3.frame), JScreenWidth-40, 1)];
    line.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:line];
    
    UILabel *label0 = [[UILabel alloc]initWithFrame:CGRectMake(45, CGRectGetMaxY(line.frame)+5, (JScreenWidth-60)/6, 33)];
    label0.text = @"环号";
    label0.textColor = [UIColor blackColor];
    [self.view addSubview:label0];
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label0.frame)-10, CGRectGetMinY(label0.frame), 8, 33)];
    label1.text = @"*";
    label1.textColor = [UIColor redColor];
    [self.view addSubview:label1];
    
    UITextField *txtF0 = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(label0.frame)+15, CGRectGetMinY(label0.frame), 150, 33)];
    txtF0.borderStyle = UITextBorderStyleLine;
    txtF0.layer.borderWidth = 0.8;
    txtF0.layer.borderColor = [UIColor lightGrayColor].CGColor;
    txtF0.returnKeyType = UIReturnKeyDone;
    [self.view addSubview:txtF0];
    _pigeonRingNum = txtF0;
    _pigeonRingNum.delegate = self;
    
    JLableAndButtonView *lbv0 = [[JLableAndButtonView alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.pigeonRingNum.frame)+5-1, JScreenWidth-60, 43)];
    [lbv0 setupLabeText:@"性别"];
    lbv0.textField.delegate = self;
    lbv0.textField.tag = 1;
    [self.view addSubview:lbv0];
    _pigeonSex = lbv0;
    
    JLableAndButtonView *lbv1 = [[JLableAndButtonView alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.pigeonSex.frame)-1, JScreenWidth-60, 43)];
    [lbv1 setupLabeText:@"羽色"];
    lbv1.textField.delegate = self;
    lbv1.textField.tag = 2;
    [self.view addSubview:lbv1];
    _pigeonFurcolor = lbv1;
    
    JLableAndButtonView *lbv2 = [[JLableAndButtonView alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.pigeonFurcolor.frame)-1, JScreenWidth-60, 43)];
    [lbv2 setupLabeText:@"眼纱"];
    lbv2.textField.delegate = self;
    lbv2.textField.tag = 3;
    [self.view addSubview:lbv2];
    _pigeonEyesand = lbv2;
    
    JLableAndButtonView *lbv3 = [[JLableAndButtonView alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.pigeonEyesand.frame)-1, JScreenWidth-60, 43)];
    [lbv3 setupLabeText:@"血统"];
    lbv3.textField.delegate = self;
    lbv3.textField.tag = 4;
    [self.view addSubview:lbv3];
    _pigeonDescent = lbv3;
    
    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-49-200, self.view.frame.size.width, 200)];
    picker.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    picker.delegate = self;
    picker.dataSource = self;
    picker.showsSelectionIndicator = YES;
    [self.view addSubview:picker];
    self.furcolorPicker = picker;
    [self.furcolorPicker setHidden:YES];
}

- (void)addPigeonDetailToSQLManager
{
    SQLManager *manager =  [SQLManager shareManager];
    NSMutableArray *mutArr = [manager searchAll];
    
    if (!self.pigeonRingNum.text.length) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"环号不能为空" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else if (self.model ==nil ) {
        PigeonDetailModel *newModel = [[PigeonDetailModel alloc]init];
        newModel.pigeonID = mutArr.count + 1;

        newModel.pigeonRingNumber = self.pigeonRingNum.text;
        newModel.pigeonSex = self.pigeonSex.textField.text;
        newModel.pigeonFurcolor = self.pigeonFurcolor.textField.text;
        newModel.pigeonEyesand = self.pigeonEyesand.textField.text;
        newModel.pigeonDescent = self.pigeonDescent.textField.text;
        [self addPigeonModelToWeb:newModel];
        [manager insert:newModel];
//        NSLog(@"加入了新的model：pigeonID:%ld, ringNum:%@, sex:%@, furcolor:%@, eyesand:%@, descent:%@",(long)newModel.pigeonID, newModel.pigeonRingNumber, newModel.pigeonSex, newModel.pigeonFurcolor, newModel.pigeonEyesand, newModel.pigeonDescent);
    }
    else {
        [self deletePigeonModelFromWeb:self.model];
        PigeonDetailModel *newModel = [[PigeonDetailModel alloc]init];
        newModel.pigeonID = self.model.pigeonID;
        newModel.pigeonRingNumber = self.pigeonRingNum.text;
        newModel.pigeonSex = self.pigeonSex.textField.text;
        newModel.pigeonFurcolor = self.pigeonFurcolor.textField.text;
        newModel.pigeonEyesand = self.pigeonEyesand.textField.text;
        newModel.pigeonDescent = self.pigeonDescent.textField.text;
//        NSLog(@"更新了model：pigeonID:%ld, ringNum:%@, sex:%@, furcolor:%@, eyesand:%@, descent:%@",newModel.pigeonID, newModel.pigeonRingNumber, newModel.pigeonSex, newModel.pigeonFurcolor, newModel.pigeonEyesand, newModel.pigeonDescent);
        [self addPigeonModelToWeb:newModel];
        [manager update:newModel];
    }

    [self.navigationController popViewControllerAnimated:YES];
}

/***  添加鸽子信息到网络服务器 ***/
- (void)addPigeonModelToWeb:(PigeonDetailModel*)pigeonDetailModel
{
    NSString *ringNumStr = pigeonDetailModel.pigeonRingNumber;
    NSString *sexStr = pigeonDetailModel.pigeonSex;
    NSString *furcolorStr = pigeonDetailModel.pigeonFurcolor;
    NSString *eyesandStr = pigeonDetailModel.pigeonEyesand;
    NSString *descentStr = pigeonDetailModel.pigeonDescent;
    // 定义web服务器接口,用户帐号／鸽子环号／性别／羽色／眼砂／血统
    NSString *domainStr = [NSString stringWithFormat:@"http://b.airlord.cn:31568/users/addGZH?pid=%@&gzhid=%@&male=%@&cl=%@&sy=%@&xt=%@",globalAccount, ringNumStr, sexStr, furcolorStr, eyesandStr, descentStr];
    
//    NSString *domainStr = [NSString stringWithFormat:@"http://b.airlord.cn:31568/users/addGZH?pid=13611111111&gzhid=12345&male=雌&cl=灰&sy=沙眼@&xt=中国"];
    
    /***  URL地址中含有中文，需对url进行解码！！！！！！！ ***/
    NSString *urlStr = [domainStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLFragmentAllowedCharacterSet]];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:urlStr parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id resultObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"添加信鸽model到web信息:%@",resultObj);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"添加信鸽model到网络服务器失败");
        //        NSLog(@"task:%@",task);
        NSLog(@"error:%@",error);
    }];
}

/***  从网络服务器删除鸽子信息 ***/
- (void)deletePigeonModelFromWeb:(PigeonDetailModel*)pigeonDetailModel
{
    // 定义web服务器接口,用户帐号／鸽子环号／性别／羽色／眼砂／血统
    NSString *domainStr = [NSString stringWithFormat:@"http://b.airlord.cn:31568/users/deleteGZH?pid=%@&gzhid=%@",globalAccount, pigeonDetailModel.pigeonRingNumber];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager GET:domainStr parameters:nil progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        id resultObj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"从服务器删除信鸽信息:%@",resultObj);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"添加设备到网络服务器失败");
        //        NSLog(@"task:%@",task);
        NSLog(@"error:%@",error);
    }];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.furcolorArray = @[@"白", @"灰", @"黑", @"红(绛)", @"花", @"红楞", @"深灰", @"银白", @"雨点", @"灰雨点", @"深雨点", @"灰白条", @"雨白条", @"白条", @"黑白条", @"麒麟花"];
    [self setupViews];
}

//- (void)viewWillDisappear:(BOOL)animated
//{
//    [super viewWillDisappear:animated];
//    // 取消当前的第一相应对象
//    [self.view endEditing:YES];
//    // 将修改 保存 至model对象
//    PigeonDetailModel *model = self.model;
//    model.pigeonRingNumber = self.pigeonRingNum.text;
//    
////    model.pigeonSex = self.pigeonSex.button.titleLabel.text;
////    model.pigeonFurcolor = self.pigeonFurcolor.button.titleLabel.text;
////    model.pigeonEyesand = self.pigeonEyesand.button.titleLabel.text;
////    model.pigeonDescent = self.pigeonDescent.button.titleLabel.text;
//    
////    NSLog(@"self.item:%@",self.item);
////    NSLog(@"itemC:%@",itemC);
//
//}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    PigeonDetailModel *model = self.model;
    self.pigeonRingNum.text = model.pigeonRingNumber;
//    [self.pigeonSex.button setTitle:model.pigeonSex forState:UIControlStateNormal];
//    [self.pigeonFurcolor.button setTitle:model.pigeonFurcolor forState:UIControlStateNormal];
//    [self.pigeonEyesand.button setTitle:model.pigeonEyesand forState:UIControlStateNormal];
//    [self.pigeonDescent.button setTitle:model.pigeonDescent forState:UIControlStateNormal];

    self.pigeonSex.textField.text = model.pigeonSex;
    self.pigeonFurcolor.textField.text = model.pigeonFurcolor;
    self.pigeonEyesand.textField.text = model.pigeonEyesand;
    self.pigeonDescent.textField.text = model.pigeonDescent;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{

    if (textField.tag == 1) {
        [self.pigeonRingNum resignFirstResponder];
        [self.pigeonDescent.textField resignFirstResponder];
        [self.furcolorPicker setHidden:YES];
        [self showSexChoices];
        return NO;
    }
    else if (textField.tag ==2) {
        [self.pigeonRingNum resignFirstResponder];
        [self.pigeonDescent.textField resignFirstResponder];
        [self showFurcolorChoices];
//        [self showFurcolorPicker];
        return NO;
    }
    else if (textField.tag == 3) {
        [self.pigeonRingNum resignFirstResponder];
        [self.pigeonDescent.textField resignFirstResponder];
        [self.furcolorPicker setHidden:YES];
        [self showEyesandChoices];
        return NO;
    }
    else {
        [self.furcolorPicker setHidden:YES];
        return YES;
    }
}

//屏幕上移
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == 4)
    {
        CGRect frame = self.pigeonDescent.frame;
        int offset = frame.origin.y + 60 - (JScreenHeight - 216.0 -60.0);
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        
        float width = self.view.frame.size.width;
        float height = self.view.frame.size.height;
        if (offset > 0) {
            CGRect rect = CGRectMake(0.0f, -offset, width, height); //上推键盘操作，view大小始终没变
            self.view.frame = rect;
        }
        [UIView commitAnimations];
    }
}
// 屏幕恢复
- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 4) {
        NSTimeInterval animationDuration = 0.30f;
        [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
        [UIView setAnimationDuration:animationDuration];
        // 回复屏幕
        self.view.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height);
        [UIView commitAnimations];
    }
}

- (void)showSexChoices
{
    UIAlertController *alerC = [UIAlertController alertControllerWithTitle:@"请选择性别" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    // 添加雌性 按钮
    [alerC addAction:[UIAlertAction actionWithTitle:@"雌" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.pigeonSex.textField.text = @"雌";
//        [self.pigeonSex.button setTitle:@"雌" forState:UIControlStateNormal];
    }]];
    [alerC addAction:[UIAlertAction actionWithTitle:@"雄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.pigeonSex.textField.text = @"雄";
//        [self.pigeonSex.button setTitle:@"雄" forState:UIControlStateNormal];
    }]];
    [alerC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alerC animated:YES completion:nil];
}

- (void)showFurcolorPicker
{
    [self.view endEditing:YES];
    [self.furcolorPicker setHidden:NO];
}

- (void)showEyesandChoices
{
    UIAlertController *alerC = [UIAlertController alertControllerWithTitle:@"请选择眼砂" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    // 添加雌性 按钮
    [alerC addAction:[UIAlertAction actionWithTitle:@"黄眼" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.pigeonEyesand.textField.text = @"黄眼";
    }]];
    [alerC addAction:[UIAlertAction actionWithTitle:@"沙眼" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.pigeonEyesand.textField.text = @"砂眼";
    }]];
    [alerC addAction:[UIAlertAction actionWithTitle:@"牛眼" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.pigeonEyesand.textField.text = @"牛眼";
    }]];
    [alerC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alerC animated:YES completion:nil];
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

#pragma mark - UIPickerViewDelegate
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.furcolorArray objectAtIndex:row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.pigeonFurcolor.textField.text = [self.furcolorArray objectAtIndex:row];
}
#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.furcolorArray.count;
}

- (void)showFurcolorChoices
{
    UIAlertController *alerC = [UIAlertController alertControllerWithTitle:@"请选择羽色" message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    // 添加雌性 按钮
    [alerC addAction:[UIAlertAction actionWithTitle:@"白" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.pigeonFurcolor.textField.text = @"白";
    }]];
    [alerC addAction:[UIAlertAction actionWithTitle:@"灰" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.pigeonFurcolor.textField.text = @"灰";
    }]];
    [alerC addAction:[UIAlertAction actionWithTitle:@"黑" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.pigeonFurcolor.textField.text = @"黑";
    }]];
    [alerC addAction:[UIAlertAction actionWithTitle:@"红(绛)" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.pigeonFurcolor.textField.text = @"红(绛)";
    }]];
    [alerC addAction:[UIAlertAction actionWithTitle:@"花" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.pigeonFurcolor.textField.text = @"花";
    }]];
    [alerC addAction:[UIAlertAction actionWithTitle:@"红楞" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.pigeonFurcolor.textField.text = @"红楞";
    }]];
    [alerC addAction:[UIAlertAction actionWithTitle:@"深灰" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.pigeonFurcolor.textField.text = @"深灰";
    }]];
    [alerC addAction:[UIAlertAction actionWithTitle:@"银白" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.pigeonFurcolor.textField.text = @"银白";
    }]];
    [alerC addAction:[UIAlertAction actionWithTitle:@"雨点" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.pigeonFurcolor.textField.text = @"雨点";
    }]];
    [alerC addAction:[UIAlertAction actionWithTitle:@"灰雨点" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.pigeonFurcolor.textField.text = @"灰雨点";
    }]];
    [alerC addAction:[UIAlertAction actionWithTitle:@"深雨点" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.pigeonFurcolor.textField.text = @"深雨点";
    }]];
    [alerC addAction:[UIAlertAction actionWithTitle:@"灰白条" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.pigeonFurcolor.textField.text = @"灰白条";
    }]];
    [alerC addAction:[UIAlertAction actionWithTitle:@"雨白条" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.pigeonFurcolor.textField.text = @"雨白条";
    }]];
    [alerC addAction:[UIAlertAction actionWithTitle:@"白条" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.pigeonFurcolor.textField.text = @"白条";
    }]];
    [alerC addAction:[UIAlertAction actionWithTitle:@"黑白条" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.pigeonFurcolor.textField.text = @"黑白条";
    }]];
    [alerC addAction:[UIAlertAction actionWithTitle:@"麒麟花" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.pigeonFurcolor.textField.text = @"麒麟花";
    }]];
    [alerC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alerC animated:YES completion:nil];
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
