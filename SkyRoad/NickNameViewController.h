//
//  NickNameViewController.h
//  SkyRoad
//
//  Created by alan on 17/3/24.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JTextFieldView;

typedef void (^returnValueBlock)(NSString* nickNameTxt);

@interface NickNameViewController : UIViewController

// 新增传值block，保存鸽名及设备
@property (nonatomic, copy) returnValueBlock valueBlock;

@property (nonatomic, strong) JTextFieldView *NNtxtFiedView;

@property (nonatomic) NSString *sub_nickName;


@end
