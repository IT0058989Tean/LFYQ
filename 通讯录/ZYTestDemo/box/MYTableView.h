//
//  MYTableView.h
//  ZYTestDemo
//
//  Created by Box on 14-3-5.
//  Copyright (c) 2014年 Box. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TypeTable)
{
    TypeAll       = 200,
    TypeGroups         ,
    TypeNew
};

@interface MYTableView : UITableView

@property (nonatomic, assign) TypeTable typeItem;

@end
