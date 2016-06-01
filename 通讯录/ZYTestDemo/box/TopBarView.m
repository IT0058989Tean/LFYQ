//
//  TopBarView.m
//  ZYTestDemo
//
//  Created by Box on 14-3-4.
//  Copyright (c) 2014年 Box. All rights reserved.
//

#import "TopBarView.h"

@implementation TopBarView
@synthesize block = _block;
@synthesize indexSelect,typeItem;

- (void)dealloc {
    self.block = nil;
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame completion:(changeTable)newBlock
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.block = newBlock;
        [self initView];
    }
    return self;
}

- (void)initView {
    
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    bgImageView.image = [UIImage imageNamed:@"底.png"];
    [self addSubview:bgImageView];
    [bgImageView release];
    
    NSArray *btnNameArray = @[@"所有人",@"群/组",@"新建联系人"];
    
    for (int i = 0; i < 3; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        btn.tag = 100+i;
        btn.frame = CGRectMake(106*i, 0, 106, 44);
        [btn setTitle:[btnNameArray objectAtIndex:i] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(changeTableEvent:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:btn];
    }
    
    _barArrow = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"TabBarNipple.png"]];
    _barArrow.frame = CGRectMake(48, 30, 10, 7);
    [self addSubview:_barArrow];
    [_barArrow release];
    
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark - Change BUTTON 

- (void)changeTableEvent:(id)sender {
    
    UIButton *btn = (UIButton *)sender;
    [self setSelectedIndex:(btn.tag - 100)];
    
    switch (btn.tag) {
        case 100:
        {
            self.typeItem = TypeAllPeople;
            _block(self.typeItem);
            break;
        }
        case 101:
        {
            self.typeItem = TypeGroup;
            _block(self.typeItem);
            break;
        }
        case 102:
        {
            self.typeItem = TypeNewCreate;
            _block(self.typeItem);
            break;
        }
        default:
            break;
    }
}

- (void)changeFrameWithIndex:(NSInteger)newIndex {
    [self gotoItemWithIndex:newIndex];
}

- (void)setSelectedIndex:(NSInteger)newIndex {
    indexSelect = newIndex;
    [self gotoItemWithIndex:indexSelect];
    
}

- (void)gotoItemWithIndex:(NSInteger)newIndex {
    [UIView animateWithDuration:0.3 animations:^(void){
        _barArrow.frame = CGRectMake(106*newIndex+48, 30, 10, 7);
    }];
}
@end
