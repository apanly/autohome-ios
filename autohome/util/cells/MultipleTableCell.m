//
//  MultipleTableCell.m
//  autohome
//
//  Created by vincent on 9/3/15.
//  Copyright (c) 2015 vincent. All rights reserved.
//

#import "MultipleTableCell.h"
#import "BlogFrame.h"

@implementation MultipleTableCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    
    NSString *type = _modelCell.type;
    NSLog(@"%@",type);
    id targetFrame = [BlogFrame DataInit:_modelCell];
    
    [targetFrame view];
    [self.contentView addSubview:[targetFrame view]];
}

@end
