//
//  UserRWFiles.m
//  BptApp03
//
//  Created by BlueApp on 13-3-4.
//  Copyright (c) 2013年 Box. All rights reserved.
//

#import "UserRWFiles.h"


@implementation UserRWFiles

+ (void)buildDirWithFM:(NSString *)theFN {
    
    [[NSFileManager defaultManager] createDirectoryAtPath:[self getPathWithFN:theFN] withIntermediateDirectories:YES attributes:nil error:nil];
}

+ (BOOL)writeTJData:(id)theData withFN:(NSString *)theName {
    NSArray *array = (NSArray *)theData;
    if ([array count] != 0) {
//        NSLog(@"arr is %@",array);
//        NSLog(@"name :%@  ***** %@",theName,[self getPathWithFN:theName]);
        BOOL ret = [array writeToFile:[self getPathWithFN:theName] atomically:YES];
        if (ret) {
//            NSLog(@"arris %@",array);
        }else{
            NSLog(@"0");
        }
        return YES;
    }
    return NO;
}
+ (BOOL)writeURLData:(id)theData withFN:(NSString *)theName {
    NSArray *array = (NSArray *)theData;
    NSMutableArray *dataArr = [[NSMutableArray alloc]init];
    if ([array count] != 0) {
        BOOL ret = [dataArr writeToFile:[self getPathWithFN:theName] atomically:YES];
        if (ret) {
            
        }else{
            NSLog(@"0");
        }
        [dataArr release];
        return YES;
    }
    [dataArr release];
    return NO;
}
+ (BOOL)writeLTDatawithFN:(NSString *)theName {
    if (theName) {
        NSDate *date = [NSDate date];
        [NSDateFormatter setDefaultFormatterBehavior:NSDateFormatterBehaviorDefault];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateStyle:NSDateFormatterShortStyle];
        [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *refreshTimestr = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:date]];
//        NSLog(@"refresh timer  is  %@",refreshTimestr);
        NSDictionary *dict = [NSDictionary dictionaryWithObject:refreshTimestr forKey:@"PageRefreshTableView_LastRefresh"];
        [dict writeToFile:[self getPathWithFN:theName] atomically:YES];
        [dateFormatter release];
        return YES;
    }
    return NO;
}

+ (BOOL)isFileWithFN:(NSString *)theName {
    return [[NSFileManager defaultManager] fileExistsAtPath:[self getPathWithFN:theName]];
}

+ (NSString *)getPathWithFN:(NSString *)theName {
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:theName];
}

+ (NSString *)intervalSinceNow: (NSString *) theDate {

    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:theDate];
        
    NSTimeInterval late=[d timeIntervalSince1970]*1;
        
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    
    NSTimeInterval cha=now-late;
    
    if (cha/3600<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/60];
        //        NSLog(@"time string1 is %@",timeString);
        timeString = [timeString substringToIndex:timeString.length-7];

        
    }
    if (cha/3600>1&&cha/86400<1) {
        timeString = [NSString stringWithFormat:@"%f", cha/3600*60];
        //        NSLog(@"time string1 is %@",timeString);
        timeString = [timeString substringToIndex:timeString.length-7];

    }
    if (cha/86400>1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400*24*60];
        //        NSLog(@"time string1 is %@",timeString);
        timeString = [timeString substringToIndex:timeString.length-7];
        
    }
    [date release];
    return timeString;
}

//计算文件夹size//计算文件夹下文件的总大小
+ (double)fileSizeForDir:(NSString*)path {
    NSFileManager *fileManager = [[NSFileManager alloc] init];
    NSArray* array = [fileManager contentsOfDirectoryAtPath:path error:nil];
    double size = 0;
    for(int i = 0; i<[array count]; i++)
    {
        NSString *fullPath = [path stringByAppendingPathComponent:[array objectAtIndex:i]];
        BOOL isDir;
        if ( !([fileManager fileExistsAtPath:fullPath isDirectory:&isDir] && isDir) )
        {
            NSDictionary *fileAttributeDic=[fileManager attributesOfItemAtPath:fullPath error:nil];
            size += fileAttributeDic.fileSize;
        }
        else
        {
            [self fileSizeForDir:fullPath];
        }
    }
    [fileManager release];
    return size;
}


@end
