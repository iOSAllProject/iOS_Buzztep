//
//  ChatViewController.h
//  ChatCollectionView

//  Created by Sanchit Thakur on 23/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.

#import <UIKit/UIKit.h>

#import "BTFriendshipModel.h"
#import "BTMessageModel.h"
#import "BTPeopleModel.h"

@interface ChatViewController : UIViewController
{
    NSMutableArray *bubbledata;
    BOOL isfromMe;
}

@property (weak, nonatomic) IBOutlet UICollectionView *chatTable;
@property (weak, nonatomic) IBOutlet UIView *messageInPutView;
@property (weak, nonatomic) IBOutlet UITextField *messageField;
@property (weak, nonatomic) IBOutlet UIView*myView;

@property (strong, nonatomic) NSString* chat_friendShipId;
@property (strong, nonatomic) BTMessageModel* chat_messageModel;
@property (strong, nonatomic) BTPeopleModel* chat_personModel;
@property (atomic, assign)  BOOL    isFromMessageList;
@property (nonatomic, strong) NSString* friendId;
- (IBAction)sendMessageNow:(id)sender;

@end
