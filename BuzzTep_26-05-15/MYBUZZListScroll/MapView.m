//
//  MapView.m
//  MapKit11
//
//  Created by Sanchit Thakur on 23/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "MapView.h"
#import "AppDelegate.h"
#import "AddNewBuzzTypeVC.h"
#import "AnimationVC.h"
#import "AmenitiesVC1.h"
#import "MapAnnotation.h"

#import "LocationWorker.h"
#import "UNPolyline.h"

@interface MapView () <MKMapViewDelegate>
{
    MKPolyline *_routeOverlay;
    MKRoute *_currentRoute;
}

@property (strong, nonatomic) IBOutlet UIButton *hideMapButton;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIView *travelMapView;
@property (strong, nonatomic) IBOutlet UIButton *setMapBtn;
@property (strong, nonatomic) NSMutableArray *mapAnnotations;
@property (strong, nonatomic) NSMutableArray *roadAnnotations;
@property (nonatomic, strong) MapAnnotation *annotation;

- (IBAction)directionImageButton:(id)sender;
- (IBAction)stepsImageButton:(id)sender;
- (IBAction)threeDotButton:(id)sender;
- (IBAction)hideMaptButtonAction:(id)sender;
- (IBAction)setMapButtonPresset:(id)sender;

@end

@implementation MapView

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didUpdateLocations:)
                                                 name:LocationWorkerDidUpdateLocationsNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didUpdateRoads:)
                                                 name:LocationWorkerDidUpdateRoadsNotification
                                               object:nil];

    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    self.mapView.userTrackingMode = MKUserTrackingModeFollow;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];

    void (^loadErrorBlock)(NSError *) = ^(NSError *error) {
        NSLog( @"Error %@", error.description);

        [self updateSavedRoads];
    };

    void (^loadSuccessBlock)(NSArray *) = ^(NSArray *models) {
        NSLog( @"selfSuccessBlock %zd", models.count);

        NSLog( @"Success %zd", [models count]);
        [self.mapAnnotations removeAllObjects];

        for (int i = 0; i < models.count; i++) {

            LBModel *modelInstance = (LBModel*)[models objectAtIndex:i];
            LBModel *geoInstance  = [modelInstance objectForKeyedSubscript:@"location"];

            CLLocationCoordinate2D locCord;
            locCord.latitude = [[geoInstance objectForKeyedSubscript:@"lat"] doubleValue];
            locCord.longitude = [[geoInstance objectForKeyedSubscript:@"lng"] doubleValue];

            MapAnnotation *annot = [[MapAnnotation alloc] initWithLocation:locCord];
            annot.title = [modelInstance objectForKeyedSubscript:@"title"];
            annot.image = @"visits_marker";

            [self.mapAnnotations addObject:annot];
        }

        [self.mapView removeAnnotations:self.mapView.annotations];
        [self.mapView addAnnotations:self.mapAnnotations];

        [self updateSavedRoads];
    };

    LBModelRepository *objectB = [[AppDelegate adapter] repositoryWithModelName:@"visits"];
    [objectB allWithSuccess:loadSuccessBlock failure:loadErrorBlock];
}

- (void)updateSavedRoads
{
    LocationWorker *worker = [LocationWorker sharedWorker];
    for (Road *road in worker.roads) {
        CLLocationCoordinate2D *coords = (CLLocationCoordinate2D*)malloc(sizeof(CLLocationCoordinate2D) * road.points.count);
        for (int i=0; i<road.points.count; i++) {
            NSDictionary *point = road.points[i];
            double latitude = [point[@"latitude"] doubleValue];
            double longitude = [point[@"longitude"] doubleValue];
            coords[i] = CLLocationCoordinate2DMake(latitude, longitude);
        }

        UNPolyline *polyLine = [UNPolyline polylineWithCoordinates:coords count:road.points.count];
        polyLine.color = road.roadColor;
        [self.mapView addOverlay:polyLine];
        free(coords);
    }

    [self updateRoadAnnotations];
}

- (void)updateRoadAnnotations
{
    [self.mapView removeAnnotations:self.mapAnnotations];
    [self.mapAnnotations removeAllObjects];

    LocationWorker *worker = [LocationWorker sharedWorker];
    for (Road *road in worker.roads) {
        for (NSDictionary *point in road.annotationPoints) {
            double latitude = [point[@"latitude"] doubleValue];
            double longitude = [point[@"longitude"] doubleValue];

            MapAnnotation *annot = [[MapAnnotation alloc] initWithLocation:CLLocationCoordinate2DMake(latitude, longitude)];
            annot.image = road.annotationImageName;
            [self.mapView addAnnotation:annot];

            [self.roadAnnotations addObject:annot];
        }
    }
}

- (NSMutableArray*)mapAnnotations
{
    if ( !_mapAnnotations) _mapAnnotations = [[NSMutableArray alloc] init];
    return _mapAnnotations;
};

- (NSMutableArray*)roadAnnotations
{
    if ( !_roadAnnotations) _roadAnnotations = [[NSMutableArray alloc] init];
    return _roadAnnotations;
};

- (MapAnnotation *)annotation
{
    if (!_annotation)
    {
        CLLocationCoordinate2D cityCoord;
        _annotation = [[MapAnnotation alloc] initWithLocation:cityCoord];
    }
    return _annotation;
};

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    NSLog(@"calloutAccessoryControlTapped ");

    id <MKAnnotation> annotation = [view annotation];
    if ([annotation isKindOfClass:[MapAnnotation class]])
    {
        NSLog(@"clicked MapAnnotation Annotation  ");
    }

    [self performSegueWithIdentifier:@"showdetail" sender:self];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView *anotView = nil;

    if ([annotation isKindOfClass:MKUserLocation.class])
    {
        anotView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"UserLocation"];
        if (!anotView)  {
            anotView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"UserLocation"];

        } else {
            anotView.annotation = annotation;
        }

        anotView.enabled = YES;
        anotView.canShowCallout = YES;
        anotView.image = [UIImage imageNamed:@"user_dot"];
        anotView.centerOffset = CGPointMake(0, -20);
    }

    else {
        anotView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"Annotation"];
        if (!anotView) {
            anotView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"Annotation"];
            anotView.canShowCallout = YES;
        }

        MapAnnotation *customAnnotation = (MapAnnotation *)annotation;
        anotView.image = [UIImage imageNamed:customAnnotation.image];
    }

    return anotView;
}

- (void)didUpdateRoads:(NSNotification*)notif
{
    LocationWorker *worker = [LocationWorker sharedWorker];
    for (Road *road in worker.roads) {
        CLLocationCoordinate2D *coords = (CLLocationCoordinate2D*)malloc(sizeof(CLLocationCoordinate2D) * road.points.count);
        for (int i=0; i<road.points.count; i++) {
            NSDictionary *point = road.points[i];
            double latitude = [point[@"latitude"] doubleValue];
            double longitude = [point[@"longitude"] doubleValue];
            coords[i] = CLLocationCoordinate2DMake(latitude, longitude);
        }

        UNPolyline *polyLine = [UNPolyline polylineWithCoordinates:coords count:road.points.count];
        polyLine.color = road.roadColor;
        [self.mapView addOverlay:polyLine];
        free(coords);

        [self updateRoadAnnotations];
    }
}

- (void)didUpdateLocations:(NSNotification*)notif
{
    NSArray *locations = notif.object;

    CLLocationCoordinate2D *coords = (CLLocationCoordinate2D*)malloc(sizeof(CLLocationCoordinate2D) * locations.count);
    for (int i=0; i<locations.count; i++) {
        NSDictionary *location = locations[i];
        double latitude = [location[@"latitude"] doubleValue];
        double longitude = [location[@"longitude"] doubleValue];
        coords[i] = CLLocationCoordinate2DMake(latitude, longitude);
    }

    UNPolyline *polyLine = [UNPolyline polylineWithCoordinates:coords count:locations.count];
    polyLine.color = [LocationWorker currentColor];
    [self.mapView addOverlay:polyLine];
    free(coords);

    if ([LocationWorker currentRoad].points.count <= 2) {
        [self updateRoadAnnotations];
    }
}

#pragma mark - MKMapViewDelegate

- (MKOverlayRenderer *)mapView:(MKMapView *)mapView rendererForOverlay:(id < MKOverlay >)overlay
{
    if ([overlay isKindOfClass:[UNPolyline class]]) {
        MKPolylineRenderer *renderer = [[MKPolylineRenderer alloc] initWithPolyline:overlay];
        renderer.strokeColor = [(UNPolyline*)overlay color];
        renderer.fillColor = [UIColor blackColor];
        renderer.lineWidth = 3;
        return renderer;
    }

    return nil;
}

- (IBAction)threeDotButton:(id)sender
{
    AnimationVC *newBuzz=[self.storyboard instantiateViewControllerWithIdentifier:@"AnimationView"];
    [self.navigationController pushViewController:newBuzz animated:YES];
}

- (IBAction)hideMaptButtonAction:(id)sender
{
    self.travelMapView.hidden=NO;
    self.hideMapButton.hidden=YES;
}

- (IBAction)setMapButtonPresset:(id)sender
{
    UIImage *btnImage1 = [UIImage imageNamed:@"map_btn_1.png"];
    UIImage *btnImage2 = [UIImage imageNamed:@"map_btn_2.png"];

    if (_mapView.mapType == MKMapTypeStandard)
    {
        _mapView.mapType = MKMapTypeSatellite;
        [_setMapBtn setImage:btnImage1 forState:UIControlStateNormal];
    }
    else
    {
        _mapView.mapType = MKMapTypeStandard;
        [_setMapBtn setImage:btnImage2 forState:UIControlStateNormal];
    }
}

- (IBAction)directionImageButton:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Amenities" bundle:nil];

    AmenitiesVC1 *invite=[storyboard instantiateViewControllerWithIdentifier:@"amenities"];
    [self.navigationController pushViewController:invite animated:YES];
}

- (IBAction)stepsImageButton:(id)sender
{
    AddNewBuzzTypeVC *newBuzz=[self.storyboard instantiateViewControllerWithIdentifier:@"addnewbuzztype"];
    [self.navigationController pushViewController:newBuzz animated:YES];
}

- (IBAction)travelMapButtonPressed:(UIButton *)senderButton
{
    //  NSLog(@"Button tag = %ld", (long)senderButton.tag);

    self.travelMapView.hidden = YES;
    self.hideMapButton.hidden = NO;

    switch (senderButton.tag)
    {
        case 0:
            break;

        default:
            break;
    }
}

@end
