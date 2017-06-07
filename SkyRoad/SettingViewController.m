//
//  SettingViewController.m
//  SkyRoad
//
//  Created by alan on 17/3/24.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import "SettingViewController.h"
#import "DeviceSQLManager.h"
#import "SQLManager.h"

@interface SettingViewController () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_tableView;
    NSMutableArray *_titleGroups;
    NSMutableArray *_classGroups;
    DeviceSQLManager *_deleteDevManager;
    SQLManager *_deletePegionManager;
    
}

@end

@implementation SettingViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"设置";
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
        self.navigationItem.backBarButtonItem = backItem;
    }
    return self;
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tableDataInit
{
    _titleGroups = [[NSMutableArray alloc]init];
    _classGroups = [[NSMutableArray alloc]init];
    
    NSArray *titles0 = @[@"修改密码",
                         @"关于"];
    [_titleGroups addObject:titles0];
    NSArray *titles1 = @[@"退出当前帐号"];
    [_titleGroups addObject:titles1];
    
    NSArray *classNames0 = @[@"CreatNewPSWViewController",
                            @"AboutViewController"];
    [_classGroups addObject:classNames0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self tableDataInit];
    
    DeviceSQLManager *manager = [DeviceSQLManager shareManager];
    _deleteDevManager = manager;
    SQLManager *manager1 = [SQLManager shareManager];
    _deletePegionManager = manager1;
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _tableView.sectionHeaderHeight = 15;
    _tableView.sectionFooterHeight = 0;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 从子视图回来后表格为非选中状态
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 1)
    {
//        [_deleteDevManager deleteAll];
//        [_deletePegionManager deleteAll];
        /***  self --> parentVC: MineViewController --> parentVC: rootTabBarVC -->dismiss -->loginVC ***/
        [self.parentViewController.parentViewController dismissViewControllerAnimated:YES completion:nil];
    }
    else {
        NSArray *subClassGroup = [[NSArray alloc]init];
        subClassGroup = _classGroups[indexPath.section];
        NSString *className = subClassGroup[indexPath.row];
        UIViewController *subVC = [[NSClassFromString(className) alloc] init];
        subVC.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:subVC animated:YES];
    }
}

#pragma mark - tableView datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _titleGroups.count   ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *subTitleArr = [[NSArray alloc]init];
    subTitleArr = _titleGroups[section];
    return subTitleArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"cellIdentifier";
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
    }
    if (indexPath.section == 0) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSArray *subTitlesArr = [[NSArray alloc]init];
    subTitlesArr = _titleGroups[indexPath.section];
    NSString *str = subTitlesArr[indexPath.row];
    cell.textLabel.text = str;
    
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 更改表头视图的高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 8.0f;
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
