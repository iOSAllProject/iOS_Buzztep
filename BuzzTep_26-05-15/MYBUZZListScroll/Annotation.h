//
//  Annotation.h
//  BuzzTepFindFriends
//
//  Created by Sanchit Thakur  on 01/05/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface Annotation : NSObject <MKAnnotation>

@property (nonatomic, assign) CLLocationCoordinate2D coordinate;

@property (nonatomic, copy) NSString *dot;
@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *userAdress;
@property (nonatomic, copy) NSString *userAvatar;
@property (nonatomic, copy) NSString *userNumberPhone;
@property (nonatomic, copy) NSString *userId;

@end
