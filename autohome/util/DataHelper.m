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

+ (NSString *) getHealthSite
{
    //return @"http://api.dr.local.com/upload/health";
    NSString *ret = [self getApiSite];
    if (!ret) {
        ret = @"http://api.vincentguo.cn";
    }
    ret = [ ret stringByAppendingString:@"/upload/health"];
    return ret;
}

+ (NSString *)getApiLibrarySite
{
    NSString *ret = [self getApiSite];
    if (!ret) {
        ret = @"http://api.vincentguo.cn";
    }
    ret = [ ret stringByAppendingString:@"/library/scan"];
    return ret;
}

+ (NSString *)getApiUploadMediaUrl
{
    //return @"http://api.dr.local.com/upload/media";
    NSString *ret = [self getApiSite];
    if (!ret) {
        ret = @"http://api.vincentguo.cn";
    }
    ret = [ ret stringByAppendingString:@"/upload/media"];
    return ret;
}

@end
