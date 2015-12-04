//
//  BTBuzzItemModel.h
//  BUZZtep
//
//  Created by Lin on 6/12/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTBuzzItemModel : NSObject

@property (atomic, assign) NSInteger        buzzitem_BuzzType;
@property (nonatomic, strong) NSString*     buzzitem_createdOn;
@property (nonatomic, strong) NSString*     buzzitem_personId;
@property (nonatomic, strong) NSDictionary* buzzitem_BuzzDict;

- (id)initBuzzItemWithDict:(NSDictionary* )model
                  withType:(NSInteger )buzzType;

- (NSInteger)buzzMediaCount;
- (NSInteger)buzzViewCount;
- (NSInteger) buzzLikeCount;
- (NSInteger) buzzCommentCount;
- (NSInteger) buzzBucketListCount;

@end
