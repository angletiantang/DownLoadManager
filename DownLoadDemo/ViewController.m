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
    // 设置文件名称
    NSString * fileName = @"5afac68fcdf64ef0a15ee78baa1aeb9e.png";
    // 设置缓存路径
    NSString * cachePath = [FileCachePathUtil documentDirectoryPath:@"image"];
    NSLog(@"cachePath:%@",cachePath);
    // 创建FileDownloadTask对象
    FileDownloadTask * task = [[FileDownloadTask alloc]init];
    // 配置task对象属性
    task.FileCachePath = cachePath;
    task.fileName = fileName;
    task.downloadUrl = downLoadURL;
    task.userInfo = @{@"key1":@"value1",@"key2":@"value2"};
    // 创建FileDownloadManager对象
    FileDownloadManager * manager = [[FileDownloadManager alloc]init];
    // 设置代理
    manager.delegate = self;
    // 将task对象添加进任务队列
    [manager addTask:task];
}

//////////////////// FileDownloadManagerDelegate代理方法
// 收到第一次请求
- (void)download:(BlobDownloader *)blobDownload
didReceiveFirstResponse:(NSURLResponse *)response
{
    NSLog(@"收到第一次请求!");
}
//
- (void)download:(BlobDownloader *)blobDownload
  didReceiveData:(uint64_t)receivedLength
         onTotal:(uint64_t)totalLength
        progress:(float)progress
{
    
}
// 下载失败
- (void)download:(BlobDownloader *)blobDownload
didStopWithError:(NSError *)error
{
    
}
// 下载完成的回调
- (void)download:(BlobDownloader *)blobDownload
didFinishWithSuccess:(BOOL)downloadFinished
          atPath:(NSString *)pathToFile
{
    NSLog(@"pathToFile:%@",pathToFile);
    // 下载成功
    id object = [blobDownload.attachedInfo valueForKey:FileDownloadManagerAttachedInfoKey];
    if ([object isKindOfClass:[FileDownloadTask class]]) {
        FileDownloadTask *task = (FileDownloadTask*)object;
        NSLog(@"userinfo:%@\nfileName:%@\nFileCachePath:%@\ndownloadUrl:%@",task.userInfo,task.fileName,task.FileCachePath,task.downloadUrl);
    }
    
    NSData * data = [NSData dataWithContentsOfFile:pathToFile];
    self.myImageView.image = [UIImage imageWithData:data];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
