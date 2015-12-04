//
//  BTMessageModel.h
//  BUZZtep
//
//  Created by Lin on 5/28/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 {
 "type": "",
 "text": "",
 "createdOn": "",
 "id": "objectid",
 "friendshipId": "objectid",
 "toPerson": "objectid",
 "createdBy": "objectid",
 "createdById": "objectid",
 "toPersonId": "objectid"
 }
 */

@interface BTMessageModel : NSObject

@property (nonatomic, strong) NSString* message_type;
@property (nonatomic, strong) NSString* message_text;
@property (nonatomic, strong) NSString* message_createdOn;
@property (nonatomic, strong) NSString* message_Id;
@property (nonatomic, strong) NSString* message_friendshipId;
@property (nonatomic, strong) NSString* message_toPerson;
@property (nonatomic, strong) NSString* message_createdBy;
@property (nonatomic, strong) NSString* message_createdById;
@property (nonatomic, strong) NSString* message_toPersonId;

- (id)initMessageWithDict:(NSDictionary*)model;

@end
