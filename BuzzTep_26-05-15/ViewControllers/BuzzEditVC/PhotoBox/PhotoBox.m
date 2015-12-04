//
//  Created by matt on 28/09/12.
//

#import "PhotoBox.h"
#import "UIImageView+WebCache.h"
#import "UIImage+Resize.h"
#import "MBProgressHUD.h"
#import "BTAPIClient.h"
#import "Constant.h"
#import "Global.h"
#import "UIAlertView+Blocks.h"

@implementation PhotoBox

@synthesize mediaModel;
@synthesize mediaImageView;
@synthesize btnMediaDelete;

#pragma mark - Init

- (void)setup {
    // positioning
    self.topMargin = 0;
    self.leftMargin = 0;
    
    // background
    self.backgroundColor = [UIColor colorWithRed:0.94 green:0.94 blue:0.95 alpha:1];
    
    // shadow
    self.layer.shadowColor = [UIColor colorWithWhite:0.12 alpha:1].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 0.5);
    self.layer.shadowRadius = 1;
    self.layer.shadowOpacity = 1;
    
}

#pragma mark - Factories

+ (PhotoBox *)photoAddBoxWithSize:(CGSize)size {
    // basic box
    PhotoBox *box = [PhotoBox boxWithSize:size];
    
    // style and tag
    box.backgroundColor = [UIColor colorWithRed:(44/255.0f) green:(48/255.0f) blue:(50/255.0f) alpha:1];
    box.tag = -1;
    
    // add the add image
    UIImage *add = [UIImage imageNamed:@"buzzitem_edit_newmedia"];
    
    box.mediaImageView = [[UIImageView alloc] initWithImage:add];
    
    [box addSubview:box.mediaImageView];
    
    box.mediaImageView.center = (CGPoint){box.width / 2, box.height / 2};
    
    box.mediaImageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin
    | UIViewAutoresizingFlexibleRightMargin
    | UIViewAutoresizingFlexibleBottomMargin
    | UIViewAutoresizingFlexibleLeftMargin;
    
    return box;
}

+ (PhotoBox *)photoBoxFor:(BTMediaModel* )mediaObject size:(CGSize)size
{
    __block BTMediaModel* mediaModel = mediaObject;
    
    // box with photo number tag
    PhotoBox *box = [PhotoBox boxWithSize:size];
    
    box.mediaModel = mediaModel;
    
    // add a loading spinner
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc]
                                        initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    spinner.center = CGPointMake(box.width / 2, box.height / 2);
    spinner.autoresizingMask = UIViewAutoresizingFlexibleTopMargin
    | UIViewAutoresizingFlexibleRightMargin
    | UIViewAutoresizingFlexibleBottomMargin
    | UIViewAutoresizingFlexibleLeftMargin;
    spinner.color = UIColor.lightGrayColor;
    [box addSubview:spinner];
    [spinner startAnimating];
    
    // do the photo loading async, because internets
    __block id bbox = box;
    box.asyncLayoutOnce = ^{
        
        [bbox loadPhoto:mediaModel];
        
    };
    
    return box;
}

#pragma mark - Layout

- (void)layout
{
    [super layout];
    
    // speed up shadows
    self.layer.shadowPath = [UIBezierPath bezierPathWithRect:self.bounds].CGPath;
}

#pragma mark - Photo box loading

- (void)loadPhoto:(BTMediaModel* )mediaObject
{
    // photo url
    
    __block NSString* fullPath = [mediaObject mediaDownloadPath];
    
    UIImage* localImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:fullPath];
    
    if (localImage)
    {
        // do UI stuff back in UI land
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // ditch the spinner
            
            [self setMediaImage:localImage];
        });
        
    }
    else
    {
        // fetch the remote photo
        NSURL *url = [NSURL URLWithString:fullPath];
        
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        // do UI stuff back in UI land
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // ditch the spinner
            UIActivityIndicatorView *spinner = self.subviews.lastObject;
            [spinner stopAnimating];
            [spinner removeFromSuperview];
            
            // failed to get the photo?
            if (!data) {
                self.alpha = 0.3;
                return;
            }
            
            // got the photo, so lets show it
            UIImage *image = [UIImage imageWithData:data];
            
            [[SDImageCache sharedImageCache] storeImage:image
                                                 forKey:fullPath
                                                 toDisk:YES];
            
            [self setMediaImage:image];
        });
    }
}

- (void)setMediaImage:(UIImage* )image
{
    UIActivityIndicatorView *spinner = self.subviews.lastObject;
    [spinner stopAnimating];
    [spinner removeFromSuperview];
    
    self.mediaImageView = [[UIImageView alloc] initWithImage:image];
    
    [self addSubview:self.mediaImageView];
    
    self.mediaImageView.size = self.size;
    self.mediaImageView.alpha = 0;
    self.mediaImageView.autoresizingMask = UIViewAutoresizingFlexibleWidth
    | UIViewAutoresizingFlexibleHeight;
    
    // fade the image in
    [UIView animateWithDuration:0.2 animations:^{
        self.mediaImageView.alpha = 1;
    }];
    
    self.btnMediaDelete = [UIButton buttonWithType: UIButtonTypeCustom];
    
    CGRect buttonFrame = CGRectMake(self.size.width - 27, 10, 20, 20);
    
    self.btnMediaDelete.frame = buttonFrame;
    
    [self.btnMediaDelete setBackgroundImage:[UIImage imageNamed:@"buzzitem_delete"]
                                   forState:UIControlStateNormal];
    
    [self.btnMediaDelete addTarget:self
                            action:@selector(onDeleteMedia:)
                  forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:self.btnMediaDelete];
}

- (IBAction)onDeleteMedia:(id)sender
{
    [UIAlertView showWithTitle:ApplicationTile
                       message:@"Are you sure that you want to delete this photo?"
             cancelButtonTitle:@"Cancel"
             otherButtonTitles:@[@"Delete"]
                      tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex)
    {
        if (buttonIndex == [alertView cancelButtonIndex])
        {
            NSLog(@"Cancelled");
        }
        else if ([[alertView buttonTitleAtIndex:buttonIndex] isEqualToString:@"Delete"])
        {
            if (self.mediaModel)
            {
                // Remove Media first
                
                [MBProgressHUD hideAllHUDsForView:[AppDelegate SharedDelegate].window animated:NO];
                [MBProgressHUD showHUDAddedTo:[AppDelegate SharedDelegate].window animated:YES];
                
                [[BTAPIClient sharedClient] deleteMetadta:self.mediaModel.media_Id
                                                withBlock:^(NSDictionary *model, NSError *error)
                 {
                     if (error == Nil)
                     {
                         MGBox *section = (id)self.parentBox;
                         
                         // remove
                         [section.boxes removeObject:self];
                         
                         [section layoutWithSpeed:0.3 completion:nil];
                         
                         //                 [self.superview layoutWithSpeed:0.3 completion:nil];
                     }
                     
                     [MBProgressHUD hideAllHUDsForView:[AppDelegate SharedDelegate].window animated:NO];
                     
                 }];
            }
        }
    }];
}

@end
