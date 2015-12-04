//
//  NewMilestoneVC.h
//  BUZZtep
//
//  Created by Sanchit Thakur on 29/05/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface NewMilestoneVC : UIViewController

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end
