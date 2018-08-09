//
//  FileDownloadTask.h
//  GJCommonFoundation
//
//  Created by guojianheng on 2018/8/9.
//  Copyright © 2018年 guojianheng. All rights reserved.
//

//#import "AFHTTPRequestOperation.h"
#import <Foundation/Foundation.h>

@interface FileDownloadTask : NSObject

/* 下载任务的状态 */
typedef NS_ENUM(NSUInteger, FileDownloadState) {
    
    /* 从来没有执行过这个任务 */
    GJFileDownloadStateNeverBegin = 0,
    
    /* 任务已经执行失败过 */
    GJFileDownloadStateHadFaild = 1,
    
    /* 任务正在执行 */
    GJFileDownloadStateDownloading = 2,
    
    /* 任务执行已经成功 */
    GJFileDownloadStateSuccess = 3,
    
    /* 任务被取消了 */
    GJFileDownloadStateCancel = 4,
};

/* 任务唯一标示 */
@property (nonatomic,readonly)NSString *taskUniqueIdentifier;

/* 任务执行状态 */
@property (nonatomic,assign)FileDownloadState taskState;

/* 下载数据指定缓存路径 */
@property (nonatomic,strong)NSString *FileCachePath;

/* 将要下载文件的路径 */
@property (nonatomic,strong)NSString *downloadUrl;

/* 将要下载文件的名称（要带后缀名） */
@property (nonatomic,strong)NSString *fileName;

/* 用户自定义内容 */
@property (nonatomic,strong)NSDictionary *userInfo;

/* 任务自检是否能下载 */
- (BOOL)isValidateForDownload;

- (BOOL)isEqualToTask:(FileDownloadTask *)task;

@end
