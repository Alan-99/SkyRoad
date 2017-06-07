//
//  AddWebDeviceViewController.m
//  SkyRoad
//
//  Created by alan on 2017/5/4.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import "AddWebDeviceViewController.h"
#import "DeviceSQLManager.h"
#import "DeviceDetailModel.h"

#import "QRCodeReaderViewController.h"
#import "QRCodeReader.h"

@interface AddWebDeviceViewController () <UITableViewDelegate, UITableViewDataSource, QRCodeReaderDelegate>
{
    UITableView *_mainTableView;
    NSMutableArray *_deviceGroup;
    
}
@property (nonatomic, strong) NSMutableArray *cells;
@property (nonatomic, copy) NSArray *cellIcons;
@property (nonatomic, copy) NSArray *webDevArr;

@end

@implementation AddWebDeviceViewController

/***  从api获取用户所拥有的设备号  ***/
- (void)getDevsFromApiAccountEqualsTo:(NSString*)account
{
    self.webDevArr = [[NSMutableArray alloc]init];
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

            id obj = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            long objCount = [(NSArray*)obj count];
            NSLog(@"obj:%@",obj);
            for (int i=0; i < objCount; i++) {
                NSDictionary *devDic = [(NSArray *)obj objectAtIndex:i];
                NSString *devStr = [(NSDictionary *)devDic objectForKey:@"sbid"];
                NSString *filterDevStr = [devStr substringFromIndex:2];
                NSLog(@"filterDevStr:%@",filterDevStr);
                [devArr0 addObject:filterDevStr];
            }
            self.webDevArr = devArr0;
            [_cells addObject:self.webDevArr];
            [_mainTableView reloadData];
        }
    }];
    
    [dataTask resume];
}

- (void)initCells
{
    _cells = [[NSMutableArray alloc]init];
    NSArray *titles0 = @[@"扫一扫",
                         @"手动添加"
                         ];
    [_cells addObject:titles0];
//    [_cells addObject:self.webDevArr];
    
    NSArray *Icons = @[@"Track_AddD_Scan",@"Track_AddD_Typing"];
    _cellIcons = [[NSMutableArray alloc]init];
    _cellIcons = Icons;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self getDevsFromApiAccountEqualsTo:@"13611111111"];
    [self initCells];
    
    _mainTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _mainTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    [self.view addSubview:_mainTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mainTableView reloadData];
}

#pragma mark - Table View Delegate
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//    if (indexPath.section == 1) {
//        // 获取所选行的数据源
//        NSArray *modelArr = _cells[indexPath.section];
//        DeviceDetailModel *selectedModel = modelArr[indexPath.row];
//        // 把数据源赋值给pdvc的model
//        UIAlertController *alertC0 = [UIAlertController alertControllerWithTitle:@"更改脚环设备号" message:nil preferredStyle:UIAlertControllerStyleAlert];
//        [alertC0 addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//            textField.keyboardType = UIKeyboardTypeNumberPad;
//            textField.text = selectedModel.deviceNum;
//        }];
//        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//            UITextField *txtF = alertC0.textFields.firstObject;
//            selectedModel.deviceNum = txtF.text;
//            [self initCells];
//            [_mainTableView reloadData];
//        }];
//        [alertC0 addAction:okAction];
//        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//        [alertC0 addAction:cancelAction];
//        [self presentViewController:alertC0 animated:YES completion:nil];
//        
//    }
//    else if (indexPath.section == 0){
//        if (indexPath.row == 0) {
//            [self initScanView];
//        }
//        else {
//            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"输入脚环设备号" message:nil preferredStyle:UIAlertControllerStyleAlert];
//            [alertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
//                textField.placeholder = @"请输设备号";
//                textField.keyboardType = UIKeyboardTypeNumberPad;
//            }];
//            // 按钮按下时，读取文本框的值，存到数据库中
//            UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
//                UITextField *txtF = alertC.textFields.firstObject;
//                DeviceDetailModel *model = [[DeviceDetailModel alloc]init];
//                if ([[txtF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
//                    NSLog(@"没输入设备号");
//                    return;
//                } else {
//                    model.deviceNum = txtF.text;
//                    [self initCells];
//                    [_mainTableView reloadData];
//                    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
//                }
//            }];
//            
//            [alertC addAction:okAction];
//            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
//            [alertC addAction:cancelAction];
//            [self presentViewController:alertC animated:YES completion:nil];
//        }
//    }
//}


- (void)initScanView
{
    if ([QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]]) {
        static QRCodeReaderViewController *vc = nil;
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
            vc = [QRCodeReaderViewController readerWithCancelButtonTitle:@"Cancel" codeReader:reader startScanningAtLoad:YES showSwitchCameraButton:NO showTorchButton:NO];
            vc.modalPresentationStyle = UIModalPresentationFormSheet;
        });
        vc.delegate = self;
        [vc setCompletionWithBlock:^(NSString *resultAsString) {
            NSLog(@"Completion with result: %@", resultAsString);
        }];
        [self presentViewController:vc animated:YES completion:NULL];
    }
    else {
        UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"Error" message:@"Reader not supported by the current device" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertC addAction:cancelAction];
        [self presentViewController:alertC animated:YES completion:nil];
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.cells.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *subArr = [[NSArray alloc]init];
    subArr = self.cells[section];
    return subArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 此方法调用十分频繁，cell的标示声明为静态变量有利于性能优化
    static NSString *cellIdentifier0 = @"cellIdentifierKey0";
    static NSString *cellIdentifier1 = @"cellIdentifierKey1";
    
    UITableViewCell *cell;
    // 首先根据标示去缓存池取
    
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier0];
        
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier1];
    }
    
    // 如果缓存池没有取到则重新创建并放到缓存池中
    if (!cell) {
        if (indexPath.section == 0) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier0];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        } else {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier1];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    if (indexPath.section == 0) {
        NSArray *subArr = _cells[indexPath.section];
        NSString *subStr = subArr[indexPath.row];
        cell.textLabel.text = subStr;
        
        NSString *iconStr = _cellIcons[indexPath.row];
        cell.imageView.image = [UIImage imageNamed:iconStr];
        
    } else {
        NSArray *subArr = _cells[indexPath.section];
        NSString *subStr = subArr[indexPath.row];
        cell.textLabel.text = subStr;
    }
    
    return cell;
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
