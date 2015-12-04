//
//  MyFootPrint.h
//  Animation99
//
//  Created by Sanchit Thakur  on 05/05/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MyFootPrint : NSObject<MKAnnotation>
@property (nonatomic) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) NSString * pinTitle;
@property (nonatomic, strong) NSString * pinSubtitle;
@property (nonatomic, assign) int pinIndex;

- (id)initWithCoordinates:(CLLocationCoordinate2D)location placeName:(NSString *)placeName description:(NSString *)description withIndex :(int) index;


@end
