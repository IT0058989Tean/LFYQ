//
//  TopBarView.h
//  ZYTestDemo
//
//  Created by Box on 14-3-4.
//  Copyright (c) 2014年 Box. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TypeSelected)
{
    TypeAllPeople       = 100,
    TypeGroup           ,
    TypeNewCreate       
};

typedef void(^changeTable)(TypeSelected);

@interface TopBarView : UIView {
    changeTable _block;
    UIImageView *_barArrow;
}

@property (nonatomic, copy) changeTable block;
@property (nonatomic, unsafe_unretained, setter = setSelectedIndex:) NSInteger indexSelect;
@property (nonatomic, assign) TypeSelected typeItem;

- (id)initWithFrame:(CGRect)frame completion:(changeTable)newBlock;
- (void)changeFrameWithIndex:(NSInteger)newIndex;
@end
