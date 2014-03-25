//
//  LLKWebImageManager.m
//  LLKChat
//
//  Created by 管理员 on 14-3-14.
//  Copyright (c) 2014年 Mirror. All rights reserved.
//

#import "LLKWebImageManager.h"
#import <SDWebImageManager.h>

@implementation LLKWebImageManager
+ (instancetype) shared {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}

-(UIImage*) requestImageWithURL:(NSString*)url
             completedBlock:(void (^)(BOOL success,UIImage* image))completedBlock
                   progressBlock:(void (^)(NSInteger receivedSize, NSInteger expectedSize))progressBlock{
    UIImage* image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:url];
    if (image) {
        return image;
    }else{
        // 下载图片
        [[SDWebImageDownloader sharedDownloader] downloadImageWithURL:[NSURL URLWithString:url] options:0 progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            NSLog(@"下载进度%f",receivedSize/(CGFloat)expectedSize);
            if (progressBlock) {
                progressBlock(receivedSize,expectedSize);
            }
        } completed:^(UIImage *image, NSData *data, NSError *error, BOOL finished) {
            if (image && finished){
                NSLog(@"下载文件成功,url:%@",url);
                [[SDImageCache sharedImageCache] storeImage:image forKey:url];
                if (completedBlock) {
                    completedBlock(YES,image);
                }
            }else{
                NSLog(@"下载文件失败,url:%@",url);
                if (completedBlock) {
                    completedBlock(NO,nil);
                }
            }
        }];
    }
    return nil;
}

@end
