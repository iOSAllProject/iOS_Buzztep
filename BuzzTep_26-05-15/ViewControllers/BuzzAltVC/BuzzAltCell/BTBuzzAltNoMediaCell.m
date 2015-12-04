//
//  BTBuzzAltNoMediaCell.m
//  BUZZtep
//
//  Created by Lin on 7/2/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "BTBuzzAltNoMediaCell.h"
#import "Global.h"
#import "Constant.h"
#import "BTMediaModel.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Resize.h"

@implementation BTBuzzAltNoMediaCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initCell:(BTBuzzItemModel* )buzzItemModel
{
    self.buzzItem = buzzItemModel;
    
    self.lblbprofileName.text = @"Emily Stoneburg";
    
    // Title
    
    self.lblbuzzTitle.text = [self.buzzItem.buzzitem_BuzzDict objectForKeyedSubscript:@"title"];
    
    if (self.buzzItem.buzzitem_BuzzType == Global_BuzzType_Adventure)
    {
        self.lblbuzzTitle.textColor = kBTAdventureTitleColor;
    }
    else if (self.buzzItem.buzzitem_BuzzType == Global_BuzzType_Milestone)
    {
        self.lblbuzzTitle.textColor = kBTMilestoneTitleColor;
    }
    else if (self.buzzItem.buzzitem_BuzzType == Global_BuzzType_Event)
    {
        self.lblbuzzTitle.textColor = kBTEventTitleColor;
    }
    
    // Date
    
    NSString *date = self.buzzItem.buzzitem_createdOn;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    
    NSDate* dateFromString = [formatter dateFromString:date];
    
    [formatter setDateFormat:@"dd/MM/yy"];
    
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    
    NSString *stringFromDate = [formatter stringFromDate:dateFromString];
    
    self.lblbuzzTime.text = stringFromDate;
    
    // View Count
    
    if ([self.buzzItem buzzMediaCount] == 0)
    {
        [self.lblviewedCount setHidden:YES];
        [self.imgViewed setHidden:YES];
    }
    else
    {
        if ([self.buzzItem buzzViewCount] == 0)
        {
            [self.lblviewedCount setHidden:YES];
            [self.imgViewed setHidden:YES];
        }
        else
        {
            [self.lblviewedCount setHidden:NO];
            [self.imgViewed setHidden:NO];
            
            self.lblviewedCount.text = [NSString stringWithFormat:@"%d", (int)[self.buzzItem buzzViewCount]];
        }
    }
}

@end
