//
//  LabelAndTextFieldView.m
//  SkyRoad
//
//  Created by alan on 17/3/29.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import "LabelAndTextFieldView.h"

@interface LabelAndTextFieldView () <UITextFieldDelegate>

@end

@implementation LabelAndTextFieldView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 设置LabelView的宽度为其父view宽度的1/6,高度取当前view的高度
        _LabelView = [[UILabel alloc]initWithFrame:CGRectMake(0,  0, CGRectGetWidth(self.frame)/6, CGRectGetHeight(self.frame))];
        _LabelView.backgroundColor = [UIColor clearColor];
        _LabelView.textAlignment = NSTextAlignmentLeft;
        _LabelView.textColor = [UIColor blackColor];
        [self addSubview:_LabelView];
        
        _textFiled = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.frame)/6, 0, 5*CGRectGetWidth(self.frame)/6, CGRectGetHeight(self.frame))];
        _textFiled.delegate = self;
        _textFiled.borderStyle = UITextBorderStyleLine;
        _textFiled.backgroundColor = [UIColor clearColor];
        _textFiled.textAlignment = NSTextAlignmentLeft;
        _textFiled.textColor = [UIColor blackColor];
        _textFiled.returnKeyType = UIReturnKeyDone;
        
        [self addSubview:_textFiled];
    }
    return self;
}


- (void)setupLabelString:(NSString *)lableString textFieldPlaceHolder:(NSString *)placeHolder
{
    _LabelView.text = lableString;
    _textFiled.placeholder = placeHolder;

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES  ;
}

@end
