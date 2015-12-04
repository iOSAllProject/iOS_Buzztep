//
//  CreateProfile.h
//  MYBUZZListScroll
//
//  Created by Sanchit Thakur on 16/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCImagePickerHeader.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "BTAPIClient.h"
#import "Constant.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
@interface CreateProfile : UIViewController

- (IBAction)takePhotoAction:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *profileButton;
@end
