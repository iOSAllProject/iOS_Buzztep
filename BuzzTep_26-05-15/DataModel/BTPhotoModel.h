//
//  BTPhotoModel.h
//  BUZZtep
//
//  Created by Mac on 6/10/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
/*{
 "name": "",
 "type": "",
 "source": "",
 "uploadIP": "",
 "data": {
 "container": "",
 "filename": "",
 "dataUrl": "",
 "peakUrl": ""
 },
 "createdOn": "",
 "statistics": {
 "views": 0,
 "likes": 0,
 "bucketLists": 0,
 "comments": 0
 },
 "location": "geopoint",
 "id": "objectid",
 "adventureId": "objectid",
 "eventId": "objectid",
 "meetupId": "objectid",
 "milestoneId": "objectid",
 "personId": "objectid",
 "visitId": "objectid"
 }*/
@interface BTPhotoModel : NSObject
@property (nonatomic, strong) NSString* photo_Id;
@property (nonatomic, strong) NSString* photo_edventureId;
@property (nonatomic, strong) NSString* photo_eventId;
@property (nonatomic, strong) NSString* photo_meetupId;
@property (nonatomic, strong) NSString* photo_milestoneId;
@property (nonatomic, strong) NSString* photo_personId;
@property (nonatomic, strong) NSString* photo_visitId;
@property (nonatomic, strong) NSString* photo_name;
@property (nonatomic, strong) NSString* photo_type;
@property (nonatomic, strong) NSString* photo_source;
@property (nonatomic, strong) NSString* photo_uploadIP;
@property (nonatomic, strong) NSDictionary* photo_data;
@property (nonatomic, strong) NSDate* photo_createdOn;
@property (nonatomic, strong) NSDictionary* photo_statistics;
@property (nonatomic, strong) CLLocation* photo_location;
- (id) initPhotoPeopleWithDict:(NSDictionary* )model;
@end
