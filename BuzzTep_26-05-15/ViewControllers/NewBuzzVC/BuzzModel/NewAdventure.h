//
//  NewAdventure.h
//  BUZZtep
//
//  Created by Sanchit Thakur on 04/06/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface NewAdventure : NSManagedObject

@property (nonatomic, retain) NSString * adventureCity;
@property (nonatomic, retain) NSString * adventureCountry;
@property (nonatomic, retain) NSString * adventureTitle;
@property (nonatomic, retain) NSDate * date;

@end
