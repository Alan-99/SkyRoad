//
//  JImageAndTxtfieldView.h
//  SkyRoad
//
//  Created by alan on 2017/4/18.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JImageAndTxtfieldView : UIView

@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UITextField *txtField;

- (void)setupImageView:(NSString*)imageName txtfieldPlaceholder:(NSString*)placeholderStr;

@end
