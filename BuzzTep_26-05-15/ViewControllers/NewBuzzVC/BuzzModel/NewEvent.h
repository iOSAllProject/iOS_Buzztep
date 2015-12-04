//
//  NewEvent.h
//  BUZZtep
//
//  Created by Sanchit Thakur on 04/06/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface NewEvent : NSManagedObject

@property (nonatomic, retain) NSString * eventCity;
@property (nonatomic, retain) NSString * eventCountry;
@property (nonatomic, retain) NSString * eventTitle;
@property (nonatomic, retain) NSDate * date;

@end
