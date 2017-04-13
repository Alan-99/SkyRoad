//
//  AddPigeonViewController.m
//  SkyRoad
//
//  Created by alan on 17/3/30.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import "AddPigeonViewController.h"
#import "PigeonDetailModel.h"
#import "PigeonDetailViewController.h"
#import "SQLManager.h"

// 宏定义-导航栏的高度 - 为啥是0？
//#define JNavBarH self.navigationController.navigationBar.frame.size.height

#define JNavBarH 64
#define JScreenWidth [[UIScreen mainScreen]bounds].size.width
#define JScreenHeight [[UIScreen mainScreen]bounds].size.height

@interface AddPigeonViewController () <UITableViewDelegate, UITableViewDataSource>
{
    UITableView *_mainTableView;
    // 已添加鸽子的集合
    NSMutableArray *_pigeonGroup;
    SQLManager *_mainManager;
}

@property (nonatomic, strong) NSMutableArray *cells;

@end

@implementation AddPigeonViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
//        // 导航栏右侧button为系统自带add button
//        UIBarButtonItem *bbi = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPigeonDetail)];
//        self.navigationItem.rightBarButtonItem = bbi;
    }
    return self;
}

- (void)initCells
{
    _cells = [[NSMutableArray alloc]init];
    
    NSArray *titles0 = @[@"添加信鸽"];
    [_cells addObject:titles0];
    
    _pigeonGroup = [[NSMutableArray alloc]init];
    SQLManager *manager = [SQLManager shareManager];
    _mainManager = manager;
    _pigeonGroup = [_mainManager searchAll];
    [_cells addObject:_pigeonGroup];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initCells];
//    [self initAddPigeonBtn];
    
    _mainTableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _mainTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _mainTableView.sectionHeaderHeight = 40;
    _mainTableView.sectionFooterHeight = 30;
    _mainTableView.delegate = self;
    _mainTableView.dataSource = self;
    [self.view addSubview:_mainTableView];
    
//    // 通过向UITableView注册UITableViewCell的类来使用UITableViewCell
    
//    // 通过NIB文件加载UITableViewCell,需要注册相应的NIB文件
//    // 创建UINib对象，该对象代表包含了ItemCell的NIB文件
//    // 在UITableView对象中注册了包含ItemCell.xib的UINib对象之后，UITableView对象就可以通过 ItemCell 键找到并加载ItemCell对象
//    UINib *nib = [UINib nibWithNibName:@"ItemCell" bundle:nil];
//    // 通过UINib对象注册对应的NIB文件
//    [self.tableView registerNib:nib forCellReuseIdentifier:@"ItemCell"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    _pigeonGroup = [[NSMutableArray alloc]init];
//    SQLManager *manager = [SQLManager shareManager];
//    _pigeonGroup = [manager searchAll];
    NSLog(@"addPigeonViewWillAppear");
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
//        pdvc.valueBlock = ^(SQLManager *manager) {
//            _mainManager = manager;
//        };
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
        cell.textLabel.text = @"请添加信鸽";
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
            
//            SQLManager *manager = [SQLManager shareManager];
            [_mainManager deleteWithRingNum:subCell];
            
            if( subArr.count == 0) {
                [_cells removeObject:subArr];
                [tableView reloadData];
            }
        }
    }

}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        if ([[_mainManager searchAll] count] != 0) {
            return @"已添加的信鸽";
        }
        return nil;
    } else {
        return nil;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}

//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath
//{
//    [[ItemStore sharedStore] moveItemAtIndex:sourceIndexPath.row toIndex:destinationIndexPath.row];
//}



/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
