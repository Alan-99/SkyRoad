//
//  detailCopy.m
//  SkyRoad
//
//  Created by alan on 17/4/4.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import "detailCopy.h"

@implementation detailCopy


- (instancetype)initWithPigeonRowNum:(NSInteger)row0
                           devRowNum:(NSInteger)row1
                          pigeonName:(NSString*)name
                              devNum:(NSString*)number
                              detail:(NSString*)detail
{
    self = [super init];
    if (self) {
        _pigeonR = row0;
        _devR = row1;
        _pigeonName = name;
        _detail = detail;
    }
    return self;
}

@end
