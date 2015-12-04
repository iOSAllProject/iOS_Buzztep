//
//  ViewController.m
//  Globemapview
//
//  Created by Sanchit Thakur on 05/05/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "MyFootprintGlobeVC.h"
#import "MyFootprintVC.h"
#import <WhirlyGlobeMaplyComponent/WhirlyGlobeComponent.h>
#import "ProjectHandler.h"
#import <LoopBack/LoopBack.h>

#define prototypename @"people"

//http://buzztep.com:80/api/bucketitems

@interface MyFootprintGlobeVC ()<WhirlyGlobeViewControllerDelegate,MaplyViewControllerDelegate>
{
    AppDelegate * appdel;

}
//@property (strong, nonatomic) LBRESTAdapter * adapter;
- (void) addCountries;
- (void) addAnnotation:(NSString *)title withSubtitle:(NSString *)subtitle at: (MaplyCoordinate)coord;
@property (nonatomic, strong) NSMutableArray* visitList;
@end

@implementation MyFootprintGlobeVC
{
    WhirlyGlobeViewController *theViewC;
    NSDictionary *vectorDict;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    if(self.navigationController!=nil)
        NSLog(@"Hello Fab");
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationItem setTitle:@"MY FOOTPRINT"];
    
    // Create an empty globe and add it to the view
    theViewC = [[WhirlyGlobeViewController alloc] init];
    [self.view addSubview:theViewC.view];
    UIView *topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70)];
    [topView setBackgroundColor:[UIColor blackColor]];
    theViewC.view.frame = self.view.bounds;
    [self.view addSubview:topView];
    
    // this logic makes it work for either globe or map
    WhirlyGlobeViewController *globeViewC = nil;
    MaplyViewController *mapViewC = nil;
    if ([theViewC isKindOfClass:[WhirlyGlobeViewController class]])
        globeViewC = (WhirlyGlobeViewController *)theViewC;
    else
        mapViewC = (MaplyViewController *)theViewC;
    

    // we want a black background for a globe, a white background for a map.
//    theViewC.clearColor = (globeViewC != nil) ? [UIColor blackColor] : [UIColor whiteColor];

    // and thirty fps if we can get it ­ change this to 3 if you find your app is struggling
    theViewC.frameInterval = 2;
    
    // add the capability to use the local tiles or remote tiles
    bool useLocalTiles = false;

    // we'll need this layer in a second
    MaplyQuadImageTilesLayer *layer;

    if (useLocalTiles)
    {
        MaplyMBTileSource *tileSource =
        [[MaplyMBTileSource alloc] initWithMBTiles:@"geography­-class_medres"];
        layer = [[MaplyQuadImageTilesLayer alloc]
                 initWithCoordSystem:tileSource.coordSys tileSource:tileSource];
    } else {
        // Because this is a remote tile set, we'll want a cache directory
        NSString *baseCacheDir =
        [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)
         objectAtIndex:0];
        NSString *aerialTilesCacheDir = [NSString stringWithFormat:@"%@/osmtiles/",
                                         baseCacheDir];
        int maxZoom = 18;
        
        // MapQuest Open Aerial Tiles, Courtesy Of Mapquest
        // Portions Courtesy NASA/JPL­Caltech and U.S. Depart. of Agriculture, Farm Service Agency
        MaplyRemoteTileSource *tileSource =
        [[MaplyRemoteTileSource alloc]
         initWithBaseURL:@"http://otile1.mqcdn.com/tiles/1.0.0/sat/"
         ext:@"png" minZoom:0 maxZoom:maxZoom];
        tileSource.cacheDir = aerialTilesCacheDir;
        layer = [[MaplyQuadImageTilesLayer alloc]
                 initWithCoordSystem:tileSource.coordSys tileSource:tileSource];
    }

    layer.handleEdges = (globeViewC != nil);
    layer.coverPoles = (globeViewC != nil);
    layer.requireElev = false;
    layer.waitLoad = false;
    layer.drawPriority = 0;
    layer.singleLevelLoading = false;
    [theViewC addLayer:layer];

    // start up over San Francisco, center of the universe
    if (globeViewC != nil)
    {
        globeViewC.height = 0.9999999;
        [globeViewC animateToPosition:MaplyCoordinateMakeWithDegrees(-0.33,26.67)
                                 time:1.0];
    } else {
        mapViewC.height = 1.0;
        [mapViewC animateToPosition:MaplyCoordinateMakeWithDegrees(-122.4192,37.7793)
                               time:1.0];
    }
    [self addChildViewController:theViewC];

    // set the vector characteristics to be pretty and selectable
    vectorDict = @{
                   kMaplyColor: [UIColor whiteColor],
                   kMaplySelectable: @(true),
                   kMaplyVecWidth: @(4.0)};
    

    // If you're doing a globe
    if (globeViewC != nil)
        globeViewC.delegate = self;

    // If you're doing a map
    if (mapViewC != nil)
        mapViewC.delegate = self;
//    [self getModels];
    [self loadServerData];
}


- (void)addAnnotation:(NSString *)title withSubtitle:(NSString *)subtitle at:(MaplyCoordinate)coord
{
    [theViewC clearAnnotations];

    MaplyAnnotation *annotation = [[MaplyAnnotation alloc] init];
    annotation.title = title;
    annotation.subTitle = subtitle;
    NSLog(@"Latitude is %f and longitude is %f and subtitle is %@", coord.x*57.296, coord.y*57.296, subtitle);
    //    MyFootprintViewControllerViewController *myFootVC = [[MyFootprintViewControllerViewController alloc] initWithNibName:@"MyFootprintViewControllerViewController" bundle:Nil];

    //    myfootprint

    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"InviteFriends" bundle:nil];

    MyFootprintVC *myFootVC = [sb instantiateViewControllerWithIdentifier:@"myfootprint"];

    
    
    myFootVC.tappedLatitude = coord.y*57.296;
    myFootVC.tappedLongitude = coord.x*57.296;
    //[theViewC addAnnotation:annotation forPoint:coord offset:CGPointZero];
    [self.navigationController pushViewController:myFootVC animated:YES];
}

- (void)globeViewController:(WhirlyGlobeViewController *)viewC
                   didTapAt:(MaplyCoordinate)coord
{
    NSString *title = @"Tap Location:";
    NSString *subtitle = [NSString stringWithFormat:@"(%.2fN, %.2fE)",
                          coord.y*57.296,coord.x*57.296];
    [self addAnnotation:title withSubtitle:subtitle at:coord];
}

- (void)maplyViewController:(MaplyViewController *)viewC
                   didTapAt:(MaplyCoordinate)coord
{
    NSString *title = @"Tap Location:";
    NSString *subtitle = [NSString stringWithFormat:@"(%.2fN, %.2fE)",
                          coord.y*57.296,coord.x*57.296];
    [self addAnnotation:title withSubtitle:subtitle at:coord];
}

// Unified method to handle the selection
- (void) handleSelection:(MaplyBaseViewController *)viewC
                selected:(NSObject *)selectedObj
{
    // ensure it's a MaplyVectorObject. It should be one of our outlines.
    if ([selectedObj isKindOfClass:[MaplyVectorObject class]])
    {
        MaplyVectorObject *theVector = (MaplyVectorObject *)selectedObj;
        MaplyCoordinate location;

        if ([theVector centroid:&location])
        {
            NSString *title = @"Selected:";
            NSString *subtitle = (NSString *)theVector.userObject;
            [self addAnnotation:title withSubtitle:subtitle at:location];
        }
    }
    if ([selectedObj isKindOfClass:[MaplyScreenMarker class]]) {
        MaplyScreenMarker *marker = (MaplyScreenMarker*)selectedObj;

        NSString *title = @"Unknow";

        [self addAnnotation:title withSubtitle:title at:marker.loc];
    }
}

// This is the version for a globe
- (void) globeViewController:(WhirlyGlobeViewController *)viewC
                   didSelect:(NSObject *)selectedObj
{
    [self handleSelection:viewC selected:selectedObj];
}

// This is the version for a map
- (void) maplyViewController:(MaplyViewController *)viewC
                   didSelect:(NSObject *)selectedObj
{
    [self handleSelection:viewC selected:selectedObj];
}

#pragma mark - LoopBack Data
-(void)viewWillAppear:(BOOL)animated
{


}


#pragma mark


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadServerData{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    NSDictionary *params = @{@"include":@"media"};
    NSData *paramsData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
    NSString *paramsStr = [[NSString alloc] initWithData:paramsData encoding:NSUTF8StringEncoding];
    NSString* filterQuery = [NSString stringWithFormat:@"filter=%@", paramsStr];

    [[BTAPIClient sharedClient] getVisitPeople:@"people" withPersonId:@"55665cce04cdbee008428022" withFilter:filterQuery withBlock:^(NSArray *models, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (error == nil) {
            if ([models isKindOfClass:[NSArray class]]) {
                NSMutableArray *markers = [[NSMutableArray alloc]init];
                UIImage *icon = [UIImage imageNamed:@"footprint_marker"];
                for (NSDictionary *visitObject in models) {
                    BTVisitModel *visitModel = [[BTVisitModel alloc]initVisitWithDict:visitObject];
                    int numMedia;
                    if ([[visitObject objectForKeyedSubscript:@"media"] isKindOfClass:[NSArray class]]) {
                        NSArray *media = [visitObject objectForKeyedSubscript:@"media"];
                        numMedia = (int)[media count];
                    }
                    MaplyScreenMarker *marker = [[MaplyScreenMarker alloc] init];
                    marker.image = [[AppDelegate SharedDelegate] DrawText:[NSString stringWithFormat:@"%d",(int)numMedia] inImage:icon atPoint:CGPointMake(0, 0)];
                    marker.loc = MaplyCoordinateMakeWithDegrees([[visitModel.visit_location objectForKeyedSubscript:@"lng"] floatValue], [[visitModel.visit_location objectForKeyedSubscript:@"lat"] floatValue]);
                    marker.size = CGSizeMake(28,45);
                    [markers addObject:marker];
                }
                [theViewC addScreenMarkers:markers desc:nil];
            }
        }
    }];
}




@end
