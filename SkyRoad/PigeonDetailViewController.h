//
//  PigeonDetailViewController.h
//  SkyRoad
//
//  Created by alan on 17/3/29.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "LabelAndTextFieldView.h"

@class Item;
@class SQLManager;
@class PigeonDetailModel;

typedef void (^returnManagerBlock)(SQLManager *manager0);

@interface PigeonDetailViewController : UIViewController

@property (nonatomic, strong) PigeonDetailModel *model;


// 新增传值block，保存鸽名及设备
@property (nonatomic, copy) returnManagerBlock valueBlock;

@property (nonatomic, strong) IBOutlet UITextField *pigeonName;
@property (nonatomic, strong) IBOutlet UITextField *pigeonRingNum;
@property (nonatomic, strong) IBOutlet UITextField *pigeonSex;
@property (nonatomic, strong) IBOutlet UITextField *pigeonFurcolor;
@property (nonatomic, strong) IBOutlet UITextField *pigeonEyesand;
@property (nonatomic, strong) IBOutlet UITextField *pigeonDescent;

@end
