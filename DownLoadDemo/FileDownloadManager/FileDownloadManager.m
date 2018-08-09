//
//  FileDownloadManager.m
//  GJCommonFoundation
//
//  Created by guojianheng on 2018/8/9.
//  Copyright © 2018年 guojianheng. All rights reserved.
//

#import "FileDownloadManager.h"

NSString *const FileDownloadManagerAttachedInfoKey = @"FileDownloadManagerAttachedInfoKey";

@interface FileDownloadManager ()<BlobDownloaderDelegate>
@property(nonatomic,strong)NSOperationQueue *operationQueue;
@end

@implementation FileDownloadManager

static FileDownloadManager* kSingleObject = nil;

+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        kSingleObject = [[super allocWithZone:NULL] init];
    });
    return kSingleObject;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self sharedInstance];
}

- (id)copy {
    return kSingleObject;
}

#pragma -public method

- (void)addTask:(FileDownloadTask *)task
{
    if (!task) {
        NSLog(@"[%s:%d] no download task !",__FUNCTION__,__LINE__);
        return;
    }
    
    if (![task isValidateForDownload]) {
        return;
    }
    
    if (!_operationQueue) {
        _operationQueue = [[NSOperationQueue alloc] init];
    }
    
    BlobDownloader *downLoader = [[BlobDownloader alloc]initWithURL:[NSURL URLWithString:task.downloadUrl]
                                                   downloadPath:task.FileCachePath
                                                      delegate:self];
    downLoader.fileName = task.fileName;
    NSMutableDictionary *attachedInfo = [NSMutableDictionary dictionary];
    [attachedInfo setObject:task forKey:FileDownloadManagerAttachedInfoKey];
    downLoader.attachedInfo = [attachedInfo copy];
    [_operationQueue addOperation:downLoader];
}

#pragma mark  BlobDownloaderDelegate

- (void)download:(BlobDownloader *)blobDownload didReceiveFirstResponse:(NSURLResponse *)response
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(download:didReceiveFirstResponse:)]) {
        [self.delegate download:blobDownload didReceiveFirstResponse:response];
    }
}

- (void)download:(BlobDownloader *)blobDownload
  didReceiveData:(uint64_t)receivedLength
         onTotal:(uint64_t)totalLength
        progress:(float)progress

{
    if (self.delegate && [self.delegate respondsToSelector:@selector(download:didReceiveData:onTotal:progress:)]) {
        [self.delegate download:blobDownload didReceiveData:receivedLength onTotal:totalLength progress:progress];
    }
}

- (void)download:(BlobDownloader *)blobDownload
didStopWithError:(NSError *)error
{
    if (self.delegate&&[self.delegate respondsToSelector:@selector(download:didStopWithError:)]) {
        [self.delegate download:blobDownload didStopWithError:error];
    }
}

- (void)download:(BlobDownloader *)blobDownload
didFinishWithSuccess:(BOOL)downloadFinished
          atPath:(NSString *)pathToFile
{
    if (self.delegate &&[self.delegate respondsToSelector:@selector(download:didFinishWithSuccess:atPath:)]) {
        [self.delegate download:blobDownload didFinishWithSuccess:downloadFinished atPath:pathToFile];
    }
}

@end
