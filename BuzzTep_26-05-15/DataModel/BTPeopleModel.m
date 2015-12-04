//
//  BTPeopleModel.m
//  BUZZtep
//
//  Created by Lin on 5/28/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "BTPeopleModel.h"
#import "Constant.h"

@implementation BTPeopleModel

@synthesize people_Id;
@synthesize people_type;
@synthesize people_deviceId;
@synthesize people_identity;
@synthesize people_auth;
@synthesize people_homeLocation;
@synthesize people_lastLocation;
@synthesize people_companyLocations;
@synthesize people_accountActive;
@synthesize people_accountLevel;
@synthesize people_createdOn;
@synthesize people_lastVisitDate;
@synthesize people_ipHistory;
@synthesize people_statistics;
@synthesize people_settings;
@synthesize people_amenities;
@synthesize photoError;

- (id) initPeopleWithDict:(NSDictionary* )model
{
    self = [super init];
    
    if (self)
    {
        @try {
            
            self.people_Id = @"";
            self.people_type = @"";
            self.people_deviceId = @"";
            self.people_identity = [[NSDictionary alloc] init];
            self.people_auth = [[NSDictionary alloc] init];
            self.people_homeLocation = [[NSDictionary alloc] init];
            self.people_lastLocation = [[NSDictionary alloc] init];
            self.people_companyLocations = [[NSMutableArray alloc] init];
            self.people_accountActive = @"";
            self.people_accountLevel = @"";
            self.people_createdOn = @"";
            self.people_lastVisitDate = @"";
            self.people_ipHistory = [[NSMutableArray alloc] init];
            self.people_statistics = [[NSDictionary alloc] init];
            self.people_settings = [[NSDictionary alloc] init];
            self.people_amenities = [[NSMutableArray alloc] init];
            
            if ([model objectForKeyedSubscript:@"id"])
            {
                self.people_Id = [model objectForKeyedSubscript:@"id"];
            }
            
            if ([model objectForKeyedSubscript:@"type"])
            {
                self.people_type = [model objectForKeyedSubscript:@"type"];
            }
            
            if ([model objectForKeyedSubscript:@"deviceId"])
            {
                self.people_deviceId = [model objectForKeyedSubscript:@"deviceId"];
            }
            
            if ([model objectForKeyedSubscript:@"identity"])
            {
                self.people_identity = [model objectForKeyedSubscript:@"identity"];
            }
            
            if ([model objectForKeyedSubscript:@"auth"])
            {
                self.people_auth = [model objectForKeyedSubscript:@"auth"];
            }
            
            if ([model objectForKeyedSubscript:@"homeLocation"])
            {
                if ([[model objectForKeyedSubscript:@"homeLocation"] isKindOfClass:[NSDictionary class]])
                {
                    self.people_homeLocation = [model objectForKeyedSubscript:@"homeLocation"];
                }
            }
            
            if ([model objectForKeyedSubscript:@"lastLocation"])
            {
                if ([[model objectForKeyedSubscript:@"lastLocation"] isKindOfClass:[NSDictionary class]])
                {
                    self.people_lastLocation = [model objectForKeyedSubscript:@"lastLocation"];
                }
            }
            
            if ([model objectForKeyedSubscript:@"companyLocations"])
            {
                if ([[model objectForKeyedSubscript:@"companyLocations"] isKindOfClass:[NSDictionary class]])
                {
                    self.people_companyLocations = [model objectForKeyedSubscript:@"companyLocations"];
                }
            }
            
            if ([model objectForKeyedSubscript:@"accountActive"])
            {
                self.people_accountActive = [model objectForKeyedSubscript:@"accountActive"];
            }
            
            if ([model objectForKeyedSubscript:@"accountLevel"])
            {
                self.people_accountLevel = [model objectForKeyedSubscript:@"accountLevel"];
            }
            
            if ([model objectForKeyedSubscript:@"createdOn"])
            {
                self.people_createdOn = [model objectForKeyedSubscript:@"createdOn"];
            }
            
            if ([model objectForKeyedSubscript:@"lastVisitDate"])
            {
                self.people_lastVisitDate = [model objectForKeyedSubscript:@"lastVisitDate"];
            }
            
            if ([model objectForKeyedSubscript:@"ipHistory"])
            {
                self.people_ipHistory = [model objectForKeyedSubscript:@"ipHistory"];
            }
            
            if ([model objectForKeyedSubscript:@"statistics"])
            {
                self.people_statistics = [model objectForKeyedSubscript:@"statistics"];
            }
            
            if ([model objectForKeyedSubscript:@"settings"])
            {
                self.people_settings = [model objectForKeyedSubscript:@"settings"];
            }
            
            if ([model objectForKeyedSubscript:@"amenities"])
            {
                self.people_amenities = [model objectForKeyedSubscript:@"amenities"];
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
