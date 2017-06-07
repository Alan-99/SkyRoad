//
//  JPOISearchView.h
//  SkyRoad
//
//  Created by alan on 2017/5/9.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JPOISearchView : UIView

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UITextField *textField;

- (void)setupLabeText:(NSString*)labelTxt textFieldPlaceholder:(NSString*)placeholder;
@end
