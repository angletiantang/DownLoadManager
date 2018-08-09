//
//  FileDownloadTask.m
//  GJCommonFoundation
//
//  Created by guojianheng on 2018/8/9.
//  Copyright © 2018年 guojianheng. All rights reserved.
//

#import "FileDownloadTask.h"
#import "FileDownloadManager.h"

@interface FileDownloadTask ()

@end

@implementation FileDownloadTask

- (id)init
{
    if (self = [super init]) {
        self.taskState = GJFileDownloadStateNeverBegin;
    }
    return self;
}

+ (NSString *)currentTimeStamp
{
    NSDate *now = [NSDate date];
    NSTimeInterval timeInterval = [now timeIntervalSinceReferenceDate];
    NSString *timeString = [NSString stringWithFormat:@"%lf",timeInterval];
    timeString = [timeString stringByReplacingOccurrencesOfString:@"." withString:@"_"];
    return timeString;
}

/* 任务自检是否能下载 */
- (BOOL)isValidateForDownload
{
    if ([self.downloadUrl isEqualToString:@""]||[self.FileCachePath isEqualToString:@""]||[self.fileName isEqualToString:@""]) {
        NSLog(@"[%s:%d] invalid download task !",__FUNCTION__,__LINE__);
        return NO;
    }
    return YES;
}

- (BOOL)isEqualToTask:(FileDownloadTask *)task
{
    if (!task) {
        return NO;
    }
    if ([task.downloadUrl isEqualToString:self.downloadUrl]) {
        return YES;
    }
     return NO;
}

@end
