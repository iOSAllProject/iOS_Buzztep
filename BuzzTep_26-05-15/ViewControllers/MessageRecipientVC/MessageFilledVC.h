//
//  MessageFilledVC.h
//  CocaColaVC
//
//  Created by Sanchit Thakur on 22/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageFilledVC : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *messageInPutView;
@property (weak, nonatomic) IBOutlet UITextField *messageField;

@end
