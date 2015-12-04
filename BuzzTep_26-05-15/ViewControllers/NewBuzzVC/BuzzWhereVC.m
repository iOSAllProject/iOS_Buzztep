//
//  BuzzWhereVC.m
//  When_WhereVC
//
//  Created by Sanchit Thakur on 20/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "BuzzWhereVC.h"
#import "BuzzWhenVC.h"
#import "BuzzProfileVC.h"
#import "BuzzWhoVC.h"
#import "BuzzWhenVC.h"
#import "AppDelegate.h"
#import "AFHTTPRequestOperation.h"
#import "AFHTTPRequestOperationManager.h"
#import "MapView.h"
#import "PickerView.h"

#import "Constant.h"
#import "Global.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"
#import "BTCountryCityModel.h"

#import <CoreLocation/CoreLocation.h>
#import "LMAddress.h"
#import "LMGeocoder.h"

#import "MLPAutoCompleteTextField.h"
#import "DEMOCustomAutoCompleteCell.h"
#import "DEMOCustomAutoCompleteObject.h"
#import "DEMODataSource.h"
#import <QuartzCore/QuartzCore.h>

@interface BuzzWhereVC () <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

@property (strong, nonatomic) IBOutlet UIButton *currentLocationProperty;
@property (strong, nonatomic) IBOutlet UIButton *whereProperty;
@property (strong, nonatomic) IBOutlet UIButton *countryButton;

@property (nonatomic, strong) NSArray *cityArray,*countryArray;
@property (nonatomic, strong) NSArray *objectsArray;
@property (nonatomic, strong) NSArray *numbersArray;
@property (nonatomic, assign) id selectedObject;
@property (nonatomic, strong) NSString * cityString,* countryString;

@property NSDictionary *dictionary1;

@property (nonatomic, retain) NSMutableArray *jsonArray;
@property (nonatomic, strong) NSArray *cityListArray;

@property NSArray *tableData,*tableData1;

- (IBAction)nextVC:(id)sender;
- (IBAction)closeButton:(id)sender;

- (IBAction)whereAction:(id)sender;
- (IBAction)whenAction:(id)sender;
- (IBAction)whoAction:(id)sender;

- (IBAction)userCurrentLocation:(id)sender;

- (IBAction)cityAction:(id)sender;
- (IBAction)countryAction:(id)sender;

- (NSString* )countryCode:(NSString* )countryName;

- (void)animate;

@end

@implementation BuzzWhereVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Location manager Setup
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation;
    
    if ([self.locationManager respondsToSelector:@selector(requestAlwaysAuthorization)])
    {
        [self.locationManager requestAlwaysAuthorization];
    }
    
    // Other UI Init
    
    _countryButton.contentEdgeInsets = UIEdgeInsetsMake(0, 25, 0, 30);
    
    self.jsonArray =[[NSMutableArray alloc] init];
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"countries" ofType:@"json"];
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    NSError *error = nil;
    
    _dictionary1 = [NSJSONSerialization JSONObjectWithData:jsonData options: NSJSONReadingMutableContainers error: &error];
    
    _jsonArray = [[NSMutableArray alloc] initWithArray: _dictionary1[@"countries"][@"country"]];
    
    _countryArray = [_jsonArray valueForKey:@"countryName"];
    
    _cityArray=[_jsonArray valueForKey:@"capital"];
    
    _cityString = [_cityArray objectAtIndex:0];
    
    _countryString = [_countryArray objectAtIndex:0];
    
    id delegate = [[UIApplication sharedApplication] delegate];
    
    self.managedObjectContext = [delegate managedObjectContext];
    
    // City Auto Completion Process
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShowWithNotification:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHideWithNotification:) name:UIKeyboardDidHideNotification object:nil];
    
    //Supported Styles:
    [self.autocompleteTextField setBorderStyle:UITextBorderStyleNone];
    
    //You can use custom TableViewCell classes and nibs in the autocomplete tableview if you wish.
    //This is only supported in iOS 6.0, in iOS 5.0 you can set a custom NIB for the cell
    if ([[[UIDevice currentDevice] systemVersion] compare:@"6.0" options:NSNumericSearch] != NSOrderedAscending) {
        [self.autocompleteTextField registerAutoCompleteCellClass:[DEMOCustomAutoCompleteCell class]
                                           forCellReuseIdentifier:@"CustomCellId"];
    }
    else{
        //Turn off bold effects on iOS 5.0 as they are not supported and will result in an exception
        self.autocompleteTextField.applyBoldEffectToAutoCompleteSuggestions = NO;
    
    }
    
    [self.autocompleteTextField setAutoCompleteTableAppearsAsKeyboardAccessory:NO];
    
    self.autocompleteTextField.autoCompleteTableBackgroundColor = [UIColor blackColor];
    self.autocompleteTextField.autoCompleteTableCellBackgroundColor = [UIColor blackColor];
    self.autocompleteTextField.autoCompleteTableCellTextColor = [UIColor whiteColor];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [self animate];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [self.locationManager stopUpdatingLocation];
    
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (IBAction)nextVC:(id)sender
{
    // Stop Location Service
    
    [self.locationManager stopUpdatingLocation];
    
    // Set City and Country
    
    NSString* cityStr = self.autocompleteTextField.text;
    NSString* countryStr = _countryButton.titleLabel.text;
    
    if ([cityStr.uppercaseString isEqualToString:@"CITY"])
    {
        [[AppDelegate SharedDelegate] ShowAlert:ApplicationTile
                                 messageContent:@"Select the city"];
        
        return;
    }
    
    if ([countryStr.uppercaseString isEqualToString:@"COUNTRY"])
    {
        [[AppDelegate SharedDelegate] ShowAlert:ApplicationTile
                                 messageContent:@"Select the country"];
        
        return;
    }
    
    NSDictionary* locationDict = Nil;
    
    locationDict = @{@"lat" : @(22.284681),
                     @"lng" : @(114.158177)};
    
    [AppDelegate SharedDelegate].gBuzzLocation = locationDict;
    
    if ([AppDelegate SharedDelegate].gBuzzType == Global_BuzzType_Adventure)
    {
        [AppDelegate SharedDelegate].gAdventureModel.adventure_city = cityStr;
        [AppDelegate SharedDelegate].gAdventureModel.adventure_country = countryStr;
    }
    else if ([AppDelegate SharedDelegate].gBuzzType == Global_BuzzType_Milestone)
    {
        [AppDelegate SharedDelegate].gMilestoneModel.milestone_city = cityStr;
        [AppDelegate SharedDelegate].gMilestoneModel.milestone_country = countryStr;
    }
    else if ([AppDelegate SharedDelegate].gBuzzType == Global_BuzzType_Event)
    {
        [AppDelegate SharedDelegate].gEventModel.event_location = locationDict;
    }
        
    BuzzWhenVC *buzzWhen = [self.storyboard instantiateViewControllerWithIdentifier:@"buzzwhen"];
    [self.navigationController pushViewController:buzzWhen animated:YES];
    
    // create instance on NSManagedObect for buzzWhere
    NSManagedObject	*buzzWhere = [NSEntityDescription insertNewObjectForEntityForName:@"Adventure" inManagedObjectContext:_managedObjectContext];
    
    [buzzWhere setValue:self.autocompleteTextField.text forKey:@"adventureCity"];
    [buzzWhere setValue:_countryButton.titleLabel.text forKey:@"adventureCountry"];
    
    NSLog(@"buzzWhere objects are=%@", buzzWhere);
    
    NSError *error;
    
    // here’s where the actual save happens, and if it doesn’t we print something out to the console
    if (![_managedObjectContext save:&error])
    {
        NSLog(@"Problem saving: %@", [error localizedDescription]);
    }
}

- (IBAction)closeButton:(id)sender
{
    BuzzProfileVC *buzzProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"buzzprofile"];
    [self.navigationController pushViewController:buzzProfile animated:YES];
}

- (IBAction)whereAction:(id)sender
{
    NSLog(@"Where action");
    
}

- (IBAction)whenAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"when action");
}

- (IBAction)whoAction:(id)sender
{
    BuzzWhoVC *buzzWho = [self.storyboard instantiateViewControllerWithIdentifier:@"buzzwho"];
    [self.navigationController pushViewController:buzzWho animated:YES];
    NSLog(@"who action");
}

- (IBAction)userCurrentLocation:(id)sender {
    NSLog(@"User current Location:");

    [self.locationManager startUpdatingLocation];
    
//    MapView *map=[self.storyboard instantiateViewControllerWithIdentifier:@"mapview"];
//    [self.navigationController pushViewController:map animated:YES];
}

- (IBAction)countryAction:(id)sender
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadCityList)
                                                 name:@"PressedDismiss"
                                               object:Nil];
    
    [PickerView showPickerViewInView:self.view
                         withStrings:_countryArray
                         withOptions:@{backgroundColor: [UIColor whiteColor],
                                       textColor: [UIColor blackColor],
                                       toolbarColor: [UIColor whiteColor],
                                       buttonColor: [UIColor blueColor],
                                       font: [UIFont systemFontOfSize:18],
                                       valueY: @3,
                                       selectedObject:_countryString}
                          completion:^(NSString *selectedString)
     {
         [_countryButton setTitle:selectedString forState:UIControlStateNormal];
         
         _countryString = selectedString;
     }];
}

- (IBAction)cityAction:(id)sender {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:@"PressedDismiss"
                                                  object:Nil];
    
    [PickerView showPickerViewInView:self.view
                         withStrings:self.cityListArray
                         withOptions:@{backgroundColor: [UIColor whiteColor],
                                       textColor: [UIColor blackColor],
                                       toolbarColor: [UIColor whiteColor],
                                       buttonColor: [UIColor blueColor],
                                       font: [UIFont systemFontOfSize:18],
                                       valueY: @3,
                                       selectedObject:_cityString,
                                       textAlignment:@1}
                          completion:^(NSString *selectedString)
    {
        self.autocompleteTextField.text = selectedString;
        
         _cityString = selectedString;
        
     }];
    
}

#pragma mark - Utility Function

- (void)animate
{
    CABasicAnimation *anim = [CABasicAnimation animationWithKeyPath:@"transform"];
    anim.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    anim.duration = 0.5;
    anim.repeatCount = 2;
    anim.autoreverses = YES;
    anim.removedOnCompletion = YES;
    anim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.2, 1.2, 1.0)];
    
    [_whereProperty.layer addAnimation:anim forKey:nil];
}

- (NSString* )countryCode:(NSString* )countryName
{
    NSString* retVal = Nil;

    for (int i = 0 ; i < [_jsonArray count] ; i ++)
    {
        NSDictionary* countryDict = Nil;
        
        countryDict = [_jsonArray objectAtIndex:i];
        
        if (countryDict != Nil)
        {
            NSString* countryStr = [countryDict valueForKey:@"countryName"];
            
            if ([countryName isEqualToString:countryStr])
            {
                retVal = [countryDict valueForKey:@"countryCode"];
                
                break;
            }
        }
    }
    
    return retVal;
}

- (void)loadCityList
{
    NSString* countryCode = [self countryCode:_countryString];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[AppDelegate SharedDelegate] cityList:countryCode
                                 withBlock:^(NSArray *models, NSError *error)
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        
        self.cityListArray = [[NSArray alloc] init];
        
        NSMutableArray* cityList = [[NSMutableArray alloc] init];
        
        for (int i =0 ; i < [models count] ; i ++)
        {
            BTCountryCityModel* cityModel = [models objectAtIndex:i];
            
            [cityList addObject:cityModel.city_name];
        }
        
        NSArray* unifiedList = [[NSOrderedSet orderedSetWithArray:cityList] array];
        
        self.cityListArray= [unifiedList sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
            
            NSString *first = (NSString* )a;
            NSString *second = (NSString* )b;
            
            return [first compare:second];
        }];
        
        _cityString = [self.cityListArray objectAtIndex:0];
        
        self.autocompleteDataSource.allCountries = [[NSArray alloc] init];
        
        self.autocompleteDataSource.allCountries = self.cityListArray;
        
        self.autocompleteTextField.text = _cityString;
    }];
}

- (void)cityList:(NSString* )countryName extraCity:(NSString* )cityName
{
    __block NSArray* retArray = [[NSArray alloc] init];
    
    NSString* countryCode = [self countryCode:_countryString];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[AppDelegate SharedDelegate] cityList:countryCode
                                 withBlock:^(NSArray *models, NSError *error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
         
         retArray = [[NSArray alloc] init];
         
         NSMutableArray* cityList = [[NSMutableArray alloc] init];
         
         for (int i =0 ; i < [models count] ; i ++)
         {
             BTCountryCityModel* cityModel = [models objectAtIndex:i];
             
             [cityList addObject:cityModel.city_name];
         }
         
         if (cityName)
         {
             [cityList addObject:cityName];
         }
         
         NSArray* unifiedList = [[NSOrderedSet orderedSetWithArray:cityList] array];
         
         retArray = [unifiedList sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
             
             NSString *first = (NSString* )a;
             NSString *second = (NSString* )b;
             
             return [first compare:second];
         }];
         
         if (cityName)
         {
             _cityString = cityName;
         }
         else
         {
            _cityString = [self.cityListArray objectAtIndex:0];
         }
         
         self.autocompleteDataSource.allCountries = [[NSArray alloc] init];
         
         self.autocompleteDataSource.allCountries = self.cityListArray;
         
         self.autocompleteTextField.text = _cityString;
     }];
}

#pragma mark - LOCATION MANAGER

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *location = [locations lastObject];
    CLLocationCoordinate2D coordinate = location.coordinate;
    
    DLog(@"(%f - %f)", coordinate.latitude, coordinate.longitude);
    
    [[LMGeocoder sharedInstance] reverseGeocodeCoordinate:coordinate
                                                  service:kLMGeocoderGoogleService
                                        completionHandler:^(LMAddress *address, NSError *error)
    {
        DLog(@"%@", address);
        
        if (address && !error)
        {
            [_countryButton setTitle:address.country forState:UIControlStateNormal];
            
            self.autocompleteTextField.text = address.route;
            
            _countryString = address.country;
            
            [self cityList:_countryString extraCity:address.route];
            
            _cityString = address.route;
            
            [self.locationManager stopUpdatingLocation];
            
            // Update location
            
            NSDictionary* locationDict = Nil;
            
            locationDict = @{@"lat" : @(address.coordinate.latitude),
                             @"lng" : @(address.coordinate.longitude)};
            
            if ([AppDelegate SharedDelegate].gBuzzType == Global_BuzzType_Event)
            {
                [AppDelegate SharedDelegate].gEventModel.event_location = locationDict;
            }
            
            [AppDelegate SharedDelegate].gBuzzLocation = locationDict;
        }
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"Updating location failed");
}

#pragma mark - MLPAutoCompleteTextField Delegate


- (BOOL)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
          shouldConfigureCell:(UITableViewCell *)cell
       withAutoCompleteString:(NSString *)autocompleteString
         withAttributedString:(NSAttributedString *)boldedString
        forAutoCompleteObject:(id<MLPAutoCompletionObject>)autocompleteObject
            forRowAtIndexPath:(NSIndexPath *)indexPath;
{
    //This is your chance to customize an autocomplete tableview cell before it appears in the autocomplete tableview
    
    return YES;
}

- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
  didSelectAutoCompleteString:(NSString *)selectedString
       withAutoCompleteObject:(id<MLPAutoCompletionObject>)selectedObject
            forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(selectedObject){
        NSLog(@"selected object from autocomplete menu %@ with string %@", selectedObject, [selectedObject autocompleteString]);
    } else {
        NSLog(@"selected string '%@' from autocomplete menu", selectedString);
    }
}

#pragma mark - Other Functions

- (void)keyboardDidShowWithNotification:(NSNotification *)aNotification
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         CGPoint adjust;
                         switch (self.interfaceOrientation) {
                             case UIInterfaceOrientationLandscapeLeft:
                                 adjust = CGPointMake(-110, 0);
                                 break;
                             case UIInterfaceOrientationLandscapeRight:
                                 adjust = CGPointMake(110, 0);
                                 break;
                             default:
                                 adjust = CGPointMake(0, -160);
                                 break;
                         }
                         CGPoint newCenter = CGPointMake(self.view.center.x+adjust.x, self.view.center.y+adjust.y);
                         [self.view setCenter:newCenter];
                         
                     }
                     completion:nil];
}


- (void)keyboardDidHideWithNotification:(NSNotification *)aNotification
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationCurveEaseOut|UIViewAnimationOptionBeginFromCurrentState
                     animations:^{
                         CGPoint adjust;
                         switch (self.interfaceOrientation) {
                             case UIInterfaceOrientationLandscapeLeft:
                                 adjust = CGPointMake(110, 0);
                                 break;
                             case UIInterfaceOrientationLandscapeRight:
                                 adjust = CGPointMake(-110, 0);
                                 break;
                             default:
                                 adjust = CGPointMake(0, 160);
                                 break;
                         }
                         CGPoint newCenter = CGPointMake(self.view.center.x+adjust.x, self.view.center.y+adjust.y);
                         [self.view setCenter:newCenter];
                     }
                     completion:nil];
    
    
    [self.autocompleteTextField setAutoCompleteTableViewHidden:NO];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
