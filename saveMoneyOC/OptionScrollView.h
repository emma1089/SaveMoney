//
//  OptionScrollView.h
//  saveMoneyOC
//
//  Created by 浦明晖 on 3/10/16.
//  Copyright © 2016 浦明晖. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalMacros.h"

@class OptionScrollView;
@protocol optionScrollViewDelegate <NSObject>
-(void)didClickOptionImageButton:(NSString *)optionName optionImageNumber:(NSInteger)optionImageNumber;
-(void)didClickAddOptionButton;
-(void)didClickDeleteOptionButton:(UIButton *)button;
@end
@interface OptionScrollView : UIScrollView
@property(strong, nonatomic) NSDictionary *Options;
@property(nonatomic, weak)id<optionScrollViewDelegate> delegate;
-(void)reload;
@end
