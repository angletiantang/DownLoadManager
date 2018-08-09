//
//  FileCachePathUtil.h
//  DownLoadDemo
//
//  Created by guojianheng on 2018/8/9.
//  Copyright © 2018年 guojianheng. All rights reserved.
//  缓存路径工具

#import <Foundation/Foundation.h>

@interface FileCachePathUtil : NSObject

// cache
+ (NSString *)cacheDirectory;
// cache下的文件路径
+ (NSString *)cacheDirectoryPath:(NSString *)file;
// document
+ (NSString *)documentDirectory;
// document下的文件路径
+ (NSString *)documentDirectoryPath:(NSString *)file;

@end
