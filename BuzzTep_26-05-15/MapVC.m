//
//  ViewController.m
//  BUZZtep
//
//  Created by Oleksandr Sorokolita on 31.03.15.
//  Copyright (c) 2015 Alexandr Sorokolita. All rights reserved.
//

#import "MapVC.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "ViewController.h"
#import "AmenitiesVC.h"

@interface MapVC () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UIView *mapKeyView;
@property (strong, nonatomic) IBOutlet UIButton *setMapBtn;
@property (strong, nonatomic) IBOutlet UIButton *mapKeyButton;

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation MapVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _locationManager = [[CLLocationManager alloc]init];
    _locationManager.delegate = self;
    if ([_locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [_locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    _mapView.showsUserLocation = YES;
}

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    CLLocationCoordinate2D loc = [userLocation coordinate];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(loc, 800, 800);
    [_mapView setRegion:region animated:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView *userAnnotationView = nil;
    
    if ([annotation isKindOfClass:MKUserLocation.class])
    {
        userAnnotationView = (MKAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"UserLocation"];
        if (userAnnotationView == nil)  {
            userAnnotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"UserLocation"];
            
        } else {
            userAnnotationView.annotation = annotation;
        }
        
        userAnnotationView.enabled = YES;
        userAnnotationView.canShowCallout = YES;
        userAnnotationView.image = [UIImage imageNamed:@"pin.png"];
    }
    
    return userAnnotationView;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"amenities"]) {
        AmenitiesVC *avc = segue.destinationViewController;
    }
}

- (IBAction)setMapButtonPresset:(id)sender
{
    UIImage *btnImage1 = [UIImage imageNamed:@"map_btn_1.png"];
    UIImage *btnImage2 = [UIImage imageNamed:@"map_btn_2.png"];
    
    if (_mapView.mapType == MKMapTypeStandard) {
        _mapView.mapType = MKMapTypeSatellite;
        [_setMapBtn setImage:btnImage1 forState:UIControlStateNormal];
    
    } else {
        _mapView.mapType = MKMapTypeStandard;
        [_setMapBtn setImage:btnImage2 forState:UIControlStateNormal];
    }
}

- (IBAction)pressMapKeyButton:(id)sender
{
    self.mapKeyView.hidden = NO;
    self.mapKeyButton.hidden = YES;
}

- (IBAction)pressWalkingButtom:(id)sender
{
    self.mapKeyView.hidden = YES;
    self.mapKeyButton.hidden = NO;
    
    NSLog(@"Walking button pressed");
}

- (IBAction)pressDrivingButton:(id)sender
{
    self.mapKeyView.hidden = YES;
    self.mapKeyButton.hidden = NO;
    
    NSLog(@"Driving button pressed");
}

- (IBAction)pressFlyingButton:(id)sender
{
    self.mapKeyView.hidden = YES;
    self.mapKeyButton.hidden = NO;
    
    NSLog(@"Flying button pressed");
}

- (IBAction)pressTrainButton:(id)sender
{
    self.mapKeyView.hidden = YES;
    self.mapKeyButton.hidden = NO;
    
    NSLog(@"Train button pressed");
}

- (IBAction)pressFerryButton:(id)sender
{
    self.mapKeyView.hidden = YES;
    self.mapKeyButton.hidden = NO;
    
    NSLog(@"Ferry button pressed");
}

- (IBAction)pressAmenitiesButton:(id)sender
{
    NSLog(@"Press Amenities Button");
}

- (IBAction)tracksButtonPressed:(id)sender
{
    NSLog(@"Press Track Button");
}

- (IBAction)menuButtonPressed:(id)sender
{
    ViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewController"];
    [self.navigationController pushViewController:vc animated:YES];
    
    NSLog(@"Menu button pressed");
}

@end
