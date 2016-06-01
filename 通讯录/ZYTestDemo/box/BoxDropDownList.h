//
//  BoxDropDownList.h
//  ZYTestDemo
//
//  Created by Box on 14-3-5.
//  Copyright (c) 2014年 Box. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^completeChooseType)(id);

@interface BoxDropDownList : UIView<UITableViewDelegate, UITableViewDataSource,UITextFieldDelegate>{
    UITextField             * textFieldInput;   //文本输入框
    NSArray                 * list;            //下拉列表数据
    BOOL                    showList;             //是否弹出下拉列表
    UITableView             * listView;    //下拉列表
    CGRect                  oldFrame, newFrame;   //整个控件（包括下拉前和下拉后）的矩形
    UIColor                 *lineColor, *listBgColor;//下拉框的边框色、背景色
    CGFloat                 lineWidth;               //下拉框边框粗细
    UITextBorderStyle       borderStyle;   //文本框边框style
    completeChooseType      cCTBlock;
}

@property (nonatomic,retain)UITextField *textFieldInput;
@property (nonatomic,retain)NSArray* list;
@property (nonatomic,retain)UITableView* listView;
@property (nonatomic,retain)UIColor *lineColor,*listBgColor;
@property (nonatomic,assign)UITextBorderStyle borderStyle;
@property (nonatomic,copy) completeChooseType cCTBlock;

- (id)initWithFrame:(CGRect)frame withListArr:(id)sender withBlock:(completeChooseType)block;
- (void)drawView;
- (void)setShowList:(BOOL)b;

@end
