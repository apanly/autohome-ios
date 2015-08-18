//
//  Message.h
//  autohome
//
//  Created by vincent on 7/11/15.
//  Copyright (c) 2015 vincent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Message : NSObject
@property(strong,nonatomic) NSString *type;
@property(strong,nonatomic) NSString *txt;
@property (readonly, nonatomic, strong) UIView *view;
@property (readonly, nonatomic) UIEdgeInsets insets;

- (id)initWithText:(NSString *)text  type:(NSString *)type;
+ (id)dataWithText:(NSString *)text  type:(NSString *)type;
@end
