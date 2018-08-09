//
//  FileDownloadManager.h
//  GJCommonFoundation
//
//  Created by guojianheng on 2018/8/9.
//  Copyright © 2018年 guojianheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FileDownloadTask.h"
#import "BlobDownload.h"

extern NSString *const FileDownloadManagerAttachedInfoKey;

// 下载管理器代理事件
@protocol FileDownloadDelegate <NSObject>

@optional
// 第一次接收到下载的事件
- (void)download:(BlobDownloader *)blobDownload
didReceiveFirstResponse:(NSURLResponse *)response;
/**
 下载中的状态
 receivedLength ----- 收到的字节长度
 totalLength    ----- 文件字节总长度
 progress       ----- 下载总进度
 */
- (void)download:(BlobDownloader *)blobDownload
  didReceiveData:(uint64_t)receivedLength
         onTotal:(uint64_t)totalLength
        progress:(float)progress;
// 下载失败,返回错误码
- (void)download:(BlobDownloader *)blobDownload
didStopWithError:(NSError *)error;
// 下载完成的代理回调
- (void)download:(BlobDownloader *)blobDownload
didFinishWithSuccess:(BOOL)downloadFinished
          atPath:(NSString *)pathToFile;

@end;

__attribute__((objc_subclassing_restricted))
@interface FileDownloadManager : NSObject

+ (instancetype)sharedInstance;

@property(nonatomic,weak)id<FileDownloadDelegate>delegate;

// 添加下载任务
- (void)addTask:(FileDownloadTask *)task;

@end
