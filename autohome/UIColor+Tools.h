//
//  UIColor+Tools.h
//  HomePolice
//
//  Created by zhulh on 14-11-16.
//  Copyright (c) 2014年 ___ HomePolice___. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Tools)

+ (UIColor *)getThemeColor;
+ (UIColor *)getTableBGColor;
+ (UIColor *)getToolBarColor;
+ (UIColor *)getSelectToolBarColor;
+ (UIColor *)getImageBorderColor;
+ (UIColor *)getStripGrayColor;
+ (UIColor *)getStripGreenColor;

+ (UIColor *) colorWithHexString: (NSString *)color;

@end
