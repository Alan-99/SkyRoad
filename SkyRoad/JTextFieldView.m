//
//  JTextFieldView.m
//  SkyRoad
//
//  Created by alan on 2017/4/11.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import "JTextFieldView.h"

@interface JTextFieldView ()<UITextFieldDelegate>

@end

@implementation JTextFieldView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _txtField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width - 10, self.frame.size.height)];
        _txtField.borderStyle = UITextBorderStyleNone;
        _txtField.backgroundColor = [UIColor clearColor];
        _txtField.textAlignment = NSTextAlignmentLeft;
        _txtField.textColor = [UIColor blackColor];
        _txtField.returnKeyType = UIReturnKeyDone;
        _txtField.delegate = self;
        
        _imageV = [[UIView alloc]initWithFrame:CGRectMake(0,CGRectGetMinY(_txtField.frame) - 2, 10, self.frame.size.height)];
        _txtField.leftView = _imageV;
        _txtField.leftViewMode = UITextFieldViewModeAlways;
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 1)];
        line.backgroundColor = [UIColor lightGrayColor];
        
        UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height - 1, self.frame.size.width, 1)];
        line1.backgroundColor = [UIColor lightGrayColor];
        
        [self addSubview:_txtField];
        [self addSubview:line];
        [self addSubview:line1];
    }
    return self;
}

-(void)setupPlaceholder:(NSString*)placeholderStr
{
    _txtField.placeholder = placeholderStr;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
