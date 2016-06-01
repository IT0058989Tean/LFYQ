//
//  InfoViewController.m
//  ZYTestDemo
//
//  Created by Box on 14-3-5.
//  Copyright (c) 2014年 Box. All rights reserved.
//

#import "InfoViewController.h"
#import "RPFloatingPlaceholderTextField.h"
#import "BoxDropDownList.h"
#import "UserDB.h"


@interface InfoViewController ()<UITextFieldDelegate>{
    RPFloatingPlaceholderTextField *_userNameTextField;
    RPFloatingPlaceholderTextField *_userPhoneNumberTextField;
    BoxDropDownList                *_dropDownView;
    NSString               *_groupNameStr;
    NSArray                *_groupArr;
}

@property (nonatomic, strong) UserInfo * user;
@property (nonatomic, strong) UserDB * userDB;
@property (nonatomic, strong) NSString *groupNameStr;
@property (nonatomic, strong) NSArray *groupArr;
@end

@implementation InfoViewController
@synthesize block = _block;
- (void)dealloc {
    self.user = nil;
    self.userDB = nil;
    self.groupNameStr = nil;
    [super dealloc];
}

- (id)initWithUser:(UserInfo *)newUser withGroups:(id)sender completion:(completeEditAndAddUser)newBlock
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.user = newUser;
        self.block = newBlock;
        self.groupArr = (NSArray *)sender;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    self.userDB = [[UserDB alloc] init];
    [self initView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)initView {
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"CompleteImage.png"] style:UIBarButtonItemStylePlain target:self action:@selector(completeChangedInfo:)];
    
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIImageView *inputView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 84, 295, 189)];
    inputView.image = [UIImage imageNamed:@"设置4输入框.png"];
    
    [self.view addSubview:inputView];
    [inputView release];
    
    _userNameTextField = [[RPFloatingPlaceholderTextField alloc] initWithFrame:CGRectMake(14, 86+5, 290, 41)];
    _userNameTextField.floatingLabelActiveTextColor = [UIColor blueColor];
    _userNameTextField.floatingLabelInactiveTextColor = [UIColor grayColor];
    _userNameTextField.placeholder = @"姓名";
    _userNameTextField.font = [UIFont fontWithName:@"Helvetica" size:16.f];
    _userNameTextField.clearButtonMode = YES;
    _userNameTextField.returnKeyType = UIReturnKeyNext;
    _userNameTextField.delegate = self;
    [self.view addSubview:_userNameTextField];
    [_userNameTextField release];

    
    _userPhoneNumberTextField = [[RPFloatingPlaceholderTextField alloc] initWithFrame:CGRectMake(14, 86+44+5, 290, 41)];
    _userPhoneNumberTextField.floatingLabelActiveTextColor = [UIColor blueColor];
    _userPhoneNumberTextField.floatingLabelInactiveTextColor = [UIColor grayColor];
    _userPhoneNumberTextField.placeholder = @"电话";
    _userPhoneNumberTextField.font = [UIFont fontWithName:@"Helvetica" size:16.f];
    _userPhoneNumberTextField.clearButtonMode = YES;
    _userPhoneNumberTextField.keyboardType = UIKeyboardTypeNumberPad;
    _userPhoneNumberTextField.delegate = self;
    [self.view addSubview:_userPhoneNumberTextField];
    [_userPhoneNumberTextField release];
    
    _dropDownView = [[BoxDropDownList alloc]initWithFrame:CGRectMake(14, 84+44+44+5, 290, 41) withListArr:self.groupArr withBlock:^(id sender) {
        self.groupNameStr = (NSString *)sender;
        NSLog(@"------->%@",self.groupNameStr);
    }];
    [self.view addSubview:_dropDownView];
    [_dropDownView release];
    
    
    if (self.user) {
        self.title = self.user.name;
        _userNameTextField.text = self.user.name;
        _userPhoneNumberTextField.text = self.user.phoneNumber;
        _dropDownView.textFieldInput.text = self.user.group;
    }
    
    
}

- (void)completeChangedInfo:(id)sender {
    
    NSString *nameStr = _userNameTextField.text;
    NSString *phoneN = _userPhoneNumberTextField.text;
    
    if ([nameStr length] > 0 && [phoneN length] > 0) {
        if (self.user) {
            _user.name = _userNameTextField.text;
            _user.phoneNumber = _userPhoneNumberTextField.text;
            
            if ([_groupNameStr length] > 0) {
                _user.group = _groupNameStr;
            }
            [_userDB mergeWithUser:self.user];
            
            self.block(nil);
            
//            [self.navigationController popViewControllerAnimated:YES];
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"友情提示" message:@"修改成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }
        
        
    }else{
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"友情提示" message:@"姓名电话不能缺省" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
    }
    
    

    
}


#pragma mark - UITextField Delegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if ([textField isEqual:_userNameTextField]) {
        [_userPhoneNumberTextField becomeFirstResponder];
    }else if([textField isEqual:_userPhoneNumberTextField]){
        [textField resignFirstResponder];
    }else{
        [self.view endEditing:YES];
    }
    return YES;
}



@end
