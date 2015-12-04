//
//  BuzzItemLWCell.m
//  BUZZtep
//
//  Created by Lin on 6/19/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "BuzzItemLWCell.h"
#import "Global.h"
#import "Constant.h"
#import "BTMediaModel.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Resize.h"

@implementation BuzzItemLWCell

- (void)awakeFromNib {
    // Initialization code
    
    [self.featureView setFrame:CGRectMake(180, 0, 80, 80)];
        
    [self.lockButton setFrame:CGRectMake(90, 0, 80, 80)];
    [self.mediaView setFrame:CGRectMake(90, 0, 80, 80)];
    
    [self.unlockButton setFrame:CGRectMake(0, 0, 80, 80)];
    
    [self.scrollView addSubview:self.featureView];
    [self.scrollView addSubview:self.unlockButton];
    
    [self.scrollView addSubview:self.lockButton];
    
    [self.scrollView addSubview:self.mediaView];
    
    [self.scrollView setContentSize:CGSizeMake(290, 80)];
    [self.scrollView setContentOffset:CGPointMake((290 - self.scrollView.frame.size.width), 0)];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initCell:(BTBuzzItemModel* )buzzItemModel timeLineMode:(NSInteger)timemode
{
    self.buzzItem = buzzItemModel;
    
    [self downloadMedia:self.buzzItem];
    
    if ([self.buzzItem buzzMediaCount])
    {
        self.mediaCountLbl.text = [NSString stringWithFormat:@"%d", (int)[self.buzzItem buzzMediaCount]];
        
        [self.mediaView setHidden:NO];
        [self.lockButton setHidden:YES];
    }
    else
    {
        [self.mediaView setHidden:YES];
        [self.lockButton setHidden:NO];
        
        // Update feature image
        
        if (self.buzzItem.buzzitem_BuzzType == Global_BuzzType_Adventure)
        {
            [self.featureImage setImage:[UIImage imageNamed:@"buzzitem_adventure"]];
        }
        else if (self.buzzItem.buzzitem_BuzzType == Global_BuzzType_Milestone)
        {
            [self.featureImage setImage:[UIImage imageNamed:@"buzzitem_milestone"]];
        }
        else if (self.buzzItem.buzzitem_BuzzType == Global_BuzzType_Event)
        {
            [self.featureImage setImage:[UIImage imageNamed:@"buzzitem_event"]];
        }
    }
    
    [self.wy_dateLbl setHidden:YES];
    [self.wy_dotImage setHidden:YES];
    
    [self.dateLbl setHidden:NO];
    
    if (self.buzzItem.buzzitem_BuzzType == Global_BuzzType_Adventure)
    {
        [self.dotImage setImage:[UIImage imageNamed:@"buzzitem_adventure_circle"]];
        [self.overlayImage setImage:[UIImage imageNamed:@"buzzitem_adventure_media_overlay"]];
    }
    else if (self.buzzItem.buzzitem_BuzzType == Global_BuzzType_Milestone)
    {
        [self.dotImage setImage:[UIImage imageNamed:@"buzzitem_milestone_circle"]];
        [self.overlayImage setImage:[UIImage imageNamed:@"buzzitem_milestone_media_overlay"]];
    }
    else if (self.buzzItem.buzzitem_BuzzType == Global_BuzzType_Event)
    {
        [self.dotImage setImage:[UIImage imageNamed:@"buzzitem_event_circle"]];
        [self.overlayImage setImage:[UIImage imageNamed:@"buzzitem_event_media_overlay"]];
    }
    
    // Title
    
    self.titleLbl.text = [self.buzzItem.buzzitem_BuzzDict objectForKeyedSubscript:@"title"];
    
    if (self.buzzItem.buzzitem_BuzzType == Global_BuzzType_Adventure)
    {
        self.titleLbl.textColor = kBTAdventureTitleColor;
    }
    else if (self.buzzItem.buzzitem_BuzzType == Global_BuzzType_Milestone)
    {
        self.titleLbl.textColor = kBTMilestoneTitleColor;
    }
    else if (self.buzzItem.buzzitem_BuzzType == Global_BuzzType_Event)
    {
        self.titleLbl.textColor = kBTEventTitleColor;
    }
    
    // Date
    
    NSString *date = self.buzzItem.buzzitem_createdOn;
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    
    [formatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    
    NSDate* dateFromString = [formatter dateFromString:date];
    
    if (timemode == 0)
    {
        [formatter setDateFormat:@"EEEE, MMM.dd"];
        
        [self.wy_dateLbl setHidden:YES];
        [self.wy_dotImage setHidden:YES];
        
        [self.dateLbl setHidden:NO];
    }
    else if (timemode == 1)
    {
        [formatter setDateFormat:@"MMMM"];
        
        [self.wy_dateLbl setHidden:NO];
        [self.wy_dotImage setHidden:NO];
        
        [self.dateLbl setHidden:YES];
    }
    else if (timemode == 2)
    {
        [formatter setDateFormat:@"YYYY"];
        
        [self.wy_dateLbl setHidden:NO];
        [self.wy_dotImage setHidden:NO];
        
        [self.dateLbl setHidden:YES];
        
//        if (self.isFirstYear == NO)
//        {
//            [self.wy_dateLbl setHidden:YES];
//            [self.wy_dotImage setHidden:YES];
//        }
    }
    
    [formatter setTimeZone:[NSTimeZone localTimeZone]];
    
    NSString *stringFromDate = [formatter stringFromDate:dateFromString];
    
    self.dateLbl.text = stringFromDate;
    self.wy_dateLbl.text = stringFromDate;
}

- (IBAction)onLockAction:(id)sender
{
    if (self.delegate
        && [self.delegate respondsToSelector:@selector(lockAction:)])
    {
        [self.delegate lockAction:self.buzzItem];
    }
}

- (IBAction)onUnLockAction:(id)sender
{
    if (self.delegate
        && [self.delegate respondsToSelector:@selector(unlockAction:)])
    {
        [self.delegate unlockAction:self.buzzItem];
    }
}

- (IBAction)onMediaDetail:(id)sender
{
    if ([self.buzzItem buzzMediaCount] > 0)
    {
        if (self.delegate
            && [self.delegate respondsToSelector:@selector(showMediaDetail:)])
        {
            [self.delegate showMediaDetail:self.buzzItem];
        }
    }
}

- (IBAction)onBuzzEdit:(id)sender
{
    if ([self.buzzItem buzzMediaCount] == 0)
    {
        if (self.delegate
            && [self.delegate respondsToSelector:@selector(showBuzzEdit:)])
        {
            [self.delegate showBuzzEdit:self.buzzItem];
        }
    }
}

#pragma mark - Utility Function

- (void)downloadMedia:(BTBuzzItemModel* )buzzItem
{
    NSInteger mCount = [buzzItem buzzMediaCount];
    
//    DLog(@"Image Count : %d", (int)mCount);
    
    self.featureImage.image = Nil;
    self.lastImage.image = Nil;
    
    if (mCount)
    {
        NSArray* mediaArray = [buzzItem.buzzitem_BuzzDict objectForKeyedSubscript:@"media"];
        
        for (int i = 0; i < mCount ; i ++)
        {
            NSDictionary* mediaDict = [mediaArray objectAtIndex:i];
            
            BTMediaModel* media = [[BTMediaModel alloc] initMediaWithDict:mediaDict];
            
//            DLog(@"Download Path : %@", [media mediaDownloadPath]);
            
            UIImage* img = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[media mediaDownloadPath]];
            
            if (img == Nil)
            {
                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                
                [manager downloadImageWithURL:[NSURL URLWithString:[media mediaDownloadPath]]
                                      options:0
                                     progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                         // progression tracking code
                                     }
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                        
                                        if (image)
                                        {
                                            // do something with image
                                            
                                            UIImage* roundedImage = Nil;
                                            
                                            roundedImage = [image thumbnailImage:80
                                                               transparentBorder:1
                                                                    cornerRadius:40
                                                            interpolationQuality:kCGInterpolationHigh];
                                            
                                            if (self.featureImage.image == Nil)
                                            {
                                                [self.featureImage setImage:roundedImage];
                                            }
                                            
                                            if (self.lastImage.image == Nil)
                                            {
                                                [self.lastImage setImage:roundedImage];
                                            }
                                            
                                            [[SDImageCache sharedImageCache] storeImage:image
                                                                                 forKey:[media mediaDownloadPath]
                                                                                 toDisk:YES];
                                        }
                                    }];
            }
            else
            {
                UIImage* roundedImage = Nil;
                
                roundedImage = [img thumbnailImage:80
                                   transparentBorder:1
                                        cornerRadius:40
                                interpolationQuality:kCGInterpolationHigh];
                
                if (i == 0)
                {
                    if (self.featureImage.image == Nil)
                    {
                        [self.featureImage setImage:roundedImage];
                    }
                    
                    if (self.lastImage.image == Nil)
                    {
                        [self.lastImage setImage:roundedImage];
                    }
                }
            }
            
            
        }
    }
}

@end
