//
//  MyFootprintVC.m
//  Animation99
//
//  Created by Sanchit Thakur  on 05/05/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "MyFootprintVC.h"
#import "AnimationVC.h"
#import "MyFootPrint.h"
#import "AddNewBuzzTypeVC.h"
#import "ProjectHandler.h"
#import "BTVisitModel.h"
#import "BTAPIClient.h"
#import "Constant.h"
#import "Annotation.h"
#import <LoopBack/LoopBack.h>

#define prototypename @"people"

@interface MyFootprintVC ()
{
    MyFootPrint * footPrint;
    AppDelegate * appdel;
}
- (IBAction)footPrintAction:(id)sender;


@end

@implementation MyFootprintVC
@synthesize tappedLatitude, tappedLongitude;


- (void)viewDidLoad {
    [super viewDidLoad];

    self.mapView.delegate = self;
    MKCoordinateRegion region = self.mapView.region;
    //    region = MKCoordinateRegionForMapRect(MKMapRectWorld);
    MKCoordinateSpan span = self.mapView.region.span;
    span.latitudeDelta=.05;
    span.longitudeDelta=.05;
    region.span=span;

    CLLocationCoordinate2D centerCoordinate;
    centerCoordinate.latitude = tappedLatitude;
    centerCoordinate.longitude = tappedLongitude;
    MKCoordinateRegion region1 = MKCoordinateRegionMakeWithDistance (centerCoordinate, 2850000, 285000);
    [self.mapView setRegion:region1];

    self.mapView.zoomEnabled = YES;

    self.mapView.scrollEnabled = YES;
    [self.mapView setRegion:region1 animated:YES];

    
    [self.mapView setMapType:MKMapTypeHybrid];

    [self.mapView setShowsUserLocation:NO];

    [self loadServerData];
}


- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    
    NSLog(@"view defined for annotaiton");

    NSString * identifier = @"defaultMapPin";
    MKAnnotationView* aView = [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    if(!aView)
    {
        aView = [[MKAnnotationView alloc] initWithAnnotation:annotation
                                             reuseIdentifier:identifier];
    }
    MyFootPrint *myFootPrint = (MyFootPrint*)annotation;

    [aView setImage:[[AppDelegate SharedDelegate] DrawText:[NSString stringWithFormat:@"%d",(int)myFootPrint.pinIndex] inImage:[UIImage imageNamed:@"footprint_marker"] atPoint:CGPointMake(0, 0)]];
    aView.canShowCallout = NO;
    return aView;
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view {
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)triggerNavigation:(id)sender {
    NSString * storyboardName = @"Main";
    NSString * viewControllerID = @"AnimationView";
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    AnimationVC *animation=(AnimationVC *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
    [self.navigationController pushViewController:animation animated:YES];
}
- (IBAction)footPrintAction:(id)sender {

    NSLog(@"Foot print action");

    NSString * storyboardName = @"Main";
    NSString * viewControllerID = @"addnewbuzztype";
    UIStoryboard * storyboard = [UIStoryboard storyboardWithName:storyboardName bundle:nil];
    AddNewBuzzTypeVC *animation=(AddNewBuzzTypeVC *)[storyboard instantiateViewControllerWithIdentifier:viewControllerID];
    [self.navigationController pushViewController:animation animated:YES];
}

- (IBAction)backTrigger:(id)sender {
    if(self.navigationController!=nil)
        NSLog(@"Hello Fab");

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)loadServerData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *params =@{@"include":@"media"};
    NSData *paramsData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
    NSString *paramsStr = [[NSString alloc] initWithData:paramsData encoding:NSUTF8StringEncoding];
    NSString* filterQuery = [NSString stringWithFormat:@"filter=%@", paramsStr];

    [[BTAPIClient sharedClient] getVisitPeople:@"people" withPersonId:@"55665cce04cdbee008428022" withFilter:filterQuery withBlock:^(NSArray *models, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error ==  nil) {
            if ([models isKindOfClass:[NSArray class]]) {

                for (NSDictionary *object in models) {
                    BTVisitModel *model = [[BTVisitModel alloc]initVisitWithDict:object];
                    int numMedia;
                    if ([[object objectForKeyedSubscript:@"media"] isKindOfClass:[NSArray class]]) {
                        NSArray *media = [object objectForKeyedSubscript:@"media"];
                        numMedia = (int)[media count];
                    }
                    MyFootPrint *myFootPrint = [[MyFootPrint alloc]initWithCoordinates:CLLocationCoordinate2DMake([[model.visit_location objectForKeyedSubscript:@"lat"] floatValue], [[model.visit_location objectForKeyedSubscript:@"lng"] floatValue]) placeName:model.visit_title description:@"" withIndex:(int)numMedia];
                    if(CLLocationCoordinate2DIsValid(myFootPrint.coordinate))
                        [self.mapView addAnnotation:myFootPrint];
                }
            }
        }
    }];
}
@end
