//
//  JTextFieldView.h
//  SkyRoad
//
//  Created by alan on 2017/4/11.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JTextFieldView : UIView

@property (nonatomic, strong) UIView *imageV;
@property (nonatomic, strong) UITextField *txtField;

- (void)setupPlaceholder:(NSString*)placeholderStr;

@end
