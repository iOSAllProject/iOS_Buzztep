//
//  ProjectHandler.m
//  Animation
//
//  Created by Sanchit Thakur on 20/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "ProjectHandler.h"
#import "Network.h"
#import "MBProgressHUD.h"

@interface ProjectHandler ()

@property (strong, nonatomic) LBRESTAdapter * adapter;

@end

@implementation ProjectHandler

+ (id)sharedHandler
{
    // structure used to test whether the block has completed or not
    static dispatch_once_t p = 0;
    
    // initialize sharedObject as nil (first call only)
    __strong static id _sharedObject = nil;
    
    // executes a block object once and only once for the lifetime of an application
    dispatch_once(&p, ^{
        _sharedObject = [[self alloc] init];
    });
    
    // returns the same object each time
    return _sharedObject;
}


+ (void)setSegmentAttributes
{
    [[UISegmentedControl appearance] setBackgroundColor:[UIColor lightGrayColor]];
    [[UISegmentedControl appearance] setTintColor:[UIColor clearColor]];
    
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor colorWithRed:0.439 green:0.624 blue:0.604 alpha:1], NSFontAttributeName : [UIFont systemFontOfSize:14]} forState:UIControlStateSelected];
    
    [[UISegmentedControl appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]} forState:UIControlStateNormal];
    
}

#pragma mark -  Application Internet Checking.
+ (BOOL)isReachable
{
    //Checking of Internet connection is available or not..
    Network *reachability = [Network reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    
    if(status == NotReachable)
    {
        //No internet
        NSLog(@"No internet");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Internet-OFF"
                                                        message:@"App Doesn't have Internet"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else if (status == ReachableViaWiFi)
    {
        //WiFi
        NSLog(@"WiFi");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"WiFi-ON"
                                                        message:@"App connected with WiFi"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    else if (status == ReachableViaWWAN)
    {
        //3G
        NSLog(@"3G");
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"3G"
                                                        message:@"App connected with WiFi 3G"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
    
    return status != NotReachable;
}

- (LBRESTAdapter *) adapter
{
    if( !_adapter)
        _adapter = [LBRESTAdapter adapterWithURL:[NSURL URLWithString:@"http://buzztep.com:80/api"]];
    return _adapter;
}

- (void)dataFromServerForModelName:(NSString *)name
                        parameters:(NSDictionary *)params
                           success:(RequestSuccessBlock)success
                           failure:(RequestFailureBlock)failure
{
    LBModelRepository *objectPrototype = [[self adapter] repositoryWithModelName:name];
    
    MBProgressHUD* hud = [[MBProgressHUD alloc] init];
    [hud show:YES];
    
    //Persist the newly created Model to the LoopBack node server
    [[objectPrototype modelWithDictionary:params] saveWithSuccess:^{
        
        [objectPrototype allWithSuccess:^(NSArray *models) {
            
            [hud hide:YES];
            success(models);
            
        } failure:^(NSError *error) {

            [hud hide:YES];

            NSLog(@"ERROR in API %@: %@", name, error.localizedDescription);
           // failure(error);
        }];
        
    } failure:^(NSError *error) {
        
        [hud hide:YES];

        NSLog(@"ERROR in API %@: %@", name, error.localizedDescription);
        //failure(error);
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No-Internet"
                                                        message:@"ERROR"
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
        
        
    }];

}


@end
