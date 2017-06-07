//
//  AboutViewController.m
//  SkyRoad
//
//  Created by alan on 2017/4/25.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import "AboutViewController.h"

#define bgColor [UIColor colorWithRed:239/255.0 green:239/255.0 blue:244/255.0 alpha:1]

@interface AboutViewController () <UITableViewDelegate, UITableViewDataSource>

{
    UITableView *_tableView;
    NSMutableArray *_titleGroups;
    NSMutableArray *_classGroups;
}
@end

@implementation AboutViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"关于";
        
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
    
    NSArray *titles0 = @[@"相关介绍",
                     @"检查更新",
                     @"反馈与帮助"];
    [_titleGroups addObject:titles0];
    
    NSArray *classNames0 = @[@"VersionDescriptionViewController",
                    @"UpdateCheckViewController",
                     @"FeedbackAndHelpViewController"];
    [_classGroups addObject:classNames0];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self tableDataInit];
    
    _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    _tableView.sectionHeaderHeight = 15;
    _tableView.sectionFooterHeight = 0;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    UIView *imview = [[[NSBundle mainBundle] loadNibNamed:@"AboutLogo" owner:nil options:nil] lastObject];
    _tableView.tableHeaderView = imview;
    [self.view addSubview:_tableView];
}

#pragma mark - tableView delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section == 0 && indexPath.row == 1) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"此版本已经为最新版本" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"我知道了" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:okAction];
        [self presentViewController:alert animated:YES completion:nil];
    }
    else
    {
        NSArray *classSubArr = [[NSArray alloc]init];
        classSubArr = _classGroups[indexPath.section];
        NSString *className = classSubArr[indexPath.row];
        UIViewController *subVC = [[NSClassFromString(className) alloc] init];
        subVC.view.backgroundColor = bgColor;
        [self.navigationController pushViewController:subVC animated:YES];
    }
}

#pragma mark - tableView DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return _titleGroups.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *subArr = [[NSArray alloc]init];
    subArr = _titleGroups[section];
    return subArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellID = @"cellIdentifier";
    UITableViewCell *cell;
    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;

    }
    NSArray *subArr = [[NSArray alloc]init];
    subArr = _titleGroups[indexPath.section];
    NSString *str = subArr[indexPath.row];
    cell.textLabel.text = str;
    
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
