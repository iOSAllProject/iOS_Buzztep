//
//  SignUpVC.m
//  MYBUZZListScroll
//
//  Created by Sanchit Thakur on 16/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "SignUpVC.h"
#import "SignUpDigits.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#import "AppDelegate.h"
#define prototypeName @"people"

@interface SignUpVC () <FBSDKLoginButtonDelegate>
{
    AppDelegate * appdel;
}
- (IBAction)backButton:(id)sender;
- (IBAction)keypadAction:(id)sender;
@property (strong, nonatomic) IBOutlet FBSDKLoginButton *fbLoginButton;

@end

@implementation SignUpVC
@synthesize fbLoginButton;
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.fbLoginButton.readPermissions = @[@"public_profile", @"email", @"user_friends", @"user_location", @"user_photos", @"user_status", @"user_tagged_places"];
    if ([FBSDKAccessToken currentAccessToken]) {
        self.fbLoginButton.delegate = self;
        appdel = (AppDelegate *) [[UIApplication sharedApplication] delegate];
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                      initWithGraphPath:@"/me"
                                      parameters:nil
                                      HTTPMethod:@"GET"];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                              id result,
                                              NSError *error) {
            if (!error) {
                NSLog(@"fetched user:%@", result);
                appdel.FBUserDetails = result;
                // NSLog(@"user details arr: %@", appdel.FBUserDetails);
                
            }
            else {
                NSLog(@"Error");
            }
            
        }];
        
        
        
        FBSDKGraphRequest *friendsRequest = [[FBSDKGraphRequest alloc]
                                             initWithGraphPath:@"/me/invitable_friends"
                                             parameters:nil
                                             HTTPMethod:@"GET"];
        [friendsRequest startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                     id result,
                                                     NSError *error) {
            if (!error) {
                NSLog(@"Invitable friends are :%@", result);
                
                appdel.FBFriendsList = result[@"data"];
                //NSLog(@"users arr: %@", appdel.FBFriendsList);
                
            }
            else {
                NSLog(@"Invitable friends Error is %@", error);
            }
            
        }];
        
        // For more complex open graph stories, use `FBSDKShareAPI`
        // with `FBSDKShareOpenGraphContent`
        /* make the API call */
        FBSDKGraphRequest *locationRequest = [[FBSDKGraphRequest alloc]
                                              initWithGraphPath:@"/me/tagged_places"
                                              parameters:nil
                                              HTTPMethod:@"GET"];
        [locationRequest startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                      id result,
                                                      NSError *error) {
            if (!error) {
                NSLog(@"User locations are:%@", result);
                
            }
            else {
                NSLog(@"Locations Error is %@", error);
            }
            // Handle the result
        }];
        
        // For more complex open graph stories, use `FBSDKShareAPI`
        // with `FBSDKShareOpenGraphContent`
        /* make the API call */
        FBSDKGraphRequest *photosRequest = [[FBSDKGraphRequest alloc]
                                            initWithGraphPath:@"/me/photos"
                                            parameters:nil
                                            HTTPMethod:@"GET"];
        [photosRequest startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                    id result,
                                                    NSError *error) {
            if (!error) {
                NSLog(@"User photos are:%@", result);
                
            }
            else {
                NSLog(@"Photos Error is %@", error);
            }
            
        }];
    }
    
}
- (void)loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult: 	(FBSDKLoginManagerLoginResult *)result
              error: 	(NSError *)error{
    NSLog(@"Login result is %@", result.token.userID);
    [self getModels];
    
}

- (void) loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)keypadAction:(id)sender {
    SignUpDigits *buzzProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"keypad2"];
    [self.navigationController pushViewController:buzzProfile animated:YES];
}

-(void) addFacebookUser {
    
    void (^saveNewErrorBlock)(NSError *) = ^(NSError *error){
        NSLog(@"Error on save %@", error.description);
    };
    void (^saveNewSuccessBlock)() = ^(){
        UIAlertView *messageAlert = [[UIAlertView alloc]initWithTitle:@"Successfull!" message:@"User registration successful" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [messageAlert show];
        UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        UIViewController *vc = [mainStoryboard instantiateViewControllerWithIdentifier:@"licence"];
        [self.navigationController pushViewController:vc animated:YES];
    };
    //if (sender != self.doneButton) return;
    //if (self.titleField.text.length > 0) {
    LBModelRepository *newFBUser = [[AppDelegate adapter] repositoryWithModelName:prototypeName];
    //create new LBModel of type
    LBModel *model = [newFBUser modelWithDictionary:@{
                                                      @"type"        : @"Facebook",
                                                      @"deviceId"       : [[[UIDevice currentDevice] identifierForVendor] UUIDString],
                                                      @"identity" :        @{@"email":[appdel.FBUserDetails valueForKey:@"email"],
                                                                             @"firstName"  : [appdel.FBUserDetails valueForKey:@"first_name"],
                                                                             @"lastName"  : [appdel.FBUserDetails valueForKey:@"last_name"]}
                                                      }];
    [model saveWithSuccess:saveNewSuccessBlock failure:saveNewErrorBlock];
    //}
    /*else {
     UIAlertView *messageAlert = [[UIAlertView alloc]initWithTitle:@"Missing Book Title!" message:@"You have to enter a book title." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
     [messageAlert show];
     }*/
    
}
- (void) getModels
{
    void (^loadErrorBlock)(NSError *) = ^(NSError *error)
    {
        NSLog( @"Get Users: Error %@", error.description);
    };
    
    void (^loadSuccessBlock)(NSArray *) = ^(NSArray *models)
    {
        NSLog( @"Get Users: Count %lu and email is %@ and contains %d", (unsigned long)models.count, [appdel.FBUserDetails valueForKey:@"email"], (int)[models containsObject:[appdel.FBUserDetails valueForKey:@"email"]]);
        if((int)[models containsObject:[appdel.FBUserDetails valueForKey:@"email"]] != 0){
            UIAlertView *messageAlert = [[UIAlertView alloc]initWithTitle:@"Registration!" message:@"User already exists" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [messageAlert show];
        }
        else {
            [self addFacebookUser];
        }
        
    };
    LBModelRepository *getFBUsers = [[AppDelegate adapter] repositoryWithModelName:prototypeName];
    [[getFBUsers contract] addItem:[SLRESTContractItem itemWithPattern:prototypeName verb:@"GET"] forMethod:@"people.filter"];
    [getFBUsers invokeStaticMethod:@"filter" parameters:@{ @"filter=[where][identity.email]":[appdel.FBUserDetails valueForKey:@"email"]} success:loadSuccessBlock failure:loadErrorBlock];
    //[objectB allWithSuccess: loadSuccessBlock failure: loadErrorBlock];
}

@end
