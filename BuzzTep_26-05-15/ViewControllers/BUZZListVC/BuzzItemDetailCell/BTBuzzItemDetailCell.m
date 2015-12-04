//
//  BTBuzzItemDetailCell.m
//  BUZZtep
//
//  Created by Lin on 6/29/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "BTBuzzItemDetailCell.h"
#import "AppDelegate.h"
#import "Global.h"
#import "Constant.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Resize.h"
#import "JTSImageViewController.h"
#import "JTSImageInfo.h"

@implementation BTBuzzItemDetailCell

@synthesize buzzitem_mediModel;

@synthesize buzzitem_descLbl;
@synthesize buzzitem_likeLbl;
@synthesize buzzitem_commentLbl;
@synthesize buzzitem_timeLbl;
@synthesize buzzitem_mediaView;

- (void)awakeFromNib {
    // Initialization code
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)initCellWithBuzzItemModel:(BTMediaModel* )model
{
    self.buzzitem_mediModel = model;
    
    // Setting Buzz Title
    
    if (self.buzzitem_mediModel.media_name)
    {
        self.buzzitem_descLbl.text = self.buzzitem_mediModel.media_name;
    }
    
    // Setting Image
    
    UIImage* img = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[self.buzzitem_mediModel mediaDownloadPath]];
    
    if (img == Nil)
    {
        SDWebImageManager *manager = [SDWebImageManager sharedManager];
        
        [manager downloadImageWithURL:[NSURL URLWithString:[self.buzzitem_mediModel mediaDownloadPath]]
                              options:0
                             progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                 // progression tracking code
                             }
                            completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
                                
                                if (image)
                                {
                                    // do something with image
                                    
                                    self.buzzitem_mediaView.image = image;
                                    
                                    [[SDImageCache sharedImageCache] storeImage:image
                                                                         forKey:[self.buzzitem_mediModel mediaDownloadPath]
                                                                         toDisk:YES];
                                }
                            }];
    }
    else
    {
        self.buzzitem_mediaView.image = img;
    }
    
    // Setting Labels
    
    self.buzzitem_timeLbl.text = @"";
    self.buzzitem_likeLbl.text = @"0 Like";
    self.buzzitem_commentLbl.text = @"0 Comment";
    
    if (self.buzzitem_mediModel.media_statistics != Nil)
    {
        /*
         statistics =             {
         bucketLists = 0;
         comments = 0;
         likes = 0;
         views = 0;
         };
         */
        
        NSInteger commentCount = [[self.buzzitem_mediModel.media_statistics objectForKeyedSubscript:@"comments"] integerValue];
        
        NSInteger likeCount = [[self.buzzitem_mediModel.media_statistics objectForKeyedSubscript:@"likes"] integerValue];
        
        if (commentCount >= 0)
        {
            if (commentCount == 0)
            {
                self.buzzitem_commentLbl.text = @"0 Comment";
            }
            else if (commentCount == 1)
            {
                self.buzzitem_commentLbl.text = @"1 Comment";
            }
            else
            {
                self.buzzitem_commentLbl.text = [NSString stringWithFormat:@"%d Comments", (int)commentCount];
            }
        }
        
        if (likeCount >= 0)
        {
            if (likeCount == 0)
            {
                self.buzzitem_likeLbl.text = @"0 Like";
            }
            else if (likeCount == 1)
            {
                self.buzzitem_likeLbl.text = @"1 Like";
            }
            else
            {
                self.buzzitem_likeLbl.text = [NSString stringWithFormat:@"%d Likes", (int)likeCount];
            }
        }
        
        
        self.buzzitem_timeLbl.text = [[AppDelegate SharedDelegate] ParseBTServerTimeToBuzzDetailTime: self.buzzitem_mediModel.media_createdOn];
    }
}

- (IBAction)onExpandImage:(id)sender
{
    if (self.buzzitem_mediaView.image)
    {
        if (self.delegate
            && [self.delegate respondsToSelector:@selector(expandImage:)])
        {
            [self.delegate expandImage:self.buzzitem_mediaView];
        }
    }
}

#pragma mark - IBActions

- (IBAction)onLike:(id)sender
{
    [[AppDelegate SharedDelegate] ShowAlert:ApplicationTile
                             messageContent:@"You liked this buzz"];
}

- (IBAction)onComment:(id)sender
{
    [[AppDelegate SharedDelegate] ShowAlert:ApplicationTile
                             messageContent:@"You commented on this buzz"];
}

@end
