//
//  BTEventModel.h
//  BUZZtep
//
//  Created by Lin on 6/8/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTEventModel : NSObject

/*
 {
 "title": "",
 "type": "",
 "scheduledDate": "",
 "createdOn": "",
 "location": "geopoint",
 "settings": {
    "undercover": false,
    "wallPublic": true,
    "mapPublic": true,
    "adventurePublic": true,
    "friendsPublic": true
 },
 "id": "objectid",
 "personId": "objectid"
 }
 */

@property (nonatomic, strong) NSString* event_Id;
@property (nonatomic, strong) NSString* event_personId;
@property (nonatomic, strong) NSString* event_title;
@property (nonatomic, strong) NSString* event_type;
@property (nonatomic, strong) NSString* event_scheduledDate;
@property (nonatomic, strong) NSString* event_createdOn;
@property (nonatomic, strong) NSDictionary* event_location;
@property (nonatomic, strong) NSDictionary* event_settings;

- (id)initEventWithDict:(NSDictionary* )model;

@end
