//
//  LocationWorker.m
//  BUZZtep
//
//  Created by Evhenij Romanishin on 02.06.15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

//http://www.gpxeditor.co.uk

#import "AppDelegate.h"
#import "LocationWorker.h"
#import "AFNetworking.h"
#import "MKMapView+ZoomLevel.h"

#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@interface LocationWorker () <CLLocationManagerDelegate, MKMapViewDelegate>
{
    BOOL typeAlertShows;
}

@property (strong, nonatomic) NSDate *speedUpdate;
@property (assign, nonatomic) BOOL working;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) MKMapView *mapView;

@end

@implementation LocationWorker

+ (LocationWorker*)sharedWorker
{
    static LocationWorker *sharedWorker = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedWorker = [[self alloc] init];
        
        sharedWorker.mapView = [[MKMapView alloc] initWithFrame:CGRectMake(20, 300, 200, 200)];
        sharedWorker.mapView.mapType = MKMapTypeStandard;
        //        sharedWorker.mapView.showsUserLocation = YES;
        //        sharedWorker.mapView.userTrackingMode = MKUserTrackingModeFollow;
        sharedWorker.mapView.delegate = sharedWorker;
        
        UIApplication *application = [UIApplication sharedApplication];
        UIWindow *window = application.keyWindow;
        [window insertSubview:sharedWorker.mapView atIndex:0];
        //[window addSubview:sharedWorker.mapView];
        
        sharedWorker.locationManager = [[CLLocationManager alloc] init];
        sharedWorker.locationManager.delegate = sharedWorker;
        sharedWorker.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        sharedWorker.locationManager.activityType = CLActivityTypeFitness;
        
        sharedWorker.roads = [NSMutableArray array];
        [sharedWorker getLocationsFromServer];
        
        if ([sharedWorker.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
            [sharedWorker.locationManager requestWhenInUseAuthorization];
        }
    });
    return sharedWorker;
}

+ (BOOL)isValidCoordinate:(CLLocationCoordinate2D)coordinate
{
    NSString *latitude = [NSString stringWithFormat:@"%f", coordinate.latitude];
    NSString *longitude = [NSString stringWithFormat:@"%f", coordinate.longitude];
    
    return (![latitude isEqualToString:@"0.000000"] && ![longitude isEqualToString:@"0.000000"]);
}

+ (UIImage*)mapImage
{
    LocationWorker *locationWorker = [LocationWorker sharedWorker];
    MKMapView *mapView = locationWorker.mapView;
    
    UIGraphicsBeginImageContextWithOptions(mapView.bounds.size, NO, [UIScreen mainScreen].scale);
    [mapView drawViewHierarchyInRect:mapView.bounds afterScreenUpdates:NO];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (BOOL)isWaterPixel:(UIImage *)image
{
    UIColor *pixelColor = [LocationWorker pixelColor:image];
    NSString *hexColor = [LocationWorker hexStringForColor:pixelColor];
    
    return ([hexColor hasPrefix:@"F0"] ||
            [hexColor hasPrefix:@"F1"] ||
            [hexColor hasPrefix:@"F2"] ||
            [hexColor hasPrefix:@"F3"] ||
            [hexColor containsString:@"DAA"] ||
            [hexColor containsString:@"DCA"]);
}

+ (UIColor*)pixelColor:(UIImage*)image
{
    CFDataRef pixelData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage));
    const UInt8* data = CFDataGetBytePtr(pixelData);
    
    int pixelInfo = ((image.size.width  * 100) + 100 ) * 4;
    
    UInt8 red = data[pixelInfo];
    UInt8 green = data[(pixelInfo + 1)];
    UInt8 blue = data[pixelInfo + 2];
    UInt8 alpha = data[pixelInfo + 3];
    CFRelease(pixelData);
    
    return [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha/255.0f];
    
    //    CGRect sourceRect = CGRectMake(1, 1, 1.f, 1.f);
    //    CGImageRef imageRef = CGImageCreateWithImageInRect([pixelImage CGImage], sourceRect);
    //
    //    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //    unsigned char *buffer = malloc(4);
    //    CGBitmapInfo bitmapInfo = kCGImageAlphaPremultipliedLast | kCGBitmapByteOrder32Big;
    //    CGContextRef context = CGBitmapContextCreate(buffer, 1, 1, 8, 4, colorSpace, bitmapInfo);
    //    CGColorSpaceRelease(colorSpace);
    //    CGContextDrawImage(context, CGRectMake(0.f, 0.f, 1.f, 1.f), imageRef);
    //    CGImageRelease(imageRef);
    //    CGContextRelease(context);
    //
    //    CGFloat r = buffer[0] / 255.f;
    //    CGFloat g = buffer[1] / 255.f;
    //    CGFloat b = buffer[2] / 255.f;
    //    CGFloat a = buffer[3] / 255.f;
    //
    //    free(buffer);
    //
    //    return [UIColor colorWithRed:r green:g blue:b alpha:a];
}

+ (NSString *)hexStringForColor:(UIColor*)color
{
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    return [NSString stringWithFormat:@"%02X%02X%02X", (int)(r * 255), (int)(g * 255), (int)(b * 255)];
}

+ (BOOL)isWorking
{
    LocationWorker *worker = [LocationWorker sharedWorker];
    return worker.working;
}

+ (void)startTracking
{
    LocationWorker *worker = [LocationWorker sharedWorker];
    [worker.locationManager startUpdatingLocation];
    worker.working = YES;
    
    Road *road = [Road new];
    [worker.roads addObject:road];
}

+ (void)stopTracking
{
    LocationWorker *worker = [LocationWorker sharedWorker];
    [worker.locationManager stopUpdatingLocation];
    worker.working = NO;
}

- (void)getLocationsFromServer
{
    LBModelRepository *objectB = [[AppDelegate adapter] repositoryWithModelName:@"routes"];
    
    [objectB allWithSuccess:^(NSArray *models) {
        for (LBModel *locationModel in models) {
            Road *road = [Road roadFromModel:locationModel];
            road.saved = YES;
            [self.roads addObject:road];
        }
        
        [[NSNotificationCenter defaultCenter] postNotificationName:LocationWorkerDidUpdateRoadsNotification
                                                            object:self];
    } failure:^(NSError *error) {
        NSLog( @"Error Get locations %@", error.description);
    }];
}

+ (void)saveLocations
{
    LocationWorker *worker = [LocationWorker sharedWorker];
    LBModelRepository *prototype = [[AppDelegate adapter] repositoryWithModelName:@"routes"];
    for (Road *road in worker.roads) {
        if (road.saved || !road.points.count) {
            continue;
        }
        
        NSString *type = [LocationWorker stringFromType:road.type];
        LBModel *model = [prototype modelWithDictionary:@{@"points":road.points, @"type":type}];
        [model saveWithSuccess:^{
            road.saved = YES;
            NSLog(@"save succes");
        } failure:^(NSError *error) {
            NSLog( @"Error on Save %@", error.description);
        }];
    }
}

+ (Road*)currentRoad
{
    LocationWorker *worker = [LocationWorker sharedWorker];
    if (worker.roads.count) {
        return worker.roads.lastObject;
    }
    return nil;
}

+ (UIColor*)currentColor
{
    Road *currentRoad = [LocationWorker currentRoad];
    if (currentRoad) {
        return currentRoad.roadColor;
    }
    
    return [UIColor purpleColor];
}

+ (RoadTypes)typeFromString:(NSString*)stringType
{
    if ([stringType isEqualToString:@"wallking"]) {
        return wallking;
    } else if ([stringType isEqualToString:@"ferry"]) {
        return ferry;
    } else if ([stringType isEqualToString:@"train"]) {
        return train;
    } else if ([stringType isEqualToString:@"fly"]) {
        return fly;
    } else if ([stringType isEqualToString:@"car"]) {
        return car;
    }
    return noType;
}

+ (NSString*)stringFromType:(RoadTypes)type
{
    switch (type) {
        case wallking:
            return @"wallking";
            break;
            
        case ferry:
            return @"ferry";
            break;
            
        case train:
            return @"train";
            break;
            
        case fly:
            return @"fly";
            break;
            
        case car:
            return @"car";
            break;
            
        default:
            return nil;
            break;
    }
}

#pragma mark - MKMapViewDelegate

-(void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views
{
    MKAnnotationView *ulv = [mapView viewForAnnotation:mapView.userLocation];
    ulv.alpha = 0.0;
}

- (void)mapView:(MKMapView*)mapView regionDidChangeAnimated:(BOOL)animated
{
    if ([LocationWorker isValidCoordinate:mapView.centerCoordinate]) {
        Road *road = [LocationWorker currentRoad];
        
        UIImage *mapImage = [LocationWorker mapImage];
        if ([LocationWorker isWaterPixel:mapImage]) {
            if (road.type != ferry) {
                Road *ferryRoad = [Road new];
                ferryRoad.type = ferry;
                [self.roads addObject:ferryRoad];
            }
        } else {
            if (road.type == ferry) {
                [self.roads addObject:[Road new]];
            }
            
            MKCoordinateSpan span;
            span.latitudeDelta = 0.0000001;
            span.longitudeDelta = 0.0000001;
            
            MKCoordinateRegion region;
            region.span = span;
            region.center = mapView.centerCoordinate;
            
            MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
            request.naturalLanguageQuery = @"Train station";
            request.region = region;
            
            MKLocalSearch *localSearch = [[MKLocalSearch alloc] initWithRequest:request];
            [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error) {
                MKMapItem *mapItem = response.mapItems.firstObject;
                CLLocation *itemLocation = mapItem.placemark.location;
                
                CLLocation *userLocation = self.mapView.userLocation.location;
                userLocation = self.locationManager.location;
                //userLocation = [[CLLocation alloc] initWithCoordinate:self.mapView.centerCoordinate altitude:0 horizontalAccuracy:0 verticalAccuracy:0 course:0 speed:0 timestamp:[NSDate date]];
                
                CLLocationDistance dist = [userLocation distanceFromLocation:itemLocation];
                
                if (!typeAlertShows &&
                    road.trainDistance > 0 &&
                    road.trainDistance <= 50 &&
                    road.trainDistance < dist)
                {
                    typeAlertShows = YES;
                    
                    UIAlertView *trainAlert = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                                         message:@"Are you go by train now?"
                                                                        delegate:self
                                                               cancelButtonTitle:@"No"
                                                               otherButtonTitles:@"Yes", nil];
                    trainAlert.tag = 10;
                    [trainAlert show];
                }
                
                road.trainDistance = dist;
            }];
        }
    }
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager*)manager didUpdateLocations:(NSArray*)locations
{
    CLLocation *location = locations.lastObject;
    
    [self.mapView setCenterCoordinate:location.coordinate zoomLevel:16 animated:NO];
    
    Road *road = self.roads.lastObject;
    RoadTypes detectType = noType;
    
    NSString *alertText = @"";
    
    if (location.speed <= 4.0) {
        detectType = wallking;
        alertText = @"Are you wallking now?";
    } else if (location.speed > 4.0 && location.speed <= 89.4) {
        detectType = car;
        alertText = @"Are you driving now?";
    } else if (location.speed > 89.4) {
        detectType = fly;
        alertText = @"Are you flying now?";
    }
    
    if (road.type == noType) {
        road.type = detectType;
    } else if (road.type != detectType && road.type != train && road.type != ferry) {
        if (self.speedUpdate && !typeAlertShows) {
            float seconds = fabs([self.speedUpdate timeIntervalSinceNow]);
            if (seconds > 30.0) {
                typeAlertShows = YES;
                [[[UIAlertView alloc] initWithTitle:@"Alert"
                                            message:alertText
                                           delegate:self
                                  cancelButtonTitle:@"No"
                                  otherButtonTitles:@"Yes", nil] show];
            }
        } else {
            self.speedUpdate = [NSDate date];
        }
    }
    
    for (CLLocation *location in locations) {
        NSMutableDictionary *dicLocation = [NSMutableDictionary dictionary];
        dicLocation[@"latitude"] = [NSString stringWithFormat:@"%f", location.coordinate.latitude];
        dicLocation[@"longitude"] = [NSString stringWithFormat:@"%f", location.coordinate.longitude];
        [road.points addObject:dicLocation];
    }
    
    if (road.points.count>1) {
        NSArray *notifPoints = @[road.points[road.points.count-2], road.points.lastObject];
        [[NSNotificationCenter defaultCenter] postNotificationName:LocationWorkerDidUpdateLocationsNotification
                                                            object:notifPoints];
    }
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    self.speedUpdate = nil;
    typeAlertShows = NO;
    
    if (alertView.tag == 10) {
        Road *road = self.roads.lastObject;
        road.type = buttonIndex==1 ? train : noType;
        return;
    }
    
    //    if (alertView.tag == 11 && buttonIndex == 0) {
    //
    //    }
    
    if (buttonIndex == 1) {
        [self.roads addObject:[Road new]];
    }
}

@end


@implementation Road

- (id)init
{
    self = [super init];
    if (self) {
        self.type = noType;
        self.points = [NSMutableArray array];
        self.trainDistance = -1;
    }
    return self;
}

+ (Road*)roadFromModel:(LBModel*)model
{
    Road *road = [Road new];
    road.points = [[model objectForKeyedSubscript:@"points"] mutableCopy];
    road.type = [LocationWorker typeFromString:[model objectForKeyedSubscript:@"type"]];
    return road;
}

- (BOOL)isCurrentRoad
{
    return [LocationWorker sharedWorker].roads.lastObject == self;
}

- (UIColor*)roadColor
{
    switch (self.type) {
        case wallking:
            return UIColorFromRGB(0Xce80bb);
            break;
            
        case ferry:
            return UIColorFromRGB(0Xf16739);
            break;
            
        case train:
            return UIColorFromRGB(0X72c7c7);
            break;
            
        case fly:
            return UIColorFromRGB(0Xf06597);
            break;
            
        case car:
            return UIColorFromRGB(0Xcccc33);
            break;
            
        default:
            return [UIColor purpleColor];
            break;
    }
}

- (NSString*)annotationImageName
{
    switch (self.type) {
        case wallking:
            return @"walking_route_marker";
            break;
            
        case ferry:
            return @"ferry_route_marker";
            break;
            
        case train:
            return @"train_route_marker";
            break;
            
        case fly:
            return @"fly_route_marker";
            break;
            
        case car:
            return @"car_route_marker";
            break;
            
        default:
            return nil;
            break;
    }
}

- (NSArray*)annotationPoints
{
    if (!self.points.count) {
        return nil;
    } else if (self.points.count == 1 || self.isCurrentRoad) {
        return @[self.points.firstObject];
    }
    
    return @[self.points.firstObject, self.points.lastObject];
}

@end
