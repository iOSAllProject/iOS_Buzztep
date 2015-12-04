//
//  CustomCell.m
//  BuzzTepInvite
//
//  Created by Sanchit Thakur  on 01/05/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "InviteFriendsCell.h"

@interface InviteFriendsCell ()
{
    BOOL invited;
}

@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;

@end

@implementation InviteFriendsCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)updateWithInvite:(Invite *)model
{
    _model = model;
    
    invited = model.invited;
    _userAvatar.layer.backgroundColor=[[UIColor clearColor] CGColor];
    _userAvatar.layer.cornerRadius=20;
    _userAvatar.layer.borderWidth=0.0;
    _userAvatar.layer.masksToBounds = YES;
    self.userName.text = model.userName;
    
    if ([model.userAvatar isKindOfClass:[NSString class]]) {
        UIImage* avtr = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:model.userAvatar]]];
        self.userAvatar.image = avtr;
    } else {
        self.userAvatar.image = (UIImage*)model.userAvatar;
    }
    
    self.inviteButton.tag = [model.friendID integerValue];
    if (invited) {
        [self.inviteButton setTitle:@"INVITED" forState:UIControlStateNormal];
    }
    invited = !invited;
    [self.inviteButton setImage:[UIImage imageNamed:invited ? @"invite_btn.png":@""] forState:UIControlStateNormal];
    
}

@end
