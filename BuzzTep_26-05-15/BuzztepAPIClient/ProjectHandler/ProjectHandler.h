//
//  ProjectHandler.h
//  Animation
//
//  Created by Sanchit Thakur on 20/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <LoopBack/LoopBack.h>
#import "AppDelegate.h"
#define FONT_APPLE_SD_GOTHIC(x) [UIFont fontWithName:@"Apple SD Gothic Neo" size:x]

#define MyPicturesDirPath [[NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"/myPictures"]

typedef void (^RequestSuccessBlock)(NSArray *models);
typedef void (^RequestFailureBlock)(NSError *error);

@interface ProjectHandler : NSObject

+ (id)sharedHandler;

+ (void)setSegmentAttributes;
+ (BOOL)isReachable;

- (void)dataFromServerForModelName:(NSString *)name
                        parameters:(NSDictionary *)params
                           success:(RequestSuccessBlock)success
                           failure:(RequestFailureBlock)failure;

@end
