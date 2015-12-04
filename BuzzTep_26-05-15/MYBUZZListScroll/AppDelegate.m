//
//  AppDelegate.m
//  MYBUZZListScroll
//
//  Created by Sanchit Thakur on 15/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "AppDelegate.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "ProjectHandler.h"
#import <DropboxSDK/DropboxSDK.h>
#import "BuzzViewController.h"
#import "AppDelegate.h"
#import <Fabric/Fabric.h>
#import <DigitsKit/DigitsKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <Twitter/Twitter.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <HockeySDK/HockeySDK.h>
#import "LocationWorker.h"
#include <sqlite3.h>

#import "BuzzViewController.h"
#import "Constant.h"
#import "BTAPIClient.h"
#import "Constant.h"
#import "BTCountryCityModel.h"
#import "UIImageView+WebCache.h"

@interface AppDelegate ()<DBNetworkRequestDelegate,DBSessionDelegate,DBRestClientDelegate>

@property UINavigationController *navigationController;
@property (nonatomic)  DBRestClient *restClient;

@property (nonatomic, strong) NSTimer* backTimer;

@end

@implementation AppDelegate
@synthesize FBFriendsList, FBUserDetails, FBUserPlacesVisited, personFBID, personFBEmail;

#pragma mark - loopback
//loopback adapter class method.
static LBRESTAdapter * _adapter = nil;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

+(AppDelegate*)SharedDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}
+ (LBRESTAdapter *) adapter
{
    if ( !_adapter)
        _adapter = [LBRESTAdapter adapterWithURL:[NSURL URLWithString:@"http://buzztep.com:80/api/"]];
//    http://buzztep.com:80/api/bucketitems
    return _adapter;
}

#pragma mark

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
//    BOOL isLoggedIn = [[NSUserDefaults standardUserDefaults] boolForKey:@"isLoggedIn"];
//    NSString *identifier = isLoggedIn ? @"HomeNavigation" : @"LoginNavigation";
//    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    UINavigationController *navigation = [storyboard instantiateViewControllerWithIdentifier:identifier];
//    self.window.rootViewController = navigation;
    
    SDWebImageManager.sharedManager.cacheKeyFilter = ^(NSURL *url) {
        url = [[NSURL alloc] initWithScheme:url.scheme host:url.host path:url.path];
        return [url absoluteString];
    };
    
    if (self.backTimer == Nil)
    {
        self.backTimer = [NSTimer scheduledTimerWithTimeInterval: kBTGetNotificationInterval
                                                          target: self
                                                        selector: @selector(onTick:)
                                                        userInfo: nil
                                                         repeats: YES];
    }
    
    //for dropbox integration
    
    NSString *dropBoxAppKey = @"b8cmdmuhdbslnh2";
    NSString *dropBoxAppSecret = @"cxl84ncnp240sh0";
    NSString *root = kDBRootAppFolder;
    DBSession* session = [[DBSession alloc] initWithAppKey:dropBoxAppKey appSecret:dropBoxAppSecret root:root];
    session.delegate = self;
    [DBSession setSharedSession:session];
    [DBRequest setNetworkRequestDelegate:self];
    

    //  Application Internet Checking.
    
    [ProjectHandler isReachable];
    
    // AFNetworking - NSURLCache
    
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:4 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    [[BITHockeyManager sharedHockeyManager] configureWithIdentifier:@"2cc5987ef3799d28f2f666da1cfa1779"];
    [[BITHockeyManager sharedHockeyManager] startManager];
    [[BITHockeyManager sharedHockeyManager].authenticator authenticateInstallation];
    
    [Fabric with:@[DigitsKit]];

    [FBSDKLoginButton class];
    
    _personID = [[NSUserDefaults standardUserDefaults]objectForKey:kBTPersonLocalID];

    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                    didFinishLaunchingWithOptions:launchOptions];

}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    if ([[DBSession sharedSession] handleOpenURL:url]) {
        if ([[DBSession sharedSession] isLinked]) {
            [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"OPEN_DROPBOX_VIEW" object:nil]];
        }
        return YES;
    }
    return NO;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    [LocationWorker saveLocations];
}

#pragma mark - DBSessionDelegate methods
- (void)sessionDidReceiveAuthorizationFailure:(DBSession *)session userId:(NSString *)userId
{
    relinkUserId = userId;
    [[[UIAlertView alloc] initWithTitle:@"Dropbox Session Ended" message:@"Do you want to relink?" delegate:self
                      cancelButtonTitle:@"Cancel" otherButtonTitles:@"Relink", nil] show];
}

#pragma mark UIAlertViewDelegate methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)index
{
    if (index != alertView.cancelButtonIndex) {
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle: nil];
        UINavigationController *controller = (UINavigationController*)[mainStoryboard instantiateViewControllerWithIdentifier:@"NavigationController"];
        [[DBSession sharedSession] linkFromController:[controller visibleViewController]];
    }
    relinkUserId = nil;
}




#pragma mark DBNetworkRequestDelegate methods

static int outstandingRequests;

- (void)networkRequestStarted
{
    outstandingRequests++;
    if (outstandingRequests == 1)
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    }
}
- (void)networkRequestStopped
{
    outstandingRequests--;
    if (outstandingRequests == 0)
    {
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }
}




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    
    if (self.backTimer)
    {
        [self.backTimer invalidate];
        
        self.backTimer = Nil;
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [FBSDKAppEvents activateApp];
    if (self.backTimer == Nil)
        {
            self.backTimer = [NSTimer scheduledTimerWithTimeInterval: kBTGetNotificationInterval
                                                          target: self
                                                        selector: @selector(onTick:)
                                                        userInfo: nil
                                                         repeats: YES];
        }
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

#pragma mark - Core Data Saving
- (void)saveContext
{
    NSError *error = nil;
    
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (NSManagedObjectContext *)managedObjectContext{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"BuzzTep" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"BuzzTep.sqlite"];
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark -
#pragma mark - Utility Function

- (void)ShowAlert:(NSString*)title messageContent:(NSString *)content
{
    UIAlertView* confirm = [[UIAlertView alloc] initWithTitle:title
                                                      message:content
                                                     delegate:nil
                                            cancelButtonTitle:Nil
                                            otherButtonTitles:@"Ok", nil];
    
    confirm.message = [NSString stringWithFormat:@"%@", content];
    
    [confirm show];
    
}

- (NSString* )ParseBTServerTime:(NSString *)serverTime
{
    NSString *date = serverTime;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    
    NSDate* dateFromString = [formatter dateFromString:date];
    
    [formatter setDateFormat:@"hh:mm a"];
    
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    
    NSString *stringFromDate = [formatter stringFromDate:dateFromString];
    
    return stringFromDate;
}

- (NSString* )ParseBTServerTimeToYYYYMMDD:(NSString *)serverTime
{
    NSString *date = serverTime;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    
    NSDate* dateFromString = [formatter dateFromString:date];
    
    [formatter setDateFormat:@"yyyy-MM-dd"];
    
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    
    NSString *stringFromDate = [formatter stringFromDate:dateFromString];
    
    return stringFromDate;
}

- (NSString* )ParseBTServerTimeToBuzzDetailTime:(NSString *)serverTime
{
    NSString *date = serverTime;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    
    NSDate* dateFromString = [formatter dateFromString:date];
    
    [formatter setDateFormat:@"MM/dd/yy HH:mm a"];
    
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    
    NSString *stringFromDate = [formatter stringFromDate:dateFromString];
    
    return stringFromDate;
}

- (NSString* )GenerateCreatedOnTime
{
    NSString* createdOn = Nil;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    
    createdOn = [formatter stringFromDate:[NSDate date]];
    
    return createdOn;
}

- (NSString* )CreateTimeWithYear:(NSInteger)year Month:(NSInteger)month Day:(NSInteger)day
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    
    NSDate* createdDate = [calendar dateFromComponents:components];
    
    NSString* createdDateStr = Nil;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    
    createdDateStr = [formatter stringFromDate:createdDate];
    
    return createdDateStr;
    
}

- (NSString* )DurationTimeWithYear:(NSInteger)year Month:(NSInteger)month Day:(NSInteger)day ExtraDays:(NSInteger)duration
{
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    
    NSDateComponents *components = [[NSDateComponents alloc] init];
    
    [components setYear:year];
    [components setMonth:month];
    [components setDay:day];
    
    NSDate* createdDate = [calendar dateFromComponents:components];
    
    NSDateComponents *addDaysComponents = [[NSDateComponents alloc] init];
    [addDaysComponents setDay:duration];
    
    NSDate* durationDate = [[NSCalendar currentCalendar]
                            dateByAddingComponents:addDaysComponents
                            toDate:createdDate
                            options:0];
    
    NSString* durationDateStr = Nil;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    
    durationDateStr = [formatter stringFromDate:durationDate];
    
    return durationDateStr;
    
}

-(void)onTick:(NSTimer *)timer
{
    [[BTAPIClient sharedClient] getNotificationCount:@"people"
                                        withPersonId:MyPersonModelID
                                           withBlock:^(NSDictionary *model, NSError *error)
     {
         if (error == Nil)
         {
             if ([model isKindOfClass:[NSDictionary class]])
             {
                 if ([model objectForKeyedSubscript:@"count"])
                 {
                     // Update Local Store Information
                     
                     NSNumber* countNum = [model objectForKeyedSubscript:@"count"] ;
                     
                     [self setLocalNotificationCount:[countNum integerValue]];
                     
                     [[NSNotificationCenter defaultCenter] postNotificationName:kBTNotificationGotNewNotificationCount
                                                                         object:model];
                 }
             }
         }
     }];
}

- (void)setLocalNotificationCount:(NSInteger)count
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    [defaults setInteger:count forKey:kBTPersonLocalNotificationCount];
    
    [defaults synchronize];
}

- (NSInteger)getLocalNotificationCount
{
    NSInteger retVal = 0;
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    
    if ([defaults integerForKey:kBTPersonLocalNotificationCount])
    {
        retVal = [defaults integerForKey:kBTPersonLocalNotificationCount];
    }
    
    return retVal;
}



- (void)cityList:(NSString *)countryCode
       withBlock:(void (^)(NSArray *models, NSError *error))block
{
    @try {
        
        NSMutableArray        *g_CityList = [[NSMutableArray alloc] init];
        
        // Define temporary variables
        
        NSString*   db_countryCode = Nil;
        NSString*   db_subdivisionCode = Nil;
        NSString*   db_gns_fd = Nil;
        NSString*   db_gns_ufi = Nil;
        NSString*   db_languageCode = Nil;
        NSString*   db_languageScript = Nil;
        NSString*   db_cityName = Nil;
        float       db_latitude = 0;
        float       db_longitude = 0;
        
        NSString *dbPathStr = [[NSBundle mainBundle] pathForResource:@"btcountrydb" ofType:@"sqlite"];
        
        sqlite3 *dbHandler;
        sqlite3_open([dbPathStr UTF8String], &dbHandler);
        
        NSString *query = [NSString stringWithFormat:@"select * from worldcities where country_code = \"%@\" and language_script = \"%@\";", countryCode , @"latin"];
        
        sqlite3_stmt *stmt;
        
        int ret = sqlite3_prepare(dbHandler, [query UTF8String], -1, &stmt, nil);
        
        if(ret != SQLITE_OK)
        {
            NSLog(@"Sqlite query failed : %@", query);
        }
        
        while (sqlite3_step(stmt) == SQLITE_ROW)
        {
            BTCountryCityModel  *city = [[BTCountryCityModel alloc] init];
            
            char    *countryCode        = (char *)sqlite3_column_text(stmt, 0);
            char    *subdivisionCode    = (char *)sqlite3_column_text(stmt, 1);
            char    *gns_fd             = (char *)sqlite3_column_text(stmt, 2);
            char    *gns_ufi            = (char *)sqlite3_column_text(stmt, 3);
            char    *languageCode       = (char *)sqlite3_column_text(stmt, 4);
            char    *languageScript     = (char *)sqlite3_column_text(stmt, 5);
            char    *cityName           = (char *)sqlite3_column_text(stmt, 6);
            char    *latitude           = (char *)sqlite3_column_text(stmt, 7);
            char    *longitude          = (char *)sqlite3_column_text(stmt, 8);
            
            if (countryCode != Nil)
            {
                db_countryCode = [NSString stringWithCString:countryCode encoding:NSUTF8StringEncoding];
            }
            else
            {
                db_countryCode = @"";
            }
            
            if (subdivisionCode != Nil)
            {
                db_subdivisionCode = [NSString stringWithCString:subdivisionCode encoding:NSUTF8StringEncoding];
            }
            else
            {
                db_subdivisionCode = @"";
            }
            
            if (gns_fd != Nil)
            {
                db_gns_fd = [NSString stringWithCString:gns_fd encoding:NSUTF8StringEncoding];
            }
            else
            {
                db_gns_fd = @"";
            }
            
            if (gns_ufi != Nil)
            {
                db_gns_ufi = [NSString stringWithCString:gns_ufi encoding:NSUTF8StringEncoding];
            }
            else
            {
                db_gns_ufi = @"";
            }
            
            if (languageCode != Nil)
            {
                db_languageCode = [NSString stringWithCString:languageCode encoding:NSUTF8StringEncoding];
            }
            else
            {
                db_languageCode = @"";
            }
            
            if (languageScript != Nil)
            {
                db_languageScript = [NSString stringWithCString:languageScript encoding:NSUTF8StringEncoding];
            }
            else
            {
                db_languageScript = @"";
            }
            
            if (cityName != Nil)
            {
                db_cityName = [NSString stringWithCString:cityName encoding:NSUTF8StringEncoding];
            }
            else
            {
                db_cityName = @"";
            }
            
            db_latitude = [[NSString stringWithCString:latitude encoding:NSUTF8StringEncoding] floatValue];
            db_longitude = [[NSString stringWithCString:longitude encoding:NSUTF8StringEncoding] floatValue];
            
            city.country_code = db_countryCode;
            city.subdivision_code = db_subdivisionCode;
            city.gns_fd = db_gns_fd;
            city.gns_ufi = db_gns_ufi;
            city.language_code = db_languageCode;
            city.language_script = db_languageScript;
            city.city_name = db_cityName;
            city.latitude = db_latitude;
            city.longitude = db_longitude;
            
            [g_CityList addObject:city];
        }
        
        sqlite3_close(dbHandler);
        
        block(g_CityList, Nil);
                
    }
    @catch (NSException *exception) {
        
    }
    @finally {
        
    }
}

#define RANDOM_BYTES_LEN 8

- (NSString *)randomImageName
{
    NSMutableString     *hexString  = [NSMutableString stringWithCapacity:(RANDOM_BYTES_LEN * 2)];
    
    for (int i = 0; i < RANDOM_BYTES_LEN; ++i)
    {
        [hexString appendString:[NSString stringWithFormat:@"%02x", arc4random() & 0xFF]];
    }
    
    return [NSString stringWithString:hexString];
}

- (UIImage*)DrawText:(NSString*) text
             inImage:(UIImage*)  image
             atPoint:(CGPoint)   point
{
    UIGraphicsBeginImageContextWithOptions(image.size, NO, 0.0f);
    [image drawInRect:CGRectMake(0,0,image.size.width,image.size.height)];
    CGRect rect = CGRectMake(point.x, point.y, image.size.width, image.size.height);

    [[UIColor whiteColor] set];
    UIFont* font = [UIFont fontWithName:@"OpenSans" size:17];
    UIColor* textColor = [UIColor whiteColor];
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    /// Set line break mode
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    /// Set text alignment
    paragraphStyle.alignment = NSTextAlignmentCenter;

    if([text respondsToSelector:@selector(drawInRect:withAttributes:)])
    {
        //iOS 7
        NSDictionary *att = @{NSFontAttributeName:font, NSForegroundColorAttributeName:textColor,NSParagraphStyleAttributeName:paragraphStyle};
        [text drawInRect:rect withAttributes:att];

    }
    else
    {
        //legacy support
        [text drawInRect:CGRectIntegral(rect) withFont:font];
    }

    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    return newImage;
}

- (void)callWithURL:(NSURL *)url
{
    static UIWebView *webView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        webView = [UIWebView new];
    });
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
}
@end
