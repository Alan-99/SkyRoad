//
//  FeedYearsViewController.m
//  SkyRoad
//
//  Created by alan on 17/3/24.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import "FeedYearsViewController.h"
#import "JTextFieldView.h"

@interface FeedYearsViewController ()

@end

@implementation FeedYearsViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.navigationItem.title = @"养殖鸽龄";
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(addDone)];
        self.navigationItem.rightBarButtonItem = bbi;
    }
    return self;
}


- (void)addDone
{
    _sub_feedYear = self.FYtxtFiedView.txtField.text;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
        
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
