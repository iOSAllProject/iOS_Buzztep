//
//  MapAnnotation.m
//  BUZZtep
//
//  Created by Alex Sorokolita on 19.05.15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "MapAnnotation.h"

@implementation MapAnnotation

@synthesize coordinate;
@synthesize title;
@synthesize image;

- (id)initWithLocation:(CLLocationCoordinate2D)coord {
    self = [super init];
    if (self) {
        coordinate = coord;
        title = @"unknown";
    }
    return self;
}

- (id)initWithLocationAndName:(CLLocationCoordinate2D)coord name:(NSString*)name {
    self = [super init];
    if (self) {
        coordinate = coord;
        title = name;
    }
    return self;
}

@end
