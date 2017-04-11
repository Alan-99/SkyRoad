//
//  addDeviceViewController.m
//  SkyRoad
//
//  Created by alan on 17/3/29.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import "addDeviceViewController.h"
#import "DeviceSQLManager.h"
#import "DeviceDetailModel.h"
#import "DeviceDetailViewController.h"

@interface addDeviceViewController () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_mainTableView;
    NSMutableArray *_deviceGroup;
}

@property (nonatomic, strong) NSMutableArray *cells;

@end

@implementation addDeviceViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // 导航栏右侧button为系统自带add button
//        UIBarButtonItem *bbi = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addDevice)];
//        self.navigationItem.rightBarButtonItem = bbi;
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
        self.navigationItem.backBarButtonItem = backItem;
    }
    return self;
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
    _deviceGroup = [manager searchAll];
    [_cells addObject:_deviceGroup];
    
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _mainTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _mainTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _mainTableView.sectionHeaderHeight = 15;
    _mainTableView.sectionFooterHeight = 0;
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    [self.view addSubview:_mainTableView];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initCells];
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
//        NSArray *modelArr = _cells[indexPath.section];
//        DeviceDetailModel *selectedModel = modelArr[indexPath.row];
        // 把数据源赋值给pdvc的model
        DeviceDetailViewController *pdvc0 = [[DeviceDetailViewController alloc]init];
//        pdvc0.model = selectedModel;
        pdvc0.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:pdvc0 animated:YES];
    } else {
        DeviceDetailViewController *pdvc = [[DeviceDetailViewController alloc]init];
        pdvc.view.backgroundColor = [UIColor whiteColor];

        [self.navigationController pushViewController:pdvc animated:YES];
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
    } else {
        NSArray *subArr = _cells[indexPath.section];
        id subCell = subArr[indexPath.row];
        cell.textLabel.text =[(DeviceDetailModel *)subCell deviceNum];
        NSLog(@"cell2:%@",cell);
    }
    
    return cell;
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
