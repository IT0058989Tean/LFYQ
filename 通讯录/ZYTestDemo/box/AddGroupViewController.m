//
//  AddGroupViewController.m
//  ZYTestDemo
//
//  Created by Box on 14-3-5.
//  Copyright (c) 2014年 Box. All rights reserved.
//

#import "AddGroupViewController.h"

@interface AddGroupViewController ()<UITextFieldDelegate>{
    UITextField *_groupName;
}

@end

@implementation AddGroupViewController
@synthesize block = _block;
- (id)init:(completeAddGroupName)newBlock
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.block = newBlock;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self initView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    UIImageView *bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 64)];
    bgImageView.image = [UIImage imageNamed:@"NavigationBarBackGroundImage.png"];
    [self.view addSubview:bgImageView];
    [bgImageView release];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.titleLabel.font = [UIFont fontWithName:@"Arial" size:14.0];;
    [button setTitle:@"添加" forState:UIControlStateNormal];
//    [button setTitle:@"添加" forState:UIControlStateSelected];
    
    [button addTarget:self action:@selector(BarRightBarButton:) forControlEvents:UIControlEventTouchUpInside];
    button.frame = CGRectMake(270, 20, 45, 42);
    [self.view addSubview:button];
    
    UIImageView *inputView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 84, 295, 189)];
    inputView.image = [UIImage imageNamed:@"设置4输入框.png"];
    
    [self.view addSubview:inputView];
    [inputView release];
    
    _groupName = [[UITextField alloc]initWithFrame:CGRectMake(14, 84, 290, 41)];
    _groupName.placeholder = @"组名(必填)";
    _groupName.clearButtonMode = YES;
    _groupName.returnKeyType = UIReturnKeyNext;
    //    _projectInput.secureTextEntry = YES;
    _groupName.delegate = self;
    [self.view addSubview:_groupName];
    [_groupName release];
}

- (void)BarRightBarButton:(id)sender {
    UIButton *btn = (UIButton *)sender;
    if (btn.selected) {
        btn.selected = NO;
    }else{
        btn.selected = YES;
    }
    
    NSString *str = _groupName.text;
    
    [self dismissViewControllerAnimated:YES completion:^{
        if ([str length] > 0) {
            _block(str);
        }
    }];
    
}

#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self.view endEditing:YES];
    return YES;
}


@end
