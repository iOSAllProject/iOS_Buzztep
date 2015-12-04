//
//  LocationWorker.h
//  BUZZtep
//
//  Created by Evhenij Romanishin on 02.06.15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

#define kGOOGLE_API_KEY @"AIzaSyDNiFSGg6ql6aU_8Cihl9T1eCTO1r2zkyQ"

#define LocationWorkerDidUpdateRoadsNotification @"LocationWorkerDidUpdateRoads"
#define LocationWorkerDidUpdateLocationsNotification @"LocationWorkerDidUpdateLocations"

typedef enum {
    noType = -1,
    wallking = 0,
    ferry = 1,
    train = 2,
    fly = 3,
    car = 4
} RoadTypes;

@class Road;
@interface LocationWorker : NSObject

@property (strong, nonatomic) NSMutableArray *roads;

+ (LocationWorker*)sharedWorker;

+ (BOOL)isWorking;
+ (void)startTracking;
+ (void)stopTracking;

+ (void)saveLocations;

+ (Road*)currentRoad;
+ (UIColor*)currentColor;

+ (RoadTypes)typeFromString:(NSString*)stringType;
+ (NSString*)stringFromType:(RoadTypes)type;

@end

@interface Road : NSObject

@property (strong, nonatomic) NSMutableArray *points;
@property (assign, nonatomic)  float distance;
@property (assign, nonatomic)  BOOL saved;
@property (assign, nonatomic)  float trainDistance;
@property (assign, nonatomic)  RoadTypes type;

+ (Road*)roadFromModel:(LBModel*)model;

- (BOOL)isCurrentRoad;

- (UIColor*)roadColor;
- (NSString*)annotationImageName;
- (NSArray*)annotationPoints;

@end