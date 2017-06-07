//
//  MyPigeonsViewController.m
//  SkyRoad
//
//  Created by alan on 17/3/24.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import "MyPigeonsViewController.h"
#import "PigeonDetailModel.h"
#import "PigeonDetailViewController.h"
#import "SQLManager.h"
#import "AFNetworking.h"

#define JNavBarH 64
#define JScreenWidth [[UIScreen mainScreen]bounds].size.width
#define JScreenHeight [[UIScreen mainScreen]bounds].size.height

@interface MyPigeonsViewController ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_mainTableView;
    // 已添加鸽子的集合
    NSMutableArray *_pigeonGroup;
    SQLManager *_mainManager;
}
@property (nonatomic, strong) NSMutableArray *cells;

@end

@implementation MyPigeonsViewController

// 获取全局变量,即账号信息
extern NSString* globalAccount;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.navigationItem.title = @"我的信鸽";
    }
    return self;
}

- (void)initCells
{
    _cells = [[NSMutableArray alloc]init];
        NSArray *titles0 = @[@"添加信鸽"];
    [_cells addObject:titles0];
    
    _pigeonGroup = [[NSMutableArray alloc]init];
    _pigeonGroup = [_mainManager searchAll];
    [_cells addObject:_pigeonGroup];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    SQLManager *manager = [SQLManager shareManager];
    _mainManager = manager;
    [self initCells];
    _mainTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _mainTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _mainTableView.sectionHeaderHeight = 5;
    _mainTableView.sectionFooterHeight = 0;
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    [self.view addSubview:_mainTableView];
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
        NSLog(@"删除信鸽model信息：%@",resultObj);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"从网络服务器删除信鸽model失败");
        NSLog(@"error:%@",error);
    }];
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
        NSArray *modelArr = _cells[indexPath.section];
        PigeonDetailModel *selectedModel = modelArr[indexPath.row];
        // 把数据源赋值给pdvc的model
        PigeonDetailViewController *pdvc0 = [[PigeonDetailViewController alloc]init];
        pdvc0.model = selectedModel;
        pdvc0.view.backgroundColor = [UIColor whiteColor];
        [self.navigationController pushViewController:pdvc0 animated:YES];
    } else {
        PigeonDetailViewController *pdvc = [[PigeonDetailViewController alloc]init];
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
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:cellIdentifier1];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
    }
    
    if (indexPath.section == 0) {
        cell.textLabel.text = @"添加信鸽";
    } else {
        NSArray *subArr = _cells[indexPath.section];
        id subCell = subArr[indexPath.row];
        cell.textLabel.text = [NSString stringWithFormat:@"身份环:%@",[(PigeonDetailModel *)subCell pigeonRingNumber]];
        NSString *sexTxt = [(PigeonDetailModel *)subCell pigeonSex];
        NSString *furcolorTxt = [(PigeonDetailModel *)subCell pigeonFurcolor];
        NSString *eyesandTxt = [(PigeonDetailModel *)subCell pigeonEyesand];
        NSString *descentTxt = [(PigeonDetailModel *)subCell pigeonDescent];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@",sexTxt,furcolorTxt,eyesandTxt,descentTxt];
        
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if(indexPath.section == 1) {
        if (editingStyle == UITableViewCellEditingStyleDelete) {
            NSMutableArray *subArr = _cells[indexPath.section];
            id subCell = subArr[indexPath.row];
            [subArr removeObject:subCell];
            
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [self deletePigeonModelFromWeb:(PigeonDetailModel *)subCell];
            [_mainManager deleteWithRingNum:subCell];
            if( subArr.count == 0) {
                [_cells removeObject:subArr];
                [tableView reloadData];
            }
        }
    }
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
