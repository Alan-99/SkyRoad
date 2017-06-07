//
//  JLableAndButtonView.m
//  SkyRoad
//
//  Created by alan on 2017/5/3.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import "JLableAndButtonView.h"

@interface JLableAndButtonView () <UITextFieldDelegate>

@end

@implementation JLableAndButtonView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIView *blankV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, self.frame.size.height)];
        [self addSubview:blankV];
        _label = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(blankV.frame), 5, self.frame.size.width/6, self.frame.size.height-10)];
        _label.textAlignment = NSTextAlignmentLeft;
        
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_label.frame)+15, 5, 100, self.frame.size.height-10)];
        _textField.borderStyle = UITextBorderStyleLine;
        _textField.layer.borderWidth = 0.8;
        _textField.layer.borderColor = [UIColor lightGrayColor].CGColor;
        _textField.returnKeyType = UIReturnKeyDone;
        _textField.delegate = self;
        
//        _button = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_label.frame)+15, 5, 100, self.frame.size.height-10)];
//        _button.layer.borderWidth = 0.8;
//        [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//        _button.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
        line.backgroundColor = [UIColor lightGrayColor];
        
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1)];
        line1.backgroundColor = [UIColor lightGrayColor];
        
        [self addSubview:_label];
        [self addSubview:_textField];
//        [self addSubview:_button];
        [self addSubview:line];
        [self addSubview:line1];
    }
    return self;
}

- (void)setupLabeText:(NSString *)labelTxt
{
    _label.text = labelTxt;
}

- (void)setupTextfieldPlaceholder:(NSString *)placeholder
{
    _textField.placeholder = placeholder;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
