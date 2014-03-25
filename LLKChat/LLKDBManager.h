//
//  LLKDBManager.h
//  LLKChat
//
//  Created by 管理员 on 14-3-13.
//  Copyright (c) 2014年 Mirror. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LLKUser;
@class LLKMessage;

static NSString * const LLKRecipesStoreName = @"Recipes.sqlite";


typedef NS_ENUM(NSInteger, LLKMessageType) {
    LLKMessageTypeText,
    LLKMessageTypeImage
};

//static NSString * const LLKMessageTypeImageNoSyncURL = @"127.0.0.1";



@interface LLKDBManager : NSObject
+ (instancetype) shared ;
- (void) setup;
- (void) save;
#pragma mark - message
-(LLKMessage*) creatMessageWithType:(LLKMessageType)type value:(NSString*)value fromMe:(BOOL)fromMe user:(LLKUser*)user;
-(NSArray*) findMessagesArrayWithUser:(LLKUser*)user offset:(NSUInteger)offset limit:(NSUInteger)limit;
#pragma mark - user
- (LLKUser*) findUserWithID:(NSString*)userID;
-(LLKUser*) replaceUserWithID:(NSString*)userID iconURL:(NSString*)iconURL name:(NSString*)name ;
#pragma mark - record
- (NSArray*) findAllRecord;
@end
