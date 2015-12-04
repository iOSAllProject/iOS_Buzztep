//
//  LoginVC2.m
//  MYBUZZListScroll
//
//  Created by Sanchit Thakur on 16/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "LoginVC2.h"
#import "LoginVC.h"
#import "AppDelegate.h"
#import "BuzzProfileVC.h"
#import "LoginDigits.h"
#import <DigitsKit/DigitsKit.h>
#import <Twitter/Twitter.h>

#import <TwitterCore/TwitterCore.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>
#define prototypeName @"people"
@interface LoginVC2 ()<FBSDKLoginButtonDelegate>
{
    AppDelegate * appdel;
    id locationResult;
}
- (IBAction)backButton:(id)sender;
- (IBAction)goAction:(id)sender;
- (IBAction)phoneNoAction:(id)sender;
@property (strong, nonatomic) IBOutlet DGTAuthenticateButton *digitsButton;
@property (strong, nonatomic) IBOutlet FBSDKLoginButton *fbLoginButton;
- (IBAction)didTapButton:(id)sender;

@end

@implementation LoginVC2
@synthesize digitsButton;
@synthesize fbLoginButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    DGTAuthenticateButton *authenticateButton = [DGTAuthenticateButton buttonWithAuthenticationCompletion:^(DGTSession *session, NSError *error) {
        // play with Digits session
    }];
    authenticateButton.center = self.phoneNumberBtn.center;
    [authenticateButton setFrame:CGRectMake(self.phoneNumberBtn.frame.origin.x, self.phoneNumberBtn.frame.origin.y, self.phoneNumberBtn.frame.size.width, self.phoneNumberBtn.frame.size.height)];
    [self.view addSubview:authenticateButton];
}
- (void) viewDidAppear:(BOOL)animated {
    
    
    [self facebookAuth];
    
}
-(void) facebookAuth {
    self.fbLoginButton.readPermissions = @[@"public_profile", @"email", @"user_friends", @"user_location", @"user_photos", @"user_status", @"user_tagged_places"];
    fbLoginButton.delegate = self;
    appdel = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
}
- (void)loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult: 	(FBSDKLoginManagerLoginResult *)result
              error: 	(NSError *)error{
    NSLog(@"Login result is %@", result.token.userID);
    //[self addUserLocations];
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
            // NSLog(@"user details arr: %@", appdel.FBUserDetails)
            [self getIdFromEmail:[result valueForKey:@"email"]];
        }
        else {
            NSLog(@"Error");
        }
        
    }];
    
    FBSDKGraphRequest *locationRequest = [[FBSDKGraphRequest alloc]
                                          initWithGraphPath:@"/me/tagged_places"
                                          parameters:nil
                                          HTTPMethod:@"GET"];
    [locationRequest startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                                  id result,
                                                  NSError *error) {
        if (!error) {
            locationResult = result;
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
    
    BuzzProfileVC *buzzProfile =
    [self.storyboard instantiateViewControllerWithIdentifier:@"buzzprofile"];
    [self.navigationController pushViewController:buzzProfile animated:YES];
    
    
    
}
-(void)getIdFromEmail:(NSString *)userIdentityEmail {
    NSLog(@"Email is %@", userIdentityEmail);
    void (^loadErrorBlock)(NSError *) = ^(NSError *error)
    {
        NSLog( @"Get Users: Error %@", error.description);
    };
    
    void (^loadSuccessBlock)(NSArray *) = ^(NSArray *models)
    {
        NSString *userIdentityID;
        NSArray *identityArray;
        NSString *userEmail;
        NSMutableArray *userArray = [[NSMutableArray alloc] init];
        //NSLog( @"Get Users ID: %@ and email is %@ and user array is %@", [models valueForKey:@"id"], [identityArray valueForKey:@"email"], models);
        NSMutableDictionary *userIDEmailDict = [[NSMutableDictionary alloc] init];
        for(int i=0; i<[models count];i++){
            NSDictionary * d = models[i];
            userIdentityID = [d valueForKey:@"id"];
            userEmail = [d valueForKeyPath:@"identity.email"];
            [userIDEmailDict setValue:userIdentityID forKey:userEmail];
            NSLog(@"UserID and Email are %@ <-> %@",userIdentityID, userEmail);
            
        }
        //[userArray addObject:userIDEmailDict];
        appdel.personFBID = [userIDEmailDict valueForKey:userIdentityEmail];
        [self addUserLocations];
        NSLog(@"user array is %@ and user ID is %@", userIDEmailDict, appdel.personFBID);
        
        
    };
    LBModelRepository *getFBUsers = [[AppDelegate adapter] repositoryWithModelName:prototypeName];
    [[[AppDelegate adapter] contract] addItem:[SLRESTContractItem itemWithPattern:@"/people" verb:@"GET"] forMethod:@"people.filter"];
    [getFBUsers invokeStaticMethod:@"filter" parameters:@{ @"filter=[where][identity.email]":userIdentityEmail} success:loadSuccessBlock failure:loadErrorBlock];
    //[objectB allWithSuccess: loadSuccessBlock failure: loadErrorBlock];
}
-(void) addUserLocations {
    
    void (^saveNewErrorBlock)(NSError *) = ^(NSError *error){
        NSLog(@"Error on save %@", error.description);
    };
    void (^saveNewSuccessBlock)() = ^(){
        NSLog(@"User locations saved");
    };
    NSString *peopleString = @"people/";
    NSLog(@"Person ID is %@", appdel.personFBID);
    // NSString *modelName = [prototypeName stringByAppendingString:@"/5571c70b4c300ed30cb341e1/visitedLocations"];
    NSString* modelName = [[peopleString stringByAppendingFormat:@"%@",appdel.personFBID]stringByAppendingFormat:@"/visitedLocations"];
    NSLog(@"Model name is %@", modelName);
    LBModelRepository *newFBUser = [[AppDelegate adapter] repositoryWithModelName:modelName];
    //create new LBModel of type
    
    for(NSDictionary * dict in locationResult[@"data"]){
        NSLog(@"dict : %@", dict);
        NSDictionary * d  = dict[@"place"];
        NSString * placeName = d[@"name"];
        d = d[@"location"];
        
        LBModel *model = [newFBUser modelWithDictionary:@{
                                                          @"title"        : placeName,
                                                          @"location"       : @{@"lat":d[@"latitude"],
                                                                                @"lng":d[@"longitude"]}
                                                          }];
        [model saveWithSuccess:saveNewSuccessBlock failure:saveNewErrorBlock];
        
    }
    
    //}
    /*else {
     UIAlertView *messageAlert = [[UIAlertView alloc]initWithTitle:@"Missing Book Title!" message:@"You have to enter a book title." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
     [messageAlert show];
     }*/
    
}
- (void) loginButtonDidLogOut:(FBSDKLoginButton *)loginButton{
    
}
-(void) twitterDigitsAuth{
    digitsButton = [DGTAuthenticateButton buttonWithAuthenticationCompletion:^(DGTSession *session, NSError *error) {
        // play with Digits session
        if(session){
            //        BuzzProfileVC *buzzProfile =
            //        [self.storyboard instantiateViewControllerWithIdentifier:@"buzzprofile"];
            //        [self.navigationController pushViewController:buzzProfile animated:YES];
        }
        
    }];
    digitsButton.frame = CGRectMake(0.0, 429.0, 376.0, 71.0);
    //[self.view addSubview:digitsButton];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)goAction:(id)sender {
    BuzzProfileVC *buzzProfile =
    [self.storyboard instantiateViewControllerWithIdentifier:@"buzzprofile"];
    [self.navigationController pushViewController:buzzProfile animated:YES];
}

- (IBAction)phoneNoAction:(id)sender {
    LoginDigits *buzzProfile =
    [self.storyboard instantiateViewControllerWithIdentifier:@"keypad1"];
    [self.navigationController pushViewController:buzzProfile animated:YES];
}
- (IBAction)didTapButton:(id)sender {
    // Create an already initialized DGTAppearance object with standard colors:
    DGTAppearance *digitsAppearance =
    [[DGTAppearance alloc] init];
    // Change color properties to customize the look:
    digitsAppearance.backgroundColor = [UIColor
                                        colorWithRed:81/255.
                                        green:208/255.
                                        blue:90/255.
                                        alpha:1];
    digitsAppearance.accentColor = [UIColor redColor];
    
    // Start the authentication flow with the custom appearance. Nil parameters for default values.
    Digits *digits = [Digits sharedInstance];
    [digits authenticateWithDigitsAppearance:digitsAppearance
                              viewController:nil
                                       title:nil
                                  completion:^(DGTSession *session,
                                               NSError *error) {
                                      // Inspect session/error objects
                                  }];
}
@end
