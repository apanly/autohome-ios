//
//  TableMessage.h
//  autohome
//
//  Created by vincent on 9/3/15.
//  Copyright (c) 2015 vincent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface TableMessage : NSObject <UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic) NSString *type;
@property(strong,nonatomic) NSString *act;
@property(strong,nonatomic) NSMutableArray *data;
@property (readonly, nonatomic, strong) UIView *view; 

- (id)initWithData:(NSMutableArray *)data  act:(NSString *)act type:(NSString *)type;

+ (id)DataInit:(NSMutableArray *)data  act:(NSString *)act type:(NSString *)type;

@end
