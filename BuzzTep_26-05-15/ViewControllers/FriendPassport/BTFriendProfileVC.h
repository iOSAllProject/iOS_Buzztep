//
//  BTFriendProfileVC.h
//  BUZZtep
//
//  Created by Lin on 6/4/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface BTFriendProfileVC : UIViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) NSString* friendId;
@end
