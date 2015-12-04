//
//  BTFollowModel.m
//  BUZZtep
//
//  Created by Lin on 6/6/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "BTFollowModel.h"
#import "Constant.h"

/*
 {
 createdOn = "2015-06-06T01:59:19.471Z";
 followedId = 55665cce04cdbee008428022;
 followerId = 55665cce04cdbee008428024;
 id = 557253f74c300ed30cb34204;
 }
 
 */
@implementation BTFollowModel

@synthesize follow_createdOn;
@synthesize follow_followedId;
@synthesize follow_followerId;
@synthesize follow_ID;

- (id)initFollowWithDict:(NSDictionary* )model
{
    self = [super init];
    
    if (self)
    {
        @try {
            
            self.follow_createdOn = @"";
            self.follow_followedId = @"";
            self.follow_followerId= @"";
            self.follow_ID = @"";
            
            // Id
            
            if ([model objectForKeyedSubscript:@"id"])
            {
                self.follow_ID = [model objectForKeyedSubscript:@"id"];
            }
            
            // createdOn
            
            if ([model objectForKeyedSubscript:@"createdOn"])
            {
                self.follow_createdOn = [model objectForKeyedSubscript:@"createdOn"];
            }
            
            // Followed
            
            if ([model objectForKeyedSubscript:@"followedId"])
            {
                self.follow_followedId = [model objectForKeyedSubscript:@"followedId"];
            }
            
            // Follower
            
            if ([model objectForKeyedSubscript:@"followerId"])
            {
                self.follow_followerId = [model objectForKeyedSubscript:@"followerId"];
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
