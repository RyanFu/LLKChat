//
//  LLKServerManager.m
//  LLKChat
//
//  Created by 管理员 on 14-3-13.
//  Copyright (c) 2014年 Mirror. All rights reserved.
//

#import "LLKServerManager.h"
#import <ASIHTTPRequest.h>
#import <JSONKit.h>
#import <OpenUDID.h>

@implementation LLKServerManager

+ (instancetype) shared {
    static id _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[self alloc] init];
    });
    
    return _sharedInstance;
}
-(void) login{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 参数设计
        NSMutableDictionary* jsonD = [@{} mutableCopy];
        [jsonD setObject:[OpenUDID value] forKey:@"deviceId"];
        [jsonD setObject:@"IOS_PHONE" forKey:@"terminalType"];
        ASIHTTPRequest* request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:LLKLoginURL]];
        __weak ASIHTTPRequest* weakRequest = request;
        NSLog(@"登录请求参数:%@",jsonD);
        [request setPostBody:[NSMutableData dataWithData:[[jsonD JSONString] dataUsingEncoding:NSUTF8StringEncoding]]];
        [request setCompletionBlock:^{
            NSLog(@"请求完成:%@",weakRequest.responseString);
            NSMutableDictionary* json = [[weakRequest responseString] objectFromJSONStringWithParseOptions:JKParseOptionStrict];
            NSNumber* errorNum = [json objectForKey:@"errno"];
            NSString* errmsg = [json objectForKey:@"errmsg"];
            NSString* userID = [json objectForKey:@"userId"];
            
            NSLog(@"errorNum : %@",errorNum);
            NSLog(@"errmsg: %@",errmsg);
            NSLog(@"userID: %@",userID);
            if (errorNum && errorNum.integerValue == 0) {
                NSLog(@"登录成功,userID from %@ to %@",[[NSUserDefaults standardUserDefaults] objectForKey:LLKUserIDKey],userID);
                [[NSUserDefaults standardUserDefaults] setObject:userID forKey:LLKUserIDKey];
            }else{
                NSLog(@"登录失败: %@",errmsg);
            }
        }];
        [request setFailedBlock:^{
            NSLog(@"请求未完成:%@",weakRequest.responseString);
        }];
        [request startSynchronous];
    });
}
-(void) checkUser:(NSString*)userID block:(void (^)(BOOL success,NSString* errmsg))block{
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 参数设计
        NSMutableDictionary* jsonD = [@{} mutableCopy];
        [jsonD setObject:userID forKey:@"userId"];
        ASIHTTPRequest* request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:LLKCheckUserURL]];
        __weak ASIHTTPRequest* weakRequest = request;
        NSLog(@"检测用户请求参数:%@",jsonD);
        [request setPostBody:[NSMutableData dataWithData:[[jsonD JSONString] dataUsingEncoding:NSUTF8StringEncoding]]];
        [request setCompletionBlock:^{
            NSLog(@"请求完成:%@",weakRequest.responseString);
            NSMutableDictionary* json = [[weakRequest responseString] objectFromJSONStringWithParseOptions:JKParseOptionStrict];
            NSNumber* errorNum = [json objectForKey:@"errno"];
            NSString* errmsg = [json objectForKey:@"errmsg"];
            NSLog(@"errorNum : %@",errorNum);
            NSLog(@"errmsg: %@",errmsg);
            if (errorNum && errorNum.integerValue == 0) {
                NSLog(@"检查成功");
                block(YES,nil);
            }else{
                block(NO,errmsg);
            }
        }];
        [request setFailedBlock:^{
            NSLog(@"请求未完成:%@",weakRequest.responseString);
            block(NO,@"请检查网络");
        }];
        [request startSynchronous];
    });
}

#pragma mark - 做到这里了

//-(void) sendTextWithUserID:(NSString*)userID text:(NSString*)text{
//    dispatch_async(dispatch_get_global_queue(0, 0), ^{
//        // 参数设计
//        NSMutableDictionary* jsonD = [@{} mutableCopy];
//        [jsonD setObject:userID forKey:@"userId"];
//        NSMutableDictionary* data = [@{} mutableCopy];
//        [data setObject:sendId forKey:@"sendId"];
//        
//        
//        [jsonD setObject:userID forKey:@"data"];
//        ASIHTTPRequest* request = [[ASIHTTPRequest alloc] initWithURL:[NSURL URLWithString:LLKCheckUserURL]];
//        __weak ASIHTTPRequest* weakRequest = request;
//        NSLog(@"发送消息请求参数:%@",jsonD);
//        [request setPostBody:[NSMutableData dataWithData:[[jsonD JSONString] dataUsingEncoding:NSUTF8StringEncoding]]];
//        [request setCompletionBlock:^{
//            NSLog(@"请求完成:%@",weakRequest.responseString);
//            NSMutableDictionary* json = [[weakRequest responseString] objectFromJSONStringWithParseOptions:JKParseOptionStrict];
//            NSNumber* errorNum = [json objectForKey:@"errno"];
//            NSString* errmsg = [json objectForKey:@"errmsg"];
//            NSLog(@"errorNum : %@",errorNum);
//            NSLog(@"errmsg: %@",errmsg);
//            if (errorNum && errorNum.integerValue == 0) {
//                NSLog(@"检查成功");
//                block(YES,nil);
//            }else{
//                block(NO,errmsg);
//            }
//        }];
//        [request setFailedBlock:^{
//            NSLog(@"请求未完成:%@",weakRequest.responseString);
//            block(NO,@"请检查网络");
//        }];
//        [request startSynchronous];
//    });
//}
@end
