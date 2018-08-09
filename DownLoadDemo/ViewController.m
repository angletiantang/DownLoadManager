//
//  ViewController.m
//  DownLoadDemo
//
//  Created by guojianheng on 2018/8/9.
//  Copyright © 2018年 guojianheng. All rights reserved.
//

#import "ViewController.h"
#import "FileCachePathUtil.h"
#import "FileDownloadTask.h"
#import "FileDownloadManager.h"

@interface ViewController ()<FileDownloadDelegate>

@property (nonatomic , strong) UIImageView * myImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutImageView];
    [self startDownLoadTask];
    
}

- (void)layoutImageView
{
    self.myImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 64, 375, 375)];
    self.myImageView.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:self.myImageView];
}

- (void)startDownLoadTask
{
    // 下载图片的路径
    NSString * downLoadURL = @"https://img.zcool.cn/community/01b34f58eee017a8012049efcfaf50.jpg@1280w_1l_2o_100sh.jpg";
    NSString * fileName = @"5afac68fcdf64ef0a15ee78baa1aeb9e.png";
    NSString * cachePath = [FileCachePathUtil documentDirectoryPath:@"image"];
    NSLog(@"cachePath:%@",cachePath);
    FileDownloadTask * task = [[FileDownloadTask alloc]init];
    task.FileCachePath = cachePath;
    task.fileName = fileName;
    task.downloadUrl = downLoadURL;
    
    FileDownloadManager * manager = [[FileDownloadManager alloc]init];
    manager.delegate = self;
    [manager addTask:task];
}

- (void)download:(BlobDownloader *)blobDownload
didReceiveFirstResponse:(NSURLResponse *)response
{
    NSLog(@"收到第一次请求!");
}

- (void)download:(BlobDownloader *)blobDownload
  didReceiveData:(uint64_t)receivedLength
         onTotal:(uint64_t)totalLength
        progress:(float)progress
{
    
}

- (void)download:(BlobDownloader *)blobDownload
didStopWithError:(NSError *)error
{
    
}

- (void)download:(BlobDownloader *)blobDownload
didFinishWithSuccess:(BOOL)downloadFinished
          atPath:(NSString *)pathToFile
{
    // 下载成功
    NSLog(@"pathToFile:%@",pathToFile);
    NSData * data = [NSData dataWithContentsOfFile:pathToFile];
    self.myImageView.image = [UIImage imageWithData:data];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
