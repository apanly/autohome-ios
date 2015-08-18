//
//  CustomTableViewCell.m
//  autohome
//
//  Created by vincent on 7/11/15.
//  Copyright (c) 2015 vincent. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

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
    CGFloat width = self.data.view.frame.size.width;
    CGFloat height = self.data.view.frame.size.height;
    
    CGFloat x = ( [self.data.type isEqualToString:@"reply"]) ? 0 : self.frame.size.width - width - self.data.insets.left - self.data.insets.right;
    CGFloat y = 0;
    
    
    
    UIImageView *bgImage = [[ UIImageView alloc] init];
    [self.contentView addSubview:bgImage];
    
    
    UIView *cellView = self.data.view;
    
    cellView.frame = CGRectMake(x + self.data.insets.left, y + self.data.insets.top, width, height);
    
    [self.contentView addSubview:cellView];
    
    if ( [self.data.type isEqualToString:@"reply"] ) {
        bgImage.image = [[UIImage imageNamed:@"bubbleSomeone.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:14];
    }else{
        bgImage.image = [[UIImage imageNamed:@"bubbleMine.png"] stretchableImageWithLeftCapWidth:21 topCapHeight:14];
    }
    
    bgImage.frame = CGRectMake(x, y, width + self.data.insets.left + self.data.insets.right, height + self.data.insets.top + self.data.insets.bottom);
    
}



@end
