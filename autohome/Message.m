//
//  Message.m
//  autohome
//
//  Created by vincent on 7/11/15.
//  Copyright (c) 2015 vincent. All rights reserved.
//

#import "Message.h"


@implementation Message
const UIEdgeInsets textInsetsMine = {5, 10, 11, 17};
const UIEdgeInsets textInsetsSomeone = {5, 15, 11, 10};

const UIEdgeInsets imageInsetsMine = {11, 13, 16, 22};
const UIEdgeInsets imageInsetsSomeone = {11, 18, 16, 14};


+ (id)dataWithText:(NSString *)text  type:(NSString *)type
{
    return [[Message alloc] initWithText:text type:type];
}


- (id)initWithText:(NSString *)text  type:(NSString *)type
{
    UIFont *font = [UIFont systemFontOfSize:[UIFont systemFontSize]];
    CGSize size = [(text ? text : @"") sizeWithFont:font constrainedToSize:CGSizeMake(220, 9999) lineBreakMode:NSLineBreakByWordWrapping];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height)];
    label.numberOfLines = 0;
    label.lineBreakMode = NSLineBreakByWordWrapping;
    label.text = (text ? text : @"1");
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
    
    
    self.txt = text;
    self.type = type;
    
    _view = label;
    _insets = ( [type isEqualToString:@"reply"] ? textInsetsSomeone : textInsetsMine);
    
    return self;
}




@end
