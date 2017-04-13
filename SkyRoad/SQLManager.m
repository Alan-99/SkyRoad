//
//  SQLManager.m
//  SQLite-nameList
//
//  Created by alan on 17/3/22.
//  Copyright © 2017年 sibet. All rights reserved.
//

#import "SQLManager.h"

@implementation SQLManager

#define jSQLNameFile (@"pigeonDetail.sqlite") // 处理本地文件

static SQLManager* manager = nil;

+ (SQLManager *)shareManager
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
    NSString *filePath = [documentDirectory stringByAppendingPathComponent:jSQLNameFile];
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
    if (sqlite3_open([writetablePath UTF8String], &db) != SQLITE_OK) {
        // SQLITE_OK代表打开成功
        // 失败
        // 失败或者不对数据库进行操作时，要对数据库进行关闭
        sqlite3_close(db);
        // 抛出错误信息
        NSAssert(NO, @"数据库打开失败");
    } else {
        char *err;
        NSString *creatSQL = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS PigeonDetail (pigeonID NSINTEGER PRIMARYKEY, ringNum TEXT, sex TEXT, furcolor TEXT, eyesand TEXT, descent TEXT);"];
        // 第一个参数 db对象
        // 第二个参数 执行的sql语句
        // 第三个和第四个参数  回调函数和回调函数传递的参数
        // 第五个参数 是一个错误信息
        if (sqlite3_exec(db, [creatSQL UTF8String], NULL, NULL, &err)!= SQLITE_OK) {
            // 失败
            // 失败或者不对数据库进行操作时，要对数据库进行关闭
            sqlite3_close(db);
            // 抛出错误信息
            NSAssert(NO, @"数据库建表失败！%s",err);
        }
        //成功,无需操作
        sqlite3_close(db);
    }
}

// 查询所有数据
- (NSMutableArray *)searchAll
{
    // 初始化返回的dataArr
    NSMutableArray *dataArr = [[NSMutableArray alloc]init];
    
    // 1 获取数据库路径，打开数据库
    NSString *path = [self applicationDocumentsDirectoryFile];
    
    if (sqlite3_open([path UTF8String], &db)!=SQLITE_OK) {
        // 数据库打开失败，需要关闭数据库
        sqlite3_close(db);
        NSAssert(NO, @"数据库打开失败");
        
    }else {
        // 打开数据库成功，新建查询语句
        NSString *qsql = @"SELECT pigeonID,ringNum,sex,furcolor,eyesand,descent FROM PigeonDetail";
        sqlite3_stmt *statement; // 语句对象
        /*
         // 2 预处理操作
         第一个参数 数据库的对象；第二个参数SQL语句；第三个参数 执行语句的长度 -1指全部长度； 第四个参数 语句对象； 第五个参数 没有执行的语句部分 NULL
         */
        if (sqlite3_prepare_v2(db, [qsql UTF8String], -1, &statement, NULL) == SQLITE_OK) {

            // 3 执行sql语句，遍历结果集，该语句有一个返回值，SQLITE_ROW代表查出来了
            while (sqlite3_step(statement) == SQLITE_ROW) {
                //5 提取数据
                // 第一个参数 语句对象
                // 第二个参数 字段的索引，select的字段的数据
                // 索引姓名
                char *name = (char *)sqlite3_column_text(statement, 0);
                // 数据转换
                NSString *nameStr = [[NSString alloc ]initWithUTF8String:name];
                // 获取索引
                NSInteger pigeonID = (int)sqlite3_column_int(statement, 0);
                // 索引环号
                char *ringNum = (char*)sqlite3_column_text(statement, 1);
                NSString *ringNumStr = [[NSString alloc]initWithUTF8String:ringNum];
                // 索引性别
                char *sex = (char*)sqlite3_column_text(statement, 2);
                NSString *sexStr = [[NSString alloc]initWithUTF8String:sex];
                // 索引羽色
                char *furcolor = (char*)sqlite3_column_text(statement, 3);
                NSString *furcolorStr = [[NSString alloc]initWithUTF8String:furcolor];
                // 索引沙眼
                char *eyesand = (char*)sqlite3_column_text(statement, 4);
                NSString *eyesandStr = [[NSString alloc]initWithUTF8String:eyesand];
                // 索引血统
                char *descent = (char*)sqlite3_column_text(statement, 5);
                NSString *descentStr = [[NSString alloc]initWithUTF8String:descent];
                
                
                PigeonDetailModel *model = [[PigeonDetailModel alloc]init];
                model.pigeonName = nameStr;
                model.pigeonID = pigeonID;
                model.pigeonRingNumber = ringNumStr;
                model.pigeonSex = sexStr;
                model.pigeonFurcolor = furcolorStr;
                model.pigeonEyesand = eyesandStr;
                model.pigeonDescent = descentStr;
                
                [dataArr addObject:model];
//                //6 数据提取成功之后，要对资源释放
//                sqlite3_finalize(statement);
//                sqlite3_close(db);
//                
            }
        }
        //预处理不成功，数据提取不成功，要对资源释放
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return dataArr;
}


// 查询数据
- (PigeonDetailModel *)searchWithName:(PigeonDetailModel *)model
{
    // 1 获取数据库路径，打开数据库
    NSString *path = [self applicationDocumentsDirectoryFile];
    if (sqlite3_open([path UTF8String], &db)!=SQLITE_OK) {
        // 数据库打开失败，需要关闭数据库
        sqlite3_close(db);
        NSAssert(NO, @"数据库打开失败");

    }else {
        // 打开数据库成功，新建查询语句
        NSString *qsql = @"SELECT name,ringNum,sex,furcolor,eyesand,descent FROM PigeonDetail where name = ?";
        sqlite3_stmt *statement; // 语句对象
        /*
         // 2 预处理操作
         第一个参数 数据库的对象；第二个参数SQL语句；第三个参数 执行语句的长度 -1指全部长度； 第四个参数 语句对象； 第五个参数 没有执行的语句部分 NULL
         */
        if (sqlite3_prepare_v2(db, [qsql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            //3 绑定操作，为qsql中的问号占位符赋值
            NSString *name = model.pigeonName;
            /*
             第一个参数：语句对象； 第二个参数 参数开始执行的序号； 第三个参数 要绑定的值； 第四个参数 绑定的字符串的长度； 第五个参数 指针NULL
             可以绑定不同的类型，这里是text类型
             */
            sqlite3_bind_text(statement, 1, [name UTF8String], -1, NULL);
            // 4 执行sql语句，遍历结果集，该语句有一个返回值，SQLITE_ROW代表查出来了
            if (sqlite3_step(statement) == SQLITE_ROW) {
                //5 提取数据
                // 第一个参数 语句对象
                // 第二个参数 字段的索引，select的字段的数据
                char *name = (char *)sqlite3_column_text(statement, 0);
                // 数据转换
                NSString *nameStr = [[NSString alloc ]initWithUTF8String:name];
                // 索引环号
                char *ringNum = (char*)sqlite3_column_text(statement, 1);
                NSString *ringNumStr = [[NSString alloc]initWithUTF8String:ringNum];
                // 索引性别
                char *sex = (char*)sqlite3_column_text(statement, 2);
                NSString *sexStr = [[NSString alloc]initWithUTF8String:sex];
                // 索引羽色
                char *furcolor = (char*)sqlite3_column_text(statement, 3);
                NSString *furcolorStr = [[NSString alloc]initWithUTF8String:furcolor];
                // 索引沙眼
                char *eyesand = (char*)sqlite3_column_text(statement, 4);
                NSString *eyesandStr = [[NSString alloc]initWithUTF8String:eyesand];
                // 索引血统
                char *descent = (char*)sqlite3_column_text(statement, 5);
                NSString *descentStr = [[NSString alloc]initWithUTF8String:descent];

                
                PigeonDetailModel *model = [[PigeonDetailModel alloc]init];
                model.pigeonName = nameStr;
                model.pigeonRingNumber = ringNumStr;
                model.pigeonSex = sexStr;
                model.pigeonFurcolor = furcolorStr;
                model.pigeonEyesand = eyesandStr;
                model.pigeonDescent = descentStr;
                
                //6 数据提取成功之后，要对资源释放
                sqlite3_finalize(statement);
                sqlite3_close(db);
                
                return model;
            }
        }
        //预处理不成功，数据提取不成功，要对资源释放
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return nil;
}

// 修改数据库
- (int)insert:(PigeonDetailModel*)model
{
    NSString *path = [self applicationDocumentsDirectoryFile];
    if (sqlite3_open([path UTF8String], &db) != SQLITE_OK) {
        sqlite3_close(db);
        NSAssert(NO, @"数据库打开失败");
    } else {
        NSString *sql = @"INSERT OR REPLACE INTO PigeonDetail (pigeonID, ringNum, sex, furcolor, eyesand, descent) VALUES (?,?,?,?,?,?)";
        sqlite3_stmt *statement;
        // 预处理
        if (sqlite3_prepare_v2(db, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            // 绑定参数
            sqlite3_bind_int(statement, 1, (int)model.pigeonID);
            sqlite3_bind_text(statement, 2, [model.pigeonRingNumber UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 3, [model.pigeonSex UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 4, [model.pigeonFurcolor UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 5, [model.pigeonEyesand UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 6, [model.pigeonDescent UTF8String], -1, NULL);

            
            if (sqlite3_step(statement) != SQLITE_DONE) {
                NSAssert(NO, @"插入数据库失败");
            }
            sqlite3_finalize(statement);
            sqlite3_close(db);
        }
    }
    return 0;
}

// 删除数据
- (int)deleteWithRingNum:(PigeonDetailModel*)model
{
    // 1 获取数据库路径，打开数据库
    NSString *path = [self applicationDocumentsDirectoryFile];
    if (sqlite3_open([path UTF8String], &db)!=SQLITE_OK) {
        // 数据库打开失败，需要关闭数据库
        sqlite3_close(db);
        NSAssert(NO, @"数据库打开失败");
        
    }else {
        // 打开数据库成功，新建查询语句
        NSString *qsql = @"DELETE FROM PigeonDetail where ringNum = ?";
    
        sqlite3_stmt *statement; // 语句对象
        /*
         // 2 预处理操作
         第一个参数 数据库的对象；第二个参数SQL语句；第三个参数 执行语句的长度 -1指全部长度； 第四个参数 语句对象； 第五个参数 没有执行的语句部分 NULL
         */
        if (sqlite3_prepare_v2(db, [qsql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            //3 绑定操作，为qsql中的问号占位符赋值
            NSString *ringNumStr = model.pigeonRingNumber;
            /*
             第一个参数：语句对象； 第二个参数 参数开始执行的序号； 第三个参数 要绑定的值； 第四个参数 绑定的字符串的长度； 第五个参数 指针NULL
             可以绑定不同的类型，这里是text类型
             */
            sqlite3_bind_text(statement, 1, [ringNumStr UTF8String], -1, NULL);
            // 执行
            if (sqlite3_step(statement) != SQLITE_DONE) {
                NSAssert(NO, @"数据库删除数据失败");
            }
        }
        //预处理不成功，数据提取不成功，要对资源释放
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return 0;
}

- (int)update:(PigeonDetailModel *)model
{
    // 1 获取数据库路径，打开数据库
    NSString *path = [self applicationDocumentsDirectoryFile];
    if (sqlite3_open([path UTF8String], &db)!=SQLITE_OK) {
        // 数据库打开失败，需要关闭数据库
        sqlite3_close(db);
        NSAssert(NO, @"数据库打开失败");
        
    }else {
        // 打开数据库成功，新建查询语句
        NSString *qsql = @"UPDATE PigeonDetail SET ringNum=?, sex=?, furcolor=?, eyesand=?, descent=? WHERE pigeonID=?";
        
        sqlite3_stmt *statement; // 语句对象
        /*
         // 2 预处理操作
         第一个参数 数据库的对象；第二个参数SQL语句；第三个参数 执行语句的长度 -1指全部长度； 第四个参数 语句对象； 第五个参数 没有执行的语句部分 NULL
         */
        if (sqlite3_prepare_v2(db, [qsql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
            //3 绑定操作，为qsql中的问号占位符赋值
            NSInteger pigeonID = model.pigeonID;
            NSString *ringNumStr = model.pigeonRingNumber;
            NSString *sexStr = model.pigeonSex;
            NSString *furcolorStr = model.pigeonFurcolor;
            NSString *eyesandStr = model.pigeonEyesand;
            NSString *descentStr = model.pigeonDescent;
            /*
             第一个参数：语句对象； 第二个参数 参数开始执行的序号； 第三个参数 要绑定的值； 第四个参数 绑定的字符串的长度； 第五个参数 指针NULL
             可以绑定不同的类型，这里是text类型
             */
            sqlite3_bind_text(statement, 1, [ringNumStr UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 2, [sexStr UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 3, [furcolorStr UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 4, [eyesandStr UTF8String], -1, NULL);
            sqlite3_bind_text(statement, 5, [descentStr UTF8String], -1, NULL);
            sqlite3_bind_int(statement, 6, (int)pigeonID);

            // 执行
            if (sqlite3_step(statement) != SQLITE_DONE) {
                NSAssert(NO, @"更新数据失败");
            }
        }
        //预处理不成功，数据提取不成功，要对资源释放
        sqlite3_finalize(statement);
        sqlite3_close(db);
    }
    return 0;
}


@end
