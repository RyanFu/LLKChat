//
//  LLKUser.h
//  LLKChat
//
//  Created by 管理员 on 14-3-14.
//  Copyright (c) 2014年 Mirror. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class LLKMessage;

@interface LLKUser : NSManagedObject

@property (nonatomic, retain) NSString * iconURL;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSSet *messages;
@end

@interface LLKUser (CoreDataGeneratedAccessors)

- (void)addMessagesObject:(LLKMessage *)value;
- (void)removeMessagesObject:(LLKMessage *)value;
- (void)addMessages:(NSSet *)values;
- (void)removeMessages:(NSSet *)values;

@end
