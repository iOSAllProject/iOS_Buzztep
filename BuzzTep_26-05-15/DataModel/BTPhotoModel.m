//
//  BTPhotoModel.m
//  BUZZtep
//
//  Created by Mac on 6/10/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "BTPhotoModel.h"
#import "Constant.h"
@implementation BTPhotoModel

@synthesize photo_Id;
@synthesize photo_edventureId;
@synthesize photo_eventId;
@synthesize photo_meetupId;
@synthesize photo_milestoneId;
@synthesize photo_personId;
@synthesize photo_visitId;
@synthesize photo_name;
@synthesize photo_type;
@synthesize photo_source;
@synthesize photo_uploadIP;
@synthesize photo_data;
@synthesize photo_createdOn;
@synthesize photo_statistics;
@synthesize photo_location;
- (id) initPhotoPeopleWithDict:(NSDictionary* )model
{
    self = [super init];

    if (self)
    {
        @try {

            self.photo_Id = @"";
            self.photo_edventureId = @"";
            self.photo_eventId = @"";
            self.photo_meetupId = @"";
            self.photo_milestoneId = @"";
            self.photo_personId = @"";
            self.photo_visitId = @"";
            self.photo_name = @"";
            self.photo_type = @"";
            self.photo_source = @"";
            self.photo_uploadIP = @"";
            self.photo_data = [[NSDictionary alloc] init];
            self.photo_statistics = [[NSDictionary alloc] init];
            self.photo_createdOn = [[NSDate alloc] init];
            self.photo_location = [[CLLocation alloc]init];

            if ([model objectForKeyedSubscript:@"id"])
            {
                self.photo_Id = [model objectForKeyedSubscript:@"id"];
            }

            if ([model objectForKeyedSubscript:@"adventureId"])
            {
                self.photo_edventureId = [model objectForKeyedSubscript:@"adventureId"];
            }

            if ([model objectForKeyedSubscript:@"eventId"])
            {
                self.photo_eventId = [model objectForKeyedSubscript:@"eventId"];
            }

            if ([model objectForKeyedSubscript:@"meetupId"])
            {
                self.photo_meetupId = [model objectForKeyedSubscript:@"meetupId"];
            }

            if ([model objectForKeyedSubscript:@"visitId"])
            {
                self.photo_visitId = [model objectForKeyedSubscript:@"visitId"];
            }

            if ([model objectForKeyedSubscript:@"name"])
            {
                self.photo_name = [model objectForKeyedSubscript:@"name"];
            }

            if ([model objectForKeyedSubscript:@"type"])
            {
                self.photo_type = [model objectForKeyedSubscript:@"type"];
            }

            if ([model objectForKeyedSubscript:@"source"])
            {
                self.photo_source = [model objectForKeyedSubscript:@"source"];
            }

            if ([model objectForKeyedSubscript:@"uploadIP"])
            {
                self.photo_uploadIP = [model objectForKeyedSubscript:@"uploadIP"];
            }

            if ([model objectForKeyedSubscript:@"data"])
            {
                self.photo_data = [model objectForKeyedSubscript:@"data"];
            }

            if ([model objectForKeyedSubscript:@"statistics"])
            {
                self.photo_statistics = [model objectForKeyedSubscript:@"statistics"];
            }

            if ([model objectForKeyedSubscript:@"createdOn"])
            {
                self.photo_createdOn = [model objectForKeyedSubscript:@"createdOn"];
            }

            if ([model objectForKeyedSubscript:@"location"])
            {
                self.photo_createdOn = [model objectForKeyedSubscript:@"location"];
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
