//
//  DeviceSQLManager.h
//  SkyRoad
//
//  Created by alan on 2017/4/11.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "DeviceDetailModel.h"

@interface DeviceSQLManager : NSObject
{
    // 定义sqlite对象
    sqlite3 *deviceDB;
}

+ (DeviceSQLManager *)shareManager;

// 根据字段查询，返回一个新歌detail信息
//- (DeviceDetailModel *)searchWithName:(DeviceDetailModel *)model;

//// 查询所有数据方法
- (NSMutableArray *)searchAll;

// 修改数据库数据
- (int)insert:(DeviceDetailModel*)model;

// 删除数据库数据
- (int)deleteWithName:(DeviceDetailModel *)model;

// 更新数据
- (int)update:(DeviceDetailModel*)model;

@end
