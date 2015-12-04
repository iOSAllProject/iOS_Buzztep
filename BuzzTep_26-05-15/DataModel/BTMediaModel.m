//
//  BTMediaModel.m
//  BUZZtep
//
//  Created by Lin on 6/28/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "BTMediaModel.h"
#import "Constant.h"
#import "Global.h"
#import "Constant.h"

@implementation BTMediaModel

@synthesize media_Id;
@synthesize media_createdOn;
@synthesize media_data;
@synthesize media_eventId;
@synthesize media_adventureId;
@synthesize media_milestoneId;
@synthesize media_location;
@synthesize media_name;
@synthesize media_type;
@synthesize media_personId;
@synthesize media_statistics;

- (id)initMediaWithDict:(NSDictionary *)model
{
    self = [super init];
    
    if (self)
    {
        @try {
            
            self.media_Id = @"";
            self.media_personId = @"";
            self.media_createdOn = @"";
            self.media_data = Nil;
            self.media_location = Nil;
            self.media_statistics = Nil;
            self.media_eventId = @"";
            self.media_adventureId = @"";
            self.media_milestoneId = @"";
            self.media_name = @"";
            self.media_type = @"";
            
            if ([model objectForKeyedSubscript:@"id"])
            {
                self.media_Id = [model objectForKeyedSubscript:@"id"];
            }
            
            if ([model objectForKeyedSubscript:@"personId"])
            {
                self.media_personId = [model objectForKeyedSubscript:@"personId"];
            }
            
            if ([model objectForKeyedSubscript:@"createdOn"])
            {
                self.media_createdOn = [model objectForKeyedSubscript:@"createdOn"];
            }
            
            if ([model objectForKeyedSubscript:@"data"]
                && [[model objectForKeyedSubscript:@"data"] isKindOfClass:[NSDictionary class]]
                && model != Nil)
            {
                self.media_data = [model objectForKeyedSubscript:@"data"];
            }
            
            if ([model objectForKeyedSubscript:@"location"]
                && [[model objectForKeyedSubscript:@"location"] isKindOfClass:[NSDictionary class]]
                && model != Nil)
            {
                self.media_location = [model objectForKeyedSubscript:@"location"];
            }
            
            if ([model objectForKeyedSubscript:@"statistics"]
                && [[model objectForKeyedSubscript:@"statistics"] isKindOfClass:[NSDictionary class]]
                && model != Nil)
            {
                self.media_statistics = [model objectForKeyedSubscript:@"statistics"];
            }
            
            if ([model objectForKeyedSubscript:@"adventureId"])
            {
                self.media_adventureId = [model objectForKeyedSubscript:@"adventureId"];
            }
            
            if ([model objectForKeyedSubscript:@"eventId"])
            {
                self.media_eventId = [model objectForKeyedSubscript:@"eventId"];
            }
            
            if ([model objectForKeyedSubscript:@"milestoneId"])
            {
                self.media_milestoneId = [model objectForKeyedSubscript:@"milestoneId"];
            }
            
            if ([model objectForKeyedSubscript:@"name"])
            {
                self.media_name = [model objectForKeyedSubscript:@"name"];
            }
            
            if ([model objectForKeyedSubscript:@"type"])
            {
                self.media_type = [model objectForKeyedSubscript:@"type"];
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

- (NSString* )mediaDownloadPath
{
    NSString* retPath = Nil;
    
    if (self.media_data)
    {
        NSString* container = [self.media_data objectForKeyedSubscript:@"container"];
        NSString* fileName = [self.media_data objectForKeyedSubscript:@"filename"];
        
        if (container && fileName)
        {
            retPath = [NSString stringWithFormat:@"%@/media/%@/download/%@", BASEURL, container, fileName];
        }
    }
    
    return retPath;
}

- (NSInteger) mediaViewCount
{
    NSInteger retCount = 0;
    
    if (self.media_statistics != Nil)
    {
        if ([self.media_statistics objectForKeyedSubscript:@"views"])
        {
            retCount = [[self.media_statistics objectForKeyedSubscript:@"views"] integerValue];
        }
    }
    
    return retCount;
}

- (NSInteger) mediaLikeCount
{
    NSInteger retCount = 0;
    
    if (self.media_statistics != Nil)
    {
        if ([self.media_statistics objectForKeyedSubscript:@"likes"])
        {
            retCount = [[self.media_statistics objectForKeyedSubscript:@"likes"] integerValue];
        }
    }
    
    return retCount;
}

- (NSInteger) mediaCommentCount
{
    NSInteger retCount = 0;
    
    if (self.media_statistics != Nil)
    {
        if ([self.media_statistics objectForKeyedSubscript:@"comments"])
        {
            retCount = [[self.media_statistics objectForKeyedSubscript:@"comments"] integerValue];
        }
    }
    
    return retCount;
}

- (NSInteger) mediaBucketListCount
{
    NSInteger retCount = 0;
    
    if (self.media_statistics != Nil)
    {
        if ([self.media_statistics objectForKeyedSubscript:@"bucketLists"])
        {
            retCount = [[self.media_statistics objectForKeyedSubscript:@"bucketLists"] integerValue];
        }
    }
    
    return retCount;
}

@end
