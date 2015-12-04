//
//  BTFileModel.m
//  BUZZtep
//
//  Created by Lin on 6/27/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "BTFileModel.h"
#import "Constant.h"
#import "Global.h"

@implementation BTFileModel

@synthesize file_container;
@synthesize file_name;
@synthesize file_size;
@synthesize file_type;

- (id)initFileWithDict:(NSDictionary* )model
{
    self = [super init];
    
    if (self)
    {
        @try {
            
            self.file_container = @"";
            self.file_name = @"";
            self.file_size = 0;
            self.file_type = @"";
            
            if ([model objectForKeyedSubscript:@"container"])
            {
                self.file_container = [model objectForKeyedSubscript:@"container"];
            }
            
            if ([model objectForKeyedSubscript:@"name"])
            {
                self.file_name = [model objectForKeyedSubscript:@"name"];
            }
            
            if ([model objectForKeyedSubscript:@"type"])
            {
                self.file_type = [model objectForKeyedSubscript:@"type"];
            }            
        }
        @catch (NSException *exception) {
            
            DLog(@"%@",[exception description]);
            DLog(@"%@",[exception callStackSymbols]);
            
        }
        @finally {
            
        }
    }
    
    return self;
}

@end
