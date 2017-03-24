//
//  MineViewController.m
//  SkyRoad
//
//  Created by alan on 17/3/22.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import "MineViewController.h"

#define JScreenWidth [[UIScreen mainScreen]bounds].size.width
#define JScreenHeight [[UIScreen mainScreen]bounds].size.height

@interface MineViewController () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_mainTableView;
    NSMutableArray *_titleGroups;
    NSMutableArray *_classNameGroup;
}

@end

@implementation MineViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.tabBarItem.title = @"我的";
        UIImage *i = [UIImage imageNamed:@"Mine_BarItem.png"];
        self.tabBarItem.image = i;
    }
    
    self.navigationItem.title = @"我";
    
    return self;
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *subClassGroup = [[NSArray alloc]init];
    subClassGroup = _classNameGroup[indexPath.section];
    NSString *className = subClassGroup[indexPath.row];
    
    // push出子viewController
    UIViewController *subViewController = [[NSClassFromString(className) alloc] init];
    // 把子ViewController的背景色改成白色，其默认色为透明色，弹出时就不会出现卡顿的感觉了
    // UITableView是有默认颜色的，从默认颜色跳转到透明色，当然会有卡顿的感觉
    subViewController.view.backgroundColor = [UIColor whiteColor];
    
    [self.navigationController pushViewController:subViewController animated:YES];
}

#pragma mark - tableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _titleGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *subTitleGroup = [[NSArray alloc]init];
    subTitleGroup = _titleGroups[section];
    return subTitleGroup.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"cellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        NSArray *subTitleGroup = [[NSArray alloc]init];
        subTitleGroup = _titleGroups[indexPath.section];
        cell.textLabel.text = subTitleGroup[indexPath.row];
    }
    return cell;
}

- (void)initTitlesAndClassNameGroup
{
    _titleGroups = [[NSMutableArray alloc]init];
    // 表格标签title
    NSArray *titles0 = @[@"昵称",
                        @"养殖鸽龄",
                        @"荣誉"];
    [_titleGroups addObject:titles0];
    
    NSArray *titles1 = @[@"我的鸽子",
                        @"我的设备"];
    [_titleGroups addObject:titles1];

    NSArray *titles2 = @[@"设置"];
    [_titleGroups addObject:titles2];
    
    _classNameGroup = [[NSMutableArray alloc]init];
    NSArray *classNames0 = @[@"NickNameViewController",
                             @"FeedYearsViewController",
                             @"GloriesViewController"
                             ];
    [_classNameGroup addObject:classNames0];
    
    NSArray *classNames1 = @[@"MyPigeonsViewController",
                             @"MyDevicesViewController"
                             ];
    [_classNameGroup addObject:classNames1];
    
    NSArray *classNames2 = @[@"SettingViewController"];
    [_classNameGroup addObject:classNames2];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initTitlesAndClassNameGroup];
    
    _mainTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
//    _mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 100, 370, 400) style:UITableViewStyleGrouped];
    _mainTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _mainTableView.sectionHeaderHeight = 15;
    _mainTableView.sectionFooterHeight = 0;
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    UIView *imview = [[[NSBundle mainBundle] loadNibNamed:@"MineLogo" owner:nil options:nil] lastObject];
    _mainTableView.tableHeaderView = imview;
    
    [self.view addSubview:_mainTableView];
    
    // Do any additional setup after loading the view from its nib.
}

//- (void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];
//    
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlackTranslucent;
//    self.navigationController.navigationBar.translucent = YES;
//    
//    [self.navigationController setToolbarHidden:YES animated:animated];
//}

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
