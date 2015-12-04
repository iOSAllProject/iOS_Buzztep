//
//  BTFileModel.h
//  BUZZtep
//
//  Created by Lin on 6/27/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTFileModel : NSObject

@property (nonatomic, strong) NSString* file_container;
@property (nonatomic, strong) NSString* file_name;
@property (atomic, assign) long         file_size;
@property (nonatomic, strong) NSString* file_type;

- (id)initFileWithDict:(NSDictionary* )model;

@end
