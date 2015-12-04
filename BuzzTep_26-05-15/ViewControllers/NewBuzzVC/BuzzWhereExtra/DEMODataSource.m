//
//  DEMODataSource.m
//  MLPAutoCompleteDemo
//
//  Created by Eddy Borja on 5/28/14.
//  Copyright (c) 2014 Mainloop. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "DEMODataSource.h"
#import "DEMOCustomAutoCompleteObject.h"

@interface DEMODataSource ()

@property (strong, nonatomic) NSArray *countryObjects;

@end


@implementation DEMODataSource
@synthesize allCountries;

#pragma mark - MLPAutoCompleteTextField DataSource


//example of asynchronous fetch:
- (void)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
 possibleCompletionsForString:(NSString *)string
            completionHandler:(void (^)(NSArray *))handler
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_async(queue, ^{
        if(self.simulateLatency){
            CGFloat seconds = arc4random_uniform(4)+arc4random_uniform(4); //normal distribution
            NSLog(@"sleeping fetch of completions for %f", seconds);
            sleep(seconds);
        }
        
        NSArray *completions;
        
        if(self.testWithAutoCompleteObjectsInsteadOfStrings)
        {
            completions = [self allCountryObjects];
        }
        else
        {
            completions = self.allCountries;
        }
        
        handler(completions);
    });
}

/*
 - (NSArray *)autoCompleteTextField:(MLPAutoCompleteTextField *)textField
 possibleCompletionsForString:(NSString *)string
 {
 
 if(self.simulateLatency){
 CGFloat seconds = arc4random_uniform(4)+arc4random_uniform(4); //normal distribution
 NSLog(@"sleeping fetch of completions for %f", seconds);
 sleep(seconds);
 }
 
 NSArray *completions;
 if(self.testWithAutoCompleteObjectsInsteadOfStrings){
 completions = [self allCountryObjects];
 } else {
 completions = [self allCountries];
 }
 
 return completions;
 }
 */

- (NSArray *)allCountryObjects
{
    if(!self.countryObjects){
        
        NSArray *countryNames = self.allCountries;
        
        NSMutableArray *mutableCountries = [NSMutableArray new];
        
        for(NSString *countryName in countryNames)
        {
            DEMOCustomAutoCompleteObject *country = [[DEMOCustomAutoCompleteObject alloc] initWithCountry:countryName];
            
            [mutableCountries addObject:country];
        }
        
        [self setCountryObjects:[NSArray arrayWithArray:mutableCountries]];
    }
    
    return self.countryObjects;
}

@end
