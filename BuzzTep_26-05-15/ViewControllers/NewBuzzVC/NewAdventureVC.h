//
//  NewAdventureVC.h
//  When_WhereVC
//
//  Created by Sanchit Thakur on 20/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface NewAdventureVC : UIViewController<NSFetchedResultsControllerDelegate>

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;

@property (nonatomic, retain) NSFetchedResultsController *fetchedResultsController;

@end
