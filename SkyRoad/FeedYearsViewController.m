//
//  FeedYearsViewController.m
//  SkyRoad
//
//  Created by alan on 17/3/24.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import "FeedYearsViewController.h"
#import "JTextFieldView.h"

@interface FeedYearsViewController ()<UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) NSArray *feedYearChoice;
@property (nonatomic, strong) UIPickerView *feedYearPicker;

@end

@implementation FeedYearsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.navigationItem.title = @"养殖鸽龄";
//        UIBarButtonItem *bbi = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(addDone)];
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(addDone)];
        self.navigationItem.rightBarButtonItem = bbi;
        self.navigationItem.rightBarButtonItem = bbi;
        [self initFeedYearPicker];
    }
    return self;
}

- (void)initFeedYearPicker
{
    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.view.bounds) - 250, CGRectGetWidth(self.view.bounds), 250)];
    picker.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    picker.delegate = self;
    picker.dataSource = self;
    picker.showsSelectionIndicator = YES;
    [self.view addSubview:picker];
    self.feedYearPicker = picker;
}


- (void)addDone
{
    _sub_feedYear = self.FYtxtFiedView.txtField.text;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.feedYearChoice = @[@"1-3年",@"4-6年",@"7-10年",@"10-15年",@"15-20年",@"20年以上"];
    _FYtxtFiedView = [[JTextFieldView alloc]initWithFrame:CGRectMake(0, 79, self.view.frame.size.width, 40)];
    [self.view addSubview:_FYtxtFiedView];
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if ( self.valueBlock!= nil ) {
        self.valueBlock(self.sub_feedYear);
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSString *str = self.sub_feedYear;
    self.FYtxtFiedView.txtField.text = str;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UIPickerViewDelegate
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.feedYearChoice objectAtIndex:row];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    return 40;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.FYtxtFiedView.txtField.text = self.feedYearChoice[row];
}
#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.feedYearChoice.count;
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
