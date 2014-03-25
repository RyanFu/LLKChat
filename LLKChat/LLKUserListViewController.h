//
//  LLKUserListViewController.h
//  LLKChat
//
//  Created by 管理员 on 14-3-11.
//  Copyright (c) 2014年 Mirror. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LLKUserListViewController : UITableViewController
-(void) pushMessageControllerWithUserID:(NSString*)userID;
@end
