//
//  InviteFriends.m
//  MYBUZZListScroll
//
//  Created by Sanchit Thakur on 16/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "InviteFriends.h"
#import "CreateProfile.h"
#import "InviteFriendsVC.h"

@interface InviteFriends ()
- (IBAction)backButton:(id)sender;
- (IBAction)skipAction:(id)sender;

@end

@implementation InviteFriends

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)skipAction:(id)sender {
    CreateProfile *createProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"createprofile"];
    [self.navigationController pushViewController:createProfile animated:YES];
}
- (IBAction)findFBFriendsBtn:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"InviteFriends" bundle:nil];
    InviteFriendsVC *invite=[storyboard instantiateViewControllerWithIdentifier:@"invitefriendsvc"];
    [self.navigationController pushViewController:invite animated:YES];
    
}
@end
