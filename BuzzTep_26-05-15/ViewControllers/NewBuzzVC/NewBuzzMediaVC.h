//
//  NewBuzzMediaVC.h
//  When_WhereVC
//
//  Created by Sanchit Thakur on 20/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCImagePickerHeader.h"

@interface NewBuzzMediaVC : UIViewController<ELCImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate>
{
    NSString *viewName;
}
@end
