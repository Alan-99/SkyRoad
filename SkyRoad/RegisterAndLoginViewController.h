//
//  RegisterAndLoginViewController.h
//  SkyRoad
//
//  Created by alan on 2017/4/18.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JImageAndTxtfieldView;

@interface RegisterAndLoginViewController : UIViewController

@property (nonatomic) NSString* globalAccount;

@property (nonatomic, strong) JImageAndTxtfieldView *account;
@property (nonatomic, strong) JImageAndTxtfieldView *password;

@end
