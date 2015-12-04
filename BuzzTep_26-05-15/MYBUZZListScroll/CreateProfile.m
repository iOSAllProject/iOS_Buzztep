//
//  CreateProfile.m
//  MYBUZZListScroll
//
//  Created by Sanchit Thakur on 16/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "CreateProfile.h"
#import "BuzzProfileVC.h"
#import <CoreLocation/CoreLocation.h>

@interface CreateProfile ()<UITextFieldDelegate,UIActionSheetDelegate,ELCImagePickerControllerDelegate,UIImagePickerControllerDelegate,CLLocationManagerDelegate>
{
    CLLocationManager *locationManager;
    NSDictionary *currentLocation;
}
- (IBAction)backButton:(id)sender;
- (IBAction)goAction:(id)sender;

@property (strong, nonatomic) IBOutlet UITextField *firstName;

@property (strong, nonatomic) IBOutlet UITextField *lastName;
@property (strong, nonatomic) IBOutlet UITextField *currentCity;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumber;
@property (strong, nonatomic) UIImage *imageSelect;
@end

@implementation CreateProfile

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self.firstName setDelegate:self];
    [self.lastName setDelegate:self];
    [self.currentCity setDelegate:self];
    [self.phoneNumber setDelegate:self];

    [self.firstName setValue:[UIColor colorWithRed:1.0/255.0 green:1.0/255.0 blue:1.0/255.0 alpha:1.0]
                  forKeyPath:@"_placeholderLabel.textColor"];


    [self.lastName setValue:[UIColor colorWithRed:1.0/255.0 green:1.0/255.0 blue:1.0/255.0 alpha:1.0]
                 forKeyPath:@"_placeholderLabel.textColor"];

    [self.currentCity setValue:[UIColor colorWithRed:1.0/255.0 green:1.0/255.0 blue:1.0/255.0 alpha:1.0]
                    forKeyPath:@"_placeholderLabel.textColor"];

    [self.phoneNumber setValue:[UIColor colorWithRed:1.0/255.0 green:1.0/255.0 blue:1.0/255.0 alpha:1.0]
                    forKeyPath:@"_placeholderLabel.textColor"];

    UIView *paddingView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, 0)];
    self.firstName.leftView = paddingView1;
    self.firstName.leftViewMode = UITextFieldViewModeAlways;


    UIView *paddingView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
    self.lastName.leftView = paddingView2;
    self.lastName.leftViewMode = UITextFieldViewModeAlways;

    UIView *paddingView3 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
    self.currentCity.leftView = paddingView3;
    self.currentCity.leftViewMode = UITextFieldViewModeAlways;

    UIView *paddingView4 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 0)];
    self.phoneNumber.leftView = paddingView4;
    self.phoneNumber.leftViewMode = UITextFieldViewModeAlways;

    CALayer *layer = [_profileButton layer];
    [layer setMasksToBounds:YES];
    [layer setCornerRadius:_profileButton.frame.size.width/2];
    [layer setBorderWidth:2.0f];
    [layer setBorderColor:[UIColor grayColor].CGColor];

    // Get current location;
    locationManager = [[CLLocationManager alloc] init];
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
        [locationManager requestWhenInUseAuthorization];
    [locationManager startUpdatingLocation];
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.firstName resignFirstResponder];
    [self.lastName resignFirstResponder];
    [self.currentCity resignFirstResponder];
    [self.phoneNumber resignFirstResponder];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField:textField up:YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField:textField up:NO];
}
-(void)animateTextField:(UITextField*)textField up:(BOOL)up
{
    const int movementDistance = -120;
    const float movementDuration = 0.3f;

    int movement = (up ? movementDistance : -movementDistance);

    [UIView beginAnimations: @"animateTextField" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{

    [textField resignFirstResponder];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)goAction:(id)sender
{

    NSData *imageData = UIImagePNGRepresentation(_imageSelect);
    if (!imageData) {
        [self showMessage:@"Image profile is null"];
    }else if (_firstName.text.length == 0) {
        [self showMessage:@"First name is null"];
    }else if (_lastName.text.length == 0){
        [self showMessage:@"Last name is null"];
    }else if (_currentCity.text.length == 0){
        [self showMessage:@"Current Residing city is null"];
    }else if (_phoneNumber.text.length == 0){
        [self showMessage:@"Phone number is null"];
    }else{
        if (!currentLocation) {
            currentLocation = @{@"lat" : @(22.284681),
                             @"lng" : @(114.158177)};

        }
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];

        NSString *container = @"profilePhotos";
        NSString *fileName = [[AppDelegate SharedDelegate] randomImageName];
        [[BTAPIClient sharedClient] uploadImage:container withData:_imageSelect withFileName:fileName withBlock:^(NSDictionary *model, NSError *error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            if (!error) {
                // Create Profile
                NSDictionary *identity = @{@"phoneNumber":_phoneNumber.text,
                                           @"firstName":_firstName.text,
                                           @"lastName":_lastName.text,
                                           @"companyName":@"NSA",
                                           @"shortName":@"NSA",
                                           @"websiteUrl":@"google.com"};
                NSDictionary *homeLocation = @{@"city":_currentCity.text,
                                               @"state":@"",
                                               @"country":@""};

                NSDictionary *param = @{@"type":@"user",
                                        @"identity":identity,
                                        @"homeLocation":homeLocation,
                                        @"lastLocation":currentLocation};

                [[BTAPIClient sharedClient] createPeople:@"people" withDict:param withBlock:^(NSDictionary *model, NSError *error) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    if (!error) {
                        if ([model isKindOfClass:[NSDictionary class]]) {
                            NSString *personId = [model objectForKey:@"id"];
                            [[NSUserDefaults standardUserDefaults] setObject:personId forKey:kBTPersonLocalID];
                            [[NSUserDefaults standardUserDefaults] synchronize];

                            // Upload profile Image
                            // ......
                            NSDictionary* postDict = @{@"name": @"Profile Photo",
                                                       @"type": @"profile",
                                                       @"data": @{
                                                               @"container": container,
                                                               @"filename": [NSString stringWithFormat:@"%@.jpg",fileName],
                                                               @"dataUrl":[NSString stringWithFormat:@"%@/media/%@/download", BASEURL, container]
                                                               },
                                                       @"location": currentLocation,
                                                       @"personId":personId
                                                           };
                            [[BTAPIClient sharedClient] createMetadata:@"metadata"
                                                              withDict:postDict
                                                             withBlock:^(NSDictionary *model, NSError *error)
                             {
                                 if (error == Nil)
                                 {
                                     DLog(@"%@", model);
                                 }
                                 
                             }];

                            //Create metadata
                            BuzzProfileVC *buzzProfile =  [self.storyboard instantiateViewControllerWithIdentifier:@"buzzprofile"];
                            [self.navigationController pushViewController:buzzProfile animated:YES];
                        }
                        
                    }
                }];


            }


        }];

    }
}
- (IBAction)takePhotoAction:(id)sender {
    UIActionSheet *actionsheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Take Photo",@"Choose Photo", nil];
    [actionsheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
        {
            if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                NSArray *media = [UIImagePickerController
                                  availableMediaTypesForSourceType: UIImagePickerControllerSourceTypeCamera];

                if ([media containsObject:(NSString*)kUTTypeImage] == YES)
                {
                    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
                    picker.sourceType = UIImagePickerControllerSourceTypeCamera;
                    picker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
                    [picker setMediaTypes:[NSArray arrayWithObject:(NSString *)kUTTypeImage]];
                    picker.delegate = self;
                    picker.allowsEditing = YES;
                    [self presentViewController:picker animated:YES completion:nil];
                }
                else
                {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unsupported!"
                                                                    message:@"Camera does not support photo capturing."
                                                                   delegate:nil
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil];
                    [alert show];
                }
            }
            else
            {
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unavailable!"
                                                                message:@"This device does not have a camera."
                                                               delegate:nil
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];

            }
        }
            break;
        case 1:
        {
            ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];

            elcPicker.maximumImagesCount = 100; //Set the maximum number of images to select to 100
            elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
            elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
            elcPicker.onOrder = NO; //For multiple image selection, display and return order of selected images
            elcPicker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie]; //Supports image and movie types

            elcPicker.imagePickerDelegate = self;

            [self presentViewController:elcPicker animated:YES completion:nil];
        }
            break;
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *selectedImage = info[UIImagePickerControllerEditedImage];
    [_profileButton setBackgroundImage:selectedImage forState:UIControlStateNormal];
    _imageSelect = selectedImage;
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark ELCImagePickerControllerDelegate Methods

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    NSMutableArray* imageAray = [[NSMutableArray alloc]init];
    for (NSDictionary *dict in info) {
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];

                [imageAray addObject:image];

            } else {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        } else {
            NSLog(@"Uknown asset type");
        }
    }
    if ([imageAray count] > 0) {
        _imageSelect = [imageAray firstObject];
         [_profileButton setBackgroundImage:[imageAray firstObject] forState:UIControlStateNormal];
    }
     [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    currentLocation = @{@"lat":[NSString stringWithFormat:@"%f",oldLocation.coordinate.latitude],
                        @"lng":[NSString stringWithFormat:@"%f",oldLocation.coordinate.longitude]};
}
-(void)showMessage :(NSString*)message{
    UIAlertView* warning = [[UIAlertView alloc]initWithTitle:@"BuzzTep" message:message delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [warning show];
}
@end
