//
//  JImageAndTxtfieldView.m
//  SkyRoad
//
//  Created by alan on 2017/4/18.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import "JImageAndTxtfieldView.h"

@interface JImageAndTxtfieldView ()<UITextFieldDelegate>

@end

@implementation JImageAndTxtfieldView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _imageV = [[UIImageView alloc]initWithFrame:CGRectMake(self.bounds.origin.x+5, self.bounds.origin.y+5, self.frame.size.height-10, self.frame.size.height-10)];
        _imageV.contentMode = UIViewContentModeScaleAspectFit;
        [self addSubview:_imageV];
        
        _txtField = [[UITextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_imageV.frame)+20, 0, self.frame.size.width-CGRectGetMaxX(_imageV.frame)-20, self.frame.size.height)];
        _txtField.delegate = self;
        _txtField.borderStyle = UITextBorderStyleNone;
        _txtField.backgroundColor = [UIColor clearColor];
        _txtField.textAlignment = NSTextAlignmentLeft;
        _txtField.textColor = [UIColor whiteColor];
        _txtField.keyboardType = UIKeyboardTypeASCIICapable;
        _txtField.returnKeyType = UIReturnKeyDone;
        _txtField.clearButtonMode = UITextFieldViewModeWhileEditing;
        [self addSubview:_txtField];
        
        UIView *line = [[UIView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-1, self.frame.size.width, 1)];
        line.backgroundColor = [UIColor whiteColor];
        [self addSubview:line];
    }
    return self;
}

- (void)setupImageView:(NSString *)imageName txtfieldPlaceholder:(NSString *)placeholderStr
{
    _imageV.image = [UIImage imageNamed:imageName];
    // 设置txtField的placeholder字体颜色
    UIColor *color = [UIColor whiteColor];
    _txtField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:placeholderStr attributes:@{NSForegroundColorAttributeName:color}];
    _txtField.placeholder = placeholderStr;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
