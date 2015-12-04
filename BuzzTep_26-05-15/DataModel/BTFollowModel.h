//
//  BTFollowModel.h
//  BUZZtep
//
//  Created by Lin on 6/6/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 {
 createdOn = "2015-06-06T01:59:19.471Z";
 followedId = 55665cce04cdbee008428022;
 followerId = 55665cce04cdbee008428024;
 id = 557253f74c300ed30cb34204;
 }
 
 */

@interface BTFollowModel : NSObject

@property (nonatomic, strong) NSString* follow_createdOn;
@property (nonatomic, strong) NSString* follow_followedId;
@property (nonatomic, strong) NSString* follow_followerId;
@property (nonatomic, strong) NSString* follow_ID;

- (id)initFollowWithDict:(NSDictionary* )model;

@end
