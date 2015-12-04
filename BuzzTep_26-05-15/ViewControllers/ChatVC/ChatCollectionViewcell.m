//
//  CollectionViewcell.m

//  Created by Sanchit Thakur on 23/04/15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.

#import "ChatCollectionViewcell.h"

#import "TextBubbleView.h"
#import "ImageBubbleView.h"
#import "iosMacroDefine.h"



@implementation ChatCollectionViewcell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setFeedData:(PARAM_List *)feed_data
{
    if ([feed_data.chat_media_type isEqualToString:kSTextByme])
    {
        TextBubbleView *textMessageBubble =
        [[TextBubbleView alloc] initWithText:feed_data.chat_message
                                   withColor:GREEN_TEXT_BUBBLE_COLOR
                          withHighlightColor:[UIColor whiteColor]
                           withTailDirection:MessageBubbleViewButtonTailDirectionRight
                                    maxWidth:MAX_BUBBLE_WIDTH];
        
        [textMessageBubble sizeToFit];
        textMessageBubble.frame = CGRectMake(265-textMessageBubble.frame.size.width,0, textMessageBubble.frame.size.width, textMessageBubble.frame.size.height);
        [self.contentView addSubview:textMessageBubble];
        
        
        UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(200, self.frame.size.height-20, 55, 20)];
        timeLabel.text=feed_data.chat_date_time;
        timeLabel.font=[UIFont systemFontOfSize:9];
        timeLabel.textColor=[UIColor blackColor];
        [self.contentView addSubview:timeLabel];
        
        
        //
        //        if ([feed_data.chat_send_status isEqualToString:kSending])
        //        {
        //            UIActivityIndicatorView *myIndicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        //            [myIndicator setFrame:CGRectMake(0,self.frame.size.height-50,20, 20)];
        //            [myIndicator startAnimating];
        //            [self.contentView addSubview:myIndicator];
        //        }
        //        else
        //        {
        //            UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0,self.frame.size.height-50,16, 16)];
        //            if ([feed_data.chat_send_status isEqualToString:kBTChatSent])
        //                [imgView setImage:[UIImage imageNamed:@""]];
        //            else
        //                [imgView setImage:[UIImage imageNamed:@""]];//sentFailed
        //
        //            [self.contentView addSubview:imgView];
        //        }
        //
        
        UIImageView *AvatarView=[[UIImageView alloc]initWithFrame:CGRectMake(265, self.frame.size.height-50, 40, 40)];
        [AvatarView setImage:[UIImage imageNamed:@"Dollar"]];
        
        [self.contentView addSubview:AvatarView];
    }
    else if ([feed_data.chat_media_type isEqualToString:kSTextByOther])
    {
        TextBubbleView *textMessageBubble =
        [[TextBubbleView alloc] initWithText:feed_data.chat_message
                                   withColor:LIGHT_GRAY_TEXT_BUBBLE_COLOR
                          withHighlightColor:[UIColor blackColor]
                           withTailDirection:MessageBubbleViewButtonTailDirectionLeft
                                    maxWidth:MAX_BUBBLE_WIDTH];
        
        [textMessageBubble sizeToFit];
        textMessageBubble.frame = CGRectMake(40,0, textMessageBubble.frame.size.width+50, textMessageBubble.frame.size.height);
        [self.contentView addSubview:textMessageBubble];
        
        UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(50, self.frame.size.height-8, 50, 10)];
        timeLabel.text=feed_data.chat_date_time;
        timeLabel.font=[UIFont systemFontOfSize:9];
        timeLabel.textColor=[UIColor blackColor];
        [self.contentView addSubview:timeLabel];
        
        
        UIImageView *AvatarView=[[UIImageView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-50, 40, 40)];
        
        [AvatarView setImage:[UIImage imageNamed:@"girlPic"]];
        [self.contentView addSubview:AvatarView];
    }
    else if ([feed_data.chat_media_type isEqualToString:kSImagebyme])
    {
        ImageBubbleView *flowerImageBubbleView =
        [[ImageBubbleView alloc] initWithImage:[UIImage imageNamed:@""] withTailDirection:MessageBubbleViewTailDirectionRight atSize:IMAGE_SIZE];
        
        [flowerImageBubbleView sizeToFit];
        flowerImageBubbleView.frame = CGRectMake(170,0, 90, 90);
        
        [self.contentView addSubview:flowerImageBubbleView];
        
        
        UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(0, self.frame.size.height-30, 55, 20)];
        timeLabel.text=feed_data.chat_date_time;
        timeLabel.font=[UIFont systemFontOfSize:9];
        timeLabel.textColor=[UIColor blackColor];
        [self.contentView addSubview:timeLabel];
        
        
        
        if ([feed_data.chat_send_status isEqualToString:kBTChatSending])
        {
            UIActivityIndicatorView *myIndicator=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [myIndicator setFrame:CGRectMake(0,self.frame.size.height-50,20, 20)];
            [myIndicator startAnimating];
            [self.contentView addSubview:myIndicator];
        }
        else
        {
            UIImageView *imgView=[[UIImageView alloc]initWithFrame:CGRectMake(0,self.frame.size.height-50,16, 16)];
            if ([feed_data.chat_send_status isEqualToString:kBTChatSent])
                [imgView setImage:[UIImage imageNamed:@""]];
            else
                [imgView setImage:[UIImage imageNamed:@""]];//sentFailed
            
            [self.contentView addSubview:imgView];
        }
        
        
        
        UIImageView *AvatarView=[[UIImageView alloc]initWithFrame:CGRectMake(265, self.frame.size.height-50, 40, 40)];
        
        [AvatarView setImage:[UIImage imageNamed:@"Dollar"]];
        [self.contentView addSubview:AvatarView];
    }
    else
    {
        ImageBubbleView *flowerImageBubbleView =
        [[ImageBubbleView alloc] initWithImage:[UIImage imageNamed:@"app22"] withTailDirection:MessageBubbleViewTailDirectionLeft atSize:IMAGE_SIZE];
        
        [flowerImageBubbleView sizeToFit];
        flowerImageBubbleView.frame = CGRectMake(40,0, 90, 90);
        
        [self.contentView addSubview:flowerImageBubbleView];
        
        UILabel *timeLabel=[[UILabel alloc]initWithFrame:CGRectMake(260, self.frame.size.height-30, 55, 20)];
        timeLabel.text=feed_data.chat_date_time;
        timeLabel.font=[UIFont systemFontOfSize:9];
        timeLabel.textColor=[UIColor blackColor];
        [self.contentView addSubview:timeLabel];
        
        
        UIImageView *AvatarView=[[UIImageView alloc]initWithFrame:CGRectMake(0, self.frame.size.height-50, 40, 40)];
        
        [AvatarView setImage:[UIImage imageNamed:@"girlPic"]];
        [self.contentView addSubview:AvatarView];
        
    }
    
    
    
}
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    // Initialization code
}


@end
