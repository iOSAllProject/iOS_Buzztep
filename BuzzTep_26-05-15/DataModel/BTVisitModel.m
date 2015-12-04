//
//  BTVisitModel.m
//  BUZZtep
//
//  Created by Mac on 6/22/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "BTVisitModel.h"

@implementation BTVisitModel
@synthesize visit_Id,visit_adventureId,visit_personId,visit_eventId,visit_meetupId,visit_milestoneId,visit_title,visit_createdOn,visit_location;
- (id)initVisitWithDict:(NSDictionary *)model
{
    self = [super init];

    if (self)
    {
        @try {

            self.visit_Id = @"";
            self.visit_adventureId = @"";
            self.visit_personId = @"";
            self.visit_eventId = @"";
            self.visit_meetupId = @"";
            self.visit_milestoneId = @"";
            self.visit_title = @"";
            self.visit_createdOn = @"";
            self.visit_location = [[NSDictionary alloc]init];

            if ([model objectForKeyedSubscript:@"id"])
            {
                self.visit_Id = [model objectForKeyedSubscript:@"id"];
            }

            if ([model objectForKeyedSubscript:@"personId"])
            {
                self.visit_personId = [model objectForKeyedSubscript:@"personId"];
            }

            if ([model objectForKeyedSubscript:@"eventId"])
            {
                self.visit_eventId = [model objectForKeyedSubscript:@"eventId"];
            }

            if ([model objectForKeyedSubscript:@"meetupId"])
            {
                self.visit_meetupId = [model objectForKeyedSubscript:@"meetupId"];
            }

            if ([model objectForKeyedSubscript:@"milestoneId"])
            {
                self.visit_milestoneId = [model objectForKeyedSubscript:@"milestoneId"];
            }

            if ([model objectForKeyedSubscript:@"title"])
            {
                self.visit_title = [model objectForKeyedSubscript:@"title"];
            }

            if ([model objectForKeyedSubscript:@"location"])
            {
                // Will check this parameter with web developer
                if ([[model objectForKeyedSubscript:@"location"] isKindOfClass:[NSDictionary class]])
                {
                    self.visit_location = [model objectForKeyedSubscript:@"location"];
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
