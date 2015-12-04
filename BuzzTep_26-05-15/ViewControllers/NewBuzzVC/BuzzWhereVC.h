//
//  BuzzWhereVC.h
//  When_WhereVC
//
//  Created by Sanchit Thakur on 20/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "MLPAutoCompleteTextFieldDelegate.h"

@class DEMODataSource;
@class MLPAutoCompleteTextField;

@interface BuzzWhereVC : UIViewController <UITextFieldDelegate, MLPAutoCompleteTextFieldDelegate>

@property (strong, nonatomic) IBOutlet DEMODataSource *autocompleteDataSource;
@property (weak) IBOutlet MLPAutoCompleteTextField *autocompleteTextField;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end
