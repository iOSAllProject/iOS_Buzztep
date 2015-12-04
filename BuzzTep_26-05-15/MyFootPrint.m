//
//  MyFootPrint.m
//  Animation99
//
//  Created by Sanchit Thakur  on 05/05/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "MyFootPrint.h"

@implementation MyFootPrint
@synthesize coordinate, title, subtitle, pinIndex;
- (id)initWithCoordinates:(CLLocationCoordinate2D)location placeName:(NSString *)placeName description:(NSString *)description withIndex :(int) index
{
    self = [super init];
    if (self != nil) {
        coordinate = location;
        _pinTitle = placeName;
        _pinSubtitle = description;
        pinIndex = index;
    }
    return self;
}

- (void)dealloc {
    
}

@end
