//
//  LabelAndTextFieldView.h
//  SkyRoad
//
//  Created by alan on 17/3/29.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LabelAndTextFieldView : UIView

@property (nonatomic, strong) UILabel *LabelView;
@property (nonatomic, strong) UITextField *textFiled;

- (void)setupLabelString:(NSString *)lableString textFieldPlaceHolder:(NSString *)placeHolder;

@end
