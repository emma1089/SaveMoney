//
//  FirstViewController.h
//  saveMoneyOC
//
//  Created by 浦明晖 on 2/28/16.
//  Copyright © 2016 浦明晖. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "BaseViewController.h"
#import "XYPieChart.h"
@interface FirstViewController : BaseViewController<XYPieChartDelegate, XYPieChartDataSource>

@property (weak, nonatomic) IBOutlet XYPieChart *pieChart;

@end
