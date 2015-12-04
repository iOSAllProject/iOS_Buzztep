//
//  ViewController.h
//  BuzzTimeline
//
//  Created by Sanchit Thakur on 27/05/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

#import "BuzzItemLWCell.h"
#import "BuzzItemRWCell.h"



@interface BuzzViewController : UIViewController<BuzzItemCellDelegate>

@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext1;

@end

