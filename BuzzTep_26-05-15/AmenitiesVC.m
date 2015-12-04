//
//  AmenitiesViewController.m
//  Animation
//
//  Created by Oleksandr Sorokolita on 27.03.15.
//  Copyright (c) 2015 ILLUMINZ. All rights reserved.
//

#import "AmenitiesVC.h"
#import "MapVC.h"
#import "HMSegmentedControl.h"

@interface AmenitiesVC () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) HMSegmentedControl *segmentedControl;
@property (strong, nonatomic) NSMutableArray *restaurantsArray;
@property (weak, nonatomic) NSMutableArray *currentDataSource;
@property (weak, nonatomic) IBOutlet UICollectionView *collection;

@end

@implementation AmenitiesVC

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    _segmentedControl = [[HMSegmentedControl alloc] initWithFrame:CGRectMake(0, 0, viewWidth, 55)];
    _segmentedControl.sectionTitles = @[@"RESTAURANTS", @"ATTRACTIONS", @"SHOPPING"];
    _segmentedControl.selectedSegmentIndex = 0;
    _segmentedControl.backgroundColor = [UIColor colorWithRed:33/255.0 green:36/255.0 blue:38/255.0 alpha:1];
    _segmentedControl.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:112/255.0 green:159/255.0 blue:154/255.0 alpha:1]};
    _segmentedControl.selectedTitleTextAttributes = @{NSForegroundColorAttributeName:[UIColor colorWithRed:33/255.0 green:36/255.0 blue:38/255.0 alpha:1]};
    _segmentedControl.selectionIndicatorColor = [UIColor colorWithRed:112/255.0 green:159/255.0 blue:154/255.0 alpha:1];
    _segmentedControl.selectionStyle = HMSegmentedControlSelectionStyleBox;
    _segmentedControl.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationNone;
    _segmentedControl.tag = 3;
    
    [_segmentedControl setIndexChangeBlock:^(NSInteger index) {
        NSLog(@"Selected index %ld", (long)index);
        [_collection reloadData];
    }];
    
    [self.view addSubview:self.segmentedControl];
    
    _restaurantsArray = [[NSMutableArray alloc] initWithObjects:
                      [UIImage imageNamed:@"chinese.png"],
                      [UIImage imageNamed:@"burgers.png"],
                      [UIImage imageNamed:@"mexican.png"],
                      [UIImage imageNamed:@"pizza.png"],
                      [UIImage imageNamed:@"cafe.png"],
                      [UIImage imageNamed:@"fast_food"],
                      [UIImage imageNamed:@"pasta.png"],
                      [UIImage imageNamed:@"ice_cream.png"],
                      [UIImage imageNamed:@"sushi.png"],
                      [UIImage imageNamed:@"seafood.png"],
                      [UIImage imageNamed:@"bbq.png"],
                      [UIImage imageNamed:@"bakery.png"],
                      [UIImage imageNamed:@"other_1.png"],
                      [UIImage imageNamed:@"other_2.png"],
                      [UIImage imageNamed:@"other_1.png"],
                      [UIImage imageNamed:@"other_4.png"],
                      [UIImage imageNamed:@"other_5.png"],
                      [UIImage imageNamed:@"other_6.png"],
                      nil];
    
    _currentDataSource = _restaurantsArray;
}

#pragma mark Collection View Methods

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView
     numberOfItemsInSection:(NSInteger)section
{
    if (self.segmentedControl.selectedSegmentIndex == 0) {
        return [_restaurantsArray count];
    }
    
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    UIImageView *amenitiesImage = (UIImageView *)[cell viewWithTag:100];
    
    amenitiesImage.image = [_restaurantsArray objectAtIndex:indexPath.row];
    
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView
                        layout:(UICollectionViewLayout*)collectionViewLayout
        insetForSectionAtIndex:(NSInteger)section
{
    UIEdgeInsets insets = UIEdgeInsetsMake(80, 30, 0, 30);
    
    return insets;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView
                   layout:(UICollectionViewLayout*)collectionViewLayout
minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 13.0;
}

- (IBAction)pressMapButton:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
