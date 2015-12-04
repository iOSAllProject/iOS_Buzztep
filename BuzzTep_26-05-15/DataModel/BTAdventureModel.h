//
//  BTAdventureModel.h
//  BUZZtep
//
//  Created by Lin on 6/8/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 {
 "title": "",
 "city": "",
 "country": "",
 "createdOn": "",
 "startDate": "",
 "startLocation": "geopoint",
 "endDate": "",
 "endLocation": "geopoint",
 "statistics": {
    "visitCount": 0,
    "distanceTraveled": 0,
    "distanceUnit": "km",
    "mediaCount": 0
 },
 "settings": {
    "undercover": false,
    "wallPublic": true,
    "mapPublic": true,
    "adventurePublic": true,
    "friendsPublic": true
 },
 "id": "objectid",
 "currentId": "objectid",
 "personId": "objectid"
 }
 */

@interface BTAdventureModel : NSObject

@property (nonatomic, strong) NSString* adventure_Id;
@property (nonatomic, strong) NSString* adventure_currentId;
@property (nonatomic, strong) NSString* adventure_personId;
@property (nonatomic, strong) NSString* adventure_title;
@property (nonatomic, strong) NSString* adventure_city;
@property (nonatomic, strong) NSString* adventure_country;
@property (nonatomic, strong) NSString* adventure_createdOn;
@property (nonatomic, strong) NSString* adventure_startDate;
@property (nonatomic, strong) NSString* adventure_startLocation;
@property (nonatomic, strong) NSString* adventure_endDate;
@property (nonatomic, strong) NSString* adventure_endLocation;
@property (nonatomic, strong) NSDictionary* adventure_statistics;
@property (nonatomic, strong) NSDictionary* adventure_settings;

- (id)initAdventureWithDict:(NSDictionary* )model;

@end
