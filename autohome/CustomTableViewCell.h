//
//  CustomTableViewCell.h
//  autohome
//
//  Created by vincent on 7/11/15.
//  Copyright (c) 2015 vincent. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Message.h"

@interface CustomTableViewCell : UITableViewCell
@property(strong,nonatomic) Message *data ;
@end