//
//  MapAnnotation.h
//  BUZZtep
//
//  Created by Alex Sorokolita on 19.05.15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

@interface MapAnnotation : NSObject <MKAnnotation>
{
    CLLocationCoordinate2D coordinate;
    NSString *title;
    NSString *image;
}

@property (nonatomic, readonly) CLLocationCoordinate2D coordinate;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *image;

- (id)initWithLocation:(CLLocationCoordinate2D)coord;
- (id)initWithLocationAndName:(CLLocationCoordinate2D)coord name:(NSString*)name;

@end
