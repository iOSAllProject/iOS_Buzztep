//
//  DropboxIntegrationVC.m
//  MYBUZZListScroll
//
//  Created by Sanchit Thakur on 11/05/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "DropboxIntegrationVC.h"
#import <DropboxSDK/DropboxSDK.h>
#import "NewBuzzMediaVC.h"
#import <QuartzCore/QuartzCore.h>


@interface DropboxIntegrationVC ()

- (IBAction)backAction:(id)sender;
- (IBAction)drobBoxLogout:(id)sender;
@property (strong, nonatomic) IBOutlet UIButton *uploadButton;
@property (strong, nonatomic) IBOutlet UIButton *downloadButton;
@property (strong, nonatomic) IBOutlet UIButton *createFolderButton;
@property (strong, nonatomic) IBOutlet UIButton *logoutButton;

@end

@implementation DropboxIntegrationVC

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _uploadButton.layer.cornerRadius = 5;
    _downloadButton.layer.cornerRadius = 5;
    _createFolderButton.layer.cornerRadius = 5;
    _logoutButton.layer.cornerRadius = 5;
    
    
    _uploadButton.layer.borderWidth = 1;
    _uploadButton.layer.borderColor = [UIColor orangeColor].CGColor;
    
    _downloadButton.layer.borderWidth = 1;
    _downloadButton.layer.borderColor = [UIColor blueColor].CGColor;
    
    _createFolderButton.layer.borderWidth = 1;
    _createFolderButton.layer.borderColor = [UIColor redColor].CGColor;
    
    _logoutButton.layer.borderWidth = 1;
    _logoutButton.layer.borderColor = [UIColor whiteColor].CGColor;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dropboxLoginDone) name:@"OPEN_DROPBOX_VIEW" object:nil];
}

-(void)dropboxLoginDone
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"User logged in successfully." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    
    [alert show];
}

#pragma mark - UIAlertView Delegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    if (buttonIndex == 0)
//    {
//        [self performSegueWithIdentifier:viewName sender:self];
//    }
}

#pragma mark - Action Methods

-(IBAction)uploadFile:(id)sender
{
    if (![[DBSession sharedSession] isLinked])
    {
        viewName = @"OpenUploadFileView";//segue identifier
        [[DBSession sharedSession] linkFromController:self];
    }

}

-(IBAction)downloadFile:(id)sender
{
    if (![[DBSession sharedSession] isLinked])
    {
        viewName = @"OpenDownloadFileView";//segue identifier
        [[DBSession sharedSession] linkFromController:self];
    }

}

-(IBAction)createFolder:(id)sender
{
    if (![[DBSession sharedSession] isLinked])
    {
        viewName = @"OpenCreateFolderView";//segue identifier
        [[DBSession sharedSession] linkFromController:self];
    }

}

- (IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)drobBoxLogout:(id)sender
{
    NSLog(@"DropBox Log-Out Action");
    
     [[DBSession sharedSession] unlinkAll];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"User logout successfully." delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [alert show];
    
    NewBuzzMediaVC *buzzMedia = [self.storyboard instantiateViewControllerWithIdentifier:@"newbuzzmedia"];
    [self.navigationController pushViewController:buzzMedia animated:YES];
}
@end