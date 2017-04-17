//
//  DeviceSQLManager.m
//  SkyRoad
//
//  Created by alan on 2017/4/11.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import "DeviceSQLManager.h"

@implementation DeviceSQLManager

#define jDeviceSQLNameFile (@"deviceDetail.sqlite") // 处理本地文件

static DeviceSQLManager* manager = nil;

+ (DeviceSQLManager *)shareManager
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        manager = [[self alloc]init];
        [manager creatDataBaseTableIfNeeded];
    });
    return manager;
}

// 得到数据库的完整路径并返还
- (NSString *)applicationDocumentsDirectoryFile {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [paths firstObject];
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:jDeviceSQLNameFile];
    return filePath;
}

// 建表操作
- (void)creatDataBaseTableIfNeeded
{
    // 打开数据库时首先找到这个数据库，获取他的路径
    NSString *writetablePath = [self applicationDocumentsDirectoryFile];
    NSLog(@"数据库的地址是：%@",writetablePath);
    // 第一个参数数据库文件所在的完整路径
    // 第二个参数是数据库 DataBase 对象
    // 打开数据库的操作,数据库地址从nsstring类型转换成c语言接受的类型（utf8string）
    //    sqlite3_open([writetablePath UTF8String], &db) 返回的是一个值
    if (sqlite3_open([writetablePath UTF8String], &deviceDB) != SQLITE_OK) {
        // SQLITE_OK代表打开成功
        // 失败
        // 失败或者不对数据库进行操作时，要对数据库进行关闭
        sqlite3_close(deviceDB);
        // 抛出错误信息
        NSAssert(NO, @"数据库打开失败");
    } else {
        char *err;
        NSString *creatSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS deviceDetail (deviceID NSINTEGER PRIMARYKEY, deviceNum TEXT);"];
        // 第一个参数 db对象
        // 第二个参数 执行的sql语句
        // 第三个和第四个参数  回调函数和回调函数传递的参数
        // 第五个参数 是一个错误信息
        if (sqlite3_exec(deviceDB, [creatSQL UTF8String], NULL, NULL, &err)!= SQLITE_OK) {
            // 失败
            // 失败或者不对数据库进行操作时，要对数据库进行关闭
            sqlite3_close(deviceDB);
            // 抛出错误信息
            NSAssert(NO, @"数据库建表失败！%s",err);
        }
        //成功,无需操作
        sqlite3_close(deviceDB);
    }
}

// 查询所有数据
- (NSMutableArray *)searchAll
{
    // 初始化返回的dataArr
    NSMutableArray *dataArr = [[NSMutableArray alloc]init];
    
    // 1 获取数据库路径，打开数据库
    NSString *path = [self applicationDocumentsDirectoryFile];
    
    if (sqlite3_open([path UTF8String], &deviceDB)!=SQLITE_OK) {
        // 数据库打开失败，需要关闭数据库
        sqlite3_close(deviceDB);
        NSAssert(NO, @"数据库打开失败");
        
    }else {
        // 打开数据库成功，新建查询语句
        NSString *qsql = @"SELECT deviceID,deviceNum FROM deviceDetail";
        sqlite3_stmt *statement; // 语句对象
        /*
         // 2 预处理操作
         第一个参数 数据库的对象；第二个参数SQL语句；第三个参数 执行语句的长度 -1指全部长度； 第四个参数 语句对象； 第五个参数 没有执行的语句部分 NULL
         */
        if (sqlite3_prepare_v2(deviceDB, [qsql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            
            // 3 执行sql语句，遍历结果集，该语句有一个返回值，SQLITE_ROW代表查出来了
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //5 提取数据
                // 第一个参数 语句对象
                // 第二个参数 字段的索引，select的字段的数据
                // 索引设备号码
                NSInteger deviceID = (int)sqlite3_column_int(statement, 0);
                char* deviceNumber = (char*)sqlite3_column_text(statement, 1);
                NSString *deviceNumberStr = [[NSString alloc]initWithUTF8String:deviceNumber];

                DeviceDetailModel *model = [[DeviceDetailModel alloc]init];
                model.deviceId = deviceID;
                model.deviceNum = deviceNumberStr;
                
                [dataArr addObject:model];
                //                //6 数据提取成功之后，要对资源释放
                //                sqlite3_finalize(statement);
                //                sqlite3_close(db);
                //
            }
        }
        //预处理不成功，数据提取不成功，要对资源释放
        sqlite3_finalize(statement);
        sqlite3_close(deviceDB);
    }
    return dataArr;
}


// 修改数据库
- (int)insert:(DeviceDetailModel*)model
{
    NSString *path = [self applicationDocumentsDirectoryFile];
    if (sqlite3_open([path UTF8String], &deviceDB) != SQLITE_OK) {
        sqlite3_close(deviceDB);
        NSAssert(NO, @"数据库打开失败");
    } else {
        NSString *sql = @"INSERT OR REPLACE INTO deviceDetail (deviceID, deviceNum) VALUES (?,?)";
        sqlite3_stmt *statement;
        // 预处理
        if (sqlite3_prepare_v2(deviceDB, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            // 绑定参数
            sqlite3_bind_int(statement, 1, (int)model.deviceId);
            sqlite3_bind_text(statement, 2, [model.deviceNum UTF8String], -1, NULL);
            
            if (sqlite3_step(statement) != SQLITE_DONE) {
                NSAssert(NO, @"插入数据库失败");
            }
            sqlite3_finalize(statement);
            sqlite3_close(deviceDB);
        }
    }
    return 0;
}

// 删除数据
- (int)deleteWithName:(DeviceDetailModel*)model
{
    // 1 获取数据库路径，打开数据库
    NSString *path = [self applicationDocumentsDirectoryFile];
    if (sqlite3_open([path UTF8String], &deviceDB)!=SQLITE_OK) {
        // 数据库打开失败，需要关闭数据库
        sqlite3_close(deviceDB);
        NSAssert(NO, @"数据库打开失败");
        
    }else {
        // 打开数据库成功，新建查询语句
        NSString *qsql = @"DELETE FROM deviceDetail where deviceNum = ?";
        
        sqlite3_stmt *statement; // 语句对象
        /*
         // 2 预处理操作
         第一个参数 数据库的对象；第二个参数SQL语句；第三个参数 执行语句的长度 -1指全部长度； 第四个参数 语句对象； 第五个参数 没有执行的语句部分 NULL
         */
        if (sqlite3_prepare_v2(deviceDB, [qsql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            //3 绑定操作，为qsql中的问号占位符赋值
            NSString *deviceNumStr = model.deviceNum;
            /*
             第一个参数：语句对象； 第二个参数 参数开始执行的序号； 第三个参数 要绑定的值； 第四个参数 绑定的字符串的长度； 第五个参数 指针NULL
             可以绑定不同的类型，这里是text类型
             */
            sqlite3_bind_text(statement, 1, [deviceNumStr UTF8String], -1, NULL);
            // 执行
            if (sqlite3_step(statement) != SQLITE_DONE) {
                NSAssert(NO, @"数据库删除数据失败");
            }
        }
        //预处理不成功，数据提取不成功，要对资源释放
        sqlite3_finalize(statement);
        sqlite3_close(deviceDB);
    }
    return 0;
}

- (int)update:(DeviceDetailModel *)model
{
    // 1 获取数据库路径，打开数据库
    NSString *path = [self applicationDocumentsDirectoryFile];
    if (sqlite3_open([path UTF8String], &deviceDB)!=SQLITE_OK) {
        // 数据库打开失败，需要关闭数据库
        sqlite3_close(deviceDB);
        NSAssert(NO, @"数据库打开失败");
        
    }else {
        // 打开数据库成功，新建查询语句
        NSString *qsql = @"UPDATE deviceDetail SET deviceNum=? WHERE deviceID=?";
        
        sqlite3_stmt *statement; // 语句对象
        /*
         // 2 预处理操作
         第一个参数 数据库的对象；第二个参数SQL语句；第三个参数 执行语句的长度 -1指全部长度； 第四个参数 语句对象； 第五个参数 没有执行的语句部分 NULL
         */
        if (sqlite3_prepare_v2(deviceDB, [qsql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            //3 绑定操作，为qsql中的问号占位符赋值
            NSInteger deviceID = model.deviceId;
            NSString *deviceNumStr = model.deviceNum;
            /*
             第一个参数：语句对象； 第二个参数 参数开始执行的序号； 第三个参数 要绑定的值； 第四个参数 绑定的字符串的长度； 第五个参数 指针NULL
             可以绑定不同的类型，这里是text类型
             */
            sqlite3_bind_text(statement, 1, [deviceNumStr UTF8String], -1, NULL);
            sqlite3_bind_int(statement, 2, (int)deviceID);
            
            // 执行
            if (sqlite3_step(statement) != SQLITE_DONE) {
                NSAssert(NO, @"更新数据失败");
            }
        }
        //预处理不成功，数据提取不成功，要对资源释放
        sqlite3_finalize(statement);
        sqlite3_close(deviceDB);
    }
    return 0;
}

@end
