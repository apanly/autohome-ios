//
//  UIColor+Tools.m
//  HomePolice
//
//  Created by zhulh on 14-11-16.
//  Copyright (c) 2014年 ___ HomePolice___. All rights reserved.
//

#import "UIColor+Tools.h"

#define defaultColor [UIColor whiteColor];

@implementation UIColor (Tools)

+ (UIColor *)getThemeColor
{
    return [UIColor colorWithHexString:@"0xfc9100"];//@"0x7c82f5"];//54575a
}

+ (UIColor *)getTableBGColor
{
    return [UIColor colorWithHexString:@"0xf7f7f7"];
}

+ (UIColor *)getSelectToolBarColor
{
    return [UIColor colorWithHexString:@"0x393c54"];
}

+ (UIColor *)getToolBarColor
{
    return [UIColor colorWithHexString:@"0x444658"];
}

+ (UIColor *)getImageBorderColor
{
    return [UIColor colorWithHexString:@"0xdedede"];
}

+ (UIColor *)getStripGreenColor
{
    return [UIColor colorWithHexString:@"4fdae1"];
}

+ (UIColor *)getStripGrayColor
{
    return [UIColor colorWithHexString:@"aeafb3"];
}

#pragma mark - 颜色转换 IOS中十六进制的颜色转换为UIColor
+ (UIColor *) colorWithHexString: (NSString *)color
{
    NSString *cString = [[color stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return defaultColor;
    }
    
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return defaultColor;
    
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //r
    NSString *rString = [cString substringWithRange:range];
    
    //g
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    //b
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f) green:((float) g / 255.0f) blue:((float) b / 255.0f) alpha:1.0f];
}


@end
