//
//  ViewController.h
//  saveMoneyOC
//
//  Created by 浦明晖 on 1/8/16.
//  Copyright © 2016 浦明晖. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NaviView.h"
#import "GlobalMacros.h"
#import "SettingViewController.h"
@interface AccountBook : UIViewController <UITableViewDelegate, UITableViewDataSource, UIActionSheetDelegate, NaviviewDelegate, SettingVCDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *accountTableView;

- (IBAction)showPreviousButtonClicked:(UIButton *)sender;

- (IBAction)showNextButtonClicked:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIButton *currentDateButton;

@property (weak, nonatomic) IBOutlet UIButton *showNextButton;
@property (weak, nonatomic) IBOutlet UIButton *addButtonRound;

@property (weak, nonatomic) IBOutlet UILabel *maxCostLabel;

@property (weak, nonatomic) IBOutlet UILabel *alreadyCostLabel;
-(void)setAllText;
@end

