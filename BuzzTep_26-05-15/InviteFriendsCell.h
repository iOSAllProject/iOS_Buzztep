//
//  CustomCell.h
//  BuzzTepInvite
//
//  Created by Sanchit Thakur  on 01/05/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Invite.h"

@interface InviteFriendsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *inviteButton;

@property (strong, nonatomic) Invite *model;
@property (strong, nonatomic) NSString *inviteID;

- (void)updateWithInvite:(Invite *)model;

@end
