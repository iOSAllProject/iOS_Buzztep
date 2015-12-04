//
//  BTMetadataModel.m
//  BUZZtep
//
//  Created by Mac on 6/23/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "BTMetadataModel.h"
#import "Constant.h"
@implementation BTMetadataModel
@synthesize metadata_Id,metadata_adventureId,metadata_eventId,metadata_createdOn,metadata_data,metadata_location,metadata_meetupId,metadata_milestoneId,metadata_name,metadata_personId,metadata_source,metadata_statistics,metadata_type,metadata_uploadIp,metadata_visitId;

- (id)initMediaWithDict:(NSDictionary *)model
{
    self = [super init];

    if (self)
    {
        @try {
            self.metadata_name = @"";
            self.metadata_type = @"";
            self.metadata_source = @"";
            self.metadata_uploadIp = @"";
            self.metadata_createdOn = @"";
            self.metadata_Id = @"";
            self.metadata_adventureId = @"";
            self.metadata_eventId = @"";
            self.metadata_meetupId = @"";
            self.metadata_milestoneId = @"";
            self.metadata_personId = @"";
            self.metadata_visitId = @"";

            self.metadata_data = [[NSDictionary alloc] init];
            self.metadata_statistics = [[NSDictionary alloc] init];
            self.metadata_location = [[NSDictionary alloc] init];


            if ([model objectForKeyedSubscript:@"name"])
            {
                self.metadata_name = [model objectForKeyedSubscript:@"name"];
            }

            if ([model objectForKeyedSubscript:@"type"])
            {
                self.metadata_type = [model objectForKeyedSubscript:@"type"];
            }

            if ([model objectForKeyedSubscript:@"source"])
            {
                self.metadata_source = [model objectForKeyedSubscript:@"source"];
            }

            if ([model objectForKeyedSubscript:@"uploadIp"])
            {
                self.metadata_uploadIp = [model objectForKeyedSubscript:@"uploadIp"];
            }

            if ([model objectForKeyedSubscript:@"createdOn"])
            {
                self.metadata_createdOn = [model objectForKeyedSubscript:@"createdOn"];
            }

            if ([model objectForKeyedSubscript:@"id"])
            {
                self.metadata_Id = [model objectForKeyedSubscript:@"id"];
            }

            if ([model objectForKeyedSubscript:@"adventureId"])
            {
                self.metadata_adventureId = [model objectForKeyedSubscript:@"adventureId"];
            }

            if ([model objectForKeyedSubscript:@"eventId"])
            {
                self.metadata_eventId = [model objectForKeyedSubscript:@"eventId"];
            }

            if ([model objectForKeyedSubscript:@"meetupId"])
            {
                self.metadata_meetupId = [model objectForKeyedSubscript:@"meetupId"];
            }

            if ([model objectForKeyedSubscript:@"milestoneId"])
            {
                self.metadata_milestoneId = [model objectForKeyedSubscript:@"milestoneId"];
            }

            if ([model objectForKeyedSubscript:@"personId"])
            {
                self.metadata_personId = [model objectForKeyedSubscript:@"personId"];
            }

            if ([model objectForKeyedSubscript:@"visitId"])
            {
                self.metadata_visitId = [model objectForKeyedSubscript:@"visitId"];
            }

            if ([model objectForKeyedSubscript:@"data"])
            {
                // Will check this parameter with web developer
                if ([[model objectForKeyedSubscript:@"data"] isKindOfClass:[NSDictionary class]])
                {
                    self.metadata_data = [model objectForKeyedSubscript:@"data"];
                }
            }

            if ([model objectForKeyedSubscript:@"statistics"])
            {
                // Will check this parameter with web developer
                if ([[model objectForKeyedSubscript:@"statistics"] isKindOfClass:[NSDictionary class]])
                {
                    self.metadata_statistics = [model objectForKeyedSubscript:@"statistics"];
                }
            }

            if ([model objectForKeyedSubscript:@"location"])
            {
                // Will check this parameter with web developer
                if ([[model objectForKeyedSubscript:@"location"] isKindOfClass:[NSDictionary class]])
                {
                    self.metadata_location = [model objectForKeyedSubscript:@"location"];
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
