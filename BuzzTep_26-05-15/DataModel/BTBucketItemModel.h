//
//  BTBucketItemModel.h
//  BUZZtep
//
//  Created by Mac on 6/29/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import <Foundation/Foundation.h>
/*
 {
 "title": "",
 "location": "",
 "companyName": "",
 "createdOn": "",
 "id": "objectid",
 "personId": "objectid"
 }
 */
@interface BTBucketItemModel : NSObject
@property (nonatomic, strong) NSString* bucketitem_Id;
@property (nonatomic, strong) NSString* bucketitem_localtion;
@property (nonatomic, strong) NSString* bucketitem_companyName;
@property (nonatomic, strong) NSString* bucketitem_createdOn;
@property (nonatomic, strong) NSString* bucketitem_personId;
@property (nonatomic, strong) NSString* bucketitem_title;
- (id)initBucketItemWithDict:(NSDictionary *)model;
@end
