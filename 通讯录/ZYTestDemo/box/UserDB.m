//
//  UserDB.m
//  ZYTestDemo
//
//  Created by Box on 14-3-5.
//  Copyright (c) 2014年 Box. All rights reserved.
//

#import "UserDB.h"

#define kUserTableName @"KUser"


@implementation UserDB

- (id) init {
    self = [super init];
    if (self) {
        //========== 首先查看有没有建立message的数据库，如果未建立，则建立数据库=========
        _db = [BoxDBManager defaultDBManager].dataBase;
        
    }
    return self;
}
/**
 * @brief 创建数据库
 */
- (void) createDataBase {
    FMResultSet * set = [_db executeQuery:[NSString stringWithFormat:@"select count(*) from sqlite_master where type ='table' and name = '%@'",kUserTableName]];
    
    [set next];
    
    NSInteger count = [set intForColumnIndex:0];
    
    BOOL existTable = !!count;
    [_db open];
    if (existTable) {
        
    } else {
        // TODO: 插入新的数据库
        
        NSString * sql = [NSString stringWithFormat:@"CREATE TABLE %@ (uid INTEGER PRIMARY KEY AUTOINCREMENT  NOT NULL,Name text, Phone text, Groups text)",kUserTableName];
        BOOL res = [_db executeUpdate:sql];
        if (!res) {
            NSLog(@"数据库创建失败");
        } else {
            NSLog(@"数据库创建成功");
        }
    }
}

/**
 * @brief 保存一条用户记录
 *
 * @param user 需要保存的用户数据
 */
- (void)saveUser:(UserInfo *) user {
    NSString * sql = [NSString stringWithFormat:@"INSERT INTO %@ (uid ,Name , Phone , Groups ) VALUES (NULL,'%@','%@','%@');",kUserTableName,user.name,user.phoneNumber,user.group];
    
    BOOL res = [_db executeUpdate:sql];
    if (!res) {
        NSLog(@"插入数据库失败");
    } else {
        NSLog(@"插入数据库成功");
    }
}

/**
 * @brief 删除一条用户数据
 *
 * @param uid 需要删除的用户的id
 */
- (void) deleteUserWithId:(NSString *) uid {
    NSString * query = [NSString stringWithFormat:@"DELETE FROM %@ WHERE uid = %@",kUserTableName,uid];
    BOOL res = [_db executeUpdate:query];
    if (!res) {
        NSLog(@"删除数据库失败");
    } else {
        NSLog(@"删除数据库成功");
    }
}

/**
 *  得到所有的数据
 *
 *
 */
-(NSArray *) getAllUser
{
    NSString * query = [NSString stringWithFormat:@"select * from %@",kUserTableName];
    
    FMResultSet *rs = [_db executeQuery:query];

    NSMutableArray *allArray = [NSMutableArray arrayWithCapacity:0];
    while ([rs next]) {
        UserInfo *user = [[UserInfo alloc] init];
        user.uid = [rs stringForColumn:@"uid"];
        user.name = [rs stringForColumn:@"Name"];
        user.phoneNumber = [rs stringForColumn:@"Phone"];
        user.group = [rs stringForColumn:@"Groups"];
        [allArray addObject:user];
        [user release];
    }
    
    [rs close];
    
    return allArray;
}

/**
 * @brief 修改用户的信息
 *
 * @param user 需要修改的用户信息
 */
- (void)mergeWithUser:(UserInfo *)user {
    if (!user.uid) {
        return;
    }
    NSString * query = @"UPDATE KUser SET";
    NSMutableString * temp = [NSMutableString stringWithCapacity:20];
    // xxx = xxx;
    if (user.name) {
        [temp appendFormat:@" name = '%@',",user.name];
    }
    if (user.phoneNumber) {
        [temp appendFormat:@" Phone = '%@',",user.phoneNumber];
    }
    if (user.group) {
        [temp appendFormat:@" Groups = '%@',",user.group];
    }
    [temp appendString:@")"];
    query = [query stringByAppendingFormat:@"%@ WHERE uid = '%@'",[temp stringByReplacingOccurrencesOfString:@",)" withString:@""],user.uid];
    NSLog(@"------------->%@",query);
    
//    [AppDelegate showStatusWithText:@"修改一条数据" duration:2.0];
    [_db executeUpdate:query];
}

@end
