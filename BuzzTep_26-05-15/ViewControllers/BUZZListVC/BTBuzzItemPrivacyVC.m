//
//  BTBuzzItemPrivacyVC.m
//  BUZZtep
//
//  Created by Lin on 6/20/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "BTBuzzItemPrivacyVC.h"
#import "AppDelegate.h"
#import "Global.h"

@interface BTBuzzItemPrivacyVC ()

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

@end

@implementation BTBuzzItemPrivacyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.tFriendRelationType = Privacy_Relation_Public;
    
    [self.btn_public setImage:[UIImage imageNamed:@"friend_privacy_public_p"]
                     forState:UIControlStateNormal];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

@end
