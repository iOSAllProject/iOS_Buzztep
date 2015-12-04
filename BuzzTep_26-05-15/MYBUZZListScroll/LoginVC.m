//
//  LoginVC.m
//  MYBUZZListScroll
//
//  Created by Sanchit Thakur on 15/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "LoginVC.h"
#import "LoginVC2.h"
#import "SignUpVC.h"
#import "AppDelegate.h"

#import "BuzzProfileVC.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface LoginVC ()
{
    AppDelegate * appdel;
}
- (IBAction)loginAction:(id)sender;
- (IBAction)signUpAction:(id)sender;


@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    appdel = (AppDelegate *) [[UIApplication sharedApplication] delegate];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)loginAction:(id)sender
{
    if ([FBSDKAccessToken currentAccessToken]) {
        
        // For more complex open graph stories, use `FBSDKShareAPI`
        // with `FBSDKShareOpenGraphContent`
        /* make the API call */
        NSString *slash = @"/";
        FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc]
                                      initWithGraphPath:[slash stringByAppendingString:[[FBSDKAccessToken currentAccessToken] userID]]
                                      parameters:nil
                                      HTTPMethod:@"GET"];
        [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
                                              id result,
                                              NSError *error) {
            if (!error) {
                NSLog(@"fetched user:%@", result);
                [self getIdFromEmail:[result valueForKey:@"email"]];
            }
            else {
                NSLog(@"Error is %@", error);
            }
        }];
        
        NSLog(@"Person ID is %@", appdel.personFBID);
        BuzzProfileVC *buzzProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"buzzprofile"];
        [self.navigationController pushViewController:buzzProfile animated:YES];
    }
    else {
        LoginVC2 *buzzProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"loginvc2"];
        [self.navigationController pushViewController:buzzProfile animated:YES];
    }
    
    
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
        NSLog(@"user array is %@ and user ID is %@", userIDEmailDict, appdel.personFBID);
        
        
    };
    LBModelRepository *getFBUsers = [[AppDelegate adapter] repositoryWithModelName:@"people"];
    [[[AppDelegate adapter] contract] addItem:[SLRESTContractItem itemWithPattern:@"/people" verb:@"GET"] forMethod:@"people.filter"];
    [getFBUsers invokeStaticMethod:@"filter" parameters:@{ @"filter=[where][identity.email]":userIdentityEmail} success:loadSuccessBlock failure:loadErrorBlock];
    //[objectB allWithSuccess: loadSuccessBlock failure: loadErrorBlock];
}

- (IBAction)signUpAction:(id)sender {
    SignUpVC *buzzProfile =    [self.storyboard instantiateViewControllerWithIdentifier:@"signupvc"];
    [self.navigationController pushViewController:buzzProfile animated:YES];
}




@end
