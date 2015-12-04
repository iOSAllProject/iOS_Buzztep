//
//  Created by matt on 28/09/12.
//

#import "MGBox.h"
#import "BTMediaModel.h"

@interface PhotoBox : MGBox

@property (strong, nonatomic) BTMediaModel* mediaModel;
@property (strong, nonatomic) UIImageView*  mediaImageView;
@property (strong, nonatomic) UIButton*     btnMediaDelete;

+ (PhotoBox *)photoAddBoxWithSize:(CGSize)size;

+ (PhotoBox *)photoBoxFor:(BTMediaModel* )mediaModel size:(CGSize)size;

- (void)loadPhoto:(BTMediaModel* )mediaObject;
- (void)setMediaImage:(UIImage* )image;

@end
