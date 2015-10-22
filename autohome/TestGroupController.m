//
//  TestGroupController.m
//  autohome
//
//  Created by vincent on 9/3/15.
//  Copyright (c) 2015 vincent. All rights reserved.
//

#import "TestGroupController.h"
#import "XunFeiViewController.h"
#import "TableStyleViewController.h"
#import "HealthViewController.h"
#import "AppGlobal.h"

@interface TestGroupController ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation TestGroupController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"Alpha";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initTableData];
    
    self.groupTable = [[UITableView alloc] initWithFrame:CGRectMake(0, [AppGlobal getStatusBarHeight], [AppGlobal getScreenWidth], [AppGlobal getScreenHeight]) style:UITableViewStyleGrouped];
    
    self.groupTable.dataSource = self;
    self.groupTable.delegate = self;
    self.groupTable.layer.cornerRadius = 5;
    [self.view addSubview:self.groupTable];

    // Do any additional setup after loading the view.
}

- (void)initTableData{
    
    self.tableData = [[NSMutableArray alloc]initWithCapacity:1];
    
    NSMutableArray *common = [[NSMutableArray alloc]initWithCapacity:1];
    
    [common addObject:@"讯飞语音"];
    [common addObject:@"Table测试"];
    [common addObject:@"健康测试"];
    
    [self.tableData addObject:common];
    
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
    
    static NSString *CellIdentifier = @"testCell";
    
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
        headerLabel.text =  @"语音";
    }
    
    [customView addSubview:headerLabel];
    
    return customView;
}

//别忘了设置高度
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44.0;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    int section = indexPath.section;
    int row = indexPath.row;
    UIViewController *targetView = nil;
    
    switch (section) {
        case 0:
            switch (row) {
                case 0:
                    targetView  = [[XunFeiViewController alloc]init];
                    break;
                case 1:
                    targetView = [[TableStyleViewController alloc] init];
                    break;
                case 2:
                    targetView = [[HealthViewController alloc] init];
                    break;
            
                default:
                    break;
            }
            break;
        case 2:
            switch (row) {
                case 0:
                    
                    break;
                case 1:
                    
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
