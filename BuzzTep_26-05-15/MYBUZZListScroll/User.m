//
//  User.m
//  BUZZtep
//
//  Created by Red Monkey on 6/3/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "User.h"

@implementation User
static id instance;

+(User *)sharedUser
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [User new];
    });
    
    return instance;
}

-(id) init
{
    if(self = [super init])
    {
        
    }
    
    return self;
}

@end
