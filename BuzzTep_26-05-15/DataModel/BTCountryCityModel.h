//
//  BTCountryCityModel.h
//  BUZZtep
//
//  Created by Lin on 6/23/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTCountryCityModel : NSObject

@property (strong, nonatomic) NSString* country_code;
@property (strong, nonatomic) NSString* subdivision_code;
@property (strong, nonatomic) NSString* gns_fd;
@property (strong, nonatomic) NSString* gns_ufi;
@property (strong, nonatomic) NSString* language_code;
@property (strong, nonatomic) NSString* language_script;
@property (strong, nonatomic) NSString* city_name;
@property (atomic, assign) float        latitude;
@property (atomic, assign) float        longitude;

@end
