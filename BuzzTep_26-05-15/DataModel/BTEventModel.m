//
//  BTEventModel.m
//  BUZZtep
//
//  Created by Lin on 6/8/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "BTEventModel.h"
#import "Constant.h"

@implementation BTEventModel

@synthesize event_Id;
@synthesize event_personId;
@synthesize event_title;
@synthesize event_type;
@synthesize event_scheduledDate;
@synthesize event_createdOn;
@synthesize event_location;
@synthesize event_settings;

- (id)initEventWithDict:(NSDictionary *)model
{
    self = [super init];
    
    if (self)
    {
        @try {
            
            self.event_Id = @"";
            self.event_personId = @"";
            self.event_title = @"";
            self.event_type = @"";
            self.event_scheduledDate = @"";
            self.event_createdOn = @"";
            self.event_location = Nil;
            self.event_settings = Nil;
            
            /*
             {
             "title": "",
             "type": "",
             "scheduledDate": "",
             "createdOn": "",
             "location": "geopoint",
             "settings": {
                "undercover": false,
                "wallPublic": true,
                "mapPublic": true,
                "adventurePublic": true,
                "friendsPublic": true
             },
             "id": "objectid",
             "personId": "objectid"
             }
             */
            if ([model objectForKeyedSubscript:@"id"])
            {
                self.event_Id = [model objectForKeyedSubscript:@"id"];
            }
            
            if ([model objectForKeyedSubscript:@"personId"])
            {
                self.event_personId = [model objectForKeyedSubscript:@"personId"];
            }
            
            if ([model objectForKeyedSubscript:@"title"])
            {
                self.event_title = [model objectForKeyedSubscript:@"title"];
            }
            
            if ([model objectForKeyedSubscript:@"type"])
            {
                self.event_type = [model objectForKeyedSubscript:@"type"];
            }
            
            if ([model objectForKeyedSubscript:@"scheduledDate"])
            {
                self.event_scheduledDate = [model objectForKeyedSubscript:@"scheduledDate"];
            }
            
            if ([model objectForKeyedSubscript:@"createdOn"])
            {
                self.event_createdOn = [model objectForKeyedSubscript:@"createdOn"];
            }
            
            if ([model objectForKeyedSubscript:@"location"])
            {
                // Will check this parameter with web developer
                if ([[model objectForKeyedSubscript:@"location"] isKindOfClass:[NSDictionary class]])
                {
                    self.event_location = [model objectForKeyedSubscript:@"location"];
                }
            }
            
            if ([model objectForKeyedSubscript:@"settings"])
            {
                if ([[model objectForKeyedSubscript:@"settings"] isKindOfClass:[NSDictionary class]])
                {
                    self.event_settings = [model objectForKeyedSubscript:@"settings"];
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
