//
//  Invite.m
//  BuzzTepInvite
//
//  Created by Sanchit Thakur  on 01/05/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "Invite.h"

@implementation Invite

- (instancetype)initWithData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        _userName = data[@"name"];
        
        _userAvatar = data[@"picture"]/*[@"data"][@"url"]*/;
        
        _friendID = data[@"id"];
        
        self.invited = NO;
    }
    return self;
}

@end
