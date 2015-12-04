//
//  BTVisitModel.h
//  BUZZtep
//
//  Created by Mac on 6/22/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//
/*
 {
 "title": "",
 "createdOn": "",
 "location": "geopoint",
 "id": "objectid",
 "personId": "objectid",
 "adventureId": "objectid",
 "milestoneId": "objectid",
 "meetupId": "objectid",
 "eventId": "objectid"
 }
 */
#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "Constant.h"
@interface BTVisitModel : NSObject
@property (nonatomic, strong) NSString* visit_Id;
@property (nonatomic, strong) NSString* visit_personId;
@property (nonatomic, strong) NSString* visit_adventureId;
@property (nonatomic, strong) NSString* visit_milestoneId;
@property (nonatomic, strong) NSString* visit_meetupId;
@property (nonatomic, strong) NSString* visit_eventId;

@property (nonatomic, strong) NSString* visit_title;
@property (nonatomic, strong) NSString* visit_createdOn;
@property (nonatomic, strong) NSDictionary* visit_location;

- (id)initVisitWithDict:(NSDictionary* )model;
@end
