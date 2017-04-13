//
//  FeedYearsViewController.h
//  SkyRoad
//
//  Created by alan on 17/3/24.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JTextFieldView;
typedef void (^returnValueBlock)(NSString* feedYearTxt);

@interface FeedYearsViewController : UIViewController

@property (nonatomic, copy) returnValueBlock valueBlock;

@property (nonatomic, strong) JTextFieldView *FYtxtFiedView;

@property (nonatomic) NSString *sub_feedYear;

@end
