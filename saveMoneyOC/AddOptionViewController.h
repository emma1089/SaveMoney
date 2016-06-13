//
//  AddOptionViewController.h
//  saveMoneyOC
//
//  Created by 浦明晖 on 3/12/16.
//  Copyright © 2016 浦明晖. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NaviView.h"
#import "GlobalMacros.h"
@interface AddOptionViewController : UIViewController<NaviviewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *optionNameTextField;
@property(strong, nonatomic) NSArray *OptionIcons;
@property (weak, nonatomic) IBOutlet UIScrollView *optionIconView;

@property (weak, nonatomic) IBOutlet UIImageView *selectedOptionIcon;

@end
