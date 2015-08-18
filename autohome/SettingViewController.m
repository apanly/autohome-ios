//
//  SettingViewController.m
//  autohome
//
//  Created by vincent on 7/9/15.
//  Copyright (c) 2015 vincent. All rights reserved.
//

#import "SettingViewController.h"
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
    
    [about addObject:@"意见反馈"];
    [about addObject:@"联系我"];
    
    [self.tableData addObject:common];
    [self.tableData addObject:buss];
    [self.tableData addObject:about];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    NSLog(@"1");
    return self.tableData.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"2");
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
    
    NSLog(@"%@",[tmp objectAtIndex:row]);
    cell.textLabel.text = [tmp objectAtIndex:row];
    
    return cell;
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
