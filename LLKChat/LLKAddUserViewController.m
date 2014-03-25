//
//  LLKAddUserViewController.m
//  LLKChat
//
//  Created by 管理员 on 14-3-13.
//  Copyright (c) 2014年 Mirror. All rights reserved.
//

#import "LLKAddUserViewController.h"
#import <MBProgressHUD.h>
#import "LLKServerManager.h"
#import <TWMessageBarManager.h>
#import <MZFormSheetController.h>
#import "LLKMessagesViewController.h"

@interface LLKAddUserViewController ()
@property (weak, nonatomic) IBOutlet UITextField *userIDTextField;

@end

@implementation LLKAddUserViewController


-(void) viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    // 获取焦点
    [self.userIDTextField becomeFirstResponder];
}

- (IBAction)confirmButtonClick:(id)sender {
    MBProgressHUD* hud = [[MBProgressHUD alloc] initWithView:self.view];
    hud.removeFromSuperViewOnHide = YES;
    [self.view addSubview:hud];
    [hud show:YES];
    
    NSString* userID = self.userIDTextField.text;
    [[LLKServerManager shared] checkUser:userID block:^(BOOL success, NSString *errmsg) {
        [hud hide:YES];
        if (success) {
            [self mz_dismissFormSheetControllerAnimated:NO completionHandler:^(MZFormSheetController *formSheetController) {
                [self.userListController pushMessageControllerWithUserID:userID];
            }];
        }else{
            [[TWMessageBarManager sharedInstance] hideAll];
            [[TWMessageBarManager sharedInstance] showMessageWithTitle:@"NO"
                                                           description:errmsg
                                                                  type:TWMessageBarMessageTypeError];
        }
    } ];
}

@end
