//
//  BTPeopleModel.h
//  BUZZtep
//
//  Created by Lin on 5/28/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

/*
 {
 "type": "",
 "deviceId": "",
 "identity": {
 "email": "",
 "phoneNumber": "",
 "firstName": "",
 "lastName": "",
 "companyName": "",
 "shortName": "",
 "websiteUrl": ""
 },
 "auth": {
 "authKey": "",
 "password": ""
 },
 "homeLocation": {
 "city": "",
 "state": "",
 "country": ""
 },
 "lastLocation": "geopoint",
 "companyLocations": [
 "object"
 ],
 "accountActive": "",
 "accountLevel": "",
 "createdOn": "",
 "lastVisitDate": "",
 "ipHistory": [
 "object"
 ],
 "statistics": {
 "followingCount": 0,
 "followerCount": 0,
 "buzzCount": 0,
 "citiesVisited": 0,
 "countriesVisited": 0,
 "continentsVisited": 0,
 "adventuresHad": 0,
 "milestones": 0,
 "eventsAttended": 0
 },
 "settings": {
 "undercover": false,
 "wallPublic": true,
 "mapPublic": true,
 "adventurePublic": true,
 "friendsPublic": true
 },
 "amenities": [
 "object"
 ],
 "id": "objectid"
 }
 */

@interface BTPeopleModel : NSObject

@property (nonatomic, strong) NSString* people_Id;
@property (nonatomic, strong) NSString* people_type;
@property (nonatomic, strong) NSString* people_deviceId;
@property (nonatomic, strong) NSDictionary* people_identity;
@property (nonatomic, strong) NSDictionary* people_auth;
@property (nonatomic, strong) NSDictionary* people_homeLocation;
@property (nonatomic, strong) NSDictionary*   people_lastLocation;
@property (nonatomic, strong) NSMutableArray* people_companyLocations;
@property (nonatomic, strong) NSString* people_accountActive;
@property (nonatomic, strong) NSString* people_accountLevel;
@property (nonatomic, strong) NSString* people_createdOn;
@property (nonatomic, strong) NSString* people_lastVisitDate;
@property (nonatomic, strong) NSMutableArray* people_ipHistory;
@property (nonatomic, strong) NSDictionary* people_statistics;
@property (nonatomic, strong) NSDictionary* people_settings;
@property (nonatomic, strong) NSMutableArray* people_amenities;

@property (nonatomic, assign) BOOL photoError;

- (id) initPeopleWithDict:(NSDictionary* )model;

@end
