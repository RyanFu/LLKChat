//
//  LLKUserListViewController.m
//  LLKChat
//
//  Created by 管理员 on 14-3-11.
//  Copyright (c) 2014年 Mirror. All rights reserved.
//

#import "LLKUserListViewController.h"
#import <MZFormSheetController.h>
#import <MZTransition.h>
#import "LLKAddUserViewController.h"
#import "LLKRecord.h"
#import "LLKDBManager.h"
#import "LLKUserListTableViewCell.h"
#import "LLKWebImageManager.h"
#import "LLKMessagesViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface LLKUserListViewController ()<MZFormSheetBackgroundWindowDelegate>
@property (nonatomic) NSMutableArray* recordArray;
@end

@implementation LLKUserListViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    // 导航栏
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd                              target:self action:@selector(addButtonClick:)];
    
    
    // 添加用户 弹窗 设置
    [[MZFormSheetBackgroundWindow appearance] setBackgroundBlurEffect:YES];
//    [[MZFormSheetBackgroundWindow appearance] setBlurRadius:5.0];
//    [[MZFormSheetBackgroundWindow appearance] setBackgroundColor:[UIColor clearColor]];
    
    
    // 加载数据
    [self loadRecord];
}

#pragma mark - private
-(void) loadRecord{
    self.recordArray = [[[LLKDBManager shared] findAllRecord] mutableCopy];
}
-(void) pushMessageControllerWithUserID:(NSString*)userID{
    LLKMessagesViewController* controller = [[LLKMessagesViewController alloc] initWithNibName:nil bundle:nil];
    controller.userID = userID;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Actions

#define LLKAddUserViewController_View_Width 200
#define LLKAddUserViewController_View_Height 108

- (void)addButtonClick:(UIBarButtonItem *)sender
{
    LLKAddUserViewController *vc = [[LLKAddUserViewController alloc] initWithNibName:nil bundle:nil];
    vc.userListController = self;
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:vc];
    
    formSheet.presentedFormSheetSize = CGSizeMake(LLKAddUserViewController_View_Width, LLKAddUserViewController_View_Height);
    //    formSheet.transitionStyle = MZFormSheetTransitionStyleSlideFromTop;
//    formSheet.shadowRadius = 2.0;
//    formSheet.shadowOpacity = 0.3;
    formSheet.shouldDismissOnBackgroundViewTap = YES;
    formSheet.shouldCenterVertically = YES;
    formSheet.movementWhenKeyboardAppears = MZFormSheetWhenKeyboardAppearsCenterVertically;
    // formSheet.keyboardMovementStyle = MZFormSheetKeyboardMovementStyleMoveToTop;
    // formSheet.keyboardMovementStyle = MZFormSheetKeyboardMovementStyleMoveToTopInset;
    // formSheet.landscapeTopInset = 50;
    // formSheet.portraitTopInset = 100;
    
    formSheet.transitionStyle = MZFormSheetTransitionStyleNone;
    
    [MZFormSheetController sharedBackgroundWindow].formSheetBackgroundWindowDelegate = self;
    
    [self mz_presentFormSheetController:formSheet animated:YES completionHandler:^(MZFormSheetController *formSheetController) {
        
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.recordArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];

    if (cell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LLKUserListTableViewCell class]) owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
    
    LLKRecord* record = self.recordArray[indexPath.row];
    LLKUser* user = record.user;
    LLKMessage* message = record.lastMessage;
    
    // 头像
    [(UIImageView*)[cell viewWithTag:10000] setImageWithURL:[NSURL URLWithString:user.iconURL]
                                               placeholderImage:[UIImage imageNamed:@"defaultPortrait"] options:SDWebImageRefreshCached];

//    if (user.iconURL) {
//        UIImage* image = [[LLKWebImageManager shared] requestImageWithURL:user.iconURL completedBlock:^(BOOL success, UIImage *image) {
//            if (success) {
//                [(UIImageView*)[cell viewWithTag:10000] setImage:image];
//                [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
//            }else{
//                [(UIImageView*)[cell viewWithTag:10000] setImage:[UIImage imageNamed:@"errorImage"]];
//            }
//        } progressBlock:nil];
//        if (image) {
//            [(UIImageView*)[cell viewWithTag:10000] setImage:image];
//        }else{
//            [(UIImageView*)[cell viewWithTag:10000] setImage:[UIImage imageNamed:@"defaultPortrait"]];
//        }
//    }else{
//        [(UIImageView*)[cell viewWithTag:10000] setImage:[UIImage imageNamed:@"defaultPortrait"]];
//    }
    
    
    // 姓名
    [(UILabel*)[cell viewWithTag:10001] setText:user.name];
    // 最后一条信息
    if (message.type.intValue == LLKMessageTypeText) {
        [(UILabel*)[cell viewWithTag:10002] setText:message.value];
    }else if (message.type.intValue == LLKMessageTypeImage){
        [(UILabel*)[cell viewWithTag:10002] setText:@"[图片]"];
    }
    // 信息时间
    static NSDateFormatter* df = nil;
    if (!df) {
        df = [[NSDateFormatter alloc] init];
        [df setDateFormat:@"yy-M-d"];
    }
    [(UILabel*)[cell viewWithTag:10003] setText:[df stringFromDate:[NSDate dateWithTimeIntervalSince1970:message.date.doubleValue]]];
    
    return cell;
}

#pragma mark - UITableView

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    LLKRecord* record = self.recordArray[indexPath.row];
    [self pushMessageControllerWithUserID:record.user.userId];
}

#pragma mark - MZFormSheetBackgroundWindowDelegate

- (void)formSheetBackgroundWindow:(MZFormSheetBackgroundWindow *)formSheetBackgroundWindow didChangeStatusBarToOrientation:(UIInterfaceOrientation)orientation
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)formSheetBackgroundWindow:(MZFormSheetBackgroundWindow *)formSheetBackgroundWindow didChangeStatusBarFrame:(CGRect)newStatusBarFrame
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

- (void)formSheetBackgroundWindow:(MZFormSheetBackgroundWindow *)formSheetBackgroundWindow didRotateToOrientation:(UIDeviceOrientation)orientation animated:(BOOL)animated
{
    NSLog(@"%@",NSStringFromSelector(_cmd));
}

@end
