//
//  BTAPIClient.m
//  BUZZtep
//
//  Created by Lin on 5/28/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "BTAPIClient.h"

#import "AppDelegate.h"

#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPRequestOperation.h"
#import "AFURLSessionManager.h"

#import "Constant.h"

@implementation BTAPIClient

+ (instancetype)sharedClient
{
    static BTAPIClient *_sharedClient = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedClient = [[BTAPIClient alloc] init];
    });
    
    return _sharedClient;
}

- (void)messageList:(NSString *)modelName
         withFilter:(NSString *)filter
          withBlock:(void (^)(NSArray *models, NSError *error))block
{
    @try {
        
        NSString *getURL = [NSString stringWithFormat:@"%@/%@/%@/friendships?%@", BASEURL, modelName, MyPersonModelID, filter];
        
        getURL = [getURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager GET:getURL parameters:filter success:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            block(responseObject,nil);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            NSLog(@"ERROR in API %@: %@", modelName, error.localizedDescription);
            
            block(Nil, error);
            
        }];
        
    }
    @catch (NSException *exception) {
        DLog(@"%@",[exception description]);
        DLog(@"%@",[exception callStackSymbols]);
    }
    @finally {
        
    }
}

- (void)friendShipHistoryList:(NSString *)modelName
             withFriendshipID:(NSString *)friendshipId
                   withFilter:(NSString *)filter
                    withBlock:(void (^)(NSDictionary *model, NSError *error))block
{
    @try {
        
        NSString *getURL = [NSString stringWithFormat:@"%@/%@/%@?%@", BASEURL, modelName, friendshipId, filter];
        
        getURL = [getURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager GET:getURL parameters:filter success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             block(responseObject,nil);
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"ERROR in API %@: %@", modelName, error.localizedDescription);
             
             block(Nil, error);
             
         }];        
    }
    @catch (NSException *exception) {
        DLog(@"%@",[exception description]);
        DLog(@"%@",[exception callStackSymbols]);
    }
    @finally {
        
    }
}

- (void)postMessageWithFriendShip:(NSString* )modelName
                 withFriendshipID:(NSString* )friendshipId
                         withDict:(NSDictionary* )msgDict
                        withBlock:(void (^)(NSDictionary *model, NSError *error))block
{
    @try {
        
        NSString *postURL = [NSString stringWithFormat:@"%@/%@/%@/%@", BASEURL, modelName, friendshipId, @"messages"];
        
        postURL = [postURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager POST:postURL parameters:msgDict success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             block(responseObject,nil);
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"ERROR in API %@: %@", modelName, error.localizedDescription);
             
             block(Nil, error);
             
         }];
    }
    @catch (NSException *exception) {
        DLog(@"%@",[exception description]);
        DLog(@"%@",[exception callStackSymbols]);
    }
    @finally {
        
    }
}

- (void)getNotificationCount:(NSString* )modelName
                withPersonId:(NSString* )personId
                   withBlock:(void (^)(NSDictionary *model, NSError *error))block
{
    @try {
        
        NSString *postURL = [NSString stringWithFormat:@"%@/%@/%@/notifications/count", BASEURL, modelName, personId];
        
        postURL = [postURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager GET:postURL parameters:Nil success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             block(responseObject,nil);
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"ERROR in API %@: %@", modelName, error.localizedDescription);
             
             block(Nil, error);
             
         }];
    }
    @catch (NSException *exception) {
        DLog(@"%@",[exception description]);
        DLog(@"%@",[exception callStackSymbols]);
    }
    @finally {
        
    }
}

- (void)getNotifications:(NSString* )modelName
            withPersonId:(NSString* )personId
               withBlock:(void (^)(NSArray *models, NSError *error))block
{
    // http://buzztep.com:80/api/people/55665cce04cdbee008428024/notifications
    @try {
        
        NSString *getURL = [NSString stringWithFormat:@"%@/%@/%@/notifications", BASEURL, modelName, personId];
        
        getURL = [getURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager GET:getURL parameters:Nil success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             block(responseObject,nil);
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"ERROR in API %@: %@", modelName, error.localizedDescription);
             
             block(Nil, error);
             
         }];
    }
    @catch (NSException *exception) {
        DLog(@"%@",[exception description]);
        DLog(@"%@",[exception callStackSymbols]);
    }
    @finally {
        
    }
}

- (void)getPeople:(NSString* )modelName
       withFilter:(NSString* )filter
        withBlock:(void (^)(NSArray *models, NSError *error))block
{
    @try {
        
        NSString *getURL = [NSString stringWithFormat:@"%@/%@/?%@", BASEURL, modelName, filter];
        
        getURL = [getURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager GET:getURL parameters:Nil success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             block(responseObject,nil);
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"ERROR in API %@: %@", modelName, error.localizedDescription);
             
             block(Nil, error);
         
         }];
    }
    @catch (NSException *exception) {
        DLog(@"%@",[exception description]);
        DLog(@"%@",[exception callStackSymbols]);
    }
    @finally {
        
    }
}

// Follow

- (void)followPeople:(NSString* )modelName
        withPostDict:(NSDictionary* )postDict
           withBlock:(void (^)(NSDictionary *model, NSError *error))block;
{
    @try {
        
        NSString *postURL = [NSString stringWithFormat:@"%@/%@", BASEURL, modelName];
        
        postURL = [postURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager POST:postURL parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             block(responseObject,nil);
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"ERROR in API %@: %@", modelName, error.localizedDescription);
             
             block(Nil, error);
             
         }];
    }
    @catch (NSException *exception) {
        DLog(@"%@",[exception description]);
        DLog(@"%@",[exception callStackSymbols]);
    }
    @finally {
        
    }
}

- (void)getFollowPeople:(NSString* )modelName
           withPersonId:(NSString* )personId
             withFilter:(NSString* )filter
              withBlock:(void (^)(NSArray* models, NSError* error))block
{
    @try {
        
        NSString *getURL = [NSString stringWithFormat:@"%@/%@/%@/follows?%@", BASEURL, modelName, personId, filter];
        
        getURL = [getURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager GET:getURL parameters:Nil success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             block(responseObject,nil);
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"ERROR in API %@: %@", modelName, error.localizedDescription);
             
             block(Nil, error);
             
         }];
    }
    @catch (NSException *exception) {
        DLog(@"%@",[exception description]);
        DLog(@"%@",[exception callStackSymbols]);
    }
    @finally {
        
    }
}

- (void)unfollow:(NSString* )followId
       withBlock:(void (^)(NSDictionary *model, NSError *error))block
{
    // http://buzztep.com:80/api/follow/557253f74c300ed30cb34204
    
    @try {
        
        NSString *deleteURL = [NSString stringWithFormat:@"%@/follow/%@", BASEURL, followId];
        
        deleteURL = [deleteURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager DELETE:deleteURL
             parameters:Nil
                success:^(AFHTTPRequestOperation *operation, id responseObject)
        {
            block(responseObject,nil);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error)
        {
            NSLog(@"ERROR in API %@: %@", deleteURL, error.localizedDescription);
            
            block(Nil, error);
            
        }];
    }
    @catch (NSException *exception) {
        DLog(@"%@",[exception description]);
        DLog(@"%@",[exception callStackSymbols]);
    }
    @finally {
        
    }
}

// Get AdventureCount

- (void)getAdventureCount:(NSString* )modelName
             withPersonId:(NSString* )personId
                withBlock:(void (^)(NSDictionary* model, NSError* error))block
{
    @try {
        
        NSString *getURL = [NSString stringWithFormat:@"%@/%@/%@/adventures/count", BASEURL, modelName, personId];
        
        getURL = [getURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager GET:getURL parameters:Nil success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             block(responseObject,nil);
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"ERROR in API %@: %@", modelName, error.localizedDescription);
             
             block(Nil, error);
             
         }];
    }
    @catch (NSException *exception) {
        DLog(@"%@",[exception description]);
        DLog(@"%@",[exception callStackSymbols]);
    }
    @finally {
        
    }
}
// Get MileStoneCount

- (void)getMilestoneCount:(NSString* )modelName
             withPersonId:(NSString* )personId
                withBlock:(void (^)(NSDictionary* model, NSError* error))block
{
    @try {
        
        NSString *getURL = [NSString stringWithFormat:@"%@/%@/%@/milestones/count", BASEURL, modelName, personId];
        
        getURL = [getURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager GET:getURL parameters:Nil success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             block(responseObject,nil);
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"ERROR in API %@: %@", modelName, error.localizedDescription);
             
             block(Nil, error);
             
         }];
    }
    @catch (NSException *exception) {
        DLog(@"%@",[exception description]);
        DLog(@"%@",[exception callStackSymbols]);
    }
    @finally {
        
    }
}

// Get EventsCount

- (void)getEventCount:(NSString* )modelName
         withPersonId:(NSString* )personId
            withBlock:(void (^)(NSDictionary* model, NSError* error))block
{
    @try {
        
        NSString *getURL = [NSString stringWithFormat:@"%@/%@/%@/events/count", BASEURL, modelName, personId];
        
        getURL = [getURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager GET:getURL parameters:Nil success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             block(responseObject,nil);
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"ERROR in API %@: %@", modelName, error.localizedDescription);
             
             block(Nil, error);
         }];
    }
    @catch (NSException *exception) {
        DLog(@"%@",[exception description]);
        DLog(@"%@",[exception callStackSymbols]);
    }
    @finally {
        
    }
}

// Get photo

- (void)getPhotoPeople:(NSString *)modelName withPersonId:(NSString *)personId withBlock:(void (^)(NSDictionary *model, NSError *error))block{
    @try {

        NSString *getURL = [NSString stringWithFormat:@"%@/%@/%@/photo", BASEURL, modelName, personId];

        getURL = [getURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

        [manager GET:getURL parameters:Nil success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             block(responseObject,nil);

         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

             NSLog(@"ERROR in API %@: %@", modelName, error.localizedDescription);
		block(Nil, error);
         }];
    }
    @catch (NSException *exception) {
        DLog(@"%@",[exception description]);
        DLog(@"%@",[exception callStackSymbols]);
    }
    @finally {

    }
}

- (void)getPeopleBuzz:(NSString* )modelName
         withPersonId:(NSString* )personId
            withBlock:(void (^)(NSDictionary* model, NSError* error))block
{
    @try {
        
        NSString *getURL = [NSString stringWithFormat:@"%@/%@/%@/getBuzz", BASEURL, modelName, personId];
        
        getURL = [getURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
                
        [manager GET:getURL parameters:Nil success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             block(responseObject,nil);
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"ERROR in API %@: %@", modelName, error.localizedDescription);
             
             block(Nil, error);
         }];
    }
    @catch (NSException *exception) {
        DLog(@"%@",[exception description]);
        DLog(@"%@",[exception callStackSymbols]);
    }
    @finally {
        
    }
}

// Post Adventure
- (void)postAdventure:(NSString* )modelName
         withPersonId:(NSString* )personId
            withParam:(NSDictionary* )paramDict
            withBlock:(void (^)(NSDictionary* model, NSError* error))block
{
    @try {
        
        NSString *postURL = [NSString stringWithFormat:@"%@/%@/%@/adventures", BASEURL, modelName, personId];
        
        postURL = [postURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager POST:postURL parameters:paramDict success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             block(responseObject,nil);
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"ERROR in API %@: %@", modelName, error.localizedDescription);
             
             block(Nil, error);
             
         }];
    }
    @catch (NSException *exception) {
        DLog(@"%@",[exception description]);
        DLog(@"%@",[exception callStackSymbols]);
    }
    @finally {
        
    }
}

// Post Milestone
- (void)postMilestone:(NSString* )modelName
         withPersonId:(NSString* )personId
            withParam:(NSDictionary* )paramDict
            withBlock:(void (^)(NSDictionary* model, NSError* error))block
{
    @try {
        
        NSString *postURL = [NSString stringWithFormat:@"%@/%@/%@/milestones", BASEURL, modelName, personId];
        
        postURL = [postURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager POST:postURL parameters:paramDict success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             block(responseObject,nil);
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"ERROR in API %@: %@", modelName, error.localizedDescription);
             
             block(Nil, error);
             
         }];
    }
    @catch (NSException *exception) {
        DLog(@"%@",[exception description]);
        DLog(@"%@",[exception callStackSymbols]);
    }
    @finally {
        
    }
}

// Post Event
- (void)postEvent:(NSString* )modelName
     withPersonId:(NSString* )personId
        withParam:(NSDictionary* )paramDict
        withBlock:(void (^)(NSDictionary* model, NSError* error))block
{
    @try {
        
        NSString *postURL = [NSString stringWithFormat:@"%@/%@/%@/events", BASEURL, modelName, personId];
        
        postURL = [postURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager POST:postURL parameters:paramDict success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             block(responseObject,nil);
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"ERROR in API %@: %@", modelName, error.localizedDescription);
             
             block(Nil, error);
             
         }];
    }
    @catch (NSException *exception) {
        DLog(@"%@",[exception description]);
        DLog(@"%@",[exception callStackSymbols]);
    }
    @finally {
        
    }
}

// Get Adventure
- (void)getAdventurePeople:(NSString* )modelName
              withPersonId:(NSString* )personId
                withFilter:(NSString* )filter
                 withBlock:(void (^)(NSArray* models, NSError* error))block{
    @try {

        NSString *getURL = [NSString stringWithFormat:@"%@/%@/%@/adventures?%@", BASEURL, modelName, personId, filter];

        getURL = [getURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

        [manager GET:getURL parameters:Nil success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             block(responseObject,nil);

         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

             NSLog(@"ERROR in API %@: %@", modelName, error.localizedDescription);

             block(Nil, error);

         }];
    }
    @catch (NSException *exception) {
        DLog(@"%@",[exception description]);
        DLog(@"%@",[exception callStackSymbols]);
    }
    @finally {

    }
}

// Get Milestones
- (void)getMilestonePeople:(NSString* )modelName
              withPersonId:(NSString* )personId
                withFilter:(NSString* )filter
                 withBlock:(void (^)(NSArray* models, NSError* error))block{
    @try {

        NSString *getURL = [NSString stringWithFormat:@"%@/%@/%@/milestones?%@", BASEURL, modelName, personId, filter];

        getURL = [getURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

        [manager GET:getURL parameters:Nil success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             block(responseObject,nil);

         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

             NSLog(@"ERROR in API %@: %@", modelName, error.localizedDescription);

             block(Nil, error);

         }];
    }
    @catch (NSException *exception) {
        DLog(@"%@",[exception description]);
        DLog(@"%@",[exception callStackSymbols]);
    }
    @finally {
        
    }
}

// Get Events
- (void)getEventPeople:(NSString* )modelName
          withPersonId:(NSString* )personId
            withFilter:(NSString* )filter
             withBlock:(void (^)(NSArray* models, NSError* error))block{
    @try {

        NSString *getURL = [NSString stringWithFormat:@"%@/%@/%@/events?%@", BASEURL, modelName, personId, filter];

        getURL = [getURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

        [manager GET:getURL parameters:Nil success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             block(responseObject,nil);

         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

             NSLog(@"ERROR in API %@: %@", modelName, error.localizedDescription);

             block(Nil, error);

         }];
    }
    @catch (NSException *exception) {
        DLog(@"%@",[exception description]);
        DLog(@"%@",[exception callStackSymbols]);
    }
    @finally {
        
    }
}
- (void)getFollowByPeople:(NSString* )modelName
             withPersonId:(NSString* )personId
               withFilter:(NSString* )filter
                withBlock:(void (^)(NSArray* models, NSError* error))block{
    @try {

        NSString *getURL = [NSString stringWithFormat:@"%@/%@/%@/followedBy?%@", BASEURL, modelName, personId, filter];

        getURL = [getURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

        [manager GET:getURL parameters:Nil success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             block(responseObject,nil);

         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

             NSLog(@"ERROR in API %@: %@", modelName, error.localizedDescription);

             block(Nil, error);

         }];
    }
    @catch (NSException *exception) {
        DLog(@"%@",[exception description]);
        DLog(@"%@",[exception callStackSymbols]);
    }
    @finally {

    }
}
// Get Visit
- (void)getVisitPeople:(NSString* )modelName
          withPersonId:(NSString* )personId
            withFilter:(NSString* )filter
             withBlock:(void (^)(NSArray* models, NSError* error))block{
    @try {

        NSString *getURL = [NSString stringWithFormat:@"%@/%@/%@/visitedLocations?%@", BASEURL, modelName, personId, filter];

        getURL = [getURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

        [manager GET:getURL parameters:Nil success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             block(responseObject,nil);

         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

             NSLog(@"ERROR in API %@: %@", modelName, error.localizedDescription);

             block(Nil, error);

         }];
    }
    @catch (NSException *exception) {
        DLog(@"%@",[exception description]);
        DLog(@"%@",[exception callStackSymbols]);
    }
    @finally {

    }

}

// Get Visit
- (void)getVisit:(NSString* )modelName
      withFilter:(NSString* )filter
       withBlock:(void (^)(NSArray *models, NSError *error))block
{
    @try {

        NSString *getURL = [NSString stringWithFormat:@"%@/%@/?%@", BASEURL, modelName, filter];

        getURL = [getURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

        [manager GET:getURL parameters:Nil success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             block(responseObject,nil);

         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

             NSLog(@"ERROR in API %@: %@", modelName, error.localizedDescription);

             block(Nil, error);

         }];
    }
    @catch (NSException *exception) {
        DLog(@"%@",[exception description]);
        DLog(@"%@",[exception callStackSymbols]);
    }
    @finally {

    }
}


// Get Media Visit
- (void)getMediaVisit:(NSString* )modelName
          withVisitId:(NSString* )visitId
            withBlock:(void (^)(NSArray *models, NSError *error))block
{
    @try {

        NSString *getURL = [NSString stringWithFormat:@"%@/%@/%@/media", BASEURL, modelName, visitId];

        getURL = [getURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

        [manager GET:getURL parameters:Nil success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             block(responseObject,nil);

         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

             NSLog(@"ERROR in API %@: %@", modelName, error.localizedDescription);
             block(Nil, error);
         }];
    }
    @catch (NSException *exception) {
        DLog(@"%@",[exception description]);
        DLog(@"%@",[exception callStackSymbols]);
    }
    @finally {

    }
}


// Get FriendShip
- (void)getFriendShipPeople:(NSString* )modelName
               withPersonId:(NSString* )personId
                 withFilter:(NSString* )filter
                  withBlock:(void (^)(NSArray* models, NSError* error))block;
{
    @try {

        NSString *getURL = [NSString stringWithFormat:@"%@/%@/%@/friendships?%@", BASEURL, modelName, personId, filter];

        getURL = [getURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager GET:getURL parameters:Nil success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             block(responseObject,nil);
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"ERROR in API %@: %@", modelName, error.localizedDescription);
             
             block(Nil, error);
             
         }];
    }
    @catch (NSException *exception) {
        DLog(@"%@",[exception description]);
        DLog(@"%@",[exception callStackSymbols]);
    }
    @finally {
        
    }
}


- (void)getBucketItemPeople:(NSString* )modelName
              withPersonId:(NSString* )personId
                withFilter:(NSString* )filter
                 withBlock:(void (^)(NSArray* models, NSError* error))block{
    @try {

        NSString *getURL = [NSString stringWithFormat:@"%@/%@/%@/bucketlist?%@", BASEURL, modelName, personId, filter];

        getURL = [getURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

        [manager GET:getURL parameters:Nil success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             block(responseObject,nil);

         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

             NSLog(@"ERROR in API %@: %@", modelName, error.localizedDescription);

             block(Nil, error);

         }];
    }
    @catch (NSException *exception) {
        DLog(@"%@",[exception description]);
        DLog(@"%@",[exception callStackSymbols]);
    }
    @finally {
        
    }
}

// Post Bucket List
- (void)postBucketList:(NSString* )modelName
         withPersonId:(NSString* )personId
            withParam:(NSDictionary* )paramDict
            withBlock:(void (^)(NSDictionary* model, NSError* error))block
{
    @try {

        NSString *postURL = [NSString stringWithFormat:@"%@/%@/%@/bucketlist", BASEURL, modelName, personId];

        postURL = [postURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

        [manager POST:postURL parameters:paramDict success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             block(responseObject,nil);

         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

             NSLog(@"ERROR in API %@: %@", modelName, error.localizedDescription);

             block(Nil, error);

         }];
    }
    @catch (NSException *exception) {
        DLog(@"%@",[exception description]);
        DLog(@"%@",[exception callStackSymbols]);
    }
    @finally {
        
    }
}

// Get Meetup
- (void)getMeetUpPeople:(NSString* )modelName
               withPersonId:(NSString* )personId
                 withFilter:(NSString* )filter
                  withBlock:(void (^)(NSArray* models, NSError* error))block{
    @try {

        NSString *getURL = [NSString stringWithFormat:@"%@/%@/%@/meetups?%@", BASEURL, modelName, personId, filter];

        getURL = [getURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];

        [manager GET:getURL parameters:Nil success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             block(responseObject,nil);

         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {

             NSLog(@"ERROR in API %@: %@", modelName, error.localizedDescription);

             block(Nil, error);

         }];
    }
    @catch (NSException *exception) {
        DLog(@"%@",[exception description]);
        DLog(@"%@",[exception callStackSymbols]);
    }
    @finally {
        
    }
}
- (void)getFriends:(NSString* )modelName
      withPersonId:(NSString* )personId
        withFilter:(NSString* )filter
         withBlock:(void (^)(NSArray* models, NSError* error))block
{
    @try {
        
        NSString *getURL = [NSString stringWithFormat:@"%@/%@/%@/friendships?%@", BASEURL, modelName, MyPersonModelID, filter];
        
        getURL = [getURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager GET:getURL parameters:filter success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             block(responseObject,nil);
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"ERROR in API %@: %@", modelName, error.localizedDescription);
             
             block(Nil, error);
             
         }];
        
    }
    @catch (NSException *exception) {
        DLog(@"%@",[exception description]);
        DLog(@"%@",[exception callStackSymbols]);
    }
    @finally {
        
    }
}
- (void)createMetadata:(NSString* )modelName
              withDict:(NSDictionary* )postDict
             withBlock:(void (^)(NSDictionary* model, NSError* error))block
{
    @try {
        
        NSString *postURL = [NSString stringWithFormat:@"%@/%@", BASEURL, modelName];
        
        postURL = [postURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager POST:postURL parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             block(responseObject,nil);
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"ERROR in API %@: %@", modelName, error.localizedDescription);
             
             block(Nil, error);
             
         }];
    }
    @catch (NSException *exception) {
        DLog(@"%@",[exception description]);
        DLog(@"%@",[exception callStackSymbols]);
    }
    @finally {
        
    }
}

// Delete File

- (void)deleteMetadta:(NSString* )metadatId
                      withBlock:(void (^)(NSDictionary* model, NSError* error))block
{
    @try {
        
        // /media/%@/files/%@
        NSString *deleteURL = [NSString stringWithFormat:@"%@/metadata/%@", BASEURL, metadatId];
        
        deleteURL = [deleteURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager DELETE:deleteURL parameters:Nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            block(responseObject,nil);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            block(Nil, error);
            
        }];
        
    }
    @catch (NSException *exception) {
        DLog(@"%@",[exception description]);
        DLog(@"%@",[exception callStackSymbols]);
    }
    @finally {
        
    }
}

// Refresh Buzz Information

- (void)refreshBuzzFor:(NSString* )modelName
           withModelID:(NSString* )modelId
            withFilter:(NSString* )filter
             withBlock:(void (^)(NSDictionary* model, NSError* error))block
{
    @try {
        
        NSString *getURL = [NSString stringWithFormat:@"%@/%@/%@?%@", BASEURL, modelName, modelId, filter];
        
        getURL = [getURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager GET:getURL parameters:filter success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             block(responseObject,nil);
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             block(Nil, error);
         }];
        
    }
    @catch (NSException *exception) {
        DLog(@"%@",[exception description]);
        DLog(@"%@",[exception callStackSymbols]);
    }
    @finally {
        
    }
}

// Refresh Server BuzzData

- (void)refreshSeverBuzzFor:(NSString* )modelName
                withModelID:(NSString* )modelId
                   withDict:(NSDictionary* )modelDict
                  withBlock:(void (^)(NSDictionary* model, NSError* error))block
{
    @try {
        
        NSString *putURL = [NSString stringWithFormat:@"%@/%@/%@", BASEURL, modelName, modelId];
        
        putURL = [putURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager PUT:putURL parameters:modelDict success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            block(responseObject,nil);
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            block(Nil, error);
            
        }];
    }
    @catch (NSException *exception) {
        DLog(@"%@",[exception description]);
        DLog(@"%@",[exception callStackSymbols]);
    }
    @finally {
        
    }
}

- (void)createPeople:(NSString* )modelName
            withDict:(NSDictionary* )postDict
           withBlock:(void (^)(NSDictionary* model, NSError* error))block
{
    @try {
        
        NSString *postURL = [NSString stringWithFormat:@"%@/%@", BASEURL, modelName];
        
        postURL = [postURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        [manager POST:postURL parameters:postDict success:^(AFHTTPRequestOperation *operation, id responseObject)
         {
             block(responseObject,nil);
             
         } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             
             NSLog(@"ERROR in API %@: %@", modelName, error.localizedDescription);
             
             block(Nil, error);
             
         }];
    }
    @catch (NSException *exception) {
        DLog(@"%@",[exception description]);
        DLog(@"%@",[exception callStackSymbols]);
    }
    @finally {
        
    }
}

- (void)uploadImage:(NSString* )container
           withData:(UIImage* )image
       withFileName:(NSString* )fileName
          withBlock:(void (^)(NSDictionary* model, NSError* error))block{
    
    NSString *postURL = [NSString stringWithFormat:@"%@/media/%@/upload", BASEURL, container];
    fileName = [NSString stringWithFormat:@"%@.jpg",fileName];
    postURL = [postURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSData* imageData = UIImageJPEGRepresentation(image, 0.1);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager POST:postURL parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData
                                    name:@"files"
                                fileName:fileName
                                mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        block(responseObject,nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"ERROR in API %@: %@", fileName, error.localizedDescription);
        
        block(Nil, error);
    }];
    
}
@end
