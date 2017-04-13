//
//  SQLManager.h
//  SQLite-nameList
//
//  Created by alan on 17/3/22.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "sqlite3.h"
#import "PigeonDetailModel.h"


// 在这个类里面进行数据库的读取写入操作

@interface SQLManager : NSObject
{
    // 定义sqlite对象
    sqlite3 *db;
}

+ (SQLManager *)shareManager;

// 根据字段查询，返回一个新歌detail信息
- (PigeonDetailModel *)searchWithName:(PigeonDetailModel *)model;

// 查询所有数据方法
- (NSMutableArray *)searchAll;

// 修改数据库数据
- (int)insert:(PigeonDetailModel*)model;

// 更新数据库
- (int)update:(PigeonDetailModel*)model;

// 删除数据库数据
- (int)deleteWithRingNum:(PigeonDetailModel *)model;

@end
