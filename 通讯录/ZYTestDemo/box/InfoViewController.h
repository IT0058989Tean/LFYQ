//
//  InfoViewController.h
//  ZYTestDemo
//
//  Created by Box on 14-3-5.
//  Copyright (c) 2014年 Box. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^completeEditAndAddUser)(id);

@class UserInfo;

@interface InfoViewController : UIViewController{
    completeEditAndAddUser _block;
}

@property (nonatomic, copy) completeEditAndAddUser block;

- (id)initWithUser:(UserInfo *)newUser withGroups:(id)sender completion:(completeEditAndAddUser)newBlock;

@end
