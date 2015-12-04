//
//  BTFriendshipModel.m
//  BUZZtep
//
//  Created by Lin on 5/28/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "BTFriendshipModel.h"
#import "Constant.h"
#import "BTMessageModel.h"
#import "BTPeopleModel.h"

@implementation BTFriendshipModel

@synthesize friendship_status;
@synthesize friendship_category;
@synthesize friendship_source;
@synthesize friendship_updatedDate;
@synthesize friendship_createdOn;
@synthesize friendship_frinedOneId;
@synthesize friendship_frinedTwoId;
@synthesize friendship_Id;
@synthesize friendship_messages;
@synthesize friendship_peoples;

- (id)initFriendshipWithLBModel:(LBModel*)model
{
    self = [super init];
    
    if (self)
    {
        @try {
            
            self.friendship_status = @"";
            self.friendship_category = @"";
            self.friendship_source = @"";
            self.friendship_updatedDate = @"";
            self.friendship_createdOn = @"";
            self.friendship_frinedOneId = @"";
            self.friendship_frinedTwoId = @"";
            self.friendship_Id = @"";
            self.friendship_messages = [[NSMutableArray alloc] init];
            self.friendship_peoples = [[NSMutableArray alloc] init];
            
            // status
            
            if ([model objectForKeyedSubscript:@"status"])
            {
                self.friendship_status = [model objectForKeyedSubscript:@"status"];
            }
            
            // category
            
            if ([model objectForKeyedSubscript:@"category"])
            {
                self.friendship_category = [model objectForKeyedSubscript:@"category"];
            }
            
            // source
            
            if ([model objectForKeyedSubscript:@"source"])
            {
                self.friendship_source = [model objectForKeyedSubscript:@"source"];
            }
            
            // createdOn
            
            if ([model objectForKeyedSubscript:@"createdOn"])
            {
                self.friendship_createdOn = [model objectForKeyedSubscript:@"createdOn"];
            }
            
            // friendOne
            
            if ([model objectForKeyedSubscript:@"friendOne"])
            {
                self.friendship_frinedOneId= [model objectForKeyedSubscript:@"friendOne"];
            }
            
            // friendTwo
            
            if ([model objectForKeyedSubscript:@"friendTwo"])
            {
                self.friendship_frinedTwoId = [model objectForKeyedSubscript:@"friendTwo"];
            }
            
            // id
            
            if ([model objectForKeyedSubscript:@"id"])
            {
                self.friendship_Id = [model objectForKeyedSubscript:@"id"];
            }
            
            // peoples
            
            if ([model objectForKeyedSubscript:@"people"])
            {
                if ([[model objectForKeyedSubscript:@"people"] isKindOfClass:[NSArray class]])
                {
                    NSInteger pCount = [[model objectForKeyedSubscript:@"people"] count];
                    
                    if (pCount)
                    {
                        for (int i = 0 ; i < pCount ; i ++ )
                        {
                            NSDictionary* peopleDict = [[model objectForKeyedSubscript:@"people"] objectAtIndex:i];
                            
                            BTPeopleModel* people = [[BTPeopleModel alloc] initPeopleWithDict:peopleDict];
                            
                            [self.friendship_peoples addObject:people];
                        }
                    }
                }
            }
            
            // messages
            
            if ([model objectForKeyedSubscript:@"messages"])
            {
                if ([[model objectForKeyedSubscript:@"messages"] isKindOfClass:[NSArray class]])
                {
                    NSInteger mCount = [[model objectForKeyedSubscript:@"messages"] count];
                    
                    if (mCount)
                    {
                        for (int i = 0 ; i < mCount ; i ++ )
                        {
                            NSDictionary* messageDict = [[model objectForKeyedSubscript:@"messages"] objectAtIndex:i];
                            
                            BTMessageModel* message = [[BTMessageModel alloc] initMessageWithDict:messageDict];
                            
                            [self.friendship_messages addObject:message];
                        }
                    }
                }
            }
            
        }
        @catch (NSException *exception)
        {
            DLog(@"%@",[exception description]);
            DLog(@"%@",[exception callStackSymbols]);
            
        }
        @finally {
            
        }
        
    }
    
    return self;
    
}

- (id)initFriendshipWithDict:(NSDictionary*)model
{
    self = [super init];
    
    if (self)
    {
        @try {
            
            self.friendship_status = @"";
            self.friendship_category = @"";
            self.friendship_source = @"";
            self.friendship_updatedDate = @"";
            self.friendship_createdOn = @"";
            self.friendship_frinedOneId = @"";
            self.friendship_frinedTwoId = @"";
            self.friendship_Id = @"";
            self.friendship_messages = [[NSMutableArray alloc] init];
            self.friendship_peoples = [[NSMutableArray alloc] init];
            
            // status
            
            if ([model objectForKeyedSubscript:@"status"])
            {
                self.friendship_status = [model objectForKeyedSubscript:@"status"];
            }
            
            // category
            
            if ([model objectForKeyedSubscript:@"category"])
            {
                self.friendship_category = [model objectForKeyedSubscript:@"category"];
            }
            
            // source
            
            if ([model objectForKeyedSubscript:@"source"])
            {
                self.friendship_source = [model objectForKeyedSubscript:@"source"];
            }
            
            // createdOn
            
            if ([model objectForKeyedSubscript:@"createdOn"])
            {
                self.friendship_createdOn = [model objectForKeyedSubscript:@"createdOn"];
            }
            
            // friendOne
            
            if ([model objectForKeyedSubscript:@"friendOne"])
            {
                self.friendship_frinedOneId= [model objectForKeyedSubscript:@"friendOne"];
            }
            
            // friendTwo
            
            if ([model objectForKeyedSubscript:@"friendTwo"])
            {
                self.friendship_frinedTwoId = [model objectForKeyedSubscript:@"friendTwo"];
            }
            
            // id
            
            if ([model objectForKeyedSubscript:@"id"])
            {
                self.friendship_Id = [model objectForKeyedSubscript:@"id"];
            }
            
            // peoples
            
            if ([model objectForKeyedSubscript:@"people"])
            {
                if ([[model objectForKeyedSubscript:@"people"] isKindOfClass:[NSArray class]])
                {
                    NSInteger pCount = [[model objectForKeyedSubscript:@"people"] count];
                    
                    if (pCount)
                    {
                        for (int i = 0 ; i < pCount ; i ++ )
                        {
                            NSDictionary* peopleDict = [[model objectForKeyedSubscript:@"people"] objectAtIndex:i];
                            
                            BTPeopleModel* people = [[BTPeopleModel alloc] initPeopleWithDict:peopleDict];
                            
                            [self.friendship_peoples addObject:people];
                        }
                    }
                }
            }
            
            // messages
            
            if ([model objectForKeyedSubscript:@"messages"])
            {
                if ([[model objectForKeyedSubscript:@"messages"] isKindOfClass:[NSArray class]])
                {
                    NSInteger mCount = [[model objectForKeyedSubscript:@"messages"] count];
                    
                    if (mCount)
                    {
                        for (int i = 0 ; i < mCount ; i ++ )
                        {
                            NSDictionary* messageDict = [[model objectForKeyedSubscript:@"messages"] objectAtIndex:i];
                            
                            BTMessageModel* message = [[BTMessageModel alloc] initMessageWithDict:messageDict];
                            
                            [self.friendship_messages addObject:message];
                        }
                    }
                }
            }
            
        }
        @catch (NSException *exception)
        {
            DLog(@"%@",[exception description]);
            DLog(@"%@",[exception callStackSymbols]);
            
        }
        @finally {
            
        }
        
    }
    
    return self;
}

@end
