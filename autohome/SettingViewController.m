//
//  SettingViewController.m
//  autohome
//
//  Created by vincent on 7/9/15.
//  Copyright (c) 2015 vincent. All rights reserved.
//

#import "SettingViewController.h"
#import "APIViewController.h"
#import "AppGlobal.h"

@interface SettingViewController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation SettingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initTableData];
    // Do any additional setup after loading the view.
    self.navigationItem.title = @"设置";
    self.view.backgroundColor = [UIColor whiteColor];
    self.groupTable = [[UITableView alloc] initWithFrame:CGRectMake(0, [AppGlobal getStatusBarHeight], [AppGlobal getScreenWidth], [AppGlobal getScreenHeight]) style:UITableViewStyleGrouped];
    
    self.groupTable.dataSource = self;
    self.groupTable.delegate = self;
    self.groupTable.layer.cornerRadius = 5;
    [self.view addSubview:self.groupTable];
    
}

- (void)initTableData{
    
    self.tableData = [[NSMutableArray alloc]initWithCapacity:3];
    
    NSMutableArray *common = [[NSMutableArray alloc]initWithCapacity:3];
    NSMutableArray *buss = [[NSMutableArray alloc]initWithCapacity:2];
    NSMutableArray *about = [[NSMutableArray alloc]initWithCapacity:2];
    
    [common addObject:@"语音播报"];
    [common addObject:@"启动后自动录音"];
    [common addObject:@"分享设置"];
    
    [buss addObject:@"搜索"];
    [buss addObject:@"地图"];
    [buss addObject:@"API设置"];
    
    [about addObject:@"意见反馈"];
    [about addObject:@"联系我"];
    
    [self.tableData addObject:common];
    [self.tableData addObject:buss];
    [self.tableData addObject:about];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.tableData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSMutableArray  *tmp = [self.tableData objectAtIndex:section];
    return tmp.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    
    static NSString *CellIdentifier = @"settingCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault                reuseIdentifier:CellIdentifier];
    }
    
    NSMutableArray  *tmp = [self.tableData objectAtIndex:section];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [tmp objectAtIndex:row];
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView* customView = [[UIView alloc] initWithFrame:CGRectMake(10.0, 0.0, 300.0, 44.0)];
    
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    headerLabel.backgroundColor = [UIColor clearColor];
    headerLabel.opaque = NO;
    headerLabel.textColor = [UIColor lightGrayColor];
    headerLabel.highlightedTextColor = [UIColor whiteColor];
    headerLabel.font = [UIFont boldSystemFontOfSize:15];
    headerLabel.frame = CGRectMake(10.0, 0.0, 300.0, 44.0);
    
    if (section == 0) {
        headerLabel.text =  @"通用";
    }else if (section == 1){
        headerLabel.text = @"功能业务";
    }else if (section == 2){
        headerLabel.text = @"关于";
    }
    
    [customView addSubview:headerLabel];
    
    return customView;
}

//别忘了设置高度
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0;
}


#pragma mark - UITableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    NSDictionary *settingDictionary = self.setting[indexPath.row];
//    
//    BaseSettingViewController *baseSettingViewController = [[BaseSettingViewController alloc] init];
//    baseSettingViewController.settingDictionary = settingDictionary;
//    baseSettingViewController.title = [settingDictionary valueForKey:XHKControllerTitleKey];
//    
//    APIViewController *api
    //NSLog(@"%ld",indexPath.section);
    int section = indexPath.section;
    int row = indexPath.row;
    UIViewController *targetView = nil;
    
    switch (section) {
        case 1:
            switch (row) {
                case 0:
                    
                    break;
                case 1:
                    break;
                case 2:
                    targetView  = [[APIViewController alloc]init];
                    break;
                    
                default:
                    break;
            }
            break;
            
        default:
            break;
    }
    if (targetView) {
        [self.navigationController pushViewController:targetView animated:NO];
    }else{
        NSLog(@"%i-%i no action",section,row);
    }
    
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
