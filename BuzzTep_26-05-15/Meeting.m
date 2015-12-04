//
//  Meeting.m
//  BuzzTepMeetUps
//
//  Created by Sanchit Thakur  on 05/05/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "Meeting.h"

@implementation Meeting

- (instancetype)initWithData:(NSDictionary *)data
{
    self = [super init];
    if (self) {
        _meetName = data[@"meetName"];
        _meetDate = data[@"meetDate"];
        _meetAddress = data[@"meetAdress"];
        _meetFirstUserName = data[@"firstUserName"];
        _meetSecondUserName = data[@"secondUserName"];
        _meetThirdUserName = data[@"thirdUserName"];
    }
    return self;
}

@end
