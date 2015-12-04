//
//  BTNotificationModel.m
//  BUZZtep
//
//  Created by Lin on 6/2/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "BTNotificationModel.h"
#import "Global.h"
#import "Constant.h"

@implementation BTNotificationModel

@synthesize notification_Id;
@synthesize notification_type;
@synthesize notification_createdOn;
@synthesize notification_text;
@synthesize notification_commentId;
@synthesize notification_adventureId;
@synthesize notification_milestoneId;
@synthesize notification_meetupId;
@synthesize notification_mediaId;
@synthesize notification_eventId;
@synthesize notification_personId;

- (id) initNotificationWithDict:(NSDictionary* )model
{
    self = [super init];
    
    if (self)
    {
        @try {
            
            self.notification_Id = @"";
            self.notification_type = Notification_Type_None;
            self.notification_text = @"";
            self.notification_createdOn = @"";
            self.notification_commentId = @"";
            self.notification_adventureId = @"";
            self.notification_milestoneId = @"";
            self.notification_mediaId = @"";
            self.notification_meetupId = @"";
            self.notification_eventId = @"";
            self.notification_personId = @"";
            
            // Id
            
            if ([model objectForKeyedSubscript:@"id"])
            {
                self.notification_Id = [model objectForKeyedSubscript:@"id"];
            }
            
            // type
            
            if ([model objectForKeyedSubscript:@"type"])
            {
                NSString* typeStr = [model objectForKeyedSubscript:@"type"];
                
                if ([typeStr isEqualToString:@"adventure"])
                {
                    self.notification_type = Notification_Type_Adventure;
                }
                else if ([typeStr isEqualToString:@"milestone"])
                {
                    self.notification_type = Notification_Type_Milestone;
                }
                else if ([typeStr isEqualToString:@"meetup"])
                {
                    self.notification_type = Notification_Type_Meetup;
                }
                else if ([typeStr isEqualToString:@"media"])
                {
                    self.notification_type = Notification_Type_Media;
                }
                else if ([typeStr isEqualToString:@"event"])
                {
                    self.notification_type = Notification_Type_Event;
                }
                else if ([typeStr isEqualToString:@"message"])
                {
                    self.notification_type = Notification_Type_Message;
                }
            }
            
            // createdOn
            
            if ([model objectForKeyedSubscript:@"createdOn"])
            {
                self.notification_createdOn = [model objectForKeyedSubscript:@"createdOn"];
            }
            
            // text
            
            if ([model objectForKeyedSubscript:@"text"])
            {
                self.notification_text = [model objectForKeyedSubscript:@"text"];
            }
            
            // commentId
            
            if ([model objectForKeyedSubscript:@"commentId"])
            {
                self.notification_commentId = [model objectForKeyedSubscript:@"commentId"];
            }
            
            // adventureId
            
            if ([model objectForKeyedSubscript:@"adventureId"])
            {
                self.notification_adventureId = [model objectForKeyedSubscript:@"adventureId"];
            }
            
            // milestoneId
            
            if ([model objectForKeyedSubscript:@"milestoneId"])
            {
                self.notification_milestoneId = [model objectForKeyedSubscript:@"milestoneId"];
            }
            
            // meetupId
            
            if ([model objectForKeyedSubscript:@"meetupId"])
            {
                self.notification_meetupId = [model objectForKeyedSubscript:@"meetupId"];
            }
            
            // mediaId
            
            if ([model objectForKeyedSubscript:@"mediaId"])
            {
                self.notification_mediaId = [model objectForKeyedSubscript:@"mediaId"];
            }
            
            // eventId
            
            if ([model objectForKeyedSubscript:@"eventId"])
            {
                self.notification_eventId = [model objectForKeyedSubscript:@"eventId"];
            }
            
            // personId
            
            if ([model objectForKeyedSubscript:@"personId"])
            {
                self.notification_personId = [model objectForKeyedSubscript:@"personId"];
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
