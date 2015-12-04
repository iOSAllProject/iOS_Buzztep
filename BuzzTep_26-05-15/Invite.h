//
//  Invite.h
//  BuzzTepInvite
//
//  Created by Sanchit Thakur  on 01/05/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Invite : NSObject

@property (nonatomic, readonly) NSString *userName;
@property (nonatomic, readonly) NSString *userAvatar;
@property (nonatomic, assign) NSString *friendID;
@property (nonatomic, assign) BOOL invited;

- (instancetype)initWithData:(NSDictionary *)data;

@end
