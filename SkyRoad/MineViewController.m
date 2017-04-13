//
//  MineViewController.m
//  SkyRoad
//
//  Created by alan on 17/3/22.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import "MineViewController.h"
#import "NickNameViewController.h"
#import "FeedYearsViewController.h"

#define JScreenWidth [[UIScreen mainScreen]bounds].size.width
#define JScreenHeight [[UIScreen mainScreen]bounds].size.height

@interface MineViewController () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_mainTableView;
    NSMutableArray *_titleGroups;
    NSMutableArray *_classNameGroup;
    NSMutableArray *_imageGroup;
    NSMutableArray *_detailGroup;
}

@end

@implementation MineViewController

NSString *nickName;
NSString *feedYears;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        [[UINavigationBar appearance] setBackgroundImage:[UIImage imageNamed:@"Mine_background0"] forBarMetrics:UIBarMetricsDefault];
        
        self.tabBarItem.title = @"我的";
        UIImage *i = [UIImage imageNamed:@"Mine_BarItem.png"];
        self.tabBarItem.image = i;
        
        UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"" style:UIBarButtonItemStylePlain target:self action:@selector(backAction)];
        self.navigationItem.backBarButtonItem = backItem;
    }
    
    self.navigationItem.title = @"我";
    
    return self;
}

- (void)backAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            NickNameViewController *nnvc = [[NickNameViewController alloc]init];
            nnvc.view.backgroundColor = [UIColor whiteColor];
            nnvc.valueBlock = ^(NSString *nickNameTxt) {
                nickName = nickNameTxt;
                NSLog(@"传回来的nickName：%@",nickName);
            };
            nnvc.sub_nickName = nickName;
            [self.navigationController pushViewController:nnvc animated:YES];
        } else {
            FeedYearsViewController *fyvc = [[FeedYearsViewController alloc]init];
            fyvc.view.backgroundColor = [UIColor whiteColor];
            fyvc.valueBlock = ^(NSString *feedYearTxt) {
                feedYears = feedYearTxt;
            };
            [self.navigationController pushViewController:fyvc animated:YES];
        }
    } else {
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
    static NSString *cellIdentifier = @"cellIdentifier5";
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    // 如果缓存池没有取到则重新创建并放到缓存池中
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    NSArray *subArr = [[NSArray alloc]init];
    subArr = _titleGroups[indexPath.section];
    NSString *str = subArr[indexPath.row];
    cell.textLabel.text = str;
        
    NSArray *subImageArr = [[NSArray alloc]init];
    subImageArr = _imageGroup[indexPath.section];
    NSString *imageStr = subImageArr[indexPath.row];
    cell.imageView.image = [UIImage imageNamed:imageStr];
    
    if (indexPath.section == 0) {
        if(indexPath.row == 0) {
            cell.detailTextLabel.text = nickName;
        } else {
            cell.detailTextLabel.text = feedYears;
        }
    };
    return cell;
}

- (void)initTitlesAndClassNameGroup
{
    _titleGroups = [[NSMutableArray alloc]init];
    // 表格标签title
    NSArray *titles0 = @[@"昵称",
                        @"养殖鸽龄",
                        ];
    [_titleGroups addObject:titles0];
    
    NSArray *titles1 = @[@"我的信鸽",
                        @"我的设备",
                        @"我的社区"];
    [_titleGroups addObject:titles1];

    NSArray *titles2 = @[@"设置"];
    [_titleGroups addObject:titles2];
    
    _classNameGroup = [[NSMutableArray alloc]init];
    NSArray *classNames0 = @[@"NickNameViewController",
                             @"FeedYearsViewController",
                             ];
    [_classNameGroup addObject:classNames0];
    
    NSArray *classNames1 = @[@"MyPigeonsViewController",
                             @"MyDevicesViewController",
                             @"MyCommunityViewController"
                             ];
    [_classNameGroup addObject:classNames1];
    
    NSArray *classNames2 = @[@"SettingViewController"];
    [_classNameGroup addObject:classNames2];
    
    _imageGroup = [[NSMutableArray alloc]init];
    NSArray *image0 = @[@"Mine_Nickname",
                        @"Mine_FeedYear",
                        ];
    [_imageGroup addObject:image0];
    
    NSArray *image1 = @[@"Mine_Pigeon",
                        @"Mine_Device",
                        @"Mine_Community"
                        ];
    [_imageGroup addObject:image1];
    
    NSArray *image2 = @[@"Mine_Setting"];
    [_imageGroup addObject:image2];

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

-(void)viewWillAppear:(BOOL)animated
{
    [_mainTableView reloadData];
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
