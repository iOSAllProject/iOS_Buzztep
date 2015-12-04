//
//  NewMilestone.h
//  BUZZtep
//
//  Created by Sanchit Thakur on 04/06/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NewMilestone : NSManagedObject

@property (nonatomic, retain) NSString * milestoneCity;
@property (nonatomic, retain) NSString * milestoneCountry;
@property (nonatomic, retain) NSDate * date;
@property (nonatomic, retain) NSString * milestoneTitle;

@end
