//
//  NewCostViewController.h
//  saveMoneyOC
//
//  Created by 浦明晖 on 2/28/16.
//  Copyright © 2016 浦明晖. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "OptionScrollView.h"
#import "DailyCost.h"
@interface NewCostViewController : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIImageView *selectedOptionImageView;
@property (nonatomic,strong) NSManagedObjectContext* managedObjectContext;
@property (weak, nonatomic) IBOutlet UILabel *selectedOptionNameLabel;
@property NSDate *predate;
@property(strong) DailyCost *preCost;

@end
