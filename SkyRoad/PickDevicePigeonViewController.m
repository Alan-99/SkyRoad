//
//  PickDevicePigeonViewController.m
//  SkyRoad
//
//  Created by alan on 17/3/29.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import "PickDevicePigeonViewController.h"
#import "detailCopy.h"
#import "SQLManager.h"
#import "PigeonDetailModel.h"
#import "subTableView.h"


// 宏定义-导航栏的高度 - 为啥是0？
//#define JNavBarH self.navigationController.navigationBar.frame.size.height

#define JNavBarH 64


#define JScreenWidth [[UIScreen mainScreen]bounds].size.width
#define JScreenHeight [[UIScreen mainScreen]bounds].size.height


@interface PickDevicePigeonViewController () <UITableViewDelegate, UITableViewDataSource >
{
    UITableView *_devTableView;
    UITableView *_pigeonTableView;
}

@property (nonatomic,strong) NSIndexPath *lastPath0;
@property (nonatomic,strong) NSIndexPath *lastPath1;


@property (nonatomic, weak) UIImageView* myPigeonImage;
@property (nonatomic, weak) UIImageView* myDeviceImage;


@property (nonatomic, weak) UIButton* pickPigeonBtn;
@property (nonatomic, weak) UIButton* pickDevBtn;
@property (nonatomic, weak) UIButton* confirmBtn;

@property (nonatomic, strong) UIPickerView *pigeonPicker;
@property (nonatomic, strong) UIPickerView *devPicker;

@property (nonatomic, weak)  IBOutlet UILabel* detailLabel;

@property (nonatomic, copy) NSMutableArray *pigeonArr;
@property (nonatomic, copy) NSMutableArray *devArr;


@end

@implementation PickDevicePigeonViewController

NSString *pChosen;
NSString *dChosen;

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [self initMyPigeonImage];
        [self initMyDeviceImage];

        [self initPickPigeonBtn];
        [self initPickDevBtn];
        [self initPigeonTableView];
        [self initDevTableView];
        [self initConfirmBtn];
        [self initDetailLabel];

//        self.pigeonArr = @[@"小红", @"小兰", @"小绿", @"小黄", @"小紫", @"小赤"];
//        self.devArr = @[@"2017001", @"2017002", @"2017003", @"2017004", @"2017005", @"2017006"];
    }
    return self;
}

- (void)initPigeonArr {
    // 取出数据库存放的信鸽数据
    
    self.pigeonArr = [[NSMutableArray alloc]init];

    NSMutableArray *arr = [[NSMutableArray alloc]init];
    SQLManager *manager = [SQLManager shareManager];
    NSMutableArray *pigeonModelArr = [manager searchAll];
    NSInteger pigeonCount = [pigeonModelArr count];
    for (int i = 0; i < (int)pigeonCount; i++) {
        PigeonDetailModel *model = pigeonModelArr[i];
        NSString *nameStr = model.pigeonName;
        [arr addObject:nameStr];
    }
    self.pigeonArr = arr;
}

- (void)initMyPigeonImage
{
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(JScreenWidth/4 - 40, JNavBarH +20, 80, 80)];
    imageV.image = [UIImage imageNamed:@"Track_AddPigeon"];
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageV];
    _myPigeonImage = imageV;
}

- (void)initMyDeviceImage
{
    UIImageView *imageV = [[UIImageView alloc]initWithFrame:CGRectMake(JScreenWidth*3/4 - 40, JNavBarH +20, 80, 80)];
    imageV.image = [UIImage imageNamed:@"Track_AddDevice"];
    imageV.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:imageV];
    _myDeviceImage = imageV;
}

- (void)initPickPigeonBtn
{
    UIButton *btn0 = [[UIButton alloc]initWithFrame:CGRectMake(JScreenWidth/16, CGRectGetMaxY(self.myPigeonImage.frame) +5, 3*JScreenWidth/8, 35)];
    NSLog(@"jscreenW:%f,jnavH:%d", JScreenWidth, JNavBarH);
    //    UIButton *btn0 = [[UIButton alloc]initWithFrame:CGRectMake(20, 100, 100, 35)];
    btn0.layer.borderWidth = 0.0;
//    btn0.layer.borderColor = [UIColor grayColor].CGColor;
    [btn0 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn0 setTitle:@"选择信鸽" forState:UIControlStateNormal];
    [self.view addSubview:btn0];
    _pickPigeonBtn = btn0;
}
- (void)initPickDevBtn
{
    UIButton *btn1 = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.pickPigeonBtn.frame) + JScreenWidth/8, CGRectGetMaxY(self.myDeviceImage.frame) +5, 3*JScreenWidth/8, 35)];
    btn1.layer.borderWidth = 0.0;
//    btn1.layer.borderColor = [UIColor grayColor].CGColor;
    [btn1 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn1 setTitle:@"选择设备" forState:UIControlStateNormal];
    [self.view addSubview:btn1];
    _pickDevBtn = btn1;
}

- (void)initPigeonTableView
{
    CGRect rect = CGRectMake(CGRectGetMinX(_pickPigeonBtn.frame), CGRectGetMaxY(self.pickPigeonBtn.frame) +10, CGRectGetWidth(self.pickPigeonBtn.frame), 200);
    _pigeonTableView = [[UITableView alloc]initWithFrame:rect style:UITableViewStylePlain];

    _pigeonTableView.layer.borderWidth = 1.0;
    _pigeonTableView.layer.borderColor = [UIColor grayColor].CGColor;
    _pigeonTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;

    _pigeonTableView.delegate = self;
    _pigeonTableView.dataSource = self;
    
    [self.view addSubview:_pigeonTableView];
}

- (void)initDevTableView
{
    CGRect rect = CGRectMake(CGRectGetMinX(_pickDevBtn.frame), CGRectGetMaxY(self.pickDevBtn.frame) +10, CGRectGetWidth(self.pickDevBtn.frame), 200);
    
    _devTableView = [[UITableView alloc]initWithFrame:rect style:UITableViewStylePlain];
    _devTableView.layer.borderWidth = 1.0;
    _devTableView.layer.borderColor = [UIColor grayColor].CGColor;
    _devTableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
//    _devTableView.sectionHeaderHeight = 15;
//    _devTableView.sectionFooterHeight = 0;
    _devTableView.delegate = self;
    _devTableView.dataSource = self;
    
    [self.view addSubview:_devTableView];
}
- (void)initConfirmBtn
{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(JScreenWidth/4, CGRectGetMaxY(_pigeonTableView.frame) +25, JScreenWidth/2, 40)];
    btn.layer.borderWidth = 1.0;
    btn.layer.borderColor = [UIColor grayColor].CGColor;
    btn.backgroundColor = [UIColor greenColor];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitle:@"确认" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(showDetailInformation) forControlEvents:UIControlEventTouchUpInside];
    [btn setEnabled:YES];
    [self.view addSubview:btn];
    _confirmBtn = btn;
}

- (void)initDetailLabel
{
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.frame) -40-49, JScreenWidth, 40)];
//    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(0, self.view.bounds.size.height, JScreenWidth, 40)];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    label.textColor = [UIColor whiteColor];
    label.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin;
    label.hidden = YES;
    [self.view addSubview:label];
    _detailLabel = label;


}



- (void)showDetailInformation
{
    self.detailLabel.hidden = NO;
    if (pChosen!=nil) {
        NSString *detailStr = [NSString stringWithFormat:@"信鸽名字:%@ 脚环号:%@", pChosen, dChosen];
        self.detailLabel.text = detailStr;
    }

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self initPigeonArr];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (self.valueBlock != nil ) {
        self.valueBlock (pChosen, dChosen);
    }
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if ([tableView isEqual:_devTableView]) {
        return self.pigeonArr.count;

    } else if ([tableView isEqual:_pigeonTableView]) {
        return self.pigeonArr.count;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([tableView isEqual:_devTableView]) {
        static NSString *cellIdentifier = @"cellIdentifier";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
            cell.textLabel.text = _pigeonArr[indexPath.row];
            
            NSInteger row = [indexPath row];
            NSInteger oldRow = [_lastPath1 row];
            if (row == oldRow && self.lastPath1!=nil) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        return cell;
    }
    if ([tableView isEqual:_pigeonTableView]) {
        static NSString *cellIdentifier = @"cellIdentifier1";
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
            cell.textLabel.text = _pigeonArr[indexPath.row];
            
            NSInteger row = [indexPath row];
            NSInteger oldRow = [_lastPath0 row];
            if (row == oldRow && self.lastPath0!=nil) {
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
            }else {
                cell.accessoryType = UITableViewCellAccessoryNone;
            }
        }
        return cell;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
//    self.detailLabel.hidden = YES;
    
    if ([tableView isEqual:_devTableView]) {
//        [self.pickPigeonBtn setTitle:[self.pigeonArr objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        dChosen = [self.pigeonArr objectAtIndex:indexPath.row];
        int newRow = (int)[indexPath row];
        int oldRow = (_lastPath1!=nil)?(int)[_lastPath1 row]:-1;
        if (newRow != oldRow) {
            UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
            newCell.accessoryType = UITableViewCellAccessoryCheckmark;
            UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:_lastPath1];
            oldCell.accessoryType = UITableViewCellAccessoryNone;
            _lastPath1 = indexPath;
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
    if ([tableView isEqual:_pigeonTableView]) {
//        [self.pickPigeonBtn setTitle:[self.pigeonArr objectAtIndex:indexPath.row] forState:UIControlStateNormal];
        pChosen = [self.pigeonArr objectAtIndex:indexPath.row];
        
        int newRow = (int)[indexPath row];
        int oldRow = (_lastPath0!=nil)?(int)[_lastPath0 row]:-1;
        if (newRow != oldRow) {
            UITableViewCell *newCell = [tableView cellForRowAtIndexPath:indexPath];
            newCell.accessoryType = UITableViewCellAccessoryCheckmark;
            UITableViewCell *oldCell = [tableView cellForRowAtIndexPath:_lastPath0];
            oldCell.accessoryType = UITableViewCellAccessoryNone;
            _lastPath0 = indexPath;
        }
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
  
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
