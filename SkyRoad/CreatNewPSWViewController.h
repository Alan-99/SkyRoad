//
//  CreatNewPSWViewController.h
//  SkyRoad
//
//  Created by alan on 2017/4/19.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^returnValueBlock)(NSString *accountTxt);

@interface CreatNewPSWViewController : UIViewController

@property (nonatomic, copy) returnValueBlock valueBlock;

@end
