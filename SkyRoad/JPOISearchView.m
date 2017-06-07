//
//  JPOISearchView.m
//  SkyRoad
//
//  Created by alan on 2017/5/9.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import "JPOISearchView.h"

@interface JPOISearchView () <UITextFieldDelegate>

@end

@implementation JPOISearchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *blankV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, self.frame.size.height)];
        [self addSubview:blankV];
        _label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(blankV.frame), 5, 18, self.frame.size.height-10)];
        _label.textAlignment = NSTextAlignmentCenter;
        _label.font = [UIFont systemFontOfSize:14.0];
        
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_label.frame)+5, 5, self.frame.size.width-CGRectGetMaxY(_label.frame)-5, self.frame.size.height-10)];
        _textField.clearButtonMode = YES;
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.delegate = self;
        
//        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
//        line.backgroundColor = [UIColor lightGrayColor];
//        
//        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1)];
//        line1.backgroundColor = [UIColor lightGrayColor];
        
        [self addSubview:_label];
        [self addSubview:_textField];
        //        [self addSubview:_button];
//        [self addSubview:line];
//        [self addSubview:line1];
    }
    return self;
}

- (void)setupLabeText:(NSString *)labelTxt textFieldPlaceholder:(NSString *)placeholder
{
    _label.text = labelTxt;
    _textField.placeholder = placeholder;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
