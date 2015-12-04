//
//  MyFootprintVC.h
//  Animation99
//
//  Created by Sanchit Thakur  on 05/05/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "MBProgressHUD.h"
@interface MyFootprintVC : UIViewController<MKMapViewDelegate, CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    float tapLatitude;
    float tapLongitude;
    
}
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (weak, nonatomic) IBOutlet UIView *topBarView;

@property (nonatomic) CGFloat tappedLatitude;
@property (nonatomic) CGFloat tappedLongitude;

- (IBAction)triggerNavigation:(id)sender;

@end
