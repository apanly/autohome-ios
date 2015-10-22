//
//  MenuViewController.m
//  autohome
//
//  Created by vincent on 7/9/15.
//  Copyright (c) 2015 vincent. All rights reserved.
//
#import "AppDelegate.h"
#import "MenuViewController.h"
#import "HomeViewController.h"
#import "SettingViewController.h"
#import "TestGroupController.h"
#import "CustomScanViewController.h"
#import "WWWViewController.h"
#import "AppGlobal.h"



@interface MenuViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic)UITableView *tableview;
@property(strong,nonatomic)UIView *layer;
@property(nonatomic, strong)NSArray *titles;
@property(strong,nonatomic)HomeViewController *mainSide;
@property(strong,nonatomic)UIColor *layerColor;
@end

@implementation MenuViewController

float avatarViewHeight = 0;
float avatarViewWidth = 0;
float width = 0;
float height = 0;
float margin = 10;



- (void)viewDidLoad {
    [super viewDidLoad];
    
    avatarViewWidth = [AppGlobal getAvatarWidth];
    avatarViewHeight = [AppGlobal getAvatarHeight];

    height = [AppGlobal getScreenHeight];
    width = [AppGlobal getScreenWidth];
    
    self.layerColor = [UIColor colorWithRed:67/255.0f green:67/255.0f blue:76/255.0f alpha:1];
    
    self.layer = [[UIView alloc] init];
    self.layer.backgroundColor = self.layerColor;
    self.layer.frame = CGRectMake(0, [AppGlobal getStatusBarHeight], width - avatarViewWidth, height);
    
    [self.view addSubview:self.layer];
    
    self.titles = @[@"首页",@"扫码",@"博客",@"设置",@"Alpha"];
    self.tableview = [[UITableView alloc]initWithFrame:CGRectMake(0,  avatarViewHeight + margin * 2, width - avatarViewWidth, height - avatarViewWidth - margin * 2) style:UITableViewStylePlain];
    self.tableview.delegate = self;
    self.tableview.dataSource= self;
    self.tableview.backgroundColor = self.layerColor;
    //[self.tableview setSeparatorInset:UIEdgeInsetsZero];
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.layer addSubview:self.tableview];
    
    
    [self initAvatar];
    
}

- (void)initAvatar {
    self.avatarImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatar.png"]];
    
    //self.avatarImage.backgroundColor = self.layerColor;
    self.avatarImage.layer.cornerRadius = avatarViewHeight / 2;
    self.avatarImage.layer.masksToBounds = YES;
    self.avatarImage.frame = CGRectMake(margin, margin, avatarViewWidth, avatarViewHeight);
    
    [self.layer addSubview:self.avatarImage];
    
    UILabel *label_name = [[UILabel alloc] init];
    label_name.text = @"郭大帅哥";
    label_name.tintColor = [UIColor whiteColor];
    label_name.frame = CGRectMake(avatarViewHeight + margin * 2, margin, 100,30);
    
    [label_name setTextColor:[UIColor whiteColor]];
    [self.layer addSubview:label_name];
    
    UILabel *label_sign = [[UILabel alloc] init];
    label_sign.text = @"一路奔跑";
    label_sign.frame = CGRectMake(avatarViewHeight + margin * 2, 30 + margin, 100,30);
    
    [label_sign setTextColor:[UIColor whiteColor]];
    [self.layer addSubview:label_sign];
    
    
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier =@"Cell";
    UITableViewCell *cell = [self.tableview  dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle  reuseIdentifier:CellIdentifier];
        
        cell.textLabel.textColor = [UIColor whiteColor];
        //cell.textLabel.highlightedTextColor = [UIColor blackColor];
        cell.backgroundColor = self.layerColor;
        cell.textLabel.font = [UIFont systemFontOfSize:16];
        
        cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:cell.frame] init];
        cell.selectedBackgroundView.backgroundColor = self.layerColor;
        
        cell.textLabel.text =[NSString stringWithFormat: @"%@", self.titles[indexPath.row]];
        
        if(indexPath.row == 0){
            cell.imageView.image =[UIImage imageNamed:@"icon-home.png"];
        }else if(indexPath.row == 1){
            cell.imageView.image =[UIImage imageNamed:@"icon-scan.png"];
        }else{
            cell.imageView.image =[UIImage imageNamed:@"icon-setting.png"];
        }
        
        
        //[cell setBackgroundView:<#(UIView *)#>];
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50.0f;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    switch (indexPath.row) {
        case 0:
            [self launchHomeView];
            break;
        case 1:
            [self launchScanView];
            break;
        case 2:
            [self launchBlogView];
            break;
        case 3:
            [self launchSettingView];
            break;
        case 4:
            [self launchTestGroup];
            break;
        default:
            break;
    }
}

- (void)launchHomeView {
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    if (!self.mainSide) {
        HomeViewController *mainSide = [[HomeViewController alloc] init];
        self.mainSide = mainSide;
    }
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: _mainSide];
    app.slideMenu.rootViewController = nav;
}

- (void)launchScanView {
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    CustomScanViewController *mainSide = [[CustomScanViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: mainSide];
    app.slideMenu.rootViewController = nav;
}

- (void)launchBlogView {
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    WWWViewController *mainSide = [[WWWViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: mainSide];
    app.slideMenu.rootViewController = nav;
}

- (void)launchSettingView {
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    SettingViewController *mainSide = [[SettingViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: mainSide];
    app.slideMenu.rootViewController = nav;
}

- (void)launchTestGroup {
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    TestGroupController *mainSide = [[TestGroupController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController: mainSide];
    app.slideMenu.rootViewController = nav;
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
