//
//  UserRWFiles.h
//  BptApp03
//
//  Created by BlueApp on 13-3-4.
//  Copyright (c) 2013年 Box. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserRWFiles : NSObject

+ (void)buildDirWithFM:(NSString *)theFM;
+ (BOOL)writeTJData:(id)theData withFN:(NSString *)theName;//json
+ (BOOL)writeURLData:(id)theData withFN:(NSString *)theName;//URL json
+ (BOOL)writeLTDatawithFN:(NSString *)theName;//last refresh time
+ (BOOL)isFileWithFN:(NSString *)theName;
+ (NSString *)getPathWithFN:(NSString *)theName;
+ (NSString *)intervalSinceNow:(NSString *)theDate;
+ (double)fileSizeForDir:(NSString*)path;


@end
