//
//  UNPolyline.m
//  GoingHome
//
//  Created by Alximik on 29.09.14.
//  Copyright (c) 2014 Unotion. All rights reserved.
//

#import "UNPolyline.h"

@implementation UNPolyline

- (NSArray*)linePoints
{
    NSUInteger pointCount = self.pointCount;
    if (!pointCount) {
        return nil;
    }
    
    NSMutableArray *linePoints = [NSMutableArray array];
    
    CLLocationCoordinate2D *routeCoordinates = malloc(pointCount * sizeof(CLLocationCoordinate2D));
    [self getCoordinates:routeCoordinates range:NSMakeRange(0, pointCount)];
    
    for (int i=0; i < pointCount; i++) {
        NSDictionary *point = @{@"latitude":@(routeCoordinates[i].latitude),
                                @"longitude":@(routeCoordinates[i].longitude)};
        [linePoints addObject:point];
    }
    
    free(routeCoordinates);
    
    return linePoints;
}

@end
