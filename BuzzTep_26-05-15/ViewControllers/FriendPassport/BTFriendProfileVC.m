//
//  BTFriendProfileVC.m
//  BUZZtep
//
//  Created by Lin on 6/4/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "BTFriendProfileVC.h"
#import "Following.h"
#import "BuzzCount.h"
#import "NotificationVC2.h"
#import "AddNewBuzzTypeVC.h"
#import "Followers.h"
#import "MyBucketList.h"
#import "ConnectionsVC.h"
#import "CommunityVC.h"
#import "ProjectHandler.h"
#import "AnimationVC.h"
#import "InviteFriendsVC.h"
#import "MyFootprintVC.h"
#import "MyFootprintGlobeVC.h"
#import "ChatViewController.h"
#import "BTFriendPrivacyVC.h"

#import <MobileCoreServices/MobileCoreServices.h>

#import "BTAPIClient.h"

#import "BTFriendshipModel.h"
#import "BTPeopleModel.h"
#import "BTFollowModel.h"
#import "Constant.h"
#import "MBProgressHUD.h"

@interface BTFriendProfileVC ()

// Privacy and Follow

- (IBAction)onFriendPrivacy:(id)sender;
- (IBAction)onFriendFollow:(id)sender;

// Following, BuzzCount and Followed

- (IBAction)onFriendFollowing:(id)sender;
- (IBAction)onFriendBuzzCount:(id)sender;
- (IBAction)onFriendFollowed:(id)sender;

// Buzz, FootPrint and BucketList

- (IBAction)onFriendBuzz:(id)sender;
- (IBAction)onFriendFootPrint:(id)sender;
- (IBAction)onFriendBucketList:(id)sender;

// Milestone, Adventure and Events

- (IBAction)onFriendMilestone:(id)sender;
- (IBAction)onFriendAdventue:(id)sender;
- (IBAction)onFriendEvent:(id)sender;

// Bottom Menu

- (IBAction)onFriendMenu:(id)sender;
- (IBAction)onFriendCall:(id)sender;
- (IBAction)onFriendMessage:(id)sender;

// Load Friend Data

- (void) loadServerData;

// Init UI

- (void) InitUI;

@property (strong, nonatomic) UIStoryboard*     sMainStoryBoard;

@property (strong, nonatomic) IBOutlet UIImageView *profilePicImageView;

@property (strong, nonatomic) IBOutlet UILabel  *lbl_friend_Name;
@property (strong, nonatomic) IBOutlet UILabel  *lbl_friend_Location;

@property (strong, nonatomic) IBOutlet UIButton *btn_friend_following;
@property (strong, nonatomic) IBOutlet UIButton *btn_friend_buzzcount;
@property (strong, nonatomic) IBOutlet UIButton *btn_friend_followers;

@property (strong, nonatomic) IBOutlet UIButton *btn_friend_buzz;
@property (strong, nonatomic) IBOutlet UIButton *btn_friend_footPrint;
@property (strong, nonatomic) IBOutlet UIButton *btn_friend_bucketList;

@property (strong, nonatomic) IBOutlet UIButton *btn_friend_milestones;
@property (strong, nonatomic) IBOutlet UIButton *btn_friend_adventures;
@property (strong, nonatomic) IBOutlet UIButton *btn_friend_events;

@property (strong, nonatomic) IBOutlet UIButton *btn_privacy;
@property (strong, nonatomic) IBOutlet UIButton *btn_follow;
@property (strong, nonatomic) IBOutlet UILabel  *lbl_followState;

@property (assign, atomic)  BOOL    bFollowing;

@property (strong, nonatomic) BTPeopleModel* mPeopleModel;

@end

@implementation BTFriendProfileVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.sMainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    self.profilePicImageView.layer.cornerRadius = self.profilePicImageView.frame.size.width/2;
    self.profilePicImageView.clipsToBounds = YES;
    
    [self setWhiteBorderFor:self.profilePicImageView];
    
    [self setWhiteBorderFor:self.btn_friend_buzz];
    [self setWhiteBorderFor:self.btn_friend_footPrint];
    [self setWhiteBorderFor:self.btn_friend_bucketList];
    
    self.bFollowing = NO;
    
    [self loadServerData];
    
}

- (void)setWhiteBorderFor:(UIView*)view
{
    view.layer.borderWidth = 2.0;
    view.layer.borderColor = [UIColor whiteColor].CGColor;
}

#pragma mark - IBActioins

// Privacy and Follow

- (IBAction)onFriendPrivacy:(id)sender
{
    // Open Privacy Setting View
    
    BTFriendPrivacyVC *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"BTFriendPrivacyVC"];
    
    vc.modalPresentationStyle = UIModalPresentationCustom;
    
    [self presentViewController:vc animated:YES completion:nil];
    
}

- (IBAction)onFriendFollow:(id)sender
{
    // Call API to follow or unfollow
    
    NSDictionary* followDict = @{
                                 @"followerId" : MyPersonModelID,
                                 @"followedId" : self.friendId
                                 };
    
    if (self.bFollowing)
    {
        NSDictionary *params = @{@"where" : @{@"followedId": self.friendId}};
        
        NSData *paramsData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
        NSString *paramsStr = [[NSString alloc] initWithData:paramsData encoding:NSUTF8StringEncoding];
        
        NSString* filterQuery = [NSString stringWithFormat:@"filter=%@", paramsStr];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [[BTAPIClient sharedClient] getFollowPeople:(NSString* )@"people"
                                       withPersonId:(NSString* )self.friendId
                                         withFilter:(NSString* )filterQuery
                                          withBlock:^(NSArray* models, NSError* error)
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
             
             if (error == Nil)
             {
                 if ([models isKindOfClass:[NSArray class]])
                 {
                     DLog(@"%@", models);
                     
                     if ([models count] >= 1)
                     {
                         BTFollowModel* follow_model = [[BTFollowModel alloc] initFollowWithDict:[models firstObject]];
                         
                         [[BTAPIClient sharedClient] unfollow:follow_model.follow_ID
                                                    withBlock:^(NSDictionary *model, NSError *error)
                         {
                             if (error == Nil)
                             {
                                 [self.btn_follow setImage:[UIImage imageNamed:@"friend_passport_follow"]
                                                  forState:UIControlStateNormal];
                                 
                                 [self.lbl_followState setText:@"FOLLOW?"];
                                 
                                 self.bFollowing = NO;
                             }
                         }];
                     }
                 }
             }
         }];
    }
    else
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [[BTAPIClient sharedClient] followPeople:@"follow"
                                    withPostDict:followDict
                                       withBlock:^(NSDictionary *model, NSError *error)
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
            
            if (error == Nil)
            {
                DLog(@"%@", model);
                
                [self.btn_follow setImage:[UIImage imageNamed:@"friend_passport_followed"] forState:UIControlStateNormal];
                [self.lbl_followState setText:@"FOLLOWING"];
                
                self.bFollowing = YES;
            }
        }];
    }
}

// Following, BuzzCount and Followed

- (IBAction)onFriendFollowing:(id)sender
{
    
}

- (IBAction)onFriendBuzzCount:(id)sender
{
    
}

- (IBAction)onFriendFollowed:(id)sender
{
    
}

- (IBAction)onFriendMenu:(id)sender
{
    AnimationVC *animation =[self.sMainStoryBoard instantiateViewControllerWithIdentifier:@"AnimationView"];
    
    [self.navigationController pushViewController:animation animated:YES];
}

// Buzz, FootPrint and BucketList

- (IBAction)onFriendBuzz:(id)sender
{
    
}

- (IBAction)onFriendFootPrint:(id)sender
{
    
}

- (IBAction)onFriendBucketList:(id)sender
{
    
}

// Milestone, Adventure and Events

- (IBAction)onFriendMilestone:(id)sender
{
    UIButton* clickedButton  = (UIButton*)sender;
    
    BuzzCount *buzzCount=[self.sMainStoryBoard instantiateViewControllerWithIdentifier:@"buzzcount"];
    buzzCount.selectedIndex = clickedButton.tag;
    [self.navigationController pushViewController:buzzCount animated:YES];
}

- (IBAction)onFriendAdventue:(id)sender
{
    UIButton* clickedButton  = (UIButton*)sender;
    
    BuzzCount *buzzCount=[self.sMainStoryBoard instantiateViewControllerWithIdentifier:@"buzzcount"];
    buzzCount.selectedIndex = clickedButton.tag;
    [self.navigationController pushViewController:buzzCount animated:YES];
}

- (IBAction)onFriendEvent:(id)sender
{
    UIButton* clickedButton  = (UIButton*)sender;
    
    BuzzCount *buzzCount=[self.sMainStoryBoard instantiateViewControllerWithIdentifier:@"buzzcount"];
    buzzCount.selectedIndex = clickedButton.tag;
    [self.navigationController pushViewController:buzzCount animated:YES];
}

// Bottom Menu

- (IBAction)onFriendCall:(id)sender
{
    NSString *phoneNumber = [@"telprompt://" stringByAppendingString:@"+14145875335"];
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
}

- (IBAction)onFriendMessage:(id)sender
{
    ChatViewController *chatVC=[self.sMainStoryBoard instantiateViewControllerWithIdentifier:@"chat"];
    
    chatVC.chat_friendShipId = FriendShipID;
    chatVC.chat_messageModel = Nil;
    chatVC.chat_personModel = Nil;
    chatVC.isFromMessageList = NO;
    
    [self.navigationController pushViewController:chatVC animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

#pragma mark - Utility Function

- (void)loadServerData
{
    NSDictionary *params = @{@"where":@{@"id":self.friendId}};
    
    NSData *paramsData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
    NSString *paramsStr = [[NSString alloc] initWithData:paramsData encoding:NSUTF8StringEncoding];
    
    NSString* filterQuery = [NSString stringWithFormat:@"filter=%@", paramsStr];
    
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[BTAPIClient sharedClient] getPeople:@"people"
                               withFilter:filterQuery
                                  withBlock:^(NSArray *models, NSError *error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
         
         if (error == Nil)
         {
             if ([models count] == 1)
             {
                 if ([[models firstObject] isKindOfClass:[NSDictionary class]])
                 {
                     self.mPeopleModel = [[BTPeopleModel alloc] initPeopleWithDict:[models firstObject]];
                     
                     [self InitUI];
                 }
             }
         }
     }];
    
    // Check follow state
    
    NSDictionary *follow_params = @{@"where" : @{@"followedId": self.friendId}};
    
    NSData *follow_paramsData = [NSJSONSerialization dataWithJSONObject:follow_params options:0 error:nil];
    NSString *follow_paramsStr = [[NSString alloc] initWithData:follow_paramsData encoding:NSUTF8StringEncoding];
    
    NSString* follow_filterQuery = [NSString stringWithFormat:@"filter=%@", follow_paramsStr];
    
    [[BTAPIClient sharedClient] getFollowPeople:(NSString* )@"people"
                                   withPersonId:(NSString* )MyPersonModelID
                                     withFilter:(NSString* )follow_filterQuery
                                      withBlock:^(NSArray* models, NSError* error)
     {
         if (error == Nil)
         {
             if ([models count] > 0)
             {
                 [self.btn_follow setImage:[UIImage imageNamed:@"friend_passport_followed"] forState:UIControlStateNormal];
                 [self.lbl_followState setText:@"FOLLOWING"];
                 
                 self.bFollowing = YES;
             }
             else
             {
                 [self.btn_follow setImage:[UIImage imageNamed:@"friend_passport_follow"]
                                  forState:UIControlStateNormal];
                 
                 [self.lbl_followState setText:@"FOLLOW?"];
                 
                 self.bFollowing = NO;
             }
         }
     }];
}

- (void) InitUI
{
    if (self.mPeopleModel)
    {
        DLog(@"%@", self.mPeopleModel);

        // Name and Location
        
        NSString* name = @"";
        
        if (self.mPeopleModel.people_identity)
        {
            if ([self.mPeopleModel.people_identity objectForKeyedSubscript:@"firstName"])
            {
                if ([self.mPeopleModel.people_identity objectForKeyedSubscript:@"lastName"])
                {
                    name = [NSString stringWithFormat:@"%@ %@", [self.mPeopleModel.people_identity objectForKeyedSubscript:@"firstName"], [self.mPeopleModel.people_identity objectForKeyedSubscript:@"lastName"]];
                }
                else
                {
                    name = [NSString stringWithFormat:@"%@", [self.mPeopleModel.people_identity objectForKeyedSubscript:@"firstName"]];
                }
            }
            else
            {
                if ([self.mPeopleModel.people_identity objectForKeyedSubscript:@"lastName"])
                {
                    name = [NSString stringWithFormat:@"%@", [self.mPeopleModel.people_identity objectForKeyedSubscript:@"lastName"]];
                }
                else
                {
                    name = [NSString stringWithFormat:@"%@", @"Killer"];
                }
            }
        }
        
        self.lbl_friend_Name.text = name;
        
        // How can we get the friend's location?
        
        if (self.mPeopleModel.people_statistics)
        {
            // Following, BuzzCount and Followers
            
            if ([self.mPeopleModel.people_statistics objectForKeyedSubscript:@"followingCount"])
            {
                NSNumber* followingCount = [self.mPeopleModel.people_statistics objectForKeyedSubscript:@"followingCount"];
                
                NSString* followingCountStr = [NSString stringWithFormat:@"%d", [followingCount intValue]];
                
                [self.btn_friend_following setTitle:followingCountStr forState:UIControlStateNormal];
            }
            else
            {
                [self.btn_friend_following setTitle:@"0" forState:UIControlStateNormal];
            }
            
            if ([self.mPeopleModel.people_statistics objectForKeyedSubscript:@"buzzCount"])
            {
                NSNumber* buzzCount = [self.mPeopleModel.people_statistics objectForKeyedSubscript:@"buzzCount"];
                
                NSString* buzzCountStr = [NSString stringWithFormat:@"%d", [buzzCount intValue]];
                
                [self.btn_friend_buzzcount setTitle:buzzCountStr forState:UIControlStateNormal];
            }
            else
            {
                [self.btn_friend_buzzcount setTitle:@"0" forState:UIControlStateNormal];
            }
            
            if ([self.mPeopleModel.people_statistics objectForKeyedSubscript:@"followerCount"])
            {
                NSNumber* followerCount = [self.mPeopleModel.people_statistics objectForKeyedSubscript:@"followerCount"];
                
                NSString* followerCountStr = [NSString stringWithFormat:@"%d", [followerCount intValue]];
                
                [self.btn_friend_followers setTitle:followerCountStr forState:UIControlStateNormal];
            }
            else
            {
                [self.btn_friend_followers setTitle:@"0" forState:UIControlStateNormal];
            }
            
            // Milestones, Adventures and Events
            
            if ([self.mPeopleModel.people_statistics objectForKeyedSubscript:@"milestones"])
            {
                NSNumber* milestoneCount = [self.mPeopleModel.people_statistics objectForKeyedSubscript:@"milestones"];
                
                NSString* milestoneCountStr = [NSString stringWithFormat:@"%d", [milestoneCount intValue]];
                
                [self.btn_friend_milestones setTitle:milestoneCountStr forState:UIControlStateNormal];
            }
            else
            {
                [self.btn_friend_milestones setTitle:@"0" forState:UIControlStateNormal];
            }
            
            if ([self.mPeopleModel.people_statistics objectForKeyedSubscript:@"adventuresHad"])
            {
                NSNumber* adventureCount = [self.mPeopleModel.people_statistics objectForKeyedSubscript:@"adventuresHad"];
                
                NSString* adventureCountStr = [NSString stringWithFormat:@"%d", [adventureCount intValue]];
                
                [self.btn_friend_adventures setTitle:adventureCountStr forState:UIControlStateNormal];
            }
            else
            {
                [self.btn_friend_adventures setTitle:@"0" forState:UIControlStateNormal];
            }
            
            if ([self.mPeopleModel.people_statistics objectForKeyedSubscript:@"eventsAttended"])
            {
                NSNumber* eventCount = [self.mPeopleModel.people_statistics objectForKeyedSubscript:@"eventsAttended"];
                
                NSString* eventCountStr = [NSString stringWithFormat:@"%d", [eventCount intValue]];
                
                [self.btn_friend_events setTitle:eventCountStr forState:UIControlStateNormal];
            }
            else
            {
                [self.btn_friend_events setTitle:@"0" forState:UIControlStateNormal];
            }
        }
    }
    
    // Second method to get counts natively
    
    [[BTAPIClient sharedClient] getAdventureCount:@"people"
                                     withPersonId:self.friendId
                                        withBlock:^(NSDictionary *model, NSError *error)
    {
        DLog(@"%@", model);
        
        if (error == Nil)
        {
            if ([model isKindOfClass:[NSDictionary class]])
            {
                if ([model objectForKeyedSubscript:@"count"])
                {
                    NSNumber* countNum = [model objectForKeyedSubscript:@"count"];
                    
                    NSString* countStr = [NSString stringWithFormat:@"%d", [countNum intValue]];
                    
                    [self.btn_friend_adventures setTitle:countStr
                                                forState:UIControlStateNormal];
                }
            }
        }
    }];
    
    [[BTAPIClient sharedClient] getMilestoneCount:@"people"
                                     withPersonId:self.friendId
                                        withBlock:^(NSDictionary *model, NSError *error)
     {
         DLog(@"%@", model);
         
         if (error == Nil)
         {
             if ([model isKindOfClass:[NSDictionary class]])
             {
                 if ([model objectForKeyedSubscript:@"count"])
                 {
                     NSNumber* countNum = [model objectForKeyedSubscript:@"count"];
                     
                     NSString* countStr = [NSString stringWithFormat:@"%d", [countNum intValue]];
                     
                     [self.btn_friend_milestones setTitle:countStr
                                                 forState:UIControlStateNormal];
                 }
             }
         }
     }];
    
    [[BTAPIClient sharedClient] getEventCount:@"people"
                                 withPersonId:self.friendId
                                    withBlock:^(NSDictionary *model, NSError *error)
     {
         DLog(@"%@", model);
         
         if (error == Nil)
         {
             if ([model isKindOfClass:[NSDictionary class]])
             {
                 if ([model objectForKeyedSubscript:@"count"])
                 {
                     NSNumber* countNum = [model objectForKeyedSubscript:@"count"];
                     
                     NSString* countStr = [NSString stringWithFormat:@"%d", [countNum intValue]];
                     
                     [self.btn_friend_events setTitle:countStr
                                             forState:UIControlStateNormal];
                 }
             }
         }
     }];
}

@end
