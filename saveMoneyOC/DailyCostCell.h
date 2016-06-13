//
//  DailyCostCell.h
//  saveMoneyOC
//
//  Created by 浦明晖 on 2/28/16.
//  Copyright © 2016 浦明晖. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DailyCostCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *purposeLabel;
@property (weak, nonatomic) IBOutlet UILabel *amountLabel;
@property (weak, nonatomic) IBOutlet UILabel *indicationLabel;

@property (weak, nonatomic) IBOutlet UILabel *memoLabel;

@property (weak, nonatomic) IBOutlet UIImageView *purposeImageView;
@property (weak, nonatomic) IBOutlet UIImageView *pictureImageView;
@property (weak, nonatomic) IBOutlet UILabel *overspendLabel;
@property (weak, nonatomic) IBOutlet UIView *bar1;
@property (weak, nonatomic) IBOutlet UIView *bar2;
@end
