//
//  LLKMessage.h
//  LLKChat
//
//  Created by 管理员 on 14-3-14.
//  Copyright (c) 2014年 Mirror. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LLKUser;

@interface LLKMessage : NSManagedObject

@property (nonatomic, retain) NSNumber * date;
@property (nonatomic, retain) NSNumber * sync;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSString * value;
@property (nonatomic, retain) NSNumber * fromMe;
@property (nonatomic, retain) LLKUser *user;

@end
