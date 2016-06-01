//
//  BoxDropDownList.m
//  ZYTestDemo
//
//  Created by Box on 14-3-5.
//  Copyright (c) 2014年 Box. All rights reserved.
//

#import "BoxDropDownList.h"

@implementation BoxDropDownList
@synthesize textFieldInput,list,listView,lineColor,listBgColor,borderStyle,cCTBlock;

- (void)dealloc {
    [textFieldInput release];
    self.list = nil;
    [lineColor release];
    [listBgColor release];
    [super dealloc];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
- (id)initWithFrame:(CGRect)frame withListArr:(id)sender withBlock:(completeChooseType)block{
    
    if(self=[super initWithFrame:frame]){
        //默认的下拉列表中的数据
        self.cCTBlock = block;
        NSArray *array = (NSArray *)sender;
        if ([array count] != 0) {
            list=[[NSArray alloc]initWithArray:array];
        }else
            list=[[NSArray alloc]initWithObjects:@"木有组请先创建新组",nil];
//            list = @[@"木有组请先创建新组"];
        
        borderStyle=UITextBorderStyleRoundedRect;
        
        showList=NO; //默认不显示下拉框
        oldFrame=frame; //未下拉时控件初始大小
        //当下拉框显示时，计算出控件的大小。
        newFrame=CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, frame.size.height*5);
        
        lineColor=[UIColor lightGrayColor];//默认列表边框线为灰色
        listBgColor=[UIColor whiteColor];//默认列表框背景色为白色
        lineWidth=1;     //默认列表边框粗细为1
        
        //把背景色设置为透明色，否则会有一个黑色的边
        self.backgroundColor=[UIColor clearColor];
        [self drawView];//调用方法，绘制控件
        
    }
    return self;
}
-(void)drawView{
    //文本框
    textFieldInput=[[UITextField alloc]
                    initWithFrame:CGRectMake(0, 0,
                                             oldFrame.size.width,
                                             oldFrame.size.height)];
    textFieldInput.backgroundColor = [UIColor clearColor];
    textFieldInput.opaque = YES;
    textFieldInput.textColor = [UIColor grayColor];
    textFieldInput.font = [UIFont fontWithName:@"Arial" size:18.0];
    textFieldInput.textAlignment = NSTextAlignmentLeft;
    textFieldInput.clearButtonMode = YES;
    textFieldInput.placeholder = @"群组";
    textFieldInput.delegate = self;
    [self addSubview:textFieldInput];
    [textFieldInput addTarget:self action:@selector(dropdown) forControlEvents:UIControlEventAllTouchEvents];
    
    //下拉列表
    listView=[[UITableView alloc]initWithFrame:
              CGRectMake(lineWidth,oldFrame.size.height+lineWidth,
                         oldFrame.size.width-lineWidth*2,
                         oldFrame.size.height*4-lineWidth*2)];
    listView.dataSource=self;
    listView.delegate=self;
    listView.backgroundColor = listBgColor;
    listView.separatorColor = lineColor;
    listView.hidden =! showList;//一开始listView是隐藏的，此后根据showList的值显示或隐藏
    [self addSubview:listView];
    [listView release];
}

-(void)dropdown{
    [textFieldInput resignFirstResponder];
    if (showList) {//如果下拉框已显示，什么都不做
        return;
    }else {//如果下拉框尚未显示，则进行显示
        //把dropdownList放到前面，防止下拉框被别的控件遮住
        
        [self.superview bringSubviewToFront:self];
        [self setShowList:YES];//显示下拉框
    }
}

#pragma mark listViewdataSource method and delegate method
-(NSInteger)tableView:(UITableView *)table numberOfRowsInSection:(NSInteger)section{
    return list.count;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellid=@"listviewid";
    UITableViewCell* cell=[tableView dequeueReusableCellWithIdentifier:cellid];
    if(cell==nil){
        cell=[[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault
                                    reuseIdentifier:cellid]autorelease];
    }
    //文本标签
    cell.textLabel.text=(NSString*)[list objectAtIndex:indexPath.row];
    cell.textLabel.font=textFieldInput.font;
    
    cell.selectionStyle=UITableViewCellSelectionStyleGray;
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return oldFrame.size.height;
}
//当选择下拉列表中的一行时，设置文本框中的值，隐藏下拉列表
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    textFieldInput.text = (NSString *)[list objectAtIndex:indexPath.row];
    if ([textFieldInput.text length] != 0) {
        self.cCTBlock(textFieldInput.text);
    }else{
        
    }
    
    [self setShowList:NO];
}
-(BOOL)showList{//setShowList:No为隐藏，setShowList:Yes为显示
    return showList;
}
-(void)setShowList:(BOOL)b{
    showList=b;
    //    NSLog(@"showlist is set ");
    if(showList){
        self.frame=newFrame;
    }else {
        self.frame=oldFrame;
    }
    listView.hidden=!b;
}

#pragma mark - UITextFiled Delegate

- (void)textFieldDidEndEditing:(UITextField *)textField {

    if ([textField isEqual:textFieldInput]) {
        self.cCTBlock(textField.text);
    }
    
}


@end
