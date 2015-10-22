//
//  BlogFrame.h
//  autohome
//
//  Created by vincent on 9/5/15.
//  Copyright (c) 2015 vincent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ModelCell.h"
#import <UIKit/UIKit.h>

@interface BlogFrame : UIView<UITableViewDataSource,UITableViewDelegate>
@property(strong,nonatomic) ModelCell *modelCell;
@property (readonly, nonatomic, strong) UIView *view;

+ (id)DataInit:(ModelCell *)modelCell;
- (id)initWithData:(ModelCell *)modelCell;
@end
