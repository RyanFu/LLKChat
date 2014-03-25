//
//  LLKMessagesViewController.m
//  LLKChat
//
//  Created by 管理员 on 14-3-12.
//  Copyright (c) 2014年 Mirror. All rights reserved.
//

#import "LLKMessagesViewController.h"
#import "LLKUser.h"
#import "LLKMessage.h"
#import "LLKDBManager.h"
#import <NYXImagesKit.h>
#import "LLKWebImageManager.h"
#import <SDWebImageManager.h>
#import <objc/runtime.h>

@interface LLKMessagesViewController ()<JSMessagesViewDelegate, JSMessagesViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIActionSheetDelegate>
@property (nonatomic) NSUInteger pageCount;
@property (nonatomic) LLKUser* user;
@property (strong, nonatomic) NSMutableArray *messageArray;
@end

@implementation LLKMessagesViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pageCount = 0;
    
    self.delegate = self;
    self.dataSource = self;
    
    // DATA
    [self loadUser];
    [self loadMessage];
    // UI
    self.title = self.user.name ? self.user.name : self.user.userId;
}

- (UIButton *)sendButton
{
    return [UIButton defaultSendButton];
}

- (JSInputBarStyle)inputBarStyle
{
    /*
     JSInputBarStyleDefault,
     JSInputBarStyleFlat
     
     */
#warning 尝试下各种效果
    return JSInputBarStyleFlat;
}

#pragma mark - private
-(void) loadUser{
    self.user = [[LLKDBManager shared] findUserWithID:self.userID];
    if (!self.user) {
        self.user = [[LLKDBManager shared] replaceUserWithID:self.userID iconURL:nil name:nil];
    }
}

#warning 此页面,应该像微信一样,加载前n条数据,下拉刷新
-(void) loadMessage{
    self.messageArray = [[[LLKDBManager shared] findMessagesArrayWithUser:self.user offset:0 limit:NSUIntegerMax] mutableCopy];
}

//-(void) creatUserIfNotHave{
//    if (!self.user) {
//        self.user = [LLKDBManager creat]
//    }
//}

#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageArray.count;
}

#pragma mark - UIActionSheet Delegate
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    
    switch (buttonIndex) {
        case 0:
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            break;
        case 1:
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            break;
    }
    [self presentViewController:picker animated:YES completion:NULL];
}
#pragma mark - JSMessagesViewDelegate
- (JSBubbleMessageType)messageTypeForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LLKMessage* message = [self.messageArray objectAtIndex:indexPath.row];
    return message.fromMe.boolValue ? JSBubbleMessageTypeOutgoing :JSBubbleMessageTypeIncoming;
}

- (JSBubbleMessageStyle)messageStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
#warning 尝试下各种效果
    return JSBubbleMessageStyleFlat;
}

- (JSBubbleMediaType)messageMediaTypeForRowAtIndexPath:(NSIndexPath *)indexPath{
    LLKMessage* message = [self.messageArray objectAtIndex:indexPath.row];
    if(message.type.integerValue == LLKMessageTypeText){
        return JSBubbleMediaTypeText;
    }else if (message.type.integerValue == LLKMessageTypeImage){
        return JSBubbleMediaTypeImage;
    }
    
    return -1;
}

// 每隔 LLK_MESSAGE_Timestamp 秒 显示一次信息时间
#define LLK_MESSAGE_Timestamp 5 * 60
static char LLKAssociatedKeyTimestamp;

- (BOOL)hasTimestampForRowAtIndexPath:(NSIndexPath *)indexPath{
    LLKMessage* message = [self.messageArray objectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
        objc_setAssociatedObject(message, &LLKAssociatedKeyTimestamp, @(YES), OBJC_ASSOCIATION_RETAIN);
        return YES;
    }
    LLKMessage* lastMessageHasTimestamp = nil;
    for (int i=0;i<indexPath.row;i++) {
        LLKMessage* tempMessage = self.messageArray[indexPath.row -1 -i];
        if ([objc_getAssociatedObject(tempMessage, &LLKAssociatedKeyTimestamp) boolValue]) {
            lastMessageHasTimestamp = tempMessage;
            break;
        }
    }
    if (message.date.doubleValue - lastMessageHasTimestamp.date.doubleValue > LLK_MESSAGE_Timestamp) {
        objc_setAssociatedObject(message, &LLKAssociatedKeyTimestamp, @(YES), OBJC_ASSOCIATION_RETAIN);
        return YES;
    }
    return NO;
}

- (JSMessagesViewTimestampPolicy)timestampPolicy
{
    return JSMessagesViewTimestampPolicyCustom;
}

- (JSMessagesViewAvatarPolicy)avatarPolicy
{
    /*
     JSMessagesViewAvatarPolicyIncomingOnly = 0,
     JSMessagesViewAvatarPolicyBoth,
     JSMessagesViewAvatarPolicyNone
     */
#warning 尝试下各种效果
    return JSMessagesViewAvatarPolicyBoth;
}

- (JSAvatarStyle)avatarStyle
{
    /*
     JSAvatarStyleCircle = 0,
     JSAvatarStyleSquare,
     JSAvatarStyleNone
     */
#warning 尝试下各种效果
    return JSAvatarStyleCircle;
}

- (void)sendPressed:(UIButton *)sender withText:(NSString *)text
{
    LLKMessage* message = [[LLKDBManager shared] creatMessageWithType:LLKMessageTypeText value:text fromMe:YES user:self.user];
    [self.messageArray addObject:message];
    [JSMessageSoundEffect playMessageSentSound];
    [self finishSend];
}

- (void)cameraPressed:(id)sender{
    [self.inputToolBarView.textView resignFirstResponder];
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"相册", nil];
    [actionSheet showInView:self.view];
}

#pragma mark - JSMessagesViewDataSource
- (NSString *)textForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LLKMessage* message = [self.messageArray objectAtIndex:indexPath.row];
    return message.value;
}

- (NSDate *)timestampForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LLKMessage* message = [self.messageArray objectAtIndex:indexPath.row];
    return [NSDate dateWithTimeIntervalSince1970:message.date.doubleValue];
}

- (id)avatarImageForIncomingMessage
{
//    UIImage* image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:self.user.iconURL];
//    if (image) {
//        return image;
//    }else{
//        return [UIImage imageNamed:@"defaultPortrait"];
//    }
    return @[self.user.iconURL,[UIImage imageNamed:@"defaultPortrait"]];
}

#warning 待做 不应该是 固定的 头像
- (UIImage *)avatarImageForOutgoingMessage
{
    return [UIImage imageNamed:@"demo-avatar-jobs"];
}

- (id)dataForRowAtIndexPath:(NSIndexPath *)indexPath{
    LLKMessage* message = [self.messageArray objectAtIndex:indexPath.row];
    if (message.type.integerValue != LLKMessageTypeImage) {
        return nil;
    }
    UIImage* image = [[LLKWebImageManager shared] requestImageWithURL:message.value completedBlock:^(BOOL success, UIImage *image) {
        if (success) {
#warning 待做
            // 刷新UI
        }
    } progressBlock:nil];
    if (image) {
        return image;
    }else{
#warning !!!! 没这个图
        return [UIImage imageNamed:@"loadingImage"];
    }
}

#pragma UIImagePicker Delegate

#pragma mark - Image picker delegate

// 缩略图大小
#define CP_UI_PHOTO_SIZE_THUMBNAIL CGSizeMake(100,100)
// 原始图大小
#define CP_UI_PHOTO_SIZE_BROWSE CGSizeMake(512,512)

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	NSLog(@"Chose image!  Details:  %@", info);
    UIImage* image = [info objectForKey:UIImagePickerControllerEditedImage];
    // 缩放
    image = [image scaleToFitSize:CP_UI_PHOTO_SIZE_BROWSE];
    
    LLKMessage* message = [[LLKDBManager shared] creatMessageWithType:LLKMessageTypeImage value:nil fromMe:YES user:self.user];
    
    [self.messageArray addObject:message];
    
    NSInteger rows = [self.tableView numberOfRowsInSection:0];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:[NSIndexPath indexPathForRow:rows inSection:0]] withRowAnimation:UITableViewRowAnimationBottom];
    [self.tableView endUpdates];
    
    [JSMessageSoundEffect playMessageSentSound];
    
    [self scrollToBottomAnimated:YES];
	
    [self dismissViewControllerAnimated:YES completion:NULL];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:NULL];
    
}

@end
