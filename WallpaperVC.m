//
//  WallpaperVC.m
//  saveMoneyOC
//
//  Created by 浦明晖 on 6/11/16.
//  Copyright © 2016 浦明晖. All rights reserved.
//

#import "WallpaperVC.h"
#import "wallPaperCell.h"
#import "GlobalMacros.h"
@interface WallpaperVC ()
@property NaviView *naviView;
@property NSMutableArray *photoList;
@property NSIndexPath *selectedCellIndexPath;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation WallpaperVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.naviView = [[NaviView alloc]init];
    self.naviView.delegate = self;
    [self.naviView.rightButton removeFromSuperview];
    [self.naviView setTitleLabelName:GET_TEXT(@"ChooseWallpaper")];
    [self.naviView.leftButton setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    self.naviView.leftButton.frame = CGRectMake(self.naviView.leftButton.frame.origin.x+5, self.naviView.leftButton.frame.origin.y, 25, 25);
    [self.view addSubview:self.naviView];
    self.photoList =  @[@"background", @"bg1", @"bg2",
                        @"bg3", @"bg4", @"bg5", @"bg6", @"bg7"].mutableCopy;
    // Do any additional setup after loading the view.
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.photoList.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    wallPaperCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"photoCell"forIndexPath:indexPath];
    cell.wallImage.image = [UIImage imageNamed:self.photoList[indexPath.row]];
    
    cell.isSelected = NO;
    cell.wallImage.clipsToBounds = YES;
    [cell.wallImage.layer setCornerRadius:10];
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"resize working");
    CGSize size = CGSizeMake(SCREEN_WIDTH*0.3, SCREEN_WIDTH*0.3);
    return  size;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    wallPaperCell *cell = (wallPaperCell*)[collectionView cellForItemAtIndexPath:indexPath];
    
    if(!cell.isSelected) {
        [cell.checkButton setBackgroundImage:[UIImage imageNamed:@"tickGreen"] forState:normal];
        cell.isSelected = YES;
        wallPaperCell *previousCell = (wallPaperCell*)[collectionView cellForItemAtIndexPath:self.selectedCellIndexPath];
        [previousCell.checkButton  setBackgroundImage:[UIImage imageNamed:@"tickBlack"] forState:normal];
        previousCell.selected = NO;
        self.selectedCellIndexPath = indexPath;
    } else {
        [cell.checkButton setBackgroundImage:[UIImage imageNamed:@"tickBlack"] forState:normal];
        cell.isSelected = NO;
        self.selectedCellIndexPath = nil;
    }

}
-(void)didClickLeftButton {
    wallPaperCell *cell = (wallPaperCell*)[_collectionView cellForItemAtIndexPath:self.selectedCellIndexPath];
    [self.delegate didSelectWallPaperSuccess:cell.wallImage.image];
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
