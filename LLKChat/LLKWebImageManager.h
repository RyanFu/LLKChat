//
//  LLKWebImageManager.h
//  LLKChat
//
//  Created by 管理员 on 14-3-14.
//  Copyright (c) 2014年 Mirror. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LLKWebImageManager : NSObject
+ (instancetype) shared ;
-(UIImage*) requestImageWithURL:(NSString*)url
                 completedBlock:(void (^)(BOOL success,UIImage* image))completedBlock
                  progressBlock:(void (^)(NSInteger receivedSize, NSInteger expectedSize))progressBlock;
@end
