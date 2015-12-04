//
//  NewBuzzPrivacyVC.m
//  When_WhereVC
//
//  Created by Sanchit Thakur on 20/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "NewBuzzPrivacyVC.h"
#import "NewBuzzConfirm.h"
#import "BuzzProfileVC.h"
#import "NewBuzzMediaVC.h"
#import "AppDelegate.h"

#import "Constant.h"
#import "Global.h"

#import "BTAPIClient.h"
#import "BTAdventureModel.h"
#import "BTMilestoneModel.h"
#import "BTEventModel.h"
#import "BTFileModel.h"
#import "MBProgressHUD.h"

@interface NewBuzzPrivacyVC ()

- (void) confirmAction;
- (IBAction)goAction:(id)sender;
- (IBAction)downBackButton:(id)sender;

- (IBAction)onPrivacyClose:(id)sender;
- (IBAction)onPrivacyPublic:(id)sender;
- (IBAction)onPrivacyFriend:(id)sender;
- (IBAction)onPrivacyCloseFriend:(id)sender;
- (IBAction)onPrivacyFamily:(id)sender;

- (void)updatePrivacyRelation:(id)sender;

@property (nonatomic, strong) IBOutlet UIButton*    btn_public;
@property (nonatomic, strong) IBOutlet UIButton*    btn_friend;
@property (nonatomic, strong) IBOutlet UIButton*    btn_closefriend;
@property (nonatomic, strong) IBOutlet UIButton*    btn_family;

@property (atomic, assign) PrivacyRelationTYPE tFriendRelationType;

- (NSDictionary* )generateSettingDict;

@end

@implementation NewBuzzPrivacyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    UISwipeGestureRecognizer *swipeRightGesture=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeGesture)];
    
    [self.view addGestureRecognizer:swipeRightGesture];
    
    swipeRightGesture.direction=UISwipeGestureRecognizerDirectionRight;
    
    self.tFriendRelationType = Privacy_Relation_Friend;
    
    [self.btn_public setImage:[UIImage imageNamed:@"friend_privacy_public_p"]
                     forState:UIControlStateNormal];
    
}

-(void)handleSwipeGesture
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)goAction:(id)sender
{
    // Post Adventure, Milestone and Event
    
    DLog(@"%d", (int)[AppDelegate SharedDelegate].gBuzzType);
    
    if ([AppDelegate SharedDelegate].gBuzzType == Global_BuzzType_Adventure)
    {
        NSDictionary* adventureDict = Nil;
        
        adventureDict = @{@"title" : [AppDelegate SharedDelegate].gAdventureModel.adventure_title,
                          @"city" : [AppDelegate SharedDelegate].gAdventureModel.adventure_city,
                          @"country" : [AppDelegate SharedDelegate].gAdventureModel.adventure_country,
                          @"personId" : [AppDelegate SharedDelegate].gAdventureModel.adventure_personId,
                          @"startDate" : [AppDelegate SharedDelegate].gAdventureModel.adventure_startDate,
                          @"endDate" : [AppDelegate SharedDelegate].gAdventureModel.adventure_endDate,
                          @"settings" : [self generateSettingDict]};
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [[BTAPIClient sharedClient] postAdventure:@"people"
                                     withPersonId:MyPersonModelID
                                        withParam:adventureDict
                                        withBlock:^(NSDictionary *model, NSError *error)
        {
            [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
            
            if (error == Nil)
            {
                DLog(@"%@", model);
                
                NSString* buzzObjectId = [model objectForKey:@"id"];
                
                for (int i = 0 ; i < [[AppDelegate SharedDelegate].gBuzzImageArray count] ; i ++)
                {
                    BTFileModel* fileModel = [[AppDelegate SharedDelegate].gBuzzImageArray objectAtIndex:i];
                    
                    [self postMetadata:fileModel buzzObjectId:buzzObjectId];
                }
            }
            
            [self confirmAction];
            
        }];
    }
    else if ([AppDelegate SharedDelegate].gBuzzType == Global_BuzzType_Milestone)
    {
        NSDictionary* milestoneDict = Nil;
        
        milestoneDict = @{@"title" : [AppDelegate SharedDelegate].gMilestoneModel.milestone_title,
                          @"city" : [AppDelegate SharedDelegate].gMilestoneModel.milestone_city,
                          @"country" : [AppDelegate SharedDelegate].gMilestoneModel.milestone_country,
                          @"personId" : [AppDelegate SharedDelegate].gMilestoneModel.milestone_personId,
                          @"settings" : [self generateSettingDict]};
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [[BTAPIClient sharedClient] postMilestone:@"people"
                                     withPersonId:MyPersonModelID
                                        withParam:milestoneDict
                                        withBlock:^(NSDictionary *model, NSError *error)
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
             
             if (error == Nil)
             {
                 DLog(@"%@", model);
                 
                 NSString* buzzObjectId = [model objectForKey:@"id"];
                 
                 for (int i = 0 ; i < [[AppDelegate SharedDelegate].gBuzzImageArray count] ; i ++)
                 {
                     BTFileModel* fileModel = [[AppDelegate SharedDelegate].gBuzzImageArray objectAtIndex:i];
                     
                     [self postMetadata:fileModel buzzObjectId:buzzObjectId];
                 }
             }
             
             [self confirmAction];
             
         }];
    }
    else if ([AppDelegate SharedDelegate].gBuzzType == Global_BuzzType_Event)
    {
        NSDictionary* eventDict = Nil;
        
        eventDict = @{@"title" : [AppDelegate SharedDelegate].gEventModel.event_title,
                      @"type" : [AppDelegate SharedDelegate].gEventModel.event_type,
                      @"scheduledDate" : [AppDelegate SharedDelegate].gEventModel.event_scheduledDate,
                      @"location" : [AppDelegate SharedDelegate].gEventModel.event_location,
                      @"personId" : [AppDelegate SharedDelegate].gEventModel.event_personId,
                      @"settings" : [self generateSettingDict]};
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        [[BTAPIClient sharedClient] postEvent:@"people"
                                 withPersonId:MyPersonModelID
                                    withParam:eventDict
                                    withBlock:^(NSDictionary *model, NSError *error)
         {
             [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
             
             if (error == Nil)
             {
                 DLog(@"%@", model);
                 
                 NSString* buzzObjectId = [model objectForKey:@"id"];
                 
                 for (int i = 0 ; i < [[AppDelegate SharedDelegate].gBuzzImageArray count] ; i ++)
                 {
                     BTFileModel* fileModel = [[AppDelegate SharedDelegate].gBuzzImageArray objectAtIndex:i];
                     
                     [self postMetadata:fileModel buzzObjectId:buzzObjectId];
                 }
             }
             
             [self confirmAction];
             
         }];
    }
    
}

#pragma mark - IBActions

- (IBAction)onPrivacyPublic:(id)sender
{
    [self updatePrivacyRelation:sender];
}

- (IBAction)onPrivacyFriend:(id)sender
{
    [self updatePrivacyRelation:sender];
}

- (IBAction)onPrivacyCloseFriend:(id)sender
{
    [self updatePrivacyRelation:sender];
}

- (IBAction)onPrivacyFamily:(id)sender
{
    [self updatePrivacyRelation:sender];
}

- (void)updatePrivacyRelation:(id)sender
{
    UIButton* senderButton = (UIButton*)sender;
    
    if ([senderButton isEqual:self.btn_public])
    {
        self.tFriendRelationType = Privacy_Relation_Public;
    }
    else if ([senderButton isEqual:self.btn_friend])
    {
        self.tFriendRelationType = Privacy_Relation_Friend;
    }
    else if ([senderButton isEqual:self.btn_closefriend])
    {
        self.tFriendRelationType = Privacy_Relation_CloseFriend;
    }
    else if ([senderButton isEqual:self.btn_family])
    {
        self.tFriendRelationType = Privacy_Relation_Family;
    }
    
    switch (self.tFriendRelationType) {
        case Privacy_Relation_Public:
        {
            [self.btn_public setImage:[UIImage imageNamed:@"friend_privacy_public_p"]
                             forState:UIControlStateNormal];
            
            [self.btn_friend setImage:[UIImage imageNamed:@"friend_privacy_friend_n"]
                             forState:UIControlStateNormal];
            
            [self.btn_closefriend setImage:[UIImage imageNamed:@"friend_privacy_closefriend_n"]
                                  forState:UIControlStateNormal];
            
            [self.btn_family setImage:[UIImage imageNamed:@"friend_privacy_family_n"]
                             forState:UIControlStateNormal];
        }
            break;
        case Privacy_Relation_Friend:
        {
            [self.btn_public setImage:[UIImage imageNamed:@"friend_privacy_public_n"]
                             forState:UIControlStateNormal];
            
            [self.btn_friend setImage:[UIImage imageNamed:@"friend_privacy_friend_p"]
                             forState:UIControlStateNormal];
            
            [self.btn_closefriend setImage:[UIImage imageNamed:@"friend_privacy_closefriend_n"]
                                  forState:UIControlStateNormal];
            
            [self.btn_family setImage:[UIImage imageNamed:@"friend_privacy_family_n"]
                             forState:UIControlStateNormal];
        }
            break;
        case Privacy_Relation_CloseFriend:
        {
            [self.btn_public setImage:[UIImage imageNamed:@"friend_privacy_public_n"]
                             forState:UIControlStateNormal];
            
            [self.btn_friend setImage:[UIImage imageNamed:@"friend_privacy_friend_n"]
                             forState:UIControlStateNormal];
            
            [self.btn_closefriend setImage:[UIImage imageNamed:@"friend_privacy_closefriend_p"]
                                  forState:UIControlStateNormal];
            
            [self.btn_family setImage:[UIImage imageNamed:@"friend_privacy_family_n"]
                             forState:UIControlStateNormal];
        }
            break;
        case Privacy_Relation_Family:
        {
            [self.btn_public setImage:[UIImage imageNamed:@"friend_privacy_public_n"]
                             forState:UIControlStateNormal];
            
            [self.btn_friend setImage:[UIImage imageNamed:@"friend_privacy_friend_n"]
                             forState:UIControlStateNormal];
            
            [self.btn_closefriend setImage:[UIImage imageNamed:@"friend_privacy_closefriend_n"]
                                  forState:UIControlStateNormal];
            
            [self.btn_family setImage:[UIImage imageNamed:@"friend_privacy_family_p"]
                             forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
    
    // Will Update the relation here with API
}

- (IBAction)onPrivacyClose:(id)sender
{
    BuzzProfileVC *buzzProfile =
    [self.storyboard instantiateViewControllerWithIdentifier:@"buzzprofile"];
    [self.navigationController pushViewController:buzzProfile animated:YES];

}

- (IBAction)downBackButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) confirmAction
{
    NewBuzzConfirm *buzzConfirm =
    [self.storyboard instantiateViewControllerWithIdentifier:@"newbuzzconfirm"];
    [self.navigationController pushViewController:buzzConfirm animated:YES];
}

- (NSDictionary* )generateSettingDict
{
    NSDictionary* settingDict = @{kBTPrivacyBuzzPublic : @YES,
                                                kBTPrivacyBuzzFriendPublic : @NO,
                                                kBTPrivacyBuzzCloseFriendPublic : @NO,
                                                kBTPrivacyBuzzFamilyPublic : @NO};

    if (self.tFriendRelationType == Privacy_Relation_Public)
    {
        settingDict = @{kBTPrivacyBuzzPublic : @YES,
                        kBTPrivacyBuzzFriendPublic : @NO,
                        kBTPrivacyBuzzCloseFriendPublic : @NO,
                        kBTPrivacyBuzzFamilyPublic : @NO};
    }
    else if (self.tFriendRelationType == Privacy_Relation_Friend)
    {
        settingDict = @{kBTPrivacyBuzzPublic : @NO,
                        kBTPrivacyBuzzFriendPublic : @YES,
                        kBTPrivacyBuzzCloseFriendPublic : @NO,
                        kBTPrivacyBuzzFamilyPublic : @NO};
    }
    else if (self.tFriendRelationType == Privacy_Relation_CloseFriend)
    {
        settingDict = @{kBTPrivacyBuzzPublic : @NO,
                        kBTPrivacyBuzzFriendPublic : @NO,
                        kBTPrivacyBuzzCloseFriendPublic : @YES,
                        kBTPrivacyBuzzFamilyPublic : @NO};
    }
    else if (self.tFriendRelationType == Privacy_Relation_Family)
    {
        settingDict = @{kBTPrivacyBuzzPublic : @NO,
                        kBTPrivacyBuzzFriendPublic : @NO,
                        kBTPrivacyBuzzCloseFriendPublic : @NO,
                        kBTPrivacyBuzzFamilyPublic : @YES};
    }
    
    return settingDict;
}

- (void)postMetadata:(BTFileModel* )fileModel buzzObjectId:(NSString* )buzzObjectId
{
    NSDictionary* postDict = Nil;
    
    NSString* dataUrl = Nil;
    NSString* peakUrl = Nil;
    
    dataUrl = [NSString stringWithFormat:@"media/%@/download/%@", fileModel.file_container, fileModel.file_name];
    
    peakUrl = [NSString stringWithFormat:@"media/%@/files/%@", fileModel.file_container, fileModel.file_name];
    
    if ([AppDelegate SharedDelegate].gBuzzType == Global_BuzzType_Adventure)
    {
        postDict = @{@"name": @"adventure_metadata",
                     @"type": @"adventure",
                     @"data": @{
                         @"container": fileModel.file_container,
                         @"filename": fileModel.file_name,
                         @"dataUrl" : dataUrl,
                         @"peakUrl" : peakUrl
                     },
                     @"location": [AppDelegate SharedDelegate].gBuzzLocation,
                     @"adventureId": buzzObjectId,
                     @"personId": [AppDelegate SharedDelegate].gAdventureModel.adventure_personId
                     };
    }
    else if ([AppDelegate SharedDelegate].gBuzzType == Global_BuzzType_Milestone)
    {
        postDict = @{@"name": @"milestone_metadata",
                     @"type": @"milestone",
                     @"data": @{
                             @"container": fileModel.file_container,
                             @"filename": fileModel.file_name,
                             @"dataUrl" : dataUrl,
                             @"peakUrl" : peakUrl
                             },
                     @"location": [AppDelegate SharedDelegate].gBuzzLocation,
                     @"milestoneId": buzzObjectId,
                     @"personId": [AppDelegate SharedDelegate].gMilestoneModel.milestone_personId
                     };
    }
    else if ([AppDelegate SharedDelegate].gBuzzType == Global_BuzzType_Event)
    {
        postDict = @{@"name": @"event_metadata",
                     @"type": @"event",
                     @"data": @{
                             @"container": fileModel.file_container,
                             @"filename": fileModel.file_name,
                             @"dataUrl" : dataUrl,
                             @"peakUrl" : peakUrl
                             },
                     @"location": [AppDelegate SharedDelegate].gBuzzLocation,
                     @"eventId": buzzObjectId,
                     @"personId": [AppDelegate SharedDelegate].gEventModel.event_personId
                     };
    }
    
    DLog(@"Dict : %@", postDict);
    
    [[BTAPIClient sharedClient] createMetadata:@"metadata"
                                      withDict:postDict
                                     withBlock:^(NSDictionary *model, NSError *error)
    {
        if (error == Nil)
        {
            DLog(@"%@", model);
        }
        
     }];
    
}

@end
