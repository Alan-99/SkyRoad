//
//  FeedbackAndHelpViewController.m
//  SkyRoad
//
//  Created by alan on 2017/4/25.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import "FeedbackAndHelpViewController.h"
#import "JTextFieldView.h"

@interface FeedbackAndHelpViewController ()

@property (nonatomic, strong) JTextFieldView *detailTxtFieldView;

@end

@implementation FeedbackAndHelpViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.navigationItem.title = @"反馈与帮助";
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _detailTxtFieldView = [[JTextFieldView alloc]initWithFrame:CGRectMake(0, 79, self.view.frame.size.width, 40)];
    [_detailTxtFieldView.txtField setValue:[UIFont systemFontOfSize:14.0] forKeyPath:@"_placeholderLabel.font"];
    [_detailTxtFieldView setupPlaceholder:@"如有问题或需要帮助，请致电13616210565"];
    _detailTxtFieldView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_detailTxtFieldView];
    // Do any additional setup after loading the view.
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
