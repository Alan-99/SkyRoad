//
//  InitRouteViewController.m
//  SkyRoad
//
//  Created by alan on 2017/5/9.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import "InitRouteViewController.h"
#import "JPOISearchView.h"
#import "ErrorInfoUtility.h"

#define JScreenWidth [[UIScreen mainScreen]bounds].size.width
#define JScreenHeight [[UIScreen mainScreen]bounds].size.height

@interface InitRouteViewController () <UITextFieldDelegate, AMapSearchDelegate, UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) AMapSearchAPI *search;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *tips;



@end

static NSInteger textFieldTag;

@implementation InitRouteViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title = @"路线";
        // 自定义rightItem
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(startPOISearch)];
        self.tips = [NSMutableArray array];
    }
    return self;
}

- (void)startPOISearch
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupViews
{
    JPOISearchView *view0 = [[JPOISearchView alloc]initWithFrame:CGRectMake(30, 84, JScreenWidth-90, 43)];
    view0.layer.borderColor = [UIColor blackColor].CGColor;
    view0.layer.borderWidth = 0.8f;
    [view0 setupLabeText:@"从" textFieldPlaceholder:@"输入起点"];
    view0.textField.delegate = self;
    view0.textField.tag = 1;
    [self.view addSubview:view0];
    _routeStartView = view0;
    [self.routeStartView.textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    
    JPOISearchView *view1 = [[JPOISearchView alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(self.routeStartView.frame)+5, JScreenWidth-90, 43)];
    view1.layer.borderColor = [UIColor blackColor].CGColor;
    view1.layer.borderWidth = 0.8f;
    [view1 setupLabeText:@"到" textFieldPlaceholder:@"输入终点"];
    view1.textField.delegate = self;
    view1.textField.tag = 2;
    [self.view addSubview:view1];
    _routeEndView = view1;
    [self.routeEndView.textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    
    UIButton *Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    Btn.frame = CGRectMake(JScreenWidth-50, CGRectGetMinY(self.routeStartView.frame)/2 + CGRectGetMaxY(self.routeEndView.frame)/2 - 15, 30, 30);
//    Btn.backgroundColor = JbtnColor;
    [Btn setImage:[UIImage imageNamed:@"Track_routeBtn2"] forState:UIControlStateNormal];
    [Btn addTarget:self action:@selector(exchangeDirection) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:Btn];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.search = [[AMapSearchAPI alloc]init];
    self.search.delegate = self;
    [self setupViews];
    [self initTableView];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    _search.delegate = self;
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (self.tipsBlock != nil ) {
        if (!self.routeStartView.textField.text.length) {
            self.routeStartTip = nil;
        }
        if (!self.routeEndView.textField.text.length) {
            self.routeEndTip = nil;
        }
        AMapTip *tip0 = self.routeStartTip;
        AMapTip *tip1 = self.routeEndTip;
        self.tipsBlock (tip0, tip1);
    }
    _search.delegate = nil;
}

- (void)exchangeDirection
{
    AMapTip *tipDelegate = self.routeStartTip;
    self.routeStartTip = self.routeEndTip;
    self.routeEndTip = tipDelegate;
    self.routeStartView.textField.text = self.routeStartTip.name;
    self.routeEndView.textField.text = self.routeEndTip.name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textChange:(UITextField*)textField
{
    self.tableView.hidden = NO;
    [self searchTipsWithKey:textField.text];
}

-  (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    textFieldTag = textField.tag;
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (void)initTableView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.routeEndView.frame)+10, self.view.frame.size.width, self.view.frame.size.height) style:UITableViewStylePlain];
    
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.hidden = YES;
    [self.view addSubview:self.tableView];
}

/* 输入提示 搜索.*/
- (void)searchTipsWithKey:(NSString *)key
{
    if (key.length == 0)
    {
        return;
    }
    
    AMapInputTipsSearchRequest *tips = [[AMapInputTipsSearchRequest alloc] init];
    tips.keywords = key;
    tips.city     = @"苏州";
    //    tips.cityLimit = YES; 是否限制城市
    
    [self.search AMapInputTipsSearch:tips];
}

#pragma mark - AMapSearchDelegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    NSLog(@"Error: %@ - %@", error, [ErrorInfoUtility errorDescriptionWithCode:error.code]);
}

/* 输入提示回调. */
- (void)onInputTipsSearchDone:(AMapInputTipsSearchRequest *)request response:(AMapInputTipsSearchResponse *)response
{
    if (response.count == 0)
    {
        return;
    }
    
    [self.tips setArray:response.tips];
    [self.tableView reloadData];
}


#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AMapTip *tip = self.tips[indexPath.row];
    if (textFieldTag == 1) {
        _routeStartTip = tip;
        self.routeStartView.textField.text = tip.name;
    } else if (textFieldTag == 2) {
        _routeEndTip = tip;
        self.routeEndView.textField.text = tip.name;
    }
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tips.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *tipCellIdentifier = @"tipCellIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tipCellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle
                                      reuseIdentifier:tipCellIdentifier];
        cell.imageView.image = [UIImage imageNamed:@"Track_startImage"];
    }
    
    AMapTip *tip = self.tips[indexPath.row];
    
    if (tip.location == nil)
    {
        cell.imageView.image = [UIImage imageNamed:@"Track_startImage"];
    }
    
    cell.textLabel.text = tip.name;
    cell.detailTextLabel.text = tip.address;
    
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
