//
//  BTBuzzAltMediaCell.m
//  BUZZtep
//
//  Created by Lin on 7/2/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "BTBuzzAltMediaCell.h"
#import "Global.h"
#import "Constant.h"
#import "BTMediaModel.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Resize.h"

@implementation BTBuzzAltMediaCell

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
    
    // Setting labels
    
    if ([self.buzzItem buzzBucketListCount])
    {
        self.lblBucketlistCount.text = [NSString stringWithFormat:@"%d Bucket Lists", (int)[self.buzzItem buzzBucketListCount]];
    }
    else
    {
        self.lblBucketlistCount.text = @"0 Bucket List";
    }
    
    if ([self.buzzItem buzzLikeCount])
    {
        self.lblLikeCount.text = [NSString stringWithFormat:@"%d Likes", (int)[self.buzzItem buzzLikeCount]];
    }
    else
    {
        self.lblLikeCount.text = @"0 Like";
    }
    
    if ([self.buzzItem buzzCommentCount])
    {
        self.lblCommentCount.text = [NSString stringWithFormat:@"%d Comments", (int)[self.buzzItem buzzCommentCount]];
    }
    else
    {
        self.lblCommentCount.text = @"0 Comment";
    }
        
    
    // Setting Featured Image
    
    [self.mediaScrollView setPagingEnabled:YES];
    
    if ([self.buzzItem buzzMediaCount] > 0)
    {
        NSArray* mediaArray = [self.buzzItem.buzzitem_BuzzDict objectForKeyedSubscript:@"media"];
        
        // Featured Images
        
        if ([mediaArray count] > 0)
        {
            [self.mediaScrollView setHidden:YES];
            
            BTMediaModel* featuredMedia = [[BTMediaModel alloc] initMediaWithDict:[mediaArray firstObject]];
            
            UIImage* img = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[featuredMedia mediaDownloadPath]];
            
            if (img == Nil)
            {
                SDWebImageManager *manager = [SDWebImageManager sharedManager];
                
                [manager downloadImageWithURL:[NSURL URLWithString:[featuredMedia mediaDownloadPath]]
                                      options:0
                                     progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                         // progression tracking code
                                     }
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                        
                                        if (image)
                                        {
                                            // do something with image
                                            
                                            self.featuredImage.image = image;
                                            
                                            [[SDImageCache sharedImageCache] storeImage:image
                                                                                 forKey:[featuredMedia mediaDownloadPath]
                                                                                 toDisk:YES];
                                        }
                                    }];
            }
            else
            {
                self.featuredImage.image = img;
            }
        }
        
        if ([mediaArray count] > 1)
        {
            [self.mediaScrollView setHidden:NO];
            
            for (UIImageView * mediaview in self.mediaScrollView.subviews)
            {
                [mediaview removeFromSuperview];
            }
            
            CGRect screenRect=[[UIScreen mainScreen] bounds];
            
            __block CGFloat imageViewWidth = screenRect.size.width / 3;
            __block CGFloat imageViewHeight = 63.0f;
            
            __block CGRect workingFrame = CGRectMake(0, 0, imageViewWidth, imageViewHeight);
            workingFrame.origin.x = 0;
            workingFrame.origin.y = 0;
            
            [self.mediaScrollView setContentSize:CGSizeMake((imageViewWidth * [mediaArray count]), imageViewHeight)];
            
            for (int mediaIndex = 0 ; mediaIndex < [mediaArray count] ; mediaIndex ++ )
            {
                BTMediaModel* mediaModel = [[BTMediaModel alloc] initMediaWithDict:[mediaArray objectAtIndex:mediaIndex]];
                
                UIImage* img = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[mediaModel mediaDownloadPath]];
                
                __block UIImageView* mediaView = [[UIImageView alloc] init];
                
                if (img == Nil)
                {
                    SDWebImageManager *manager = [SDWebImageManager sharedManager];
                    
                    [manager downloadImageWithURL:[NSURL URLWithString:[mediaModel mediaDownloadPath]]
                                          options:0
                                         progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                             // progression tracking code
                                         }
                                        completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                            
                                            if (image)
                                            {
                                                // do something with image
                                                
                                                [[SDImageCache sharedImageCache] storeImage:image
                                                                                     forKey:[mediaModel mediaDownloadPath]
                                                                                     toDisk:YES];
                                                
                                                UIImage* thumbImage = Nil;
                                                
                                                thumbImage = [image resizedImage:CGSizeMake(imageViewWidth, imageViewHeight)
                                                            interpolationQuality:kCGInterpolationHigh];
                                                
                                                [mediaView setContentMode:UIViewContentModeScaleAspectFit];
                                                
                                                mediaView.image = thumbImage;
                                                
                                                mediaView.frame = workingFrame;
                                                
                                                [self.mediaScrollView addSubview:mediaView];
                                                
                                                workingFrame.origin.x = workingFrame.origin.x + workingFrame.size.width;
                                            }
                                        }];
                }
                else
                {
                    UIImage* thumbImage = Nil;
                    
                    thumbImage = [img resizedImage:CGSizeMake(imageViewWidth, imageViewHeight)
                              interpolationQuality:kCGInterpolationHigh];
                    
                    [mediaView setContentMode:UIViewContentModeScaleAspectFit];
                    
                    mediaView.image = thumbImage;
                    
                    mediaView.frame = workingFrame;
                    
                    [self.mediaScrollView addSubview:mediaView];
                    
                    workingFrame.origin.x = workingFrame.origin.x + workingFrame.size.width;
                }
            }
        }
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

@end
