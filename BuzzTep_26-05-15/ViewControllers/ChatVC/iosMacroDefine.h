//  iosMacroDefine.h

//  Created by Sanchit Thakur on 23/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.

#pragma mark - Numeric define



#define MARGIN 10.0f
#define IMAGE_SIZE CGSizeMake(100,100)
#define MAX_BUBBLE_WIDTH  200.0
#define TWO_THIRDS_OF_PORTRAIT_WIDTH (UIScreen.mainScreen.bounds.size.width * 0.6666667f)
#define GRAY_TEXT_BUBBLE_COLOR [UIColor colorWithRed:0.866667 green:0.866667 blue:0.866667 alpha:1]
#define LIGHT_GRAY_TEXT_BUBBLE_COLOR [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1]
#define GREEN_TEXT_BUBBLE_COLOR [UIColor colorWithRed:0.439 green:0.624 blue:0.604 alpha:1]
#define LIGHT_GREEN_TEXT_BUBBLE_COLOR [UIColor colorWithHue:130.0f / 360.0f saturation:0.68f brightness:0.80f alpha:1.0f]
#define BLUE_TEXT_HIGHLIGHT_COLOR [UIColor colorWithRed:0.270588 green:0.545098 blue:1.000000 alpha:1]
#define kSTextByme          @"textByme"
#define kSTextByOther       @"textbyother"
#define kSImagebyme         @"ImageByme"
#define kSImagebyOther      @"ImageByother"

#define kStypeImage         @"Image"
#define kStypeText          @"Text"

#define kBTChatSending      @"Sending"
#define kBTChatSent         @"Sent"
#define kFailed             @"Failed"

 
 #ifdef DEBUG
 #   define DLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
 #else
 #   define DLog(...)
 #endif
 
 #if DEBUG
 #define NSLog(FORMAT, ...) fprintf(stderr,"\nfunction:%s line:%d content:%s\n", __FUNCTION__, __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
 #else
 #define NSLog(FORMAT, ...) nil
 #endif


 
 


 

 









