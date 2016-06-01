//
//  MainViewController.m
//  ZYTestDemo
//
//  Created by Box on 14-3-4.
//  Copyright (c) 2014年 Box. All rights reserved.
//

#import "MainViewController.h"
#import "TopBarView.h"
#import "MYTableView.h"
#import "InfoViewController.h"
#import "UserDB.h"
#import "BoxDropDownList.h"
#import "AddGroupViewController.h"

@interface MainViewController ()<UIScrollViewDelegate,UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate> {
    UIScrollView        *_mainScrollView;
    TopBarView          *_topBar;
    UserDB              *_userDB;
    UITextField         *_userName;
    UITextField         *_phoneNumber;
    NSMutableArray      *_groupMutArray;
    NSMutableArray      *_allUserMutArray;
    NSMutableArray      *_groupTrueData;
}

@property (nonatomic, retain) NSMutableArray *tablesArray;

- (void)changeTableList:(TypeSelected)typeItem;
@end

@implementation MainViewController
@synthesize tablesArray = _tablesArray;

- (void)dealloc {
    self.tablesArray = nil;
    [_groupMutArray release];
    [_allUserMutArray release];
    [_userDB release];
    [super dealloc];
}

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        self.title = @"通讯录";
        _tablesArray = [[NSMutableArray alloc]initWithCapacity:0];
        _allUserMutArray = [[NSMutableArray alloc]initWithCapacity:0];
        _groupMutArray = [[NSMutableArray alloc]initWithCapacity:0];
        _groupTrueData = [[NSMutableArray alloc]initWithCapacity:0];
        _userDB = [[UserDB alloc]init];
        [_userDB createDataBase];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.

    [self initView];
    NSLog(@"====>>%@",NSHomeDirectory());
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Self View Init

- (void)initView {
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self readData];
    
    __block MainViewController *vc = self;
    _topBar = [[TopBarView alloc] initWithFrame:CGRectMake(0, 64, 320, 44) completion:^(TypeSelected typeItem) {
        [vc changeTableList:typeItem];
    }];
    [self.view addSubview:_topBar];
    [_topBar release];
    
    _mainScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 110, 320, self.view.frame.size.height-110)];
    _mainScrollView.delegate = self;
    _mainScrollView.backgroundColor = [UIColor whiteColor];
    _mainScrollView.bounces = NO;
    [_mainScrollView setPagingEnabled:YES];
    _mainScrollView.directionalLockEnabled = YES;
    [_mainScrollView setShowsHorizontalScrollIndicator:NO];
    [_mainScrollView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:_mainScrollView];
    [_mainScrollView release];

    for (int i = 0; i < 3; i++) {
        
        if (i == 0) {
            MYTableView *myTable = [[MYTableView alloc]initWithFrame:CGRectMake(_mainScrollView.frame.origin.x, _mainScrollView.frame.origin.x, _mainScrollView.frame.size.width, _mainScrollView.contentSize.height) style:UITableViewStylePlain];
            myTable.delegate = self;
            myTable.dataSource = self;
            myTable.typeItem = TypeAll;
            [self.tablesArray addObject:myTable];
            [myTable release];
        }else if (i == 1){
            MYTableView *myTable = [[MYTableView alloc]initWithFrame:CGRectMake(_mainScrollView.frame.origin.x, _mainScrollView.frame.origin.x, _mainScrollView.frame.size.width, _mainScrollView.contentSize.height) style:UITableViewStylePlain];
            myTable.delegate = self;
            myTable.dataSource = self;
            myTable.typeItem = TypeGroups;
            [self.tablesArray addObject:myTable];
            [myTable release];
        }else{
            MYTableView *myTable = [[MYTableView alloc]initWithFrame:CGRectMake(_mainScrollView.frame.origin.x, _mainScrollView.frame.origin.x, _mainScrollView.frame.size.width, _mainScrollView.contentSize.height) style:UITableViewStyleGrouped];
            myTable.delegate = self;
            myTable.dataSource = self;
            myTable.typeItem = TypeNew;
            myTable.scrollEnabled = NO;
            [self.tablesArray addObject:myTable];
            [myTable release];
        }
        
        
    }
    
    CGFloat cx = 0;
    NSInteger pages = 0;
    for (int i = 0; i < [self.tablesArray count]; i++) {
        UIView *v = [self.tablesArray objectAtIndex:i];
        CGRect rect = _mainScrollView.frame;
        rect.origin.x = cx;
        rect.origin.y = 0;
        //        rect.size.height = self.view.frame.size.height-44-49;
        v.frame = rect;
        [_mainScrollView addSubview:v];
        cx += 320;
        pages++;
    }
    [_mainScrollView setContentSize:CGSizeMake(320*[self.tablesArray count], self.view.frame.size.height - 110)];
    
    
    for (MYTableView *tab in self.tablesArray) {
        //添加长按手势
        UILongPressGestureRecognizer *longPressGR = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressToDo:)];
        longPressGR.minimumPressDuration = 1.0;
        [tab addGestureRecognizer:longPressGR];
        [longPressGR release];
    }
    
    
}

-(void)longPressToDo:(UILongPressGestureRecognizer *)gesture
{
    if (gesture.state == UIGestureRecognizerStateBegan) {
        
//        CGPoint point = [gesture locationInView:_tableView];
//        _indexPath = [_tableView indexPathForRowAtPoint:point];
//        
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
//                                                        message:NSLocalizedString(@"isDeleteRecord", nil)
//                                                       delegate:self
//                                              cancelButtonTitle:NSLocalizedString(@"cancle", nil)
//                                              otherButtonTitles:NSLocalizedString(@"ok", nil),
//                              nil, nil];
////        alert.tag = kDeleteRecordAlertT;
//        [alert show];
    }
    
}

#pragma mark - RW Data

- (void)readData {
    NSArray *arr = [_userDB getAllUser];
    if ([arr count] > 0) {
        [_allUserMutArray removeAllObjects];
        for (UserInfo *user in arr) {
            DLog(@"%@ %@ %@ %@",user.uid,user.name,user.phoneNumber,user.group);
            [_allUserMutArray addObject:user];
        }
    }
    NSString *fileName = [[NSString alloc]initWithFormat:@"%@/groupsData.plist",FOLDER];
    DLog(@"%@",fileName);
//    DLog(@"%@",fileName);
    BOOL ret = [UserRWFiles isFileWithFN:fileName];
    if (ret) {
        NSArray *array = [NSArray arrayWithContentsOfFile:[UserRWFiles getPathWithFN:fileName]];
        [_groupMutArray removeAllObjects];
        [_groupTrueData removeAllObjects];
        for (NSString *groupName in array) {
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]initWithCapacity:0];
            [dict setObject:groupName forKey:@"GROUPNAME"];
            NSMutableArray *arr = [[NSMutableArray alloc]initWithCapacity:0];
            for (UserInfo *user in _allUserMutArray) {
                if ([groupName isEqualToString:user.group]) {
                    [arr addObject:user];
                }
            }
            [dict setObject:arr forKey:@"USER"];
            [_groupTrueData addObject:dict];
            [_groupMutArray addObject:groupName];
            [dict release];
        }
        
    }
    [fileName release];

    
}

- (void)changeTableList:(TypeSelected)newTypeItem {

    int index = 0;
    
    switch (newTypeItem) {
        case TypeAllPeople:
        {
            index = 0;
            break;
        }
        case TypeGroup:
        {
            index = 1;
            break;
        }
        case TypeNewCreate:
        {
            index = 2;
            break;
        }
        default:
            break;
    }
    
    CGRect frame = _mainScrollView.frame;
    frame.origin.x = 320*index;
    frame.origin.y = 0;
    [_mainScrollView scrollRectToVisible:frame animated:NO];
    
    if (index == 2) {
        UIBarButtonItem *rightItem = [[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"CompleteImage.png"] style:UIBarButtonItemStylePlain target:self action:@selector(completeChangedInfo:)]autorelease];
        rightItem.tag = 2000;
        self.navigationItem.rightBarButtonItem = rightItem;
    }else if (index == 1) {
        UIBarButtonItem *rightItem = [[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"加.png"] style:UIBarButtonItemStylePlain target:self action:@selector(completeChangedInfo:)]autorelease];
        rightItem.tag = 2001;
        self.navigationItem.rightBarButtonItem = rightItem;
    }else
        self.navigationItem.rightBarButtonItem = nil;
    
    [self.view endEditing:YES];
}


#pragma mark - Scroll View Delegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat pageWidth = scrollView.frame.size.width;
    int page = floor((scrollView.contentOffset.x - pageWidth / 2) / pageWidth) + 1;
    
    [_topBar changeFrameWithIndex:page];
    
    if (page == 2) {
        UIBarButtonItem *rightItem = [[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"CompleteImage.png"] style:UIBarButtonItemStylePlain target:self action:@selector(completeChangedInfo:)]autorelease];
        rightItem.tag = 2000;
        self.navigationItem.rightBarButtonItem = rightItem;
    }else if (page == 1) {
        UIBarButtonItem *rightItem = [[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"加.png"] style:UIBarButtonItemStylePlain target:self action:@selector(completeChangedInfo:)] autorelease];
        rightItem.tag = 2001;
        self.navigationItem.rightBarButtonItem = rightItem;
    }else
        self.navigationItem.rightBarButtonItem = nil;
    
    [self.view endEditing:YES];
}

- (void)completeChangedInfo:(UIBarButtonItem *)sender {

    switch (sender.tag) {
        case 2000:
        {
            NSString *nameStr = _userName.text;
            NSString *phoneN = _phoneNumber.text;
            
            if ([nameStr length] > 0 && [phoneN length] > 0) {
                
                UserInfo *user = [[UserInfo alloc] init];
                user.name = nameStr;
                user.phoneNumber = phoneN;
                user.group = @"";
                
                [_userDB saveUser:user];
                [user release];
                
                _userName.text = @"";
                _phoneNumber.text = @"";
                
                [_allUserMutArray removeAllObjects];
                [self readData];
                
                for (MYTableView *tab in self.tablesArray) {
                    [tab reloadData];
                }
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"友情提示" message:@"添加成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                [alert release];
                
            }else{
                UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"友情提示" message:@"姓名电话不能缺省" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
                [alert show];
                [alert release];
            }
            
            
            break;
        }
        case 2001:
        {
            AddGroupViewController *addGroup = [[AddGroupViewController alloc]init:^(id nameGroup) {
//                NSLog(@"---------->%@",(NSString *)nameGroup);
                
                BOOL isHaveGroup = NO;
                
                if ([_groupMutArray count] > 0) {
                    for (NSString *gN in _groupMutArray) {
                        if ([gN isEqualToString:(NSString *)nameGroup]) {
                            isHaveGroup = YES;
                            break;
                        }else{
                            isHaveGroup = NO;
                        }
                    }
                    if (isHaveGroup == NO) {
                        [_groupMutArray addObject:(NSString *)nameGroup];
                        
                        
                        
                        NSString *fileName = [[NSString alloc]initWithFormat:@"%@/groupsData.plist",FOLDER];
                        BOOL ret = [UserRWFiles writeTJData:_groupMutArray withFN:fileName];
                        if (!ret) {
                            NSLog(@"write list json data error");
                        }
                        
//                        NSArray *array = [NSArray arrayWithContentsOfFile:[UserRWFiles getPathWithFN:fileName]];
                        
//                        NSLog(@"array : %@",array);
                        
                        [fileName release];
                        
                        [self readData];
                        
                        for (MYTableView *tab in self.tablesArray) {
                            [tab reloadData];
                        }
                    }
                }else{
                    [_groupMutArray addObject:(NSString *)nameGroup];
                    
                    
                    
                    NSString *fileName = [[NSString alloc]initWithFormat:@"%@/groupsData.plist",FOLDER];
                    BOOL ret = [UserRWFiles writeTJData:_groupMutArray withFN:fileName];
                    if (!ret) {
                        NSLog(@"write list json data error");
                    }
                    [fileName release];
                    
                    [self readData];
                    
                    for (MYTableView *tab in self.tablesArray) {
                        [tab reloadData];
                    }
                }
                
            }];
            [self presentViewController:addGroup animated:YES completion:^{
                
            }];
            [addGroup release];
            break;
        }
        default:
            break;
    }
    
}

#pragma mark - Table Delegate and Data source

- (CGFloat)tableView:(MYTableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat height = 0.0f;
    
    switch (tableView.typeItem) {
        case TypeAll:
        {
            height = 60.0f;
            break;
        }
        case TypeGroups:
        {
            height = 60.0f;
            break;
        }
        case TypeNew:
        {
            height = 400.0f;
            break;
        }
        default:
            break;
    }
    
    return height;
}

- (NSInteger)numberOfSectionsInTableView:(MYTableView *)tableView {
    
    NSInteger number = 0;
    
    switch (tableView.typeItem) {
        case TypeAll:
        {
            number = 1;
            break;
        }
        case TypeGroups:
        {
            if ([_groupMutArray count] > 0) {
                number = [_groupMutArray count];
            }else{
                number = 0;
            }
            break;
        }
        case TypeNew:
        {
            number = 1;
            break;
        }
            
        default:
            break;
    }
    
    return number;
}

- (NSInteger)tableView:(MYTableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger number = 0;
    
    switch (tableView.typeItem) {
        case TypeAll:
        {
            if ([_allUserMutArray count] > 0) {
                number = [_allUserMutArray count];
            }else{
                number = 0;
            }
            
            break;
        }
        case TypeGroups:
        {
            if ([[[_groupTrueData objectAtIndex:section] objectForKey:@"USER"] count] > 0) {
                number = [[[_groupTrueData objectAtIndex:section] objectForKey:@"USER"] count];
            }else{
                number = 0;
            }
            break;
        }
        case TypeNew:
        {
            number = 1;
            break;
        }
        default:
            break;
    }
    
    return number;
}

- (CGFloat)tableView:(MYTableView *)tableView heightForHeaderInSection:(NSInteger)section {
    CGFloat height = 0.0f;
    
    switch (tableView.typeItem) {
        case TypeAll:
        {
            height = 20.0f;
            break;
        }
        case TypeGroups:
        {
            height = 30.0f;
            break;
        }
        case TypeNew:
        {
            height = 20.0f;
            break;
        }
            
        default:
            break;
    }
    
    return height;
}

- (UIView *)tableView:(MYTableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (tableView.typeItem == TypeGroups) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 30)];
        view.backgroundColor = [UIColor whiteColor];
        
        UIImageView *bgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 30, 300, 1)];
        bgView.image = [UIImage imageNamed:@"矩形-15-副本-4.png"];
        [view addSubview:bgView];
        [bgView release];
        
        UILabel *titleLable = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 160, 20)];
        titleLable.font = [UIFont fontWithName:@"Arial" size:16.0];
        
        titleLable.text = [[_groupTrueData objectAtIndex:section] objectForKey:@"GROUPNAME"];
        [view addSubview:titleLable];
        [titleLable release];
        return [view autorelease];
    }
    return nil;
}

- (UITableViewCell *)tableView:(MYTableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellID = nil;
    UITableViewCell *cell = nil;
    
    switch (tableView.typeItem) {
        case TypeAll:
        {
            cellID = @"CellIDAll";
            cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID]autorelease];
            }
            
            UserInfo *user = [_allUserMutArray objectAtIndex:indexPath.row];
            
            cell.textLabel.text = user.name;
            
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            break;
        }
        case TypeGroups:
        {
            cellID = @"CellIDGroups";
            cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID]autorelease];
            }
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
            
            UserInfo *user = [[[_groupTrueData objectAtIndex:indexPath.section] objectForKey:@"USER"]objectAtIndex:indexPath.row];
            cell.textLabel.text = user.name;
            
            
            break;
        }
        case TypeNew:
        {
            /**
             *  这里要改进,这里可以不用 Table 用普通的UIView就可以
             */
            
            cellID = @"CreateNew";
            cell = [tableView dequeueReusableCellWithIdentifier:cellID];
            if (!cell) {
                cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID]autorelease];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;

            UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 400)];
            customView.backgroundColor = [UIColor lightGrayColor];
            
            
            UIImageView *inputView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 10, 295, 189)];
            inputView.image = [UIImage imageNamed:@"设置4输入框.png"];
            
            [customView addSubview:inputView];
            [inputView release];
            
            _userName = [[UITextField alloc]initWithFrame:CGRectMake(14, 10, 290, 41)];
            _userName.placeholder = @"姓名(必填)";
            _userName.clearButtonMode = YES;
            _userName.returnKeyType = UIReturnKeyNext;
            //    _projectInput.secureTextEntry = YES;
            _userName.delegate = self;
            
            [customView addSubview:_userName];
            [_userName release];
            
            _phoneNumber = [[UITextField alloc]initWithFrame:CGRectMake(14, 10+44, 290, 41)];
            _phoneNumber.placeholder = @"电话";
            _phoneNumber.clearButtonMode = YES;
            _phoneNumber.returnKeyType = UIReturnKeyNext;
            //    _projectInput.secureTextEntry = YES;
            _phoneNumber.delegate = self;
            
            [customView addSubview:_phoneNumber];
            [_phoneNumber release];
            
            [cell addSubview:customView];
            [customView release];
            
            break;
        }
            
        default:
        {
            break;
        }
            
    }
    
    return cell;
}

- (BOOL) tableView:(MYTableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
/// 左右滑动所显示的文字
- (NSString *)tableView:(MYTableView *)tableVie titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return @"干掉";
    
}

- (void)tableView:(MYTableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView.typeItem != TypeNew) {
        if (tableView.typeItem == TypeAll) {
            UserInfo *user = [_allUserMutArray objectAtIndex:indexPath.row];
            InfoViewController *infoVC = [[InfoViewController alloc]initWithUser:user withGroups:_groupMutArray completion:^(id message) {
                [_allUserMutArray removeAllObjects];
                [self readData];
                for (MYTableView *tab in self.tablesArray) {
                    [tab reloadData];
                }
            }];
            [self.navigationController pushViewController:infoVC animated:YES];
            [infoVC release];
        }else if(tableView.typeItem == TypeGroups){
            UserInfo *user = [[[_groupTrueData objectAtIndex:indexPath.section] objectForKey:@"USER"] objectAtIndex:indexPath.row];
            InfoViewController *infoVC = [[InfoViewController alloc]initWithUser:user withGroups:_groupMutArray completion:^(id message) {
                
                [self readData];
                for (MYTableView *tab in self.tablesArray) {
                    [tab reloadData];
                }
            }];
            [self.navigationController pushViewController:infoVC animated:YES];
            [infoVC release];
        }

    }
    

}

@end
