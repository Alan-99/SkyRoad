//
//  PigeonDetailModel.h
//  SkyRoad
//
//  Created by alan on 2017/4/5.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PigeonDetailModel : NSObject

@property (nonatomic) NSInteger pigeonID;
@property (nonatomic, strong) NSString *pigeonName; // 鸽名
@property (nonatomic, strong) NSString *pigeonRingNumber; // 环号
@property (nonatomic, strong) NSString *pigeonSex; // 性别
@property (nonatomic, strong) NSString *pigeonFurcolor; // 羽色
@property (nonatomic, strong) NSString *pigeonEyesand; // 眼砂
@property (nonatomic, strong) NSString *pigeonDescent; // 血统

@end
