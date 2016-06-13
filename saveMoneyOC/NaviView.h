//
//  NaviView.h
//  saveMoneyOC
//
//  Created by 浦明晖 on 5/27/16.
//  Copyright © 2016 浦明晖. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalMacros.h"
@class NaviView;
@protocol NaviviewDelegate <NSObject>
-(void)didClickLeftButton;
-(void)didClickRightButton;
@end
@interface NaviView : UIView
@property UILabel *titleLabel;
@property UIButton *leftButton;
@property UIButton *rightButton;
@property(nonatomic, weak)id<NaviviewDelegate> delegate;
-(void)setLeftButtonName:(NSString*)name;
-(void)setTitleLabelName:(NSString*)name;
@end
