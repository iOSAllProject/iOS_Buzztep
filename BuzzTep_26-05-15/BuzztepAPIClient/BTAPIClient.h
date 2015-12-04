//
//  BTAPIClient.h
//  BUZZtep
//
//  Created by Lin on 5/28/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BTAPIClient : NSObject

+ (instancetype)sharedClient;

// Message List UI
- (void)messageList:(NSString *)modelName
         withFilter:(NSString *)filter
          withBlock:(void (^)(NSArray *models, NSError *error))block;

// Chat History within friendship
- (void)friendShipHistoryList:(NSString *)modelName
             withFriendshipID:(NSString *)friendshipId
                   withFilter:(NSString *)filter
                    withBlock:(void (^)(NSDictionary *model, NSError *error))block;

// Post message to partner through friendship ID
- (void)postMessageWithFriendShip:(NSString* )modelName
                 withFriendshipID:(NSString* )friendshipId
                         withDict:(NSDictionary* )msgDict
                        withBlock:(void (^)(NSDictionary *model, NSError *error))block;

// Get Notification count from server
- (void)getNotificationCount:(NSString* )modelName
                withPersonId:(NSString* )personId
                   withBlock:(void (^)(NSDictionary *model, NSError *error))block;

// Get Notifications from server
- (void)getNotifications:(NSString* )modelName
            withPersonId:(NSString* )personId
               withBlock:(void (^)(NSArray *models, NSError *error))block;

// Get People
- (void)getPeople:(NSString* )modelName
       withFilter:(NSString *)filter
        withBlock:(void (^)(NSArray *models, NSError *error))block;

// Follow
- (void)followPeople:(NSString* )modelName
        withPostDict:(NSDictionary* )postDict
           withBlock:(void (^)(NSDictionary *model, NSError *error))block;

// Get Follow Model
- (void)getFollowPeople:(NSString* )modelName
           withPersonId:(NSString* )personId
             withFilter:(NSString* )filter
              withBlock:(void (^)(NSArray* models, NSError* error))block;

// Unfollow
- (void)unfollow:(NSString* )followId
       withBlock:(void (^)(NSDictionary *model, NSError *error))block;

// Get AdventureCount
- (void)getAdventureCount:(NSString* )modelName
             withPersonId:(NSString* )personId
                withBlock:(void (^)(NSDictionary* model, NSError* error))block;

// Get MileStoneCount
- (void)getMilestoneCount:(NSString* )modelName
             withPersonId:(NSString* )personId
                withBlock:(void (^)(NSDictionary* model, NSError* error))block;

// Get EventsCount
- (void)getEventCount:(NSString* )modelName
         withPersonId:(NSString* )personId
            withBlock:(void (^)(NSDictionary* model, NSError* error))block;
// Get Photo
- (void)getPhotoPeople:(NSString* )modelName withPersonId:(NSString* )personId  withBlock:(void(^)(NSDictionary* model, NSError* error))block;

// Get Buzz list
- (void)getPeopleBuzz:(NSString* )modelName
         withPersonId:(NSString* )personId
            withBlock:(void (^)(NSDictionary* model, NSError* error))block;

// Post Adventure
- (void)postAdventure:(NSString* )modelName
         withPersonId:(NSString* )personId
            withParam:(NSDictionary* )paramDict
            withBlock:(void (^)(NSDictionary* model, NSError* error))block;

// Post Milestone
- (void)postMilestone:(NSString* )modelName
         withPersonId:(NSString* )personId
            withParam:(NSDictionary* )paramDict
            withBlock:(void (^)(NSDictionary* model, NSError* error))block;

// Post Event
- (void)postEvent:(NSString* )modelName
     withPersonId:(NSString* )personId
        withParam:(NSDictionary* )paramDict
        withBlock:(void (^)(NSDictionary* model, NSError* error))block;

// Get Adventure
- (void)getAdventurePeople:(NSString* )modelName
           withPersonId:(NSString* )personId
             withFilter:(NSString* )filter
              withBlock:(void (^)(NSArray* models, NSError* error))block;

// Get Milestone
- (void)getMilestonePeople:(NSString* )modelName
              withPersonId:(NSString* )personId
                withFilter:(NSString* )filter
                 withBlock:(void (^)(NSArray* models, NSError* error))block;

// Get Events
- (void)getEventPeople:(NSString* )modelName
              withPersonId:(NSString* )personId
                withFilter:(NSString* )filter
                 withBlock:(void (^)(NSArray* models, NSError* error))block;

// Get FollowBy Model

- (void)getFollowByPeople:(NSString* )modelName
           withPersonId:(NSString* )personId
             withFilter:(NSString* )filter
              withBlock:(void (^)(NSArray* models, NSError* error))block;

- (void)getVisitPeople:(NSString* )modelName
             withPersonId:(NSString* )personId
               withFilter:(NSString* )filter
                withBlock:(void (^)(NSArray* models, NSError* error))block;

// Get Visit
- (void)getVisit:(NSString* )modelName
       withFilter:(NSString *)filter
        withBlock:(void (^)(NSArray *models, NSError *error))block;

// Get Media Visit
- (void)getMediaVisit:(NSString* )modelName
                withVisitId:(NSString* )visitId
                   withBlock:(void (^)(NSArray *models, NSError *error))block;

// Get FriendShip
- (void)getFriendShipPeople:(NSString* )modelName
          withPersonId:(NSString* )personId
            withFilter:(NSString* )filter
             withBlock:(void (^)(NSArray* models, NSError* error))block;

// Get Bucket Item
- (void)getBucketItemPeople:(NSString* )modelName
              withPersonId:(NSString* )personId
                withFilter:(NSString* )filter
                 withBlock:(void (^)(NSArray* models, NSError* error))block;

// Post Bucket List
- (void)postBucketList:(NSString* )modelName
         withPersonId:(NSString* )personId
            withParam:(NSDictionary* )paramDict
            withBlock:(void (^)(NSDictionary* model, NSError* error))block;
- (void)createMetadata:(NSString* )modelName
              withDict:(NSDictionary* )postDict
             withBlock:(void (^)(NSDictionary* model, NSError* error))block;

// Get MeetUp
- (void)getMeetUpPeople:(NSString* )modelName
               withPersonId:(NSString* )personId
                 withFilter:(NSString* )filter
                  withBlock:(void (^)(NSArray* models, NSError* error))block;

// Get Friends
- (void)getFriends:(NSString* )modelName
      withPersonId:(NSString* )personId
        withFilter:(NSString* )filter
         withBlock:(void (^)(NSArray* models, NSError* error))block;

// Delete Metadata

- (void)deleteMetadta:(NSString* )metadatId
            withBlock:(void (^)(NSDictionary* model, NSError* error))block;

// Refresh Buzz Information

- (void)refreshBuzzFor:(NSString* )modelName
           withModelID:(NSString* )modelId
            withFilter:(NSString* )filter
             withBlock:(void (^)(NSDictionary* model, NSError* error))block;

// Refresh Server BuzzData

- (void)refreshSeverBuzzFor:(NSString* )modelName
                withModelID:(NSString* )modelId
                   withDict:(NSDictionary* )modelDict
                  withBlock:(void (^)(NSDictionary* model, NSError* error))block;

// Creat People
- (void)createPeople:(NSString* )modelName
            withDict:(NSDictionary* )postDict
           withBlock:(void (^)(NSDictionary* model, NSError* error))block;


// Creat People
- (void)uploadImage:(NSString* )container
           withData:(UIImage* )image
       withFileName:(NSString* )fileName
          withBlock:(void (^)(NSDictionary* model, NSError* error))block;
@end
