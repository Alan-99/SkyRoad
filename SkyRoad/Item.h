//
//  Item.h
//  SkyRoad
//
//  Created by alan on 17/3/29.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Item : NSObject

@property NSString *pigeonName; // 鸽名
@property NSString *pigeonRingNumber; // 环号
@property NSString *pigeonSex; // 性别
@property NSString *pigeonFurcolor; // 羽色
@property NSString *pigeonEyesand; // 眼砂
@property NSString *pigeonDescent; // 血统


- (instancetype)initWithItemName:(NSString *)name
                      itemNumber:(NSString *)number
                         itemSex:(NSString *)sex
              itemFurcolor:(NSString *)furcolor
                     itemEyesand:(NSString *)eyesand
                     itemDescent:(NSString*)descent;

@end
