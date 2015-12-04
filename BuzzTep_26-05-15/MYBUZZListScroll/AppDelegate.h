//
//  AppDelegate.h
//  MYBUZZListScroll
//
//  Created by Sanchit Thakur on 15/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LoopBack/LoopBack.h>
#import <CoreData/CoreData.h>

#import "BTAdventureModel.h"
#import "BTMilestoneModel.h"
#import "BTEventModel.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

{
    NSString *relinkUserId;
}


@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, retain) BTAdventureModel* gAdventureModel;
@property (nonatomic, retain) BTMilestoneModel* gMilestoneModel;
@property (nonatomic, retain) BTEventModel*     gEventModel;

@property (nonatomic, strong) NSMutableArray*   gBuzzImageArray;
@property (nonatomic, strong) NSDictionary*     gBuzzLocation;

@property (atomic, assign)  NSInteger      gBuzzType;

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic, strong) NSMutableArray * FBFriendsList;
@property (nonatomic, strong) NSMutableArray * FBUserDetails;
@property (nonatomic, strong) NSMutableArray * FBUserPlacesVisited;
@property (nonatomic, strong) NSString * personFBID;
@property (nonatomic, strong) NSString * personFBEmail;
@property (nonatomic, strong) NSString * personID;

+(LBRESTAdapter *) adapter;
+(AppDelegate*)SharedDelegate;

// Utility Function

- (void)ShowAlert:(NSString*)title messageContent:(NSString *)content;

- (NSString* )ParseBTServerTime:(NSString* )serverTime;
- (NSString* )ParseBTServerTimeToYYYYMMDD:(NSString *)serverTime;
- (NSString* )ParseBTServerTimeToBuzzDetailTime:(NSString *)serverTime;
- (NSString* )GenerateCreatedOnTime;
- (NSString* )CreateTimeWithYear:(NSInteger)year Month:(NSInteger)month Day:(NSInteger)day;
- (NSString* )DurationTimeWithYear:(NSInteger)year Month:(NSInteger)month Day:(NSInteger)day ExtraDays:(NSInteger)duration;
// Get City List from CountryCode
- (void)cityList:(NSString *)countryCode
       withBlock:(void (^)(NSArray *models, NSError *error))block;

// Get and Set Local Notification Counts

- (void)setLocalNotificationCount:(NSInteger)count;
- (NSInteger)getLocalNotificationCount;
- (NSString *)randomImageName;
- (UIImage*)DrawText:(NSString*) text
             inImage:(UIImage*)  image
             atPoint:(CGPoint)   point;
- (void)callWithURL:(NSURL *)url;
@end

