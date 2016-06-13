//
//  SettingViewController.h
//  saveMoneyOC
//
//  Created by 浦明晖 on 6/4/16.
//  Copyright © 2016 浦明晖. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NaviView.h"
#import "ImageCropView.h"
#import "WallpaperVC.h"
@class SettingViewController;
@protocol SettingVCDelegate <NSObject>
-(void)didChangeLanguage;
@end

@interface SettingViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, NaviviewDelegate, UIImagePickerControllerDelegate, ImageCropViewControllerDelegate, WallPaperVCDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, weak) id<SettingVCDelegate>delegate;
@end
