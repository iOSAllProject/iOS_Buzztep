//
//  BTMetadataModel.h
//  BUZZtep
//
//  Created by Mac on 6/23/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 {
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
 }
 */
@interface BTMetadataModel : NSObject
@property (nonatomic, strong) NSString* metadata_name;
@property (nonatomic, strong) NSString* metadata_type;
@property (nonatomic, strong) NSString* metadata_source;
@property (nonatomic, strong) NSString* metadata_uploadIp;
@property (nonatomic, strong) NSString* metadata_createdOn;
@property (nonatomic, strong) NSString* metadata_Id;
@property (nonatomic, strong) NSString* metadata_adventureId;
@property (nonatomic, strong) NSString* metadata_eventId;
@property (nonatomic, strong) NSString* metadata_meetupId;
@property (nonatomic, strong) NSString* metadata_milestoneId;
@property (nonatomic, strong) NSString* metadata_personId;
@property (nonatomic, strong) NSString* metadata_visitId;

@property (nonatomic, strong) NSDictionary* metadata_data;
@property (nonatomic, strong) NSDictionary* metadata_statistics;
@property (nonatomic, strong) NSDictionary* metadata_location;
- (id)initMediaWithDict:(NSDictionary *)model;
@end
