//
//  LLKServerManager.h
//  LLKChat
//
//  Created by 管理员 on 14-3-13.
//  Copyright (c) 2014年 Mirror. All rights reserved.
//

#import <Foundation/Foundation.h>

// URL
static NSString* const LLKRootURL = @"http://api2.llktop.com";
static NSString* const LLKLoginURLSuffix = @"/user/login";
static NSString* const LLKCheckUserURLSuffix = @"/push/check/user";
static NSString* const LLKSendTextURLSuffix = @"/push/one";

#define LLKLoginURL [NSString stringWithFormat:@"%@%@",LLKRootURL,LLKLoginURLSuffix]
#define LLKCheckUserURL [NSString stringWithFormat:@"%@%@",LLKRootURL,LLKCheckUserURLSuffix]

// UserDefault
static NSString* const LLKUserIDKey = @"LLKUserIDKey";

@interface LLKServerManager : NSObject
+ (instancetype) shared ;
-(void) login;
-(void) checkUser:(NSString*)userID block:(void (^)(BOOL success,NSString* errmsg))block;
@end
