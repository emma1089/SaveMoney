//
//  NewWishViewController.h
//  saveMoneyOC
//
//  Created by 浦明晖 on 5/24/16.
//  Copyright © 2016 浦明晖. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "OptionScrollView.h"
#import "DailyCost.h"
#import "NaviView.h"
#import "Keyboard.h"
@interface NewWishViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UITextField *costTextField;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property DailyCost *preWish;
@property (weak, nonatomic) IBOutlet UIImageView *categoryImage;

@property (weak, nonatomic) IBOutlet UIButton *cameraButton;

- (IBAction)cameraButtonClicked:(id)sender;

@property (weak, nonatomic) IBOutlet UIImageView *topImage;

@end
