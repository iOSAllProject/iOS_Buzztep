//
//  MessagesVC.m
//  Animation
//
//  Created by Sanchit Thakur on 22/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "MessagesVC.h"
#import "MessagesCustomCell.h"
#import "MessageRecipient.h"
#import "AppDelegate.h"

#import "ChatViewController.h"
#import "AnimationVC.h"
#import "BTAPIClient.h"

#import "BTFriendshipModel.h"
#import "BTMessageModel.h"
#import "BTPeopleModel.h"
#import "Constant.h"
#import "MBProgressHUD.h"

@interface MessagesVC ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

//@property (nonatomic, strong) BTFriendshipModel* friendshipList;

@property(strong,nonatomic) NSMutableArray* friendShipList;
@property(strong,nonatomic) NSMutableArray* messageListArray;

@property(strong,nonatomic)NSArray* imageArray;

- (IBAction)addContactAction:(id)sender;
- (IBAction)animationAction:(id)sender;

- (void) reloadMessageList;
- (BTPeopleModel*) findPersonFromFriendShipe:(BTFriendshipModel* )friendshipModel;

@end

@implementation MessagesVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    self.tableView.estimatedRowHeight = 85.0f;
    
    _friendShipList = [[NSMutableArray alloc] init];
    _messageListArray = [[NSMutableArray alloc] init];
    
    _imageArray = @[@"avatar1", @"avatara", @"avat", @"avatara", @"Dollar", @"avatara", @"avatarBg"];
    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillAppear:(BOOL)animated
{
//    NSDictionary *params = @{ @"include" : @[@{@"relation" : @"messages",
//                                               @"scope" : @{@"order" : @"createdOn DESC",
//                                                            @"limit" : @(1)}},
//                                            @{@"people":@"photo"}],
//                              @"where"   : @{@"or" : @[@{@"friendOne":MyPersonModelID},
//                                                       @{@"friendTwo":MyPersonModelID}]}};
    
    NSDictionary *params = @{ @"include" : @[@{@"relation" : @"messages",
                                               @"scope" : @{@"order" : @"createdOn DESC",
                                                            @"limit" : @(1)}},
                                             @{@"people":@"photo"}]};

    
    NSData *paramsData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
    NSString *paramsStr = [[NSString alloc] initWithData:paramsData encoding:NSUTF8StringEncoding];
    
    NSString* filterQuery = [NSString stringWithFormat:@"filter=%@", paramsStr];
    
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[BTAPIClient sharedClient] messageList:@"people"
                                 withFilter:filterQuery
                                  withBlock:^(NSArray *models, NSError *error)
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        
        if (error == Nil)
        {
            if ([models count] > 0)
            {
                _friendShipList = [[NSMutableArray alloc] init];
                
                for (int i = 0 ; i < [models count] ; i ++)
                {
                    BTFriendshipModel* friendModel = [[BTFriendshipModel alloc] initFriendshipWithLBModel:[models objectAtIndex:i]];
                    
                    [_friendShipList addObject:friendModel];
                }
                
                [self reloadMessageList];
            }
        }
    }];
}

- (void) reloadMessageList
{
    if ([_friendShipList count])
    {
        for (int i = 0 ; i < [_friendShipList count] ; i ++)
        {
            BTFriendshipModel* friendModel = [_friendShipList objectAtIndex:i];
            
            if (friendModel
                && friendModel.friendship_messages
                && [friendModel.friendship_messages count])
            {
                [_messageListArray addObject:[friendModel.friendship_messages firstObject]];
            }
        }
    }
    
    [_tableView reloadData];
    
}

- (BTPeopleModel*) findPersonFromFriendShipe:(BTFriendshipModel* )friendshipModel
{
    BTPeopleModel* retModel = Nil;
    
    BTMessageModel* message = [friendshipModel.friendship_messages firstObject];
    
    if (message.message_createdById)
    {
        for (int i = 0 ; i < [friendshipModel.friendship_peoples count]; i++)
        {
            BTPeopleModel* tPeople = [friendshipModel.friendship_peoples objectAtIndex:i];
            
            if ([tPeople.people_Id isEqualToString:message.message_createdById])
            {
                retModel = tPeople;
                
                break;
            }
        }
    }
    
    return retModel;
}

#pragma mark - UITableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_messageListArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"MessagesCustomCell";
    
    MessagesCustomCell *cell = (MessagesCustomCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MessagesCustomCell" owner:self options:nil];
        
        cell = [nib objectAtIndex:0];
    }
    
    BTFriendshipModel* friendModel = _friendShipList[indexPath.row];
    BTMessageModel* messageModel = [friendModel.friendship_messages firstObject];
    
    [cell initCellWithMessage:messageModel Person:[self findPersonFromFriendShipe:friendModel]];
    
    cell.picImageView.image = [UIImage imageNamed:[_imageArray objectAtIndex:(indexPath.row % [_imageArray count])]];
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ((indexPath.row % 2) == 0)
    {
        cell.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        cell.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 85;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    MessagesCustomCell* selectedCell = (MessagesCustomCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    NSString* message_friendShipId = Nil;
    
    if (selectedCell.cellMessage.message_friendshipId)
    {
        message_friendShipId = selectedCell.cellMessage.message_friendshipId;
        
        ChatViewController *chatVC=[self.storyboard instantiateViewControllerWithIdentifier:@"chat"];
        
        chatVC.chat_friendShipId = message_friendShipId;
        chatVC.chat_messageModel = Nil;
        chatVC.chat_personModel = Nil;
        chatVC.isFromMessageList = YES;
        
        if (selectedCell.cellMessage)
        {
            chatVC.chat_messageModel = selectedCell.cellMessage;
        }
        
        if (selectedCell.cellPerson)
        {
            chatVC.chat_personModel = selectedCell.cellPerson;
        }
        
        
        [self.navigationController pushViewController:chatVC animated:YES];
    }
    else
    {
        [[AppDelegate SharedDelegate] ShowAlert:ApplicationTile
                                 messageContent:@"There is not any history"];
    }
    
}

#pragma mark - IBActions

- (IBAction)addContactAction:(id)sender
{
    MessageRecipient *vc=[self.storyboard instantiateViewControllerWithIdentifier:@"addrecipient"];
    [self.navigationController pushViewController:vc animated:YES];
}

- (IBAction)animationAction:(id)sender {
    AnimationVC *animation=[self.storyboard instantiateViewControllerWithIdentifier:@"AnimationView"];
    [self.navigationController pushViewController:animation animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
