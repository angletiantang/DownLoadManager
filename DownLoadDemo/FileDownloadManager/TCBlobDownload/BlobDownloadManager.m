//
//  BlobDownloadManager.m
//
//  Created by Thibault Charbonnier on 16/04/13.
//  Copyright (c) 2013 Thibault Charbonnier. All rights reserved.
//

#import "BlobDownloadManager.h"
#import "BlobDownloader.h"

@interface BlobDownloadManager ()
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@end

@implementation BlobDownloadManager
@dynamic downloadCount;
@dynamic currentDownloadsCount;


#pragma mark - Init


- (instancetype)init
{
    self = [super init];
    if (self) {
        self.operationQueue = [[NSOperationQueue alloc] init];
        self.defaultDownloadPath = [NSString stringWithString:NSTemporaryDirectory()];
    }
    return self;
}

+ (instancetype)sharedInstance
{
    static dispatch_once_t onceToken;
    static id sharedManager = nil;
    dispatch_once(&onceToken, ^{
        sharedManager = [[[self class] alloc] init];
        [sharedManager setOperationQueueName:@"BlobDownloadManager_SharedInstance_Queue"];
    });
    return sharedManager;
}


#pragma mark - BlobDownloader Management


- (BlobDownloader *)startDownloadWithURL:(NSURL *)url
                                customPath:(NSString *)customPathOrNil
                                  delegate:(id<BlobDownloaderDelegate>)delegateOrNil
{
    NSString *downloadPath = customPathOrNil ? customPathOrNil : self.defaultDownloadPath;

    BlobDownloader *downloader = [[BlobDownloader alloc] initWithURL:url
                                                            downloadPath:downloadPath
                                                                delegate:delegateOrNil];
    [self.operationQueue addOperation:downloader];

    return downloader;
}

- (BlobDownloader *)startDownloadWithURL:(NSURL *)url
                                customPath:(NSString *)customPathOrNil
                             firstResponse:(void (^)(NSURLResponse *response))firstResponseBlock
                                  progress:(void (^)(uint64_t receivedLength, uint64_t totalLength, NSInteger remainingTime, float progress))progressBlock
                                     error:(void (^)(NSError *error))errorBlock
                                  complete:(void (^)(BOOL downloadFinished, NSString *pathToFile))completeBlock
{
    NSString *downloadPath = customPathOrNil ? customPathOrNil : self.defaultDownloadPath;

    BlobDownloader *downloader = [[BlobDownloader alloc] initWithURL:url
                                                            downloadPath:downloadPath
                                                           firstResponse:firstResponseBlock
                                                                progress:progressBlock
                                                                   error:errorBlock
                                                                complete:completeBlock];
    [self.operationQueue addOperation:downloader];

    return downloader;
}

- (void)startDownload:(BlobDownloader *)download
{
    [self.operationQueue addOperation:download];
}

- (void)cancelAllDownloadsAndRemoveFiles:(BOOL)remove
{
    for (BlobDownloader *blob in [self.operationQueue operations]) {
        [blob cancelDownloadAndRemoveFile:remove];
    }
}


#pragma mark - Custom Setters


- (void)setOperationQueueName:(NSString *)name
{
    [self.operationQueue setName:name];
}

- (BOOL)setDefaultDownloadPath:(NSString *)pathToDL error:(NSError *__autoreleasing *)error
{
    if ([[NSFileManager defaultManager] createDirectoryAtPath:pathToDL
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:error]) {
        _defaultDownloadPath = pathToDL;
        return YES;
    } else {
        return NO;
    }
}

- (void)setMaxConcurrentDownloads:(NSInteger)maxConcurrent
{
    [self.operationQueue setMaxConcurrentOperationCount:maxConcurrent];
}


#pragma mark - Custom Getters


- (NSUInteger)downloadCount
{
    return [self.operationQueue operationCount];
}

- (NSUInteger)currentDownloadsCount
{
    NSUInteger count = 0;
    for (BlobDownloader *blob in [self.operationQueue operations]) {
        if (blob.state == BlobDownloadStateDownloading) {
            count++;
        }
    }

    return count;
}

@end
