//
//  UNPolyline.h
//  GoingHome
//
//  Created by Alximik on 29.09.14.
//  Copyright (c) 2014 Unotion. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface UNPolyline : MKPolyline
@property (strong, nonatomic) UIColor *color;

- (NSArray*)linePoints;

@end
