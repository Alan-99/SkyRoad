//
//  JLableAndButtonView.h
//  SkyRoad
//
//  Created by alan on 2017/5/3.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JLableAndButtonView : UIView

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UITextField *textField;

- (void)setupLabeText:(NSString*)labelTxt;
- (void)setupTextfieldPlaceholder:(NSString*)placeholder;

@end
