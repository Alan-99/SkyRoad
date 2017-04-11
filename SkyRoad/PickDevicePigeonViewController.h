//
//  PickDevicePigeonViewController.h
//  SkyRoad
//
//  Created by alan on 17/3/29.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^returnValueBlock)(NSString* nameTxt, NSString* numTxt);

@class detailCopy;

@interface PickDevicePigeonViewController : UIViewController

@property (nonatomic, strong) detailCopy* detailC;

// 新增传值block，保存鸽名及设备
@property (nonatomic, copy) returnValueBlock valueBlock;

@end
