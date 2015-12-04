//
//  BTBucketItemModel.m
//  BUZZtep
//
//  Created by Mac on 6/29/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "BTBucketItemModel.h"
#import "Constant.h"
@implementation BTBucketItemModel
@synthesize bucketitem_Id,bucketitem_personId,bucketitem_localtion,bucketitem_companyName,bucketitem_createdOn,bucketitem_title;
- (id)initBucketItemWithDict:(NSDictionary *)model{
    self = [super init];

    if (self)
    {
        @try {

            self.bucketitem_Id = @"";
            self.bucketitem_personId = @"";
            self.bucketitem_localtion = @"";
            self.bucketitem_companyName = @"";
            self.bucketitem_createdOn = @"";
            self.bucketitem_title = @"";
            if ([model objectForKeyedSubscript:@"id"])
            {
                self.bucketitem_Id = [model objectForKeyedSubscript:@"id"];
            }

            if ([model objectForKeyedSubscript:@"personId"])
            {
                self.bucketitem_personId = [model objectForKeyedSubscript:@"personId"];
            }

            if ([model objectForKeyedSubscript:@"localtion"])
            {
                self.bucketitem_localtion = [model objectForKeyedSubscript:@"localtion"];
            }

            if ([model objectForKeyedSubscript:@"companyName"])
            {
                self.bucketitem_companyName = [model objectForKeyedSubscript:@"companyName"];
            }

            if ([model objectForKeyedSubscript:@"createdOn"])
            {
                self.bucketitem_createdOn = [model objectForKeyedSubscript:@"createdOn"];
            }

            if ([model objectForKeyedSubscript:@"title"])
            {
                self.bucketitem_title = [model objectForKeyedSubscript:@"title"];
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
