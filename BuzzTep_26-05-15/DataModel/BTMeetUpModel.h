//
//  BTMeetUpModel.h
//  BUZZtep
//
//  Created by Mac on 7/2/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//
/*
 {
 "title": "",
 "scheduledDate": "",
 "scheduledLocation": "geopoint",
 "createdOn": "",
 "settings": {
 "undercover": false,
 "wallPublic": true,
 "mapPublic": true,
 "adventurePublic": true,
 "friendsPublic": true
 },
 "id": "objectid"
 }
 */
#import <Foundation/Foundation.h>
#import "Constant.h"
@interface BTMeetUpModel : NSObject
@property (nonatomic, strong) NSString* meetup_Id;
@property (nonatomic, strong) NSString* meetup_scheduledDate;
@property (nonatomic, strong) NSDictionary* meetup_scheduledLocation;
@property (nonatomic, strong) NSDictionary* meetup_settings;
@property (nonatomic, strong) NSString* meetup_title;
@property (nonatomic, strong) NSString* meetup_createdOn;
- (id)initMeetUpWithDict:(NSDictionary *)model;
@end
