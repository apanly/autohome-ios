//
//  HomeViewController.m
//  autohome
//
//  Created by vincent on 7/9/15.
//  Copyright (c) 2015 vincent. All rights reserved.
//
#import <QuartzCore/QuartzCore.h>
#import "HomeViewController.h"
#import "CustomTableViewCell.h"
#import "Message.h"

static float toolBarHeight  = 40;
static int mode = 1;
static float width = 0;
static float height = 0;

#define LCColor(r, g, b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1.0f]


@interface HomeViewController ()<UITableViewDataSource,UITableViewDelegate,DownSheetDelegate>

@property (strong, nonatomic) UITextField *cmdText;
@property (strong, nonatomic) UIButton *buttonMicp;
@property(strong,nonatomic)UITableView *contentTable;
@property(strong,nonatomic) UIButton *buttonLeft;
@property (strong, nonatomic) UIView *toolBarCenter;

@property(nonatomic, strong)NSMutableArray *contentData;

@property (nonatomic, strong) UIWindow *backWindow;

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"家控";
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.view.backgroundColor = [UIColor whiteColor];
    self.contentData = [[NSMutableArray alloc] init];
    [self initConstant];
    [self initContent];
    [self initToolBar];
    [self registerForKeyboardNotifications];
    //[self initWebview];
    // Do any additional setup after loading the view.
}

- (void)initConstant{
    width = self.view.frame.size.width;
    height = self.view.frame.size.height;
    [self initHelpList];
}

- (void)initContent{
    self.contentTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, width , height -  toolBarHeight) style:UITableViewStylePlain];
    
    self.contentTable.delegate = self;
    self.contentTable.dataSource= self;
    self.contentTable.backgroundColor = [UIColor clearColor];
    self.contentTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,width,10)];
    self.contentTable.tableHeaderView = headerView;
    //[self.contentTable.tableHeaderView removeFromSuperview];

    Message *tip1 = [[Message alloc] initWithText:@"大威猛 英俊潇洒 风流倜傥 人见人爱 花见花开 车见车栽才高八斗，学富五车，玉树临风，英俊潇洒，风流倜傥，貌似潘安，人称一朵梨花压海棠，帅的掉渣，乾坤无敌，迷倒千万少女" type:@"reply"];
    Message *tip2 = [[Message alloc] initWithText:@"你需要做什么" type:@"ask"];
    
    self.contentData = [[NSMutableArray alloc] initWithObjects:tip1,tip2,nil];
    
    [self.view addSubview:self.contentTable];
}



- (void)initToolBar{
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, height - toolBarHeight, width, toolBarHeight) ];
    
    [self initToolBarLeft];
    
    UIBarButtonItem *itemComment = [[UIBarButtonItem alloc] initWithCustomView:self.buttonLeft];
    
    [self initToolBarCenter];
    
    
    UIBarButtonItem *itemTemp = [[UIBarButtonItem alloc] initWithCustomView:self.toolBarCenter];
    
    
    UIButton *help = [[UIButton alloc] initWithFrame:CGRectMake(width - 40 , 0, 40, 30)];
    [help setTitle:@"?" forState:UIControlStateNormal];
    [help setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    help.tag = 3;
    [help addTarget:self action:@selector(viewClick:) forControlEvents:UIControlEventTouchUpInside];

//    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(viewClick:)];
//  
//    [help addGestureRecognizer:tapGesture];如果是UILABEL点击就要加tap
    
    
    
    UIBarButtonItem *itemHelp = [[UIBarButtonItem alloc] initWithCustomView:help];
    
    
    [toolBar setItems:[NSArray arrayWithObjects:itemComment,itemTemp,itemHelp, nil] animated:YES];
    
    [self.view addSubview:toolBar];
}

- (void)initHelpList{
    
    DownSheetModel *Model_1 = [[DownSheetModel alloc]init];
    Model_1.icon = @"icon_add";
    Model_1.icon_on = @"icon_add_hover";
    Model_1.title = @"你可以这么说";
    DownSheetModel *Model_2 = [[DownSheetModel alloc]init];
    Model_2.icon = @"icon_album";
    Model_2.icon_on = @"icon_album_hover";
    Model_2.title = @"\"今天的天气\"";
    DownSheetModel *Model_3 = [[DownSheetModel alloc]init];
    Model_3.icon = @"icon_buy";
    Model_3.icon_on = @"icon_buy_hover";
    Model_3.title = @"\"热门电影\"";
    DownSheetModel *Model_4 = [[DownSheetModel alloc]init];
    Model_4.icon = @"icon_buy";
    Model_4.icon_on = @"icon_buy_hover";
    Model_4.title = @"\"热门歌曲\"";
    
    DownSheetModel *Model_5 = [[DownSheetModel alloc]init];
    Model_5.icon = @"icon_buy";
    Model_5.icon_on = @"icon_buy_hover";
    Model_5.title = @"\"开空调\"";
    
    
    MenuList = [[NSArray alloc]init];
    MenuList = @[Model_1,Model_2,Model_3,Model_4,Model_5];
}

- (void)popHelp{
    if(helpSheet == nil){
        helpSheet = [[DownSheet alloc]initWithlist:MenuList height:0];
        helpSheet.delegate = self;
        [helpSheet showInView:nil];
    }else{
        [helpSheet show];
    }
    
}

- (void)initToolBarLeft{
    
    UIImage *icon_micphone= [UIImage imageNamed:@"icon-micphone.png"];
    UIImage *icon_comment = [UIImage imageNamed:@"icon-comment.png"];

    
    if(!self.buttonLeft){
        CGRect frame= CGRectMake(0, 0, icon_micphone.size.width, icon_micphone.size.height);
        
        UIButton *buttonLeft = [[UIButton alloc] initWithFrame:frame];
        buttonLeft.tag = 3;
        [buttonLeft setBackgroundImage:icon_comment forState:UIControlStateNormal];
        [buttonLeft addTarget:self action:@selector(hideOrShow:) forControlEvents:UIControlEventTouchUpInside];
        self.buttonLeft = buttonLeft;
        return;
    }
    if(mode == 1){
        [self.buttonLeft setBackgroundImage:icon_comment forState:UIControlStateNormal];
    }else{
        [self.buttonLeft setBackgroundImage:icon_micphone forState:UIControlStateNormal];
    }

}

- (void)initToolBarCenter{
    UIImage *icon_micphone= [UIImage imageNamed:@"icon-micphone.png"];
    
    UIView *tmpView = [[UIView alloc] init];
    tmpView.frame = CGRectMake(40, 0, width -100 , 30);
    
    
    UITextField *cmdText = [[UITextField alloc] init];
    cmdText.tag = 1;
    cmdText.frame = CGRectMake(0, 0, width -100 , 30);
    cmdText.placeholder = @"请输入命令";
    cmdText.backgroundColor = [UIColor whiteColor];
    cmdText.borderStyle = UITextBorderStyleRoundedRect;
    cmdText.returnKeyType = UIReturnKeyDone;
    cmdText.hidden = YES;
    
    [cmdText addTarget:self action:@selector(sendCmd) forControlEvents:UIControlEventEditingDidEndOnExit];
    
    //添加手势，点击屏幕其他区域关闭键盘的操作
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidenKeyboard)];
    gesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:gesture];
    
    self.cmdText = cmdText;
    
    UIButton *buttonMicp = [[UIButton alloc] init];
    buttonMicp.frame = CGRectMake(0, 0, width -100 , 30);
    buttonMicp.tag = 2;
    buttonMicp.layer.borderColor = [UIColor whiteColor].CGColor;
    buttonMicp.layer.borderWidth = 1.0;
    buttonMicp.layer.masksToBounds = YES;
    buttonMicp.layer.cornerRadius = buttonMicp.frame.size.height/8;
    
    [buttonMicp setImage: icon_micphone forState:UIControlStateNormal];
    [buttonMicp addTarget:self action:@selector(recodeAudio) forControlEvents:UIControlEventTouchUpInside];
    buttonMicp.hidden = NO;
    
    self.buttonMicp = buttonMicp;
    
    [tmpView addSubview:cmdText];
    [tmpView addSubview:buttonMicp];
    self.toolBarCenter = tmpView;
}


- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillShow:)
     
                                                 name:UIKeyboardWillShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
     
                                             selector:@selector(keyboardWillBeHidden:)
     
                                                 name:UIKeyboardWillHideNotification object:nil];
    
    
}

#pragma mark - UITableView Delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.contentData.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"contentCell";
    
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[CustomTableViewCell alloc] init];
    }
    Message *data = [self.contentData objectAtIndex:indexPath.row];
    cell.data = data;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Message *data = [self.contentData objectAtIndex:indexPath.row ];
    return data.insets.top + data.view.frame.size.height + data.insets.bottom;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}



//实现当键盘出现的时候计算键盘的高度大小。用于输入框显示位置
- (void)keyboardWillShow:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;//得到鍵盤的高度
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //上移xx个单位，按实际情况设置
    CGRect rect=CGRectMake(0.0f,-kbSize.height,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
}


- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    [self hidenKeyboard];
}


//隐藏键盘的方法
-(void)hidenKeyboard
{
    
    [self.cmdText resignFirstResponder];
    NSTimeInterval animationDuration=0.30f;
    [UIView beginAnimations:@"ResizeForKeyboard" context:nil];
    [UIView setAnimationDuration:animationDuration];
    float width = self.view.frame.size.width;
    float height = self.view.frame.size.height;
    //如果当前View是父视图，则Y为20个像素高度，如果当前View为其他View的子视图，则动态调节Y的高度
    CGRect rect=CGRectMake(0.0f,0.0f,width,height);
    self.view.frame=rect;
    [UIView commitAnimations];
}




- (void)hideOrShow:(id)sender{
    UIView *chooseItem = (UIView *) sender;
    switch (chooseItem.tag) {
        case 0:
            break;
        case 1:
            break;
        case 2:
            break;
        case 3:
            
            if ( mode == 1) {
                self.cmdText.hidden = NO;
                self.buttonMicp.hidden = YES;
                mode = 2;
            }else{
                self.cmdText.hidden = YES;
                self.buttonMicp.hidden = NO;
                mode = 1;
            }
            [self initToolBarLeft];
            
            break;
        default:
            break;
    }
}

- (void)viewClick:(id)sender{
    UIView *chooseItem = (UIView *) sender;
    switch (chooseItem.tag) {
        case 0:
            break;
        case 1:
            break;
        case 2:
            break;
        case 3:
            if(helpSheet && helpSheet.isShow){
                [helpSheet hide];
            }else{
                [self popHelp];
            }
            
            break;
        default:
            break;
    }

}

-(void)didSelectIndex:(NSInteger)index{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:[NSString stringWithFormat:@"您当前点击的是第%ld个按钮",index] delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [alert show];
}

- (void)recodeAudio{
    
}

- (void)sendCmd{
    NSString *cmdText = self.cmdText.text;
    if(cmdText.length <= 0){
        return;
    }
    Message *cmd = [Message dataWithText:cmdText type:@"ask"];
    [self.contentData addObject:cmd];
    [self.contentTable reloadData];
    
    self.cmdText.text = @"";
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
