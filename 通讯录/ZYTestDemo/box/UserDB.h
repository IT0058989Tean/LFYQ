//
//  UserDB.h
//  ZYTestDemo
//
//  Created by Box on 14-3-5.
//  Copyright (c) 2014年 Box. All rights reserved.
//

#import "BoxDBManager.h"
#import "UserInfo.h"

@interface UserDB : NSObject {
    FMDatabase * _db;
}

- (void)createDataBase;
- (void)saveUser:(UserInfo *)user;
- (void)deleteUserWithId:(NSString *)uid;
- (void)mergeWithUser:(UserInfo *)user;
- (NSArray *)getAllUser;
@end
