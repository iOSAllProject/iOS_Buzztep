//
//  BTMilestoneModel.m
//  BUZZtep
//
//  Created by Lin on 6/8/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "BTMilestoneModel.h"
#import "Constant.h"

@implementation BTMilestoneModel

@synthesize milestone_Id;
@synthesize milestone_personId;
@synthesize milestone_title;
@synthesize milestone_city;
@synthesize milestone_country;
@synthesize milestone_createdOn;
@synthesize milestone_statistics;

- (id)initMilestoneWithDict:(NSDictionary* )model
{
    self = [super init];
    
    if (self)
    {
        @try {
            
            self.milestone_Id = @"";
            self.milestone_personId = @"";
            self.milestone_title = @"";
            self.milestone_city = @"";
            self.milestone_country = @"";
            self.milestone_createdOn = @"";
            self.milestone_statistics = Nil;
            
            if ([model objectForKeyedSubscript:@"id"])
            {
                self.milestone_Id = [model objectForKeyedSubscript:@"id"];
            }
            
            if ([model objectForKeyedSubscript:@"personId"])
            {
                self.milestone_personId = [model objectForKeyedSubscript:@"personId"];
            }
            
            if ([model objectForKeyedSubscript:@"title"])
            {
                self.milestone_title = [model objectForKeyedSubscript:@"title"];
            }
            
            if ([model objectForKeyedSubscript:@"city"])
            {
                self.milestone_city = [model objectForKeyedSubscript:@"city"];
            }
            
            if ([model objectForKeyedSubscript:@"country"])
            {
                self.milestone_country = [model objectForKeyedSubscript:@"country"];
            }
            
            if ([model objectForKeyedSubscript:@"createdOn"])
            {
                self.milestone_createdOn = [model objectForKeyedSubscript:@"createdOn"];
            }
            
            if ([model objectForKeyedSubscript:@"statistics"]
                && [[model objectForKeyedSubscript:@"statistics"] isKindOfClass:[NSDictionary class]])
            {
                self.milestone_statistics = [model objectForKeyedSubscript:@"statistics"];
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
