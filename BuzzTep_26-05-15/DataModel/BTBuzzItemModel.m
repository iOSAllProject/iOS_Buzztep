//
//  BTBuzzItemModel.m
//  BUZZtep
//
//  Created by Lin on 6/12/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "BTBuzzItemModel.h"
#import "Constant.h"
#import "BTMediaModel.h"

@implementation BTBuzzItemModel

@synthesize buzzitem_BuzzType;
@synthesize buzzitem_createdOn;
@synthesize buzzitem_personId;
@synthesize buzzitem_BuzzDict;

- (id)initBuzzItemWithDict:(NSDictionary* )model
                  withType:(NSInteger )buzzType
{
    self = [super init];
    
    if (self)
    {
        @try {
            
            self.buzzitem_BuzzType = buzzType;
            self.buzzitem_BuzzDict = Nil;
            self.buzzitem_createdOn = @"";
            self.buzzitem_personId = @"";
            
            if (model)
            {
                self.buzzitem_BuzzDict = model;
            }
            
            if ([model objectForKeyedSubscript:@"createdOn"])
            {
                self.buzzitem_createdOn = [model objectForKeyedSubscript:@"createdOn"];
            }
            
            if ([model objectForKeyedSubscript:@"personId"])
            {
                self.buzzitem_personId = [model objectForKeyedSubscript:@"personId"];
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

- (NSInteger)buzzMediaCount
{
    NSInteger retCount = 0;
    
    if (self.buzzitem_BuzzDict != Nil)
    {
        if ([self.buzzitem_BuzzDict objectForKeyedSubscript:@"media"]
            && [[self.buzzitem_BuzzDict objectForKeyedSubscript:@"media"] isKindOfClass:[NSArray class]])
        {
            NSArray* mediaArray = [self.buzzitem_BuzzDict objectForKeyedSubscript:@"media"];
            
            retCount = [mediaArray count];
        }
    }
    
    return retCount;
}

- (NSInteger)buzzViewCount
{
    NSInteger retCount = 0;
    
    if ([self buzzMediaCount] > 0)
    {
        NSArray* mediaArray = [self.buzzitem_BuzzDict objectForKeyedSubscript:@"media"];
        
        for (int i = 0 ; i < [self buzzMediaCount] ; i ++)
        {
            NSDictionary* mediaDict = [mediaArray objectAtIndex:i];
            
            BTMediaModel* media = [[BTMediaModel alloc] initMediaWithDict:mediaDict];
            
            retCount = retCount + [media mediaViewCount];
        }
    }
    
    return retCount;
}

- (NSInteger) buzzLikeCount
{
    NSInteger retCount = 0;
    
    if ([self buzzMediaCount] > 0)
    {
        NSArray* mediaArray = [self.buzzitem_BuzzDict objectForKeyedSubscript:@"media"];
        
        for (int i = 0 ; i < [self buzzMediaCount] ; i ++)
        {
            NSDictionary* mediaDict = [mediaArray objectAtIndex:i];
            
            BTMediaModel* media = [[BTMediaModel alloc] initMediaWithDict:mediaDict];
            
            retCount = retCount + [media mediaLikeCount];
        }
    }
    
    return retCount;
}

- (NSInteger) buzzCommentCount
{
    NSInteger retCount = 0;
    
    if ([self buzzMediaCount] > 0)
    {
        NSArray* mediaArray = [self.buzzitem_BuzzDict objectForKeyedSubscript:@"media"];
        
        for (int i = 0 ; i < [self buzzMediaCount] ; i ++)
        {
            NSDictionary* mediaDict = [mediaArray objectAtIndex:i];
            
            BTMediaModel* media = [[BTMediaModel alloc] initMediaWithDict:mediaDict];
            
            retCount = retCount + [media mediaCommentCount];
        }
    }
    
    return retCount;
}

- (NSInteger) buzzBucketListCount
{
    NSInteger retCount = 0;
    
    if ([self buzzMediaCount] > 0)
    {
        NSArray* mediaArray = [self.buzzitem_BuzzDict objectForKeyedSubscript:@"media"];
        
        for (int i = 0 ; i < [self buzzMediaCount] ; i ++)
        {
            NSDictionary* mediaDict = [mediaArray objectAtIndex:i];
            
            BTMediaModel* media = [[BTMediaModel alloc] initMediaWithDict:mediaDict];
            
            retCount = retCount + [media mediaBucketListCount];
        }
    }
    
    return retCount;
}

@end
