//
//  BoxDBManager.h
//  ZYTestDemo
//
//  Created by Box on 14-3-5.
//  Copyright (c) 2014年 Box. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDatabaseAdditions.h"

@class FMDatabase;

@interface BoxDBManager : NSObject {
    NSString * _name;
}
@property (nonatomic, readonly) FMDatabase * dataBase;  // 数据库操作对象

+(BoxDBManager *) defaultDBManager;
- (void) close;
@end
