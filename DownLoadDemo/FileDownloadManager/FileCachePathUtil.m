//
//  FileCachePathUtil.m
//  DownLoadDemo
//
//  Created by guojianheng on 2018/8/9.
//  Copyright © 2018年 guojianheng. All rights reserved.
//

#import "FileCachePathUtil.h"

@implementation FileCachePathUtil

+ (NSString *)cacheDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSString *)cacheDirectoryPath:(NSString *)file
{
    if ([file isEqual:[NSNull null]]) {
        return @"";
    }
    else
    {
        if ([file isEqualToString:@""]) {
            return @"";
        }
        else
        {
            return [[FileCachePathUtil cacheDirectory]stringByAppendingPathComponent:file];
        }
    }
}

+ (NSString *)documentDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
}

+ (NSString *)documentDirectoryPath:(NSString *)file
{
    if ([file isEqual:[NSNull null]]) {
        return @"";
    }
    else
    {
        if ([file isEqualToString:@""]) {
            return @"";
        }
        else
        {
            return [[FileCachePathUtil documentDirectory]stringByAppendingPathComponent:file];
        }
    }
}

@end
