//
//  BTBuzzEditVC.m
//  BUZZtep
//
//  Created by Lin on 7/8/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "BTBuzzEditVC.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import <QuartzCore/QuartzCore.h>

#import "AppDelegate.h"
#import "Global.h"
#import "Constant.h"
#import "BTAPIClient.h"

#import "BTCountryCityModel.h"
#import "BTMediaModel.h"
#import "BTFileModel.h"

#import "AIDatePickerController.h"
#import "PickerView.h"
#import "MBProgressHUD.h"

#import "MLPAutoCompleteTextField.h"
#import "DEMOCustomAutoCompleteCell.h"
#import "DEMOCustomAutoCompleteObject.h"
#import "DEMODataSource.h"

#import "MGScrollView.h"
#import "PhotoBox.h"

#import "UIImageView+WebCache.h"
#import "UIImage+Resize.h"

#import "AFHTTPRequestOperationManager.h"
#import "AFHTTPRequestOperation.h"
#import "AFURLSessionManager.h"

#import "UIActionSheet+Blocks.h"

#define TOTAL_IMAGES           28
#define IPHONE_INITIAL_IMAGES  0

#define HEADER_FONT            [UIFont fontWithName:@"HelveticaNeue" size:18]

@interface BTBuzzEditVC ()

@property (nonatomic, strong) IBOutlet UILabel*     lblEditTitle;

@property (nonatomic, strong) IBOutlet UIButton*    btnCountry;

@property (nonatomic, strong) IBOutlet UILabel*     lblAdventureStart;
@property (nonatomic, strong) IBOutlet UILabel*     lblAdventureEnd;
@property (nonatomic, strong) IBOutlet UIButton*    btnCreatedDate;
@property (nonatomic, strong) IBOutlet UIButton*    btnEndDate;
@property (nonatomic, strong) IBOutlet UIButton*    btnTaggedPeople;

@property (nonatomic, retain) NSMutableArray        *jsonArray;
@property (nonatomic, strong) NSArray               *cityListArray;
@property (nonatomic, strong) NSArray               *cityArray;
@property (nonatomic, strong) NSArray               *countryArray;
@property (nonatomic, strong) NSString              *cityString;
@property (nonatomic, strong) NSString              *countryString;

@property (nonatomic, strong) NSDate*               startDate;
@property (nonatomic, strong) NSDate*               endDate;

@property (nonatomic, strong) NSMutableArray        *addImageArray;

- (IBAction)onClose:(id)sender;
- (IBAction)onSave:(id)sender;
- (IBAction)onCountry:(id)sender;
- (IBAction)onCreatedDate:(id)sender;
- (IBAction)onEndDate:(id)sender;
- (IBAction)onTaggedPeopleList:(id)sender;

- (void)loadCityList;
- (void)loadImagesFromCameraRoll;
- (void)loadImagesFromCamera;

@end

@implementation BTBuzzEditVC
{
     MGBox *photosGrid;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Init Country List Information
    
    self.jsonArray =[[NSMutableArray alloc] init];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"countries" ofType:@"json"];
    
    NSData *jsonData = [NSData dataWithContentsOfFile:filePath];
    
    NSError *error = nil;
    
    NSDictionary* countryDict = Nil;
    
    countryDict = [NSJSONSerialization JSONObjectWithData:jsonData options: NSJSONReadingMutableContainers error: &error];
    
    _jsonArray = [[NSMutableArray alloc] initWithArray: countryDict[@"countries"][@"country"]];
    
    _countryArray = [_jsonArray valueForKey:@"countryName"];
    
    _cityArray=[_jsonArray valueForKey:@"capital"];
    
    _countryString = [_countryArray objectAtIndex:0];
    
    // Init UI
    
    if (self.buzzitem_model)
    {
        if (self.buzzitem_model.buzzitem_BuzzType == Global_BuzzType_Adventure)
        {
            self.lblEditTitle.text = @"EDIT ADVENTURE";
        }
        else if (self.buzzitem_model.buzzitem_BuzzType == Global_BuzzType_Milestone)
        {
            self.lblEditTitle.text = @"EDIT MILESTONE";
        }
        else if (self.buzzitem_model.buzzitem_BuzzType == Global_BuzzType_Event)
        {
            self.lblEditTitle.text = @"EDIT EVENT";
        }
    }
    
    // Set Country Name
    
    if (self.buzzitem_model.buzzitem_BuzzDict != Nil)
    {
        if ([self.buzzitem_model.buzzitem_BuzzDict objectForKeyedSubscript:@"country"])
        {
            _countryString = [self.buzzitem_model.buzzitem_BuzzDict objectForKeyedSubscript:@"country"];
            
            [self.btnCountry setTitle:_countryString forState:UIControlStateNormal];
        }
        else
        {
            [self.btnCountry setTitle:@"COUNTRY" forState:UIControlStateNormal];
        }
        
        if ([self.buzzitem_model.buzzitem_BuzzDict objectForKeyedSubscript:@"city"])
        {
            _cityString = [self.buzzitem_model.buzzitem_BuzzDict objectForKeyedSubscript:@"city"];
            
            self.autocompleteTextField.text = _cityString;
        }
        else
        {
            self.autocompleteTextField.text = @"CITY";
        }
        
        [self cityList:_countryString extraCity:_cityString];
    }
    
    // Set Date
    
    if (self.buzzitem_model.buzzitem_BuzzType == Global_BuzzType_Adventure)
    {
        [self.lblAdventureEnd setHidden:NO];
        [self.lblAdventureStart setHidden:NO];
        [self.btnCreatedDate setHidden:NO];
        [self.btnEndDate setHidden:NO];
        
        if ([self.buzzitem_model.buzzitem_BuzzDict objectForKeyedSubscript:@"startDate"])
        {
            NSString *date = [self.buzzitem_model.buzzitem_BuzzDict objectForKeyedSubscript:@"startDate"];
            
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            
            [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
            [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
            
            NSDate* dateFromString = [formatter dateFromString:date];
            
            self.startDate = dateFromString;
            
            
            [formatter setDateFormat:@"MM/dd/yyyy"];
            
            [formatter setTimeZone:[NSTimeZone localTimeZone]];
            
            NSString *stringFromDate = [formatter stringFromDate:dateFromString];
            
            [self.btnCreatedDate setTitle:stringFromDate forState:UIControlStateNormal];
        }
        
        if ([self.buzzitem_model.buzzitem_BuzzDict objectForKeyedSubscript:@"endDate"])
        {
            NSString *date = [self.buzzitem_model.buzzitem_BuzzDict objectForKeyedSubscript:@"endDate"];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            
            [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
            [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
            
            NSDate* dateFromString = [formatter dateFromString:date];
            
            self.endDate = dateFromString;
            
            [formatter setDateFormat:@"MM/dd/yyyy"];
            
            [formatter setTimeZone:[NSTimeZone localTimeZone]];
            
            NSString *stringFromDate = [formatter stringFromDate:dateFromString];
            
            [self.btnEndDate setTitle:stringFromDate forState:UIControlStateNormal];
        }
    }
    else
    {
        [self.lblAdventureEnd setHidden:YES];
        [self.lblAdventureStart setHidden:YES];
        [self.btnEndDate setHidden:YES];
        
        if (self.buzzitem_model.buzzitem_createdOn)
        {
            NSString *date = self.buzzitem_model.buzzitem_createdOn;
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            
            [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
            [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
            
            NSDate* dateFromString = [formatter dateFromString:date];
            
            [formatter setDateFormat:@"MM/dd/yyyy"];
            
            [formatter setTimeZone:[NSTimeZone localTimeZone]];
            
            NSString *stringFromDate = [formatter stringFromDate:dateFromString];
            
            [self.btnCreatedDate setTitle:stringFromDate forState:UIControlStateNormal];
        }
    }
    
    
    
    //Supported Styles:
    [self.autocompleteTextField setBorderStyle:UITextBorderStyleNone];
    
    //You can use custom TableViewCell classes and nibs in the autocomplete tableview if you wish.
    //This is only supported in iOS 6.0, in iOS 5.0 you can set a custom NIB for the cell
    if ([[[UIDevice currentDevice] systemVersion] compare:@"6.0" options:NSNumericSearch] != NSOrderedAscending) {
        [self.autocompleteTextField registerAutoCompleteCellClass:[DEMOCustomAutoCompleteCell class]
                                           forCellReuseIdentifier:@"CustomCellId"];
    }
    else{
        //Turn off bold effects on iOS 5.0 as they are not supported and will result in an exception
        self.autocompleteTextField.applyBoldEffectToAutoCompleteSuggestions = NO;
        
    }
    
    [self.autocompleteTextField setAutoCompleteTableAppearsAsKeyboardAccessory:NO];
    
    self.autocompleteTextField.autoCompleteTableBackgroundColor = [UIColor blackColor];
    self.autocompleteTextField.autoCompleteTableCellBackgroundColor = [UIColor blackColor];
    self.autocompleteTextField.autoCompleteTableCellTextColor = [UIColor whiteColor];
    
    // Media ScrollView Init
    
    // setup the main scroller (using a grid layout)
    self.mediaScroller.contentLayoutMode = MGLayoutGridStyle;
    self.mediaScroller.bottomPadding = 8;
    
    // iPhone or iPad grid?
    
    CGRect screenRect=[[UIScreen mainScreen] bounds];
    
    CGSize photosGridSize = CGSizeMake(screenRect.size.width, 0);
    
    // the photos grid
    photosGrid = [MGBox boxWithSize:photosGridSize];
    photosGrid.contentLayoutMode = MGLayoutGridStyle;
    [self.mediaScroller.boxes addObject:photosGrid];
    
    // add a blank "add photo" box
    [photosGrid.boxes addObject:self.photoAddBox];
    
    // add photo boxes to the grid
    
    NSInteger mediaCount = [self.buzzitem_model buzzMediaCount];
    
    if (mediaCount > 0)
    {
        NSArray* mediaArray = [self.buzzitem_model.buzzitem_BuzzDict objectForKeyedSubscript:@"media"];
    
        for (int mediaIndex = 0; mediaIndex < mediaCount; mediaIndex++)
        {
            BTMediaModel* mediaModel = [[BTMediaModel alloc] initMediaWithDict:[mediaArray objectAtIndex:mediaIndex]];
            
            [photosGrid.boxes addObject:[self photoBoxFor:mediaModel]];
        }
        
    }
    
    ////////////////
    ////////////////
    
    // grid size
    photosGrid.size = photosGridSize;
    
    // photo sizes
    CGSize size = CGSizeMake(screenRect.size.width / 2, 98.0f);
    
    // apply to each photo
    for (MGBox *photo in photosGrid.boxes) {
        photo.size = size;
        photo.layer.shadowPath
        = [UIBezierPath bezierPathWithRect:photo.bounds].CGPath;
        photo.layer.shadowOpacity = 0;
    }
    
    // relayout the sections
    [self.mediaScroller layoutWithSpeed:0.3 completion:nil];
    
    for (MGBox *photo in photosGrid.boxes)
    {
        photo.layer.shadowOpacity = 1;
    }
    
    self.addImageArray = [[NSMutableArray alloc] init];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Utility Functions
- (NSString* )countryCode:(NSString* )countryName
{
    NSString* retVal = Nil;
    
    for (int i = 0 ; i < [_jsonArray count] ; i ++)
    {
        NSDictionary* countryDict = Nil;
        
        countryDict = [_jsonArray objectAtIndex:i];
        
        if (countryDict != Nil)
        {
            NSString* countryStr = [countryDict valueForKey:@"countryName"];
            
            if ([countryName isEqualToString:countryStr])
            {
                retVal = [countryDict valueForKey:@"countryCode"];
                
                break;
            }
        }
    }
    
    return retVal;
}

- (void)loadCityList
{
    NSString* countryCode = [self countryCode:_countryString];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[AppDelegate SharedDelegate] cityList:countryCode
                                 withBlock:^(NSArray *models, NSError *error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
         
         self.cityListArray = [[NSArray alloc] init];
         
         NSMutableArray* cityList = [[NSMutableArray alloc] init];
         
         for (int i =0 ; i < [models count] ; i ++)
         {
             BTCountryCityModel* cityModel = [models objectAtIndex:i];
             
             [cityList addObject:cityModel.city_name];
         }
         
//         [cityList addObject:self.autocompleteTextField.text];
         
         NSArray* unifiedList = [[NSOrderedSet orderedSetWithArray:cityList] array];
         
         self.cityListArray = [unifiedList sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
             
             NSString *first = (NSString* )a;
             NSString *second = (NSString* )b;
             
             return [first compare:second];
         }];
         
         _cityString = [self.cityListArray firstObject];// self.autocompleteTextField.text;
         
         self.autocompleteDataSource.allCountries = [[NSArray alloc] init];
         
         self.autocompleteDataSource.allCountries = self.cityListArray;
         
         self.autocompleteTextField.text = _cityString;
     }];
}

- (void)cityList:(NSString* )countryName extraCity:(NSString* )cityName
{
    NSString* countryCode = [self countryCode:_countryString];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[AppDelegate SharedDelegate] cityList:countryCode
                                 withBlock:^(NSArray *models, NSError *error)
     {
         [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
         
         NSMutableArray* cityList = [[NSMutableArray alloc] init];
         
         for (int i =0 ; i < [models count] ; i ++)
         {
             BTCountryCityModel* cityModel = [models objectAtIndex:i];
             
             [cityList addObject:cityModel.city_name];
         }
         
         if (cityName)
         {
             [cityList addObject:cityName];
         }
         
         NSArray* unifiedList = [[NSOrderedSet orderedSetWithArray:cityList] array];
         
         self.cityListArray = [unifiedList sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
             
             NSString *first = (NSString* )a;
             NSString *second = (NSString* )b;
             
             return [first compare:second];
         }];
         
         if (cityName)
         {
             _cityString = cityName;
         }
         else
         {
             _cityString = @"CITY";
         }
         
         self.autocompleteDataSource.allCountries = [[NSArray alloc] init];
         
         self.autocompleteDataSource.allCountries = self.cityListArray;
         
         self.autocompleteTextField.text = _cityString;
     }];
}

- (BOOL)enabledEndDate:(NSDate*) newEndDate;
{
    BOOL retVal = YES;
    
    NSDate*     startDate = Nil;
    
    NSString *startDateStr = self.btnCreatedDate.titleLabel.text;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"MM/dd/yyyy"];
    
    startDate = [formatter dateFromString:startDateStr];
    
    if (!([newEndDate compare:startDate] == NSOrderedAscending))
    {
        retVal = YES;
    }
    else
    {
        retVal = NO;
    }
    
    return retVal;
}

- (void)createMetaDataForNewImages
{
    NSString* buzzObjectId = Nil;
    
    if (self.buzzitem_model.buzzitem_BuzzDict)
    {
        if ([self.buzzitem_model.buzzitem_BuzzDict objectForKeyedSubscript:@"id"])
        {
            buzzObjectId = [self.buzzitem_model.buzzitem_BuzzDict objectForKeyedSubscript:@"id"];
            
            for (int i = 0 ; i < [[AppDelegate SharedDelegate].gBuzzImageArray count] ; i ++)
            {
                BTFileModel* fileModel = [[AppDelegate SharedDelegate].gBuzzImageArray objectAtIndex:i];
                
                [self postMetadata:fileModel buzzObjectId:buzzObjectId];
            }
        }
    }
}

- (void)postMetadata:(BTFileModel* )fileModel buzzObjectId:(NSString* )buzzObjectId
{
    NSDictionary* postDict = Nil;
    
    if (self.buzzitem_model.buzzitem_BuzzType == Global_BuzzType_Adventure)
    {
        postDict = @{@"name": @"adventure_metadata",
                     @"type": @"adventure",
                     @"data": @{
                             @"container": fileModel.file_container,
                             @"filename": fileModel.file_name
                             },
                     @"adventureId": buzzObjectId,
                     @"personId": self.buzzitem_model.buzzitem_personId
                     };
    }
    else if (self.buzzitem_model.buzzitem_BuzzType == Global_BuzzType_Milestone)
    {
        postDict = @{@"name": @"milestone_metadata",
                     @"type": @"milestone",
                     @"data": @{
                             @"container": fileModel.file_container,
                             @"filename": fileModel.file_name
                             },
                     @"milestoneId": buzzObjectId,
                     @"personId": self.buzzitem_model.buzzitem_personId
                     };
    }
    else if (self.buzzitem_model.buzzitem_BuzzType == Global_BuzzType_Event)
    {
        postDict = @{@"name": @"event_metadata",
                     @"type": @"event",
                     @"data": @{
                             @"container": fileModel.file_container,
                             @"filename": fileModel.file_name
                             },
                     @"eventId": buzzObjectId,
                     @"personId": self.buzzitem_model.buzzitem_personId
                     };
    }
    
    DLog(@"Dict : %@", postDict);
    
    [[BTAPIClient sharedClient] createMetadata:@"metadata"
                                      withDict:postDict
                                     withBlock:^(NSDictionary *model, NSError *error)
     {
         if (error == Nil)
         {
             DLog(@"%@", model);
             
             BTMediaModel* mediaModel = [[BTMediaModel alloc] initMediaWithDict:model];
             
             [photosGrid.boxes insertObject:[self photoBoxFor:mediaModel] atIndex:1];
             
             [photosGrid layout];
             
             // animate the section and the scroller
             [photosGrid layoutWithSpeed:0.3 completion:nil];
             
             [self.mediaScroller layoutWithSpeed:0.3 completion:nil];
         }
     }];
    
}

- (NSString* )changeServerTimeFromDate:(NSDate* )upatedDate
{
    NSString* newDateStr = Nil;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    
    newDateStr = [formatter stringFromDate:upatedDate];
    
    return newDateStr;
}

- (void)loadImagesFromCameraRoll
{
    // We will show the photo library here
    
    ELCImagePickerController *elcPicker = [[ELCImagePickerController alloc] initImagePicker];
    
    elcPicker.maximumImagesCount = 100; //Set the maximum number of images to select to 100
    elcPicker.returnsOriginalImage = YES; //Only return the fullScreenImage, not the fullResolutionImage
    elcPicker.returnsImage = YES; //Return UIimage if YES. If NO, only return asset location information
    elcPicker.onOrder = NO; //For multiple image selection, display and return order of selected images
    elcPicker.mediaTypes = @[(NSString *)kUTTypeImage, (NSString *)kUTTypeMovie]; //Supports image and movie types
    
    elcPicker.imagePickerDelegate = self;
    
    [self presentViewController:elcPicker animated:YES completion:nil];
}

- (void)loadImagesFromCamera
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

#pragma mark - IBActions

- (IBAction)onClose:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"kBTBuzzUpdated"
                                                            object:Nil];
    }];
}

- (IBAction)onSave:(id)sender
{
    NSString* startDateStr = [self changeServerTimeFromDate:self.startDate];
    NSString* endDateStr = [self changeServerTimeFromDate:self.endDate];
    
    NSDictionary* modelDict = Nil;
    
    NSString* modelName = Nil;
    NSString* modelId = [self.buzzitem_model.buzzitem_BuzzDict objectForKeyedSubscript:@"id"];
    
    if (self.buzzitem_model.buzzitem_BuzzType == Global_BuzzType_Adventure)
    {
        modelName = @"adventures";
        
        modelDict = @{@"city" : self.autocompleteTextField.text,
                      @"country" : self.btnCountry.titleLabel.text,
                      @"startDate" : startDateStr,
                      @"endDate" : endDateStr};
    }
    else if (self.buzzitem_model.buzzitem_BuzzType == Global_BuzzType_Milestone)
    {
        modelName = @"milestones";
        
        modelDict = @{@"city" : self.autocompleteTextField.text,
                      @"country" : self.btnCountry.titleLabel.text};
    }
    else if (self.buzzitem_model.buzzitem_BuzzType == Global_BuzzType_Event)
    {
        modelName = @"events";
        
        modelDict = @{@"scheduledDate" : startDateStr};
    }
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    [[BTAPIClient sharedClient] refreshSeverBuzzFor:modelName
                                        withModelID:modelId
                                           withDict:modelDict
                                          withBlock:^(NSDictionary *model, NSError *error)
    {
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        
        if (error == Nil)
        {
            DLog(@"%@", model);
        }
    }];
}

- (IBAction)onCountry:(id)sender
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadCityList)
                                                 name:@"PressedDismiss"
                                               object:Nil];
    
    [PickerView showPickerViewInView:self.view
                         withStrings:_countryArray
                         withOptions:@{backgroundColor: [UIColor whiteColor],
                                       textColor: [UIColor blackColor],
                                       toolbarColor: [UIColor whiteColor],
                                       buttonColor: [UIColor blueColor],
                                       font: [UIFont systemFontOfSize:18],
                                       valueY: @3,
                                       selectedObject:_countryString}
                          completion:^(NSString *selectedString)
     {
         [_btnCountry setTitle:selectedString forState:UIControlStateNormal];
         
         _countryString = selectedString;
     }];
}

- (IBAction)onCreatedDate:(id)sender
{
    if (self.btnCreatedDate.titleLabel.text.length > 0)
    {
        NSString *date = self.btnCreatedDate.titleLabel.text;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        [formatter setDateFormat:@"MM/dd/yyyy"];
        
        NSDate* dateFromString = [formatter dateFromString:date];
        
        AIDatePickerController *datePickerViewController = [AIDatePickerController pickerWithDate:dateFromString selectedBlock:^(NSDate *selectedDate) {
            
            self.startDate = selectedDate;
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            
            [formatter setDateFormat:@"MM/dd/yyyy"];
            
            [formatter setTimeZone:[NSTimeZone localTimeZone]];
            
            NSString *stringFromDate = [formatter stringFromDate:selectedDate];
            
            [self.btnCreatedDate setTitle:stringFromDate forState:UIControlStateNormal];
            
        } cancelBlock:^{
            
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
        
        [self presentViewController:datePickerViewController animated:YES completion:nil];
    }
}

- (IBAction)onEndDate:(id)sender
{
    if (self.btnEndDate.titleLabel.text.length > 0)
    {
        NSString *date = self.btnEndDate.titleLabel.text;
        
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        
        [formatter setDateFormat:@"MM/dd/yyyy"];
        
        NSDate* dateFromString = [formatter dateFromString:date];
        
        AIDatePickerController *datePickerViewController = [AIDatePickerController pickerWithDate:dateFromString selectedBlock:^(NSDate *selectedDate) {
        
            self.endDate = selectedDate;
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
            if ([self enabledEndDate:selectedDate])
            {
                NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                
                [formatter setDateFormat:@"MM/dd/yyyy"];
                
                [formatter setTimeZone:[NSTimeZone localTimeZone]];
                
                NSString *stringFromDate = [formatter stringFromDate:selectedDate];
                
                [self.btnEndDate setTitle:stringFromDate forState:UIControlStateNormal];
            }
            else
            {
                [[AppDelegate SharedDelegate] ShowAlert:ApplicationTile
                                         messageContent:@"Please choose later date for end date"];
            }
            
        } cancelBlock:^{
            
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }];
        
        [self presentViewController:datePickerViewController animated:YES completion:nil];
    }
}

- (IBAction)onTaggedPeopleList:(id)sender
{
    
}

#pragma mark - Photo Box factories

- (CGSize)photoBoxSize
{
    // what size plz?
    CGRect screenRect=[[UIScreen mainScreen] bounds];
    
    return CGSizeMake(screenRect.size.width / 2, 98.0f);
}

- (MGBox *)photoBoxFor:(BTMediaModel* )mediaModel
{
    // make the photo box
    __block PhotoBox *box = [PhotoBox photoBoxFor:mediaModel size:[self photoBoxSize]];
    
    [box addSubview:box.btnMediaDelete];
    
    // remove the box when tapped
    __block id bbox = box;
    box.onTap = ^{
        
    };
    
    return box;
}

- (MGBox *)photoAddBox {
    
    // make the box
    PhotoBox *box = [PhotoBox photoAddBoxWithSize:[self photoBoxSize]];
    
    // deal with taps
    __block MGBox *bbox = box;
    
    box.onTap = ^{
        
        [UIActionSheet showInView:self.view
                        withTitle:Nil
                cancelButtonTitle:@"Cancel"
           destructiveButtonTitle:Nil
                otherButtonTitles:@[@"Take a new photo", @"Choose from Camera Roll"]
                         tapBlock:^(UIActionSheet *actionSheet, NSInteger buttonIndex)
        {
            NSLog(@"Tapped '%@' at index %ld", [actionSheet buttonTitleAtIndex:buttonIndex], (long)buttonIndex);
            
            if (buttonIndex == 0)
            {
                [self loadImagesFromCamera];
            }
            else if (buttonIndex == 1)
            {
                [self loadImagesFromCameraRoll];
            }
        }];
    };
    
    return box;
}

#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *selectedImage = info[UIImagePickerControllerEditedImage];
    
    // Image Upload
    
    __block NSString* imageUploadPath = Nil;
    
    NSString* uploadKey = Nil;
    
    if (self.buzzitem_model.buzzitem_BuzzType == Global_BuzzType_Adventure)
    {
        uploadKey = @"adventures";
    }
    else if (self.buzzitem_model.buzzitem_BuzzType == Global_BuzzType_Milestone)
    {
        uploadKey = @"milestones";
    }
    else if (self.buzzitem_model.buzzitem_BuzzType == Global_BuzzType_Event)
    {
        uploadKey = @"events";
    }
    
    imageUploadPath = [NSString stringWithFormat:@"%@/media/%@/upload", BASEURL, uploadKey];
    
    [AppDelegate SharedDelegate].gBuzzImageArray = [[NSMutableArray alloc] init];
    
    [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    NSData* imageData = UIImageJPEGRepresentation(selectedImage, 0.1);
    
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
         
         [self createMetaDataForNewImages];
         
         NSLog(@"Response: %@", responseObject);
         
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         
         [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
         
         NSLog(@"Error: %@", error);
     }];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark -
#pragma mark ELCImagePickerControllerDelegate Methods

- (void)elcImagePickerController:(ELCImagePickerController *)picker didFinishPickingMediaWithInfo:(NSArray *)info
{
    [self dismissViewControllerAnimated:YES completion:nil];
    
    for (NSDictionary *dict in info)
    {
        if ([dict objectForKey:UIImagePickerControllerMediaType] == ALAssetTypePhoto)
        {
            if ([dict objectForKey:UIImagePickerControllerOriginalImage])
            {
                UIImage* image=[dict objectForKey:UIImagePickerControllerOriginalImage];
                
                [self.addImageArray addObject:image];
            }
            else
            {
                NSLog(@"UIImagePickerControllerReferenceURL = %@", dict);
            }
        }
    }
    
    // Image Upload
    
    __block NSInteger uploadedImageCount = 0;
    __block NSString* imageUploadPath = Nil;
    NSString* uploadKey = Nil;
    
    if (self.buzzitem_model.buzzitem_BuzzType == Global_BuzzType_Adventure)
    {
        uploadKey = @"adventures";
    }
    else if (self.buzzitem_model.buzzitem_BuzzType == Global_BuzzType_Milestone)
    {
        uploadKey = @"milestones";
    }
    else if (self.buzzitem_model.buzzitem_BuzzType == Global_BuzzType_Event)
    {
        uploadKey = @"events";
    }
    
    imageUploadPath = [NSString stringWithFormat:@"%@/media/%@/upload", BASEURL, uploadKey];
    
    if ([self.addImageArray count])
    {
        [AppDelegate SharedDelegate].gBuzzImageArray = [[NSMutableArray alloc] init];
        
        [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        
        AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
        
        for (int i = 0 ; i < [self.addImageArray count] ; i ++)
        {
            NSData* imageData = UIImageJPEGRepresentation((UIImage*)[self.addImageArray objectAtIndex:i], 0.1);
            
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
                 
                 if (uploadedImageCount == [self.addImageArray count]
                     && [[AppDelegate SharedDelegate].gBuzzImageArray count] == uploadedImageCount)
                 {
                     [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                     
                     self.addImageArray = [[NSMutableArray alloc] init];
                     
                     [self createMetaDataForNewImages];
                 }
                 
                 NSLog(@"Response: %@", responseObject);
                 
             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                 
                 [MBProgressHUD hideAllHUDsForView:self.view animated:NO];
                 
                 NSLog(@"Error: %@", error);
             }];
        }
    }
}

- (void)elcImagePickerControllerDidCancel:(ELCImagePickerController *)picker
{   
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
