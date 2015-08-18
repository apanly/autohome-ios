//
//  Global.m
//  autohome
//
//  Created by vincent on 7/14/15.
//  Copyright (c) 2015 vincent. All rights reserved.
//

#import "AppGlobal.h"
#import <UIKit/UIKit.h>

@implementation AppGlobal


+ (float)getAvatarHeight
{
    return 60.0;
}

+ (float)getAvatarWidth
{
    return 60.0;
}

+ (float)getStatusBarHeight
{
    CGRect rectStatus = [[UIApplication sharedApplication] statusBarFrame];
    return rectStatus.size.height;
}

+ (float)getScreenWidth
{
    CGRect r = [ UIScreen mainScreen ].applicationFrame;
    return r.size.width;
}

+ (float)getScreenHeight
{
    CGRect r = [ UIScreen mainScreen ].applicationFrame;
    return r.size.height;
}

+ (float)getSpanWidth
{
    return 60.0;
}

+ (float)getToolBarHeight{
    return 40.0;
}

@end
