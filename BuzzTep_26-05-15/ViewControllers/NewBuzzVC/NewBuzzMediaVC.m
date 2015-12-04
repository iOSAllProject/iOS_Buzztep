//
//  NewBuzzMediaVC.m
//  When_WhereVC
//
//  Created by Sanchit Thakur on 20/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "NewBuzzMediaVC.h"
#import "NewBuzzPrivacyVC.h"
#import "BuzzProfileVC.h"
#import "BuzzWhoVC.h"
#import "ProjectHandler.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "DropboxSDK/DropboxSDK.h"
#import "DropboxIntegrationVC.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "Constant.h"
#import "AppDelegate.h"
#import "Global.h"
#import "UIImage+Resize.h"

#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPRequestOperation.h"
#import "AFURLSessionManager.h"
#import "MBProgressHUD.h"
#import "BTFileModel.h"

@interface NewBuzzMediaVC ()<UINavigationControllerDelegate,
                            UIActionSheetDelegate,
                            UIImagePickerControllerDelegate,
                            DBRestClientDelegate>
{
    BOOL    editFlag;
}

@property (weak, nonatomic) IBOutlet UIButton *dropboxProperty;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) UIImage *saveImage;
@property (nonatomic)  DBRestClient *restClient;
@property (weak, nonatomic) IBOutlet UILabel *photosAddedLabel;

@property (strong, nonatomic) IBOutlet  UIScrollView*  imageScrollView;
@property (nonatomic, strong) NSMutableArray *chosenImages;
@property (nonatomic, strong) ALAssetsLibrary *specialLibrary;

- (IBAction)nextVC:(id)sender;
- (IBAction)closeButton:(id)sender;
- (IBAction)editButton:(id)sender;

- (IBAction)backDownButton:(id)sender;
- (IBAction)takeAPhotoAction:(id)sender;
- (IBAction)useCameraRoolAction:(id)sender;
- (IBAction)dropboxAction:(id)sender;


@end

@implementation NewBuzzMediaVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view from its nib.
    
     [[NSNotificationCenter defaultCenter] addObserver:self
                                              selector:@selector(dropboxLoginDone)
                                                  name:@"OPEN_DROPBOX_VIEW"
                                                object:nil];
    
    
    UISwipeGestureRecognizer *swipeRightGesture =
                    [[UISwipeGestureRecognizer alloc]initWithTarget:self
                                                             action:@selector(handleSwipeGesture1)];
    
    [self.view addGestureRecognizer:swipeRightGesture];
    
    swipeRightGesture.direction=UISwipeGestureRecognizerDirectionRight;
    
    self.chosenImages = [[NSMutableArray alloc] init];
    
    editFlag = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

-(void)dropboxLoginDone
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:@"User logged in successfully."
                                                   delegate:self
                                          cancelButtonTitle:nil
                                          otherButtonTitles:@"Ok", nil];
    
    [alert show];
}


#pragma mark - UIAlertView Delegate Method

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    if (buttonIndex == 0)
//    {
//        //[self performSegueWithIdentifier:viewName sender:self];
//    }
}


-(void)handleSwipeGesture1
{
    [self.navigationController popViewControllerAnimated:YES];
   // NSLog(@"swipe left");
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)nextVC:(id)sender
{
    // File Uploading
    
    editFlag = NO;
    
    [self reloadScrollView];
    
    [AppDelegate SharedDelegate].gBuzzImageArray = [[NSMutableArray alloc] init];
    
    __block NSInteger uploadedImageCount = 0;
    __block NSString* imageUploadPath = Nil;
    NSString* uploadKey = Nil;
    
    if ([AppDelegate SharedDelegate].gBuzzType == Global_BuzzType_Adventure)
    {
        uploadKey = @"adventures";
    }
    else if ([AppDelegate SharedDelegate].gBuzzType == Global_BuzzType_Milestone)
    {
        uploadKey = @"milestones";
    }
    else if ([AppDelegate SharedDelegate].gBuzzType == Global_BuzzType_Event)
    {
        uploadKey = @"events";
    }
    
    imageUploadPath = [NSString stringWithFormat:@"%@/media/%@/upload", BASEURL, uploadKey];
    
    if ([self.chosenImages count])
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        for (__block int i = 0 ; i < [self.chosenImages count] ; i ++ )
        {
            NSData* imageData = UIImageJPEGRepresentation((UIImage*)[self.chosenImages objectAtIndex:i], 0.1);
            
            // According to buzz type, we will change the upload path here
            
            __block NSString* fileName = Nil;
            
            fileName = [[AppDelegate SharedDelegate] randomImageName];
            fileName = [NSString stringWithFormat:@"%@.jpg", fileName];
            
            [manager POST:imageUploadPath parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData)
             {
                 [formData appendPartWithFileData:imageData
                                             name:@"files"
                                         fileName:fileName
                                         mimeType:@"image/jpeg"];
                 
             } success:^(AFHTTPRequestOperation *operation, id responseObject) {
                 
                 //             DLog(@"%dth Image was uploaded", i);
                 
                 NSDictionary* resultDict = Nil;
                 
                 if ([responseObject objectForKeyedSubscript:@"result"])
                 {
                     resultDict = [responseObject objectForKeyedSubscript:@"result"];
                     
                     NSDictionary* filesDict = Nil;
                     
                     if ([resultDict objectForKeyedSubscript:@"files"])
                     {
                         filesDict = [resultDict objectForKeyedSubscript:@"files"];
                         
                         if ([filesDict objectForKeyedSubscript:@"files"])
                         {
                             NSArray* fileArray = [filesDict objectForKeyedSubscript:@"files"];
                             
                             NSDictionary* fileDict = [fileArray firstObject];
                             
                             BTFileModel* file = [[BTFileModel alloc] initFileWithDict:fileDict];
                             
                             [[AppDelegate SharedDelegate].gBuzzImageArray addObject:file];
                         }
                     }
                 }
                 
                 uploadedImageCount = uploadedImageCount + 1;
                 
                 if (uploadedImageCount == [self.chosenImages count]
                     && [[AppDelegate SharedDelegate].gBuzzImageArray count] == uploadedImageCount)
                 {
                     [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                     
                     [self goPrivacySetting];
                 }
                 
                 NSLog(@"Response: %@", responseObject);
                 
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 
                 [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                 
                 NSString* alertStr = [NSString stringWithFormat:@"Failed in image uploading"];
                 
                 [[AppDelegate SharedDelegate] ShowAlert:alertStr messageContent:[error localizedDescription]];
                 
                 NSLog(@"Error: %@", error);
             }];
        }
    }
    else
    {
        [self goPrivacySetting];
    }
}

- (void)goPrivacySetting
{
    NewBuzzPrivacyVC *buzzPrivacy = [self.storyboard instantiateViewControllerWithIdentifier:@"newbuzzprivacy"];
    
    [self.navigationController pushViewController:buzzPrivacy animated:YES];
}

- (IBAction)closeButton:(id)sender
{
    BuzzProfileVC *buzzProfile = [self.storyboard instantiateViewControllerWithIdentifier:@"buzzprofile"];
    
    [self.navigationController pushViewController:buzzProfile animated:YES];
}

- (IBAction)backDownButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)takeAPhotoAction:(id)sender
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
            
            [self presentViewController:picker animated:YES completion:nil];
        }
        
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


- (IBAction)useCameraRoolAction:(id)sender
{
    editFlag = NO;
    
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    
    elcPicker.maximumImagesCount = 100; //Set the maximum number of images to select to 100
    elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    elcPicker.onOrder = NO; //For multiple image selection, display and return order of selected images
    elcPicker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie]; //Supports image and movie types
    
    elcPicker.imagePickerDelegate = self;
    
    [self presentViewController:elcPicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *selectedImage = info[UIImagePickerControllerEditedImage];
    
    [self.chosenImages addObject:selectedImage];
    
    [self reloadScrollView];
    
    if (selectedImage != nil)
    {
        NSString *path = [MyPicturesDirPath stringByAppendingPathComponent:@"test.png"];
        NSData *data = UIImagePNGRepresentation(selectedImage);
        [data writeToFile:path atomically:YES];
    }

    [picker dismissViewControllerAnimated:YES completion:NULL];
}

- (IBAction)dropboxAction:(id)sender
{
   // NSLog(@"Drop box action");
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    DropboxIntegrationVC *dropbox=[storyboard instantiateViewControllerWithIdentifier:@"dropboxintegration"];
    
    [self.navigationController pushViewController:dropbox animated:YES];
    
    if (![[DBSession sharedSession] isLinked])
    {
        [[DBSession sharedSession] linkFromController:self];
    }
    else
    {
        [[[UIAlertView alloc] initWithTitle:@"Account Linked!"
                                    message:@"Your dropbox account is already linked"
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

- (DBRestClient *)restClient
{
    if (_restClient == nil)
    {
        _restClient = [[DBRestClient alloc] initWithSession:[DBSession sharedSession]];
        
        _restClient.delegate = self;
    }
    
    return _restClient;
}

- (void)restClient:(DBRestClient*)client loadedMetadata:(DBMetadata *)metadata
{
    for (int i = 0; i < [metadata.contents count]; i++)
    {
        DBMetadata *data = [metadata.contents objectAtIndex:i];
        
        if (data.isDirectory)
        {
            //Add folder object in  array
        }
        else
        {
            //Add file object in  array
        }
    }
}

- (void)restClient:(DBRestClient *)client loadMetadataFailedWithError:(NSError *)error
{
   // [self.restClient loadFile:filePath intoPath:toPath];

}

- (IBAction)editButton:(id)sender
{
    NSLog(@"Edit Button Clicked");
    
    editFlag = !editFlag;
    
    [self reloadScrollView];
    
}

#pragma mark ELCImagePickerControllerDelegate Methods

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    for (UIView *v in [self.imageScrollView subviews]) {
        [v removeFromSuperview];
    }
    
    CGRect workingFrame = self.imageScrollView.frame;
    workingFrame.origin.x = 0;
    workingFrame.origin.y = 0;
    
    NSMutableArray *images = [NSMutableArray arrayWithCapacity:[info count]];
    for (NSDictionary *dict in info) {
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                
                [self.chosenImages addObject:image];
                
            } else {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        } else if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypeVideo){
            if ([dict objectForKey:UIImagePickerControllerOriginalImage]){
                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                
                [images addObject:image];
                
                UIImageView *imageview = [[UIImageView alloc] initWithImage:image];
                [imageview setContentMode:UIViewContentModeScaleAspectFit];
                imageview.frame = workingFrame;
                
                [self.imageScrollView addSubview:imageview];
                
                workingFrame.origin.x = workingFrame.origin.x + workingFrame.size.width;
            } else {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        } else {
            NSLog(@"Uknown asset type");
        }
    }
    
    [self reloadScrollView];
    
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Utility Function

- (UIView*) badgedImageView:(UIImage* )fillImage
                      index:(NSInteger)imageIndex
                       size:(CGSize)viewSize
                   editMode:(BOOL)editable
{
    UIView* roundedView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, viewSize.width, viewSize.height)];
    
    [roundedView setBackgroundColor:[UIColor clearColor]];
    
    // Add UIImageView
    
    UIImage* roundedImage = Nil;
    
    roundedImage = [fillImage thumbnailImage:viewSize.width
                           transparentBorder:1
                                cornerRadius:(viewSize.width/2)
                        interpolationQuality:kCGInterpolationHigh];
    
    UIImageView *imageview = [[UIImageView alloc] initWithImage:roundedImage];
    
    [imageview setFrame:CGRectMake(0, 0, viewSize.width, viewSize.height)];
    
    [roundedView addSubview:imageview];
    
    // Add UIButton
    
    CGFloat badgeWidth = 29;
    CGFloat badgeHeight = 29;
    
    
    UIButton* removeButton = [[UIButton alloc] initWithFrame:CGRectMake((viewSize.width - badgeWidth), 0, badgeWidth, badgeHeight)];
    
    removeButton.tag = imageIndex;
    
    [removeButton setBackgroundColor:[UIColor clearColor]];
    
    [removeButton setBackgroundImage:[UIImage imageNamed:@"image_delete_r"]
                            forState:UIControlStateNormal];
    
    
    [removeButton addTarget:self
                     action:@selector(removeImageFromArray:)
           forControlEvents:UIControlEventTouchUpInside];
    
    [roundedView addSubview:removeButton];
    
    [removeButton setHidden:!editable];
    
    return roundedView;
}

- (void)removeImageFromArray:(UIButton* )sender
{
    if (sender.tag >= 0)
    {
        [self.chosenImages removeObjectAtIndex:sender.tag];
        
        [self reloadScrollView];
    }
}

- (void) reloadScrollView
{
    CGRect workingFrame = self.imageScrollView.frame;
    workingFrame.origin.x = 0;
    workingFrame.origin.y = 0;
    
    for (UIView * view in self.imageScrollView.subviews)
    {
        [view removeFromSuperview];
    }
    
    for (int i = 0 ; i < [self.chosenImages count] ; i ++)
    {
        UIImage* image = [self.chosenImages objectAtIndex:i];
        
        UIView* roundedView = [self badgedImageView:image
                                              index:i
                                               size:self.imageScrollView.frame.size
                                           editMode:editFlag];
        
        roundedView.frame = workingFrame;
        
        [self.imageScrollView addSubview:roundedView];
        
        workingFrame.origin.x = workingFrame.origin.x + workingFrame.size.width;
    }
    
    _photosAddedLabel.text = [NSString stringWithFormat:@"%ld Photos added", [self.chosenImages count]];
    
    [self.imageScrollView setPagingEnabled:YES];
    [self.imageScrollView setContentSize:CGSizeMake(workingFrame.origin.x, workingFrame.size.height)];
    
}

@end
