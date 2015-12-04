//
//  BTAdventureModel.m
//  BUZZtep
//
//  Created by Lin on 6/8/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "BTAdventureModel.h"
#include "Constant.h"

@implementation BTAdventureModel

@synthesize adventure_Id;
@synthesize adventure_currentId;
@synthesize adventure_personId;
@synthesize adventure_title;
@synthesize adventure_city;
@synthesize adventure_country;
@synthesize adventure_createdOn;
@synthesize adventure_startDate;
@synthesize adventure_startLocation;
@synthesize adventure_endDate;
@synthesize adventure_endLocation;
@synthesize adventure_statistics;
@synthesize adventure_settings;

- (id)initAdventureWithDict:(NSDictionary* )model
{
    self = [super init];
    
    if (self)
    {
        @try {
            
            self.adventure_Id = @"";
            self.adventure_personId = @"";
            self.adventure_currentId = @"";
            
            self.adventure_title = @"";
            self.adventure_city = @"";
            self.adventure_country = @"";
            self.adventure_createdOn = @"";
            self.adventure_startDate = @"";
            self.adventure_startLocation = @"";
            self.adventure_endDate = @"";
            self.adventure_endLocation = @"";
            
            self.adventure_statistics = Nil;
            self.adventure_settings = Nil;
                      
            if ([model objectForKeyedSubscript:@"id"])
            {
                self.adventure_Id = [model objectForKeyedSubscript:@"id"];
            }
            
            if ([model objectForKeyedSubscript:@"currentId"])
            {
                self.adventure_currentId = [model objectForKeyedSubscript:@"currentId"];
            }
            
            if ([model objectForKeyedSubscript:@"personId"])
            {
                self.adventure_personId = [model objectForKeyedSubscript:@"personId"];
            }
            
            if ([model objectForKeyedSubscript:@"title"])
            {
                self.adventure_title = [model objectForKeyedSubscript:@"title"];
            }
            
            if ([model objectForKeyedSubscript:@"city"])
            {
                self.adventure_city = [model objectForKeyedSubscript:@"city"];
            }
            
            if ([model objectForKeyedSubscript:@"country"])
            {
                self.adventure_country = [model objectForKeyedSubscript:@"country"];
            }
            
            if ([model objectForKeyedSubscript:@"createdOn"])
            {
                self.adventure_createdOn = [model objectForKeyedSubscript:@"createdOn"];
            }
            
            if ([model objectForKeyedSubscript:@"startDate"])
            {
                self.adventure_startDate = [model objectForKeyedSubscript:@"startDate"];
            }
            
            if ([model objectForKeyedSubscript:@"startLocation"])
            {
                self.adventure_startLocation = [model objectForKeyedSubscript:@"startLocation"];
            }
            
            if ([model objectForKeyedSubscript:@"endDate"])
            {
                self.adventure_endDate = [model objectForKeyedSubscript:@"endDate"];
            }
            
            if ([model objectForKeyedSubscript:@"endLocation"])
            {
                self.adventure_endLocation = [model objectForKeyedSubscript:@"endLocation"];
            }
            
            if ([model objectForKeyedSubscript:@"statistics"])
            {
                if ([[model objectForKeyedSubscript:@"statistics"] isKindOfClass:[NSDictionary class]])
                {
                    self.adventure_statistics = [model objectForKeyedSubscript:@"statistics"];
                }
            }
            
            if ([model objectForKeyedSubscript:@"settings"])
            {
                if ([[model objectForKeyedSubscript:@"settings"] isKindOfClass:[NSDictionary class]])
                {
                    self.adventure_settings = [model objectForKeyedSubscript:@"settings"];
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
