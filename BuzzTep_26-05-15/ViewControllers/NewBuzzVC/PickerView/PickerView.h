//
//  PickerView.h
//  PickerView

//  Created by Sanchit Thakur on 06/05/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const backgroundColor;
extern NSString * const textColor;
extern NSString * const toolbarColor;
extern NSString * const buttonColor;
extern NSString * const font;
extern NSString * const valueY;
extern NSString * const selectedObject;
extern NSString * const toolbarBackgroundImage;
extern NSString * const textAlignment;
extern NSString * const showsSelectionIndicator;

@interface PickerView: UIView

+(void)showPickerViewInView: (UIView *)view
                withStrings: (NSArray *)strings
                withOptions: (NSDictionary *)options
                 completion: (void(^)(NSString *selectedString))completion;

+(void)showPickerViewInView: (UIView *)view
                withObjects: (NSArray *)objects
                withOptions: (NSDictionary *)options
    objectToStringConverter: (NSString *(^)(id object))converter
       completion: (void(^)(id selectedObject))completion;

+(void)dismissWithCompletion: (void(^)(NSString *))completion;

@end
