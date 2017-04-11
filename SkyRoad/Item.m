//
//  Item.m
//  SkyRoad
//
//  Created by alan on 17/3/29.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import "Item.h"

@implementation Item

- (instancetype)initWithItemName:(NSString *)name itemNumber:(NSString *)number itemSex:(NSString *)sex itemFurcolor:(NSString *)furcolor itemEyesand:(NSString *)eyesand itemDescent:(NSString *)descent
{
    self = [super init];
    if (self) {
        _pigeonName = name;
        _pigeonRingNumber = number;
        _pigeonSex = sex;
        _pigeonFurcolor = furcolor;
        _pigeonEyesand = eyesand;
        _pigeonDescent = descent;
    }
    return self;
}


@end
