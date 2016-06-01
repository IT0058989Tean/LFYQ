//
//  AddGroupViewController.h
//  ZYTestDemo
//
//  Created by Box on 14-3-5.
//  Copyright (c) 2014年 Box. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^completeAddGroupName)(id);

@interface AddGroupViewController : UIViewController{
    completeAddGroupName _block;
}

@property (nonatomic, copy) completeAddGroupName block;

- (id)init:(completeAddGroupName)newBlock;

@end
