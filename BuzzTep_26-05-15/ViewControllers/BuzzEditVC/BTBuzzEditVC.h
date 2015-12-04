//
//  BTBuzzEditVC.h
//  BUZZtep
//
//  Created by Lin on 7/8/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ELCImagePickerHeader.h"

#import "BTBuzzItemModel.h"

#import "MLPAutoCompleteTextFieldDelegate.h"

#import "PhotoBox.h"

@class DEMODataSource;
@class MLPAutoCompleteTextField;
@class MGScrollView, MGBox;

@interface BTBuzzEditVC : UIViewController <UITextFieldDelegate, MLPAutoCompleteTextFieldDelegate, ELCImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) BTBuzzItemModel*  buzzitem_model;
@property (strong, nonatomic) IBOutlet DEMODataSource *autocompleteDataSource;
@property (weak) IBOutlet MLPAutoCompleteTextField *autocompleteTextField;

@property (nonatomic, weak) IBOutlet MGScrollView *mediaScroller;

- (MGBox *)photoAddBox;

@end
