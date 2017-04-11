//
//  detailCopy.h
//  SkyRoad
//
//  Created by alan on 17/4/4.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface detailCopy : NSObject

@property NSInteger pigeonR;
@property NSInteger devR;
@property NSString *pigeonName;
@property NSString *detail;

- (instancetype)initWithPigeonRowNum:(NSInteger)row0
                           devRowNum:(NSInteger)row1
                          pigeonName:(NSString*)name
                              devNum:(NSString*)number
                              detail:(NSString*)detail;

@end
