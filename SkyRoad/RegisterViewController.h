//
//  RegisterViewController.h
//  SkyRoad
//
//  Created by alan on 2017/4/18.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^returnValueBlock)(NSString *accountTxt);

@interface RegisterViewController : UIViewController

@property (nonatomic, copy) returnValueBlock valueBlock;

@end
