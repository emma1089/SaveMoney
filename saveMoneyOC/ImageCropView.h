//
//  ImageCropView.h
//  saveMoneyOC
//
//  Created by 浦明晖 on 6/10/16.
//  Copyright © 2016 浦明晖. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NaviView.h"
@protocol ImageCropViewControllerDelegate <NSObject>
- (void)didCropImageSuccess:(UIImage *)croppedImage;
@end

@interface ImageCropView : UIViewController<NaviviewDelegate>
@property (strong, nonatomic) UIImage* cropImage;


@property (nonatomic, weak) id<ImageCropViewControllerDelegate> delegate;
@end
