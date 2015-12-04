//
//  BTMilestoneModel.h
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
 "statistics": {
 "distanceTraveled": 0,
 "distanceUnit": "km"
 },
 "id": "objectid",
 "personId": "objectid"
 }
 */
@interface BTMilestoneModel : NSObject

@property (nonatomic, strong) NSString* milestone_Id;
@property (nonatomic, strong) NSString* milestone_personId;
@property (nonatomic, strong) NSString* milestone_title;
@property (nonatomic, strong) NSString* milestone_city;
@property (nonatomic, strong) NSString* milestone_country;
@property (nonatomic, strong) NSString* milestone_createdOn;
@property (nonatomic, strong) NSDictionary* milestone_statistics;

- (id)initMilestoneWithDict:(NSDictionary* )model;

@end
