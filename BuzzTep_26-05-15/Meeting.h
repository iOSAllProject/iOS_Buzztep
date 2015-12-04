//
//  Meeting.h
//  BuzzTepMeetUps
//
//  Created by Sanchit Thakur  on 05/05/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Meeting : NSObject

@property (nonatomic, readonly) NSString *meetName;
@property (nonatomic, readonly) NSString *meetDate;
@property (nonatomic, readonly) NSString *meetAddress;
@property (nonatomic, readonly) NSString *meetFirstUserName;
@property (nonatomic, readonly) NSString *meetSecondUserName;
@property (nonatomic, readonly) NSString *meetThirdUserName;

- (instancetype)initWithData:(NSDictionary *)data;

@end
