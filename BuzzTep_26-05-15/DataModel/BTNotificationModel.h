//
//  BTNotificationModel.h
//  BUZZtep
//
//  Created by Lin on 6/2/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"

/*
 
 {
 "type": "",
 "createdOn": "",
 "text": "",
 "id": "objectid",
 "commentId": "objectid",
 "adventureId": "objectid",
 "milestoneId": "objectid",
 "meetupId": "objectid",
 "mediaId": "objectid",
 "eventId": "objectid",
 "personId": "objectid"
 }
 
 */
@interface BTNotificationModel : NSObject

@property (nonatomic, strong) NSString* notification_Id;
@property (atomic, assign)    NotificationTYPE notification_type;
@property (nonatomic, strong) NSString* notification_createdOn;
@property (nonatomic, strong) NSString* notification_text;
@property (nonatomic, strong) NSString* notification_commentId;
@property (nonatomic, strong) NSString* notification_adventureId;
@property (nonatomic, strong) NSString* notification_milestoneId;
@property (nonatomic, strong) NSString* notification_meetupId;
@property (nonatomic, strong) NSString* notification_mediaId;
@property (nonatomic, strong) NSString* notification_eventId;
@property (nonatomic, strong) NSString* notification_personId;

- (id) initNotificationWithDict:(NSDictionary* )model;

@end
