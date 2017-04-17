//
//  MyDevicesViewController.m
//  SkyRoad
//
//  Created by alan on 17/3/24.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import "MyDevicesViewController.h"
#import "DeviceSQLManager.h"
#import "DeviceDetailModel.h"
#import "ScanDeviceViewController.h"
#import "TypingDeviceViewController.h"

@interface MyDevicesViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_mainTableView;
    NSMutableArray *_deviceGroup;
    DeviceSQLManager *_mainManager;
}
@property (nonatomic, strong) NSMutableArray *cells;
@property (nonatomic, copy) NSArray *cellIcons;

@end

@implementation MyDevicesViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.navigationItem.title = @"我的设备";
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
        self.navigationItem.backBarButtonItem = backItem;
        
        [self initCells];
    }
    return self;
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)initCells
{
    _cells = [[NSMutableArray alloc]init];
    NSArray *titles0 = @[@"扫一扫",
                         @"手动添加"
                         ];
    [_cells addObject:titles0];
    
    _deviceGroup = [[NSMutableArray alloc]init];
    DeviceSQLManager *manager = [DeviceSQLManager shareManager];
    _mainManager = manager;
    
    _deviceGroup = [_mainManager searchAll];
    [_cells addObject:_deviceGroup];
    
    NSArray *Icons = @[@"Track_AddD_Scan",@"Track_AddD_Typing"];
    _cellIcons = [[NSMutableArray alloc]init];
    _cellIcons = Icons;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _mainTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _mainTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _mainTableView.sectionHeaderHeight = 5;
    _mainTableView.sectionFooterHeight = 0;
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    [self.view addSubview:_mainTableView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [_mainTableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 1) {
        // 获取所选行的数据源
        NSArray *modelArr = _cells[indexPath.section];
        DeviceDetailModel *selectedModel = modelArr[indexPath.row];
        // 把数据源赋值给pdvc的model
        UIAlertController *alertC0 = [UIAlertController alertControllerWithTitle:@"更改脚环设备号" message:nil preferredStyle:UIAlertControllerStyleAlert];
        [alertC0 addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.keyboardType = UIKeyboardTypeNumberPad;
            textField.text = selectedModel.deviceNum;
        }];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            UITextField *txtF = alertC0.textFields.firstObject;
            selectedModel.deviceNum = txtF.text;
            [_mainManager update:selectedModel];
            [self initCells];
            [_mainTableView reloadData];
        }];
        [alertC0 addAction:okAction];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alertC0 addAction:cancelAction];
        [self presentViewController:alertC0 animated:YES completion:nil];
        
    } else if (indexPath.section == 0)
    {
        if (indexPath.row == 0) {
            ScanDeviceViewController *sdvc0 = [[ScanDeviceViewController alloc]init];
            sdvc0.view.backgroundColor = [UIColor whiteColor];
            [self.navigationController pushViewController:sdvc0 animated:YES];
        } else {
            
            UIAlertController *alertC = [UIAlertController alertControllerWithTitle:@"输入脚环设备号" message:nil preferredStyle:UIAlertControllerStyleAlert];
            [alertC addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = @"请输设备号";
                textField.keyboardType = UIKeyboardTypeNumberPad;
            }];
            // 按钮按下时，读取文本框的值，存到数据库中
            UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                UITextField *txtF = alertC.textFields.firstObject;
                DeviceDetailModel *model = [[DeviceDetailModel alloc]init];
                NSMutableArray *arr = [_mainManager searchAll];
                if ([[txtF.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length] == 0) {
                    NSLog(@"没输入设备号");
                    return;
                } else {
                    model.deviceNum = txtF.text;
                    model.deviceId = [arr count]+1;
                    [_mainManager insert:model];
                    [self initCells];
                    [_mainTableView reloadData];
                    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
                }
            }];
            
            [alertC addAction:okAction];
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
            [alertC addAction:cancelAction];
            [self presentViewController:alertC animated:YES completion:nil];
        }
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
        id subCell = subArr[indexPath.row];
        cell.textLabel.text =[(DeviceDetailModel *)subCell deviceNum];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1 ) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            NSMutableArray *subArr = _cells[indexPath.section];
            id subcell = subArr[indexPath.row];
            [subArr removeObject:subcell];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [_mainManager deleteWithName:(DeviceDetailModel *)subcell];
            
            if (subArr.count == 0) {
                [_cells removeObject:subArr];
                [tableView reloadData];
            }
        }
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
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
