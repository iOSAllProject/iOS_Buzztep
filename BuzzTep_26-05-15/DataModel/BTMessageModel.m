//
//  BTMessageModel.m
//  BUZZtep
//
//  Created by Lin on 5/28/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "BTMessageModel.h"
#import "Constant.h"

@implementation BTMessageModel

@synthesize message_type;
@synthesize message_text;
@synthesize message_createdOn;
@synthesize message_Id;
@synthesize message_friendshipId;
@synthesize message_toPerson;
@synthesize message_createdBy;
@synthesize message_createdById;
@synthesize message_toPersonId;

- (id)initMessageWithDict:(NSDictionary*)model
{
    self = [super init];
    
    if (self)
    {
        @try {
            self.message_type = @"";
            self.message_text = @"";
            self.message_createdOn = @"";
            self.message_Id = @"";
            self.message_friendshipId = @"";
            self.message_toPerson = @"";
            self.message_createdBy = @"";
            self.message_createdById = @"";
            self.message_toPersonId = @"";
            
            // type
            
            if ([model objectForKeyedSubscript:@"type"])
            {
                self.message_type = [model objectForKeyedSubscript:@"type"];
            }
            
            // text
            
            if ([model objectForKeyedSubscript:@"text"])
            {
                self.message_text = [model objectForKeyedSubscript:@"text"];
            }
            
            // createdOn
            
            if ([model objectForKeyedSubscript:@"createdOn"])
            {
                self.message_createdOn = [model objectForKeyedSubscript:@"createdOn"];
            }
            
            // id
            
            if ([model objectForKeyedSubscript:@"id"])
            {
                self.message_Id = [model objectForKeyedSubscript:@"id"];
            }
            
            // friendshipID
            
            if ([model objectForKeyedSubscript:@"friendshipId"])
            {
                self.message_friendshipId = [model objectForKeyedSubscript:@"friendshipId"];
            }
            
            // toPerson
            
            if ([model objectForKeyedSubscript:@"toPerson"])
            {
                self.message_toPerson = [model objectForKeyedSubscript:@"toPerson"];
            }
            
            // createdBy
            
            if ([ model objectForKeyedSubscript:@"createdBy"])
            {
                self.message_createdBy = [model objectForKeyedSubscript:@"createdBy"];
            }
            
            // createdById
            
            if ([ model objectForKeyedSubscript:@"createdById"])
            {
                self.message_createdById = [model objectForKeyedSubscript:@"createdById"];
            }
            
            // toPersonId
            
            if ([model objectForKeyedSubscript:@"toPersonId"])
            {
                self.message_toPersonId = [model objectForKeyedSubscript:@"toPersonId"];
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
