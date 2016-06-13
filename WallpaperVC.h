//
//  WallpaperVC.h
//  saveMoneyOC
//
//  Created by 浦明晖 on 6/11/16.
//  Copyright © 2016 浦明晖. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NaviView.h"
@protocol WallPaperVCDelegate <NSObject>
- (void)didSelectWallPaperSuccess:(UIImage *)selectedWallPaperImage;
@end
@interface WallpaperVC : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate, NaviviewDelegate>
@property id<WallPaperVCDelegate> delegate;
@property UIImage *selectedPic;
@end
