//
//  BlogFrame.m
//  autohome
//
//  Created by vincent on 9/5/15.
//  Copyright (c) 2015 vincent. All rights reserved.
//

#import "BlogFrame.h"
#import "AppGlobal.h"

@implementation BlogFrame

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

+ (id)DataInit:(ModelCell *)modelCell {
    return [[BlogFrame alloc] initWithData:modelCell];
}

- (id)initWithData:(ModelCell *)modelCell {
    
    _modelCell = modelCell;
    
    NSUInteger count = [_modelCell.data count];
    
    float width = [AppGlobal getScreenWidth];
    
    UITableView *subMenuTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, width - 13, 50 * count) style:UITableViewStylePlain]; //create tableview
    subMenuTableView.tag = 100;
    subMenuTableView.backgroundColor = [UIColor redColor];
    subMenuTableView.delegate = self;
    subMenuTableView.dataSource = self;
    //subMenuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    subMenuTableView.layer.borderColor = UIColor.grayColor.CGColor;
    subMenuTableView.layer.borderWidth = 1.0f;
    subMenuTableView.layer.cornerRadius = 3.0f;
    subMenuTableView.layer.masksToBounds = YES;
    subMenuTableView.scrollEnabled = NO;
    
    subMenuTableView.layer.shadowColor = [[UIColor blackColor] CGColor];
    subMenuTableView.layer.shadowOffset = CGSizeMake(3.0f, 3.0f); // [水平偏移, 垂直偏移]
    subMenuTableView.layer.shadowOpacity = 0.5f; // 0.0 ~ 1.0 的值
    subMenuTableView.layer.shadowRadius = 10.0f; // 陰影發散的程度
    [subMenuTableView setSeparatorInset:UIEdgeInsetsZero];
    [subMenuTableView setLayoutMargins:UIEdgeInsetsZero];
    _view = subMenuTableView;
    
    return self;
}

#pragma mark - UITableView Delegate methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_modelCell.data count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSUInteger row = [indexPath row];
    
    static NSString *CellIdentifier = @"customMessageCell";
    
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault                reuseIdentifier:CellIdentifier];
    }
    
    NSMutableDictionary *data = [_modelCell.data objectAtIndex:row];
    
    NSString  *content = [data objectForKey:@"content"];
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = content;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 50.0;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return NO;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        
        [cell setSeparatorInset:UIEdgeInsetsZero];
        
    }
    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        
        [cell setLayoutMargins:UIEdgeInsetsZero];
        
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}


@end
