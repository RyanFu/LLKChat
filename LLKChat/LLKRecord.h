//
//  LLKRecord.h
//  LLKChat
//
//  Created by 管理员 on 14-3-14.
//  Copyright (c) 2014年 Mirror. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "LLKUser.h"
#import "LLKMessage.h"

@interface LLKRecord : NSManagedObject

@property (nonatomic, retain) LLKUser *user;
@property (nonatomic, retain) LLKMessage *lastMessage;

@end
