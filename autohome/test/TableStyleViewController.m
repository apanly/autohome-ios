//
//  TableStyleViewController.m
//  autohome
//
//  Created by vincent on 9/3/15.
//  Copyright (c) 2015 vincent. All rights reserved.
//

#import "TableStyleViewController.h"
#import "AppGlobal.h"
#import "ModelCell.h"
#import "MultipleTableCell.h"


enum TYPE
{
    article = 1,
    library = 2,
    cmd = 3,
};

enum ACT
{
    reply= 1,
    ask = 2,
};



@interface TableStyleViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    float height;
    float width;
}
@property(strong,nonatomic) UITableView *tablelist;
@property(strong,nonatomic) UIView *layout;
@property(nonatomic, strong)NSMutableArray *tableData;
@end

@implementation TableStyleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Table样式测试";
    [self initConstant];
    [self initUI];
    [self.view addSubview:_layout];
}

- (void) initConstant{
    height = [AppGlobal getScreenHeight] - [AppGlobal getNavigationBarHeight];
    width = [AppGlobal getScreenWidth];
    
    
    NSMutableArray *data = [[NSMutableArray alloc]initWithCapacity:3];
    
    NSMutableArray *messageData1 = [[NSMutableArray alloc] initWithCapacity:2];
    
    NSMutableDictionary *dictionary1 = [NSMutableDictionary dictionaryWithCapacity:3];
    [dictionary1 setObject:@"" forKey:@"icon"];
    [dictionary1 setObject:@"测试1" forKey:@"content"];
    [dictionary1 setObject:@"" forKey:@"images"];
    [messageData1 addObject:dictionary1];
    
    dictionary1 = [NSMutableDictionary dictionaryWithCapacity:3];
    [dictionary1 setObject:@"" forKey:@"icon"];
    [dictionary1 setObject:@"测试1_1" forKey:@"content"];
    [dictionary1 setObject:@"" forKey:@"images"];
    [messageData1 addObject:dictionary1];
    
    dictionary1 = [NSMutableDictionary dictionaryWithCapacity:3];
    [dictionary1 setObject:@"" forKey:@"icon"];
    [dictionary1 setObject:@"测试1_2" forKey:@"content"];
    [dictionary1 setObject:@"" forKey:@"images"];
    [messageData1 addObject:dictionary1];
    
    [data addObject:[ModelCell DataInit:messageData1 act:@"reply" type:@"blog"]];
    
    
    NSMutableArray *messageData2 = [[NSMutableArray alloc] initWithCapacity:2];
    NSMutableDictionary *dictionary2 = [NSMutableDictionary dictionaryWithCapacity:3];
    [dictionary2 setObject:@"" forKey:@"icon"];
    [dictionary2 setObject:@"测试2" forKey:@"content"];
    [dictionary2 setObject:@"" forKey:@"images"];
    [messageData2 addObject:dictionary2];
    [data addObject:[ModelCell DataInit:messageData2 act:@"reply" type:@"blog"]];

    NSMutableArray *messageData3 = [[NSMutableArray alloc] initWithCapacity:2];
    NSMutableDictionary *dictionary3 = [NSMutableDictionary dictionaryWithCapacity:3];
    [dictionary3 setObject:@"" forKey:@"icon"];
    [dictionary3 setObject:@"测试3" forKey:@"content"];
    [dictionary3 setObject:@"" forKey:@"images"];
    [messageData3 addObject:dictionary3];
    [data addObject:[ModelCell DataInit:messageData3 act:@"reply" type:@"blog"]];

    _tableData = data;
}

- (void)initUI {
    
    //用于开关灯操作的button
    UIButton *openButton=[[ UIButton alloc ] initWithFrame : CGRectMake ( 0 , 0 , 50 , 30 )];
    [openButton setTitle : @"添加" forState: UIControlStateNormal ];
    [openButton setTitleColor :[ UIColor blackColor ] forState : UIControlStateNormal ];
    openButton.titleLabel . textAlignment = NSTextAlignmentCenter ;
    openButton.backgroundColor =[ UIColor clearColor ];
    openButton.titleLabel . font =[ UIFont systemFontOfSize : 16.0 ];
    [openButton addTarget : self action : @selector(addNewMessage) forControlEvents : UIControlEventTouchUpInside ];
    
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:openButton];
    
    self.navigationItem.rightBarButtonItem = barItem;
    
    
    _layout = [[UIView alloc] initWithFrame:CGRectMake(0, 64, width, height)];
    _layout.backgroundColor = [UIColor clearColor];
    
    _tablelist = [[UITableView alloc] initWithFrame:CGRectMake(5, 0, width - 5, height) style:UITableViewStyleGrouped];
    
    _tablelist.backgroundColor = [UIColor clearColor];
    _tablelist.delegate = self;
    _tablelist.dataSource = self;
    //_tablelist.scrollEnabled = NO;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,width,10)];
    _tablelist.tableHeaderView = headerView;
    
    _tablelist.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [_layout addSubview:_tablelist];
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (void) addNewMessage{
    
    NSMutableArray *messageData1 = [[NSMutableArray alloc] initWithCapacity:2];
    
    NSMutableDictionary *dictionary1 = [NSMutableDictionary dictionaryWithCapacity:3];
    [dictionary1 setObject:@"" forKey:@"icon"];
    [dictionary1 setObject:@"测试1" forKey:@"content"];
    [dictionary1 setObject:@"" forKey:@"images"];
    [messageData1 addObject:dictionary1];
    
    dictionary1 = [NSMutableDictionary dictionaryWithCapacity:3];
    [dictionary1 setObject:@"" forKey:@"icon"];
    [dictionary1 setObject:@"测试1_1" forKey:@"content"];
    [dictionary1 setObject:@"" forKey:@"images"];
    [messageData1 addObject:dictionary1];
    
    dictionary1 = [NSMutableDictionary dictionaryWithCapacity:3];
    [dictionary1 setObject:@"" forKey:@"icon"];
    [dictionary1 setObject:@"测试1_2" forKey:@"content"];
    [dictionary1 setObject:@"" forKey:@"images"];
    [messageData1 addObject:dictionary1];

    [_tableData  addObject:[ModelCell DataInit:messageData1 act:@"reply" type:@"blog"]];
    
    [_tablelist reloadData];
    [_tablelist scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:([_tableData count] -1 )] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
}

#pragma mark - UITableView Delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return _tableData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    NSUInteger section = [indexPath section];
    
    static NSString *CellIdentifier = @"contentCell";
    
    MultipleTableCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MultipleTableCell alloc] init];
    }
    
    ModelCell *modelCell = [_tableData objectAtIndex:section];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.modelCell = modelCell;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = [indexPath section];
    
    //TableMessage *message = [_tableData objectAtIndex:section ];
    //return message.view.frame.size.height;
    return 50.0f;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0, width, 10)];
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *view=[[UIView alloc] initWithFrame:CGRectZero];
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 1.0f;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
