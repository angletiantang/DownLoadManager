//
//  BlobDownloadManager.h
//
//  Created by Thibault Charbonnier on 16/04/13.
//  Copyright (c) 2013 Thibault Charbonnier. All rights reserved.
//
#import <Foundation/Foundation.h>

@class BlobDownloader;
@protocol BlobDownloaderDelegate;

/**
 `BlobDownloadManager` is a subclass of `NSOperationQueue` and is used to execute `BlobDownloader` objects.
 
 It provides methods to start and cancel a download, as well as defining a maximum amount of simultaneous downloads.
 
 ## Note
 
 This class should be used as a singleton using the `sharedInstance` method.
 
 @since 1.0
 */
@interface BlobDownloadManager : NSObject

/**
 The default download path for a file if no `customPath` property is set at the creation of the `BlobDownloader` object.
 
 The default value is `/tmp`.
 
 @warning Please be careful of the iOS Data Storage Guidelines when setting the download path.
 
 @since 1.1
 */
@property (nonatomic, copy) NSString *defaultDownloadPath;

/**
 The number of downloads currently in the queue
 
 @since 1.0
 */
@property (nonatomic, assign) NSUInteger downloadCount;

/**
 The number of downloads currently being executed by the queue (currently downloading data).
 
 @since 1.6.0
 */
@property (nonatomic, assign) NSUInteger currentDownloadsCount;

/**
 Creates and returns a `BlobDownloadManager` object. If the singleton has already been created, it just returns the object.
 
 @since 1.5.0
*/
+ (instancetype)sharedInstance;

/**
 Instanciates and runs instantly a `BlobDownloadObject` with the specified URL, an optional customPath and an optional delegate. Runs in background thread the `BlobDownloader` object (a subclass of `NSOperation`) in the `BlobDownloadManager` instance.
 
 This method returns the created `BlobDownloader` object for further use.
 
 @see -initWithURL:downloadPath:delegate:
 
 @param url  The URL of the file to download.
 @param customPathOrNil  An optional path to override the default download path of the `BlobDownloadManager` instance. Can be `nil`.
 @param delegateOrNil  An optional delegate. Can be `nil`.

 @return The created and already running `BlobDownloadObject`.
 
 @since 1.4
*/
- (BlobDownloader *)startDownloadWithURL:(NSURL *)url
                                customPath:(NSString *)customPathOrNil
                                  delegate:(id<BlobDownloaderDelegate>)delegateOrNil;

/**
 Instanciates and runs instantly a `BlobDownloader` object. Provides the same functionalities than `-startDownloadWithURL:customPath:delegate:` but creates a `BlobDownloadObject` using blocks to update your view.
 
 @see -startDownloadWithURL:customPath:delegate:
 
 This method returns the created `BlobDownloader` object for further use.
 
 @see -initWithURL:downloadPath:firstResponse:progress:error:complete:
 
 @param url  The URL of the file to download.
 @param customPathOrNil  An optional path to override the default download path of the `BlobDownloadManager` instance. Can be `nil`.
 @param firstResponseBlock  This block is called when receiving the first response from the server. Can be `nil`.
 @param progressBlock  This block is called on each response from the server while the download is occurring. Can be `nil`. If the remaining time has not been calculated yet, the value is `-1`. @param errorBlock  Called when an error occur during the download. If this block is called, the download will be cancelled just after. Can be `nil`.
 @param completeBlock  Called when the download is completed or cancelled. Can be `nil`. If the download has been cancelled with the parameter `removeFile` set to `YES`, then the `pathToFile` parameter is `nil`. The `BlobDownloader` operation will be removed from `BlobDownloadManager` just after this block is called.
 
 @since 1.4
*/
- (BlobDownloader *)startDownloadWithURL:(NSURL *)url
                                customPath:(NSString *)customPathOrNil
                             firstResponse:(void (^)(NSURLResponse *response))firstResponseBlock
                                  progress:(void (^)(uint64_t receivedLength, uint64_t totalLength, NSInteger remainingTime, float progress))progressBlock
                                     error:(void (^)(NSError *error))errorBlock
                                  complete:(void (^)(BOOL downloadFinished, NSString *pathToFile))completeBlock;

/**
 Starts an already instanciated `BlobDownloader` object.
 
 You can instanciate a `BlobDownloader` object and instead of executing it directly using `-startDownloadWithURL:customPath:delegate:` or the block equivalent, pass it to this method whenever you're ready.
 
 @param download  A `BlobDownloader` object.
 
 @since 1.0
*/
- (void)startDownload:(BlobDownloader *)download;

/**
 Name the underlying `NSOperationQueue`
 
 @param name  Name to give to the `NSOperationQueue`
 
 @since 2.1.0
*/
- (void)setOperationQueueName:(NSString *)name;

/**
 Specifies the default download path. (which is `/tmp` by default)
 
 The path can be non existant, if so, it will be created.
 
 @param pathToDL  The new default path.
 @param error  
 
 @return A boolean that is the result of [NSFileManager createDirFromPath:error:]
 
 @since 1.1
*/
- (BOOL)setDefaultDownloadPath:(NSString *)pathToDL error:(NSError *__autoreleasing *)error;

/**
 Set the maximum number of concurrent downloads allowed. If more downloads are passed to the `BlobDownloadManager` singleton, they will wait for an older one to end before starting.
 
 @param max  The maximum number of downloads.
 
 @since 1.0
*/
- (void)setMaxConcurrentDownloads:(NSInteger)max;

/**
 Cancels all downloads. Remove already downloaded parts of the files from the disk is asked.
 
 @param remove  If `YES`, this method will remove all downloaded files parts from the disk. Files parts are left untouched if set to `NO`. This will allow BlobDownload to restart the download from where it has ended in a future operation.
 
 @since 1.0
*/
- (void)cancelAllDownloadsAndRemoveFiles:(BOOL)remove;

@end
