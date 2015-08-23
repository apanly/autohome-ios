//
//  DataHelper.m
//  autohome
//
//  Created by vincent on 8/23/15.
//  Copyright (c) 2015 vincent. All rights reserved.
//

#import "DataHelper.h"

@implementation DataHelper

+ (NSString *)getApiSite
{
    NSString *ret = nil;
    NSString *filePath =[ self getSettingPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if( ![fileManager fileExistsAtPath:filePath] ){
        return ret;
    }
    NSMutableDictionary *data=[NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    ret = [data objectForKey:@"api_url"];
    return ret;
}

+ (NSString *) getSettingPath
{
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,YES);
    NSString *ourDocumentPath =[documentPaths objectAtIndex:0];
    
    NSString *filePath =[ourDocumentPath stringByAppendingPathComponent:@"setting"];
    return filePath;
}

+ (NSString *)getApiLibrarySite
{
    NSString *ret = [self getApiSite];
    if (!ret) {
        ret = @"http://blog.dr.local.com/library/scan";
    }
    ret = [ ret stringByAppendingString:@"/library/scan"];
    return ret;
}

@end
