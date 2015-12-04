//
//  BTMeetUpModel.m
//  BUZZtep
//
//  Created by Mac on 7/2/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//
/*
 {
 "title": "",
 "scheduledDate": "",
 "scheduledLocation": "geopoint",
 "createdOn": "",
 "settings": {
 "undercover": false,
 "wallPublic": true,
 "mapPublic": true,
 "adventurePublic": true,
 "friendsPublic": true
 },
 "id": "objectid"
 }
 */
#import "BTMeetUpModel.h"

@implementation BTMeetUpModel
@synthesize meetup_title,meetup_settings,meetup_scheduledLocation,meetup_scheduledDate,meetup_Id,meetup_createdOn;
- (id)initMeetUpWithDict:(NSDictionary *)model
{
    self = [super init];

    if (self)
    {
        @try {
            self.meetup_Id = @"";
            self.meetup_createdOn = @"";
            self.meetup_title = @"";
            self.meetup_scheduledDate = @"";
            self.meetup_scheduledLocation = [[NSDictionary alloc]init];
            self.meetup_settings = [[NSDictionary alloc]init];


            if ([model objectForKeyedSubscript:@"id"])
            {
                self.meetup_Id = [model objectForKeyedSubscript:@"id"];
            }

            if ([model objectForKeyedSubscript:@"createdOn"])
            {
                self.meetup_createdOn = [model objectForKeyedSubscript:@"createdOn"];
            }

            if ([model objectForKeyedSubscript:@"title"])
            {
                self.meetup_title = [model objectForKeyedSubscript:@"title"];
            }

            if ([model objectForKeyedSubscript:@"scheduledDate"])
            {
                self.meetup_scheduledDate = [model objectForKeyedSubscript:@"scheduledDate"];
            }


            if ([model objectForKeyedSubscript:@"scheduledLocation"])
            {
                // Will check this parameter with web developer
                if ([[model objectForKeyedSubscript:@"scheduledLocation"] isKindOfClass:[NSDictionary class]])
                {
                    self.meetup_scheduledLocation = [model objectForKeyedSubscript:@"scheduledLocation"];
                }
            }

            if ([model objectForKeyedSubscript:@"settings"])
            {
                // Will check this parameter with web developer
                if ([[model objectForKeyedSubscript:@"settings"] isKindOfClass:[NSDictionary class]])
                {
                    self.meetup_settings = [model objectForKeyedSubscript:@"settings"];
                }
            }
        }
        @catch (NSException *exception) {
            
            DLog(@"%@",[exception description]);
            DLog(@"%@",[exception callStackSymbols]);
            
        }
        @finally {
            
        }
        
    }
    return self;
}
@end
