//
//  Metadata.h
//  BUZZtep
//
//  Created by Mac on 6/1/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Metadata : NSObject
@property (nonatomic, strong)NSString* metadataId;
@property (nonatomic, strong)NSString* name;
@property (nonatomic, strong)NSString* type;
@property (nonatomic, strong)NSString* source;
@property (nonatomic, strong)NSString* uploadIP;
@property (nonatomic, strong)NSString* data_container;
@property (nonatomic, strong)NSString* data_filename;
@property (nonatomic, strong)NSString* data_Url;
@property (nonatomic, strong)NSString* data_peakUrl;
@property (nonatomic, strong)NSDate* createdOn;
@property (nonatomic, assign)NSInteger statistics_views;
@property (nonatomic, assign)NSInteger statistics_likes;
@property (nonatomic, assign)NSInteger statistics_bucketList;
@property (nonatomic, assign)NSInteger statistics_comments;
@property (nonatomic, strong)NSDate* location;
@property (nonatomic, strong)NSString* adventureId;
@property (nonatomic, strong)NSString* eventId;
@property (nonatomic, strong)NSString* mettupId;
@property (nonatomic, strong)NSString* milestoneId;
@property (nonatomic, strong)NSString* personId;
@property (nonatomic, strong)NSString* visitId;
@end
