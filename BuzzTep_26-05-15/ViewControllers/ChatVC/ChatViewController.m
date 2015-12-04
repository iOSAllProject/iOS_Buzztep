//
//  ChatViewController.m
//  ChatCollectionView

//  Created by Sanchit Thakur on 23/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.

#import "ChatViewController.h"
#import "MessagesVC.h"
#import "AppDelegate.h"
#import "ChatCollectionViewcell.h"
#import "PARAM_List.h"
#import "iosMacroDefine.h"

#import "BTAPIClient.h"

#import "BTFriendshipModel.h"
#import "BTMessageModel.h"
#import "Constant.h"
#import "MBProgressHUD.h"
#import "Constant.h"

static NSString *CellIdentifier = @"cellIdentifier";

@interface ChatViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,UITextFieldDelegate>

@property (nonatomic, strong) BTFriendshipModel* friendshipList;

- (IBAction)backButton:(id)sender;

- (void) reloadHistoryList;
- (void) addMessageInBubbleList:(BTMessageModel* )message;
- (void) postMessage:(NSString* )message fromMe:(BOOL)fromMe;

@end

@implementation ChatViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.chatTable.delegate=self;
    self.chatTable.dataSource=self;
    self.messageField.delegate=self;
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    bubbledata =[[NSMutableArray alloc]init];
    
    UINib *cellNib = [UINib nibWithNibName:@"View" bundle:nil];
    
    [self.chatTable registerNib:cellNib forCellWithReuseIdentifier:CellIdentifier];
    
    [self SetupDummyMessages];
    
    isfromMe = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [self.chatTable addGestureRecognizer:tap];
    
    self.chatTable.backgroundColor =[UIColor clearColor];
    
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    
    self.messageField.leftView = paddingView;
    self.messageField.leftViewMode = UITextFieldViewModeAlways;
    
    // Do any additional setup after loading the view, typically from a nib.
    
    UISwipeGestureRecognizer *swipeGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeGestureRight)];
    
    swipeGesture.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:swipeGesture];
}

-(void)viewWillAppear:(BOOL)animated
{
    NSDictionary* params = @{@"include" : @[@{@"relation" : @"messages",
                                              @"scope": @{@"order": @"createdOn ASC"}},
                                            @{@"people": @"photo"}]};
    
    NSData *paramsData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
    NSString *paramsStr = [[NSString alloc] initWithData:paramsData encoding:NSUTF8StringEncoding];
    
    NSString* filterQuery = [NSString stringWithFormat:@"filter=%@", paramsStr];
    
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    if (self.chat_friendShipId)
    {
        [[BTAPIClient sharedClient] friendShipHistoryList:@"friendships"
                                         withFriendshipID:self.chat_friendShipId
                                               withFilter:filterQuery
                                                withBlock:^(NSDictionary *model, NSError *error)
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
             
             if (error == Nil)
             {
                 if ([model isKindOfClass:[NSDictionary class]])
                 {
                     self.friendshipList = [[BTFriendshipModel alloc] initFriendshipWithDict:model];
                     
                     [self reloadHistoryList];
                 }
             }
         }];
    }
    else
    {
        [[BTAPIClient sharedClient] friendShipHistoryList:@"friendships"
                                         withFriendshipID:FriendShipID
                                               withFilter:filterQuery
                                                withBlock:^(NSDictionary *model, NSError *error)
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
             
             if (error == Nil)
             {
                 if ([model isKindOfClass:[NSDictionary class]])
                 {
                     self.friendshipList = [[BTFriendshipModel alloc] initFriendshipWithDict:model];
                     
                     [self reloadHistoryList];
                 }
             }
         }];
    }
}

#pragma mark - ReloadMessage & Utility

- (void) reloadHistoryList
{
    DLog(@"Will Reload List here");
    
    DLog(@"%@", self.friendshipList);
    
    // 1. Add server message in UI message list
    
    if (self.friendshipList.friendship_messages)
    {
        NSInteger mCount = [self.friendshipList.friendship_messages count];
        
        if (mCount)
        {
            for (int i =0 ; i < mCount ; i ++)
            {
                BTMessageModel* tMessage = [self.friendshipList.friendship_messages objectAtIndex:i];
                
                [self addMessageInBubbleList:tMessage];
            }
            
            [self.chatTable reloadData];
            
            [self scrollTableview];
        }
    }
    
    // 2. Reload chat view
}

- (void) addMessageInBubbleList:(BTMessageModel* )tMessage
{
    NSString* message_sender = Nil;
    NSString* message_timeStamp = Nil;
    NSString* message_id = Nil;
    
    if ([tMessage.message_createdById isEqualToString:MyPersonModelID])
    {
        message_sender = kSTextByme;
    }
    else
    {
        message_sender = kSTextByOther;
    }
    
    if (tMessage.message_createdOn)
    {
        message_timeStamp = [[AppDelegate SharedDelegate] ParseBTServerTime:tMessage.message_createdOn];
    }
    
    if (tMessage.message_Id)
    {
        message_id = tMessage.message_Id;
    }
    else
    {
        message_id = [self genRandStringLength:24];
    }
    
    if (tMessage.message_text)
    {
        [self adddMediaBubbledata:message_sender
                        mediaPath:tMessage.message_text
                            mtime:message_timeStamp
                            thumb:@""
                   downloadstatus:@""
                    sendingStatus:kBTChatSent
                           msg_ID:message_id];
    }
}

- (void) postMessage:(NSString* )message fromMe:(BOOL)fromMe
{
    NSDictionary* postDict = Nil;
    
    if (fromMe)
    {
        postDict = @{
                     @"text"        : message,
                     @"createdById" : MyPersonModelID,
                     @"toPersonId"  : self.friendId
                     };
    }
    else
    {
        postDict = @{
                     @"text"        : message,
                     @"createdById" : self.friendId,
                     @"toPersonId"  : MyPersonModelID
                     };
    }
    
    NSString* friendShipId = Nil;
    
    if (self.chat_friendShipId)
    {
        friendShipId = self.chat_friendShipId;
    }
    else
    {
        friendShipId = FriendShipID;
    }
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[BTAPIClient sharedClient] postMessageWithFriendShip:@"friendships"
                                         withFriendshipID:friendShipId
                                                 withDict:postDict
                                                withBlock:^(NSDictionary *model, NSError *error)
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        
        if (error == Nil)
        {
            if ([model isKindOfClass:[NSDictionary class]])
            {
                BTMessageModel* serverMsg = [[BTMessageModel alloc] initMessageWithDict:model];
                
                int rowID = (int)bubbledata.count - 1;
                
                PARAM_List *feed_data=[[PARAM_List alloc]init];
                
                feed_data = [bubbledata objectAtIndex:rowID];
                
                [bubbledata  removeObjectAtIndex:rowID];
                
                [self addMessageInBubbleList:serverMsg];
                
                NSArray *indexPaths = [NSArray arrayWithObjects:
                                       [NSIndexPath indexPathForRow:rowID inSection:0],
                                       // Add some more index paths if you want here
                                       nil];
                
                BOOL animationsEnabled = [UIView areAnimationsEnabled];
                
                [UIView setAnimationsEnabled:NO];
                
                [self.chatTable reloadItemsAtIndexPaths:indexPaths];
                
                [UIView setAnimationsEnabled:animationsEnabled];
            }
        }
    }];
}

-(void)handleSwipeGestureRight
{
    MessagesVC *MVC=[self.storyboard instantiateViewControllerWithIdentifier:@"messagesvc"];
    [self.navigationController pushViewController:MVC animated:YES];
    //[self.navigationController popToViewController:MVC animated:YES];
    
}


-(void)dismissKeyboard
{
    [self.view endEditing:YES];
}

// GENERATE RANDOM ID to SAVE IN LOCAL
-(NSString *) genRandStringLength: (int) len
{    
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++)
    {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random() % [letters length]]];
    }
    
    return randomString;
}

// SETUP DUMMY MESSAGE / REPLACE THEM IN LIVE
-(void)SetupDummyMessages
{
    // NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"hh:mm a"];
    
    [self.chatTable reloadData];
}

// UPDATE WHEN MESSAGE SENT

-(void)messageSent:(NSString*)rownum
{
    int rowID=[rownum intValue];
    
    PARAM_List *feed_data=[[PARAM_List alloc]init];
    
    feed_data=[bubbledata objectAtIndex:rowID];
    
    [bubbledata  removeObjectAtIndex:rowID];
    
    feed_data.chat_send_status = kBTChatSent;
    
    [bubbledata insertObject:feed_data atIndex:rowID];
    
    NSArray *indexPaths = [NSArray arrayWithObjects:
                           [NSIndexPath indexPathForRow:rowID inSection:0],
                           // Add some more index paths if you want here
                           nil];
    
    BOOL animationsEnabled = [UIView areAnimationsEnabled];
    
    [UIView setAnimationsEnabled:NO];
    
    [self.chatTable reloadItemsAtIndexPaths:indexPaths];
    
    [UIView setAnimationsEnabled:animationsEnabled];
}

-(void)scrollTableview
{
    NSInteger item = [self collectionView:self.chatTable numberOfItemsInSection:0] - 1;
    
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForItem:item inSection:0];
    
    [self.chatTable scrollToItemAtIndexPath:lastIndexPath
                           atScrollPosition:UICollectionViewScrollPositionBottom
                                   animated:NO];
}

//SEND MESSAGE PRESSED

- (IBAction)sendMessageNow:(id)sender
{
    NSDate *date = [NSDate date];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"hh:mm a"];
    
    if ([self.messageField.text length]>0)
    {
        if (isfromMe)
        {
            [self adddMediaBubbledata:kSTextByme
                            mediaPath:self.messageField.text
                                mtime:[formatter stringFromDate:date]
                                thumb:@""
                       downloadstatus:@""
                        sendingStatus:kBTChatSending
                               msg_ID:[self genRandStringLength:7]];
            
            [self postMessage:self.messageField.text fromMe:isfromMe];
            
            isfromMe = NO;
            
            [self.messageField setText:@""];
            
            
        }
        else
        {
            [self adddMediaBubbledata:kSTextByOther
                            mediaPath:self.messageField.text
                                mtime:[formatter stringFromDate:date]
                                thumb:@""
                       downloadstatus:@""
                        sendingStatus:kBTChatSent
                               msg_ID:[self genRandStringLength:7]];
            
            [self postMessage:self.messageField.text fromMe:isfromMe];
            
            isfromMe=YES;
            
            [self.messageField setText:@""];
        }
        
        [self.chatTable reloadData];
        
        [self scrollTableview];
    }
}


-(void)adddMediaBubbledata:(NSString*)mediaType  mediaPath:(NSString*)mediaPath mtime:(NSString*)messageTime thumb:(NSString*)thumbUrl  downloadstatus:(NSString*)downloadstatus sendingStatus:(NSString*)sendingStatus msg_ID:(NSString*)msgID
{
    PARAM_List *feed_data=[[PARAM_List alloc]init];
    
    feed_data.chat_message=mediaPath;
    feed_data.chat_date_time=messageTime;
    feed_data.chat_media_type=mediaType;
    feed_data.chat_send_status=sendingStatus;
    feed_data.chat_Thumburl=thumbUrl;
    feed_data.chat_downloadStatus=downloadstatus;
    feed_data.chat_messageID=msgID;
    
    [bubbledata addObject:feed_data];
}

///KEYBOARD UPDOWN EVENT

#pragma mark - UITextFieldDelegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (bubbledata.count>2)
    {
        [self performSelector:@selector(scrollTableview) withObject:nil afterDelay:0.0];
    }
    
    CGRect msgframes=self.messageInPutView.frame;
    
    CGRect tableviewframe=self.chatTable.frame;
    msgframes.origin.y=self.view.frame.size.height-260;
    tableviewframe.size.height-=200;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.messageInPutView.frame=msgframes;
        self.chatTable.frame=tableviewframe;
    }];
  
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect msgframes=self.messageInPutView.frame;
    
    CGRect tableviewframe=self.chatTable.frame;
    
    msgframes.origin.y=self.view.frame.size.height - 50;
    tableviewframe.size.height+=200;
    self.chatTable.frame=tableviewframe;
    
    [UIView animateWithDuration:0.25 animations:^{
        self.messageInPutView.frame=msgframes;
    }];
}



-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.view endEditing:YES];
    return YES;
}


#pragma mark -UICollectionView

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    PARAM_List *feed_data=[[PARAM_List alloc]init];
    feed_data=[bubbledata objectAtIndex:indexPath.row];
    
    if ([feed_data.chat_media_type isEqualToString:kSTextByme]||[feed_data.chat_media_type isEqualToString:kSTextByOther])
    {
        
        NSStringDrawingContext *ctx = [NSStringDrawingContext new];
        NSAttributedString *aString = [[NSAttributedString alloc] initWithString:feed_data.chat_message];
        UITextView *calculationView = [[UITextView alloc] init];
        [calculationView setAttributedText:aString];
        CGRect textRect = [calculationView.text boundingRectWithSize: CGSizeMake(TWO_THIRDS_OF_PORTRAIT_WIDTH, 10000000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:calculationView.font} context:ctx];
        
        return CGSizeMake(306,textRect.size.height+40);
    }
    
    
    return CGSizeMake(306, 90);
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return bubbledata.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    ChatCollectionViewcell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.layer.shouldRasterize = YES;
    cell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    dispatch_async(dispatch_get_main_queue(),^
                   {
                       for (UIView *v in [cell.contentView subviews])
                           [v removeFromSuperview];
                       
                       if ([self.chatTable.indexPathsForVisibleItems containsObject:indexPath])
                       {
                           [cell setFeedData:(PARAM_List*)[bubbledata objectAtIndex:indexPath.row]];
                       }
                   });
    return cell;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButton:(id)sender
{
    if (self.isFromMessageList)
    {
        MessagesVC *MVC=[self.storyboard instantiateViewControllerWithIdentifier:@"messagesvc"];
        [self.navigationController pushViewController:MVC animated:YES];
    }
    else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
}
@end
