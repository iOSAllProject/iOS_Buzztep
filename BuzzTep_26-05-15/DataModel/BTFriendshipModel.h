//
//  BTFriendshipModel.h
//  BUZZtep
//
//  Created by Lin on 5/28/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <LoopBack/LoopBack.h>

/*
 {
    "status": "",
    "category": "",
    "source": "",   
    "updatedDate": "",
    "createdOn": "",
    "friendOne": "",
    "friendTwo": "",
    "id": "objectid"
 }
 
 */

@interface BTFriendshipModel : NSObject

@property (nonatomic, strong) NSString* friendship_status;
@property (nonatomic, strong) NSString* friendship_category;
@property (nonatomic, strong) NSString* friendship_source;
@property (nonatomic, strong) NSString* friendship_updatedDate;
@property (nonatomic, strong) NSString* friendship_createdOn;
@property (nonatomic, strong) NSString* friendship_frinedOneId;
@property (nonatomic, strong) NSString* friendship_frinedTwoId;
@property (nonatomic, strong) NSString* friendship_Id;

@property (nonatomic, strong) NSMutableArray*  friendship_messages;
@property (nonatomic, strong) NSMutableArray*  friendship_peoples;

- (id)initFriendshipWithLBModel:(LBModel*)model;
- (id)initFriendshipWithDict:(NSDictionary*)model;

@end
