//
//  BTMediaModel.h
//  BUZZtep
//
//  Created by Lin on 6/28/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 createdOn = "2015-06-27T04:07:08.441Z";
 data =             {
 container = events;
 filename = "5d85329c3b2e8d59.jpg";
 };
 eventId = 558e216c17eb487a5ffcf0a1;
 id = 558e216c17eb487a5ffcf0a2;
 location =             {
 lat = "22.284681";
 lng = "114.158177";
 };
 name = "event_metadata";
 personId = 55665cce04cdbee008428024;
 statistics =             {
 bucketLists = 0;
 comments = 0;
 likes = 0;
 views = 0;
 };
 type = event;
 
 */

@interface BTMediaModel : NSObject

@property (nonatomic, strong) NSString*     media_createdOn;
@property (nonatomic, strong) NSDictionary* media_data;
@property (nonatomic, strong) NSString*     media_eventId;
@property (nonatomic, strong) NSString*     media_adventureId;
@property (nonatomic, strong) NSString*     media_milestoneId;
@property (nonatomic, strong) NSString*     media_Id;
@property (nonatomic, strong) NSDictionary* media_location;
@property (nonatomic, strong) NSString*     media_name;
@property (nonatomic, strong) NSString*     media_personId;
@property (nonatomic, strong) NSDictionary* media_statistics;
@property (nonatomic, strong) NSString*     media_type;

- (id)initMediaWithDict:(NSDictionary* )model;

- (NSString* )mediaDownloadPath;
- (NSInteger) mediaViewCount;
- (NSInteger) mediaLikeCount;
- (NSInteger) mediaCommentCount;
- (NSInteger) mediaBucketListCount;


@end
