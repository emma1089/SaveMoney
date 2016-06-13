//
//  NaviView.m
//  saveMoneyOC
//
//  Created by 浦明晖 on 5/27/16.
//  Copyright © 2016 浦明晖. All rights reserved.
//

#import "NaviView.h"
#import "FlexibleButton.h"
@implementation NaviView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if(self) {
        [self setBackgroundColor:MAIN_COLOR];
        [self setFrame:CGRectMake(0,0,SCREEN_WIDTH,SCREEN_HEIGHT*0.12)];
        //Add left button
        self.leftButton = [[FlexibleButton alloc]initWithFrame:CGRectMake(0, 0, 100, SCREEN_HEIGHT/25)];
        [_leftButton setBackgroundColor:[UIColor clearColor]];
        [_leftButton setCenter:CGPointMake(60, self.frame.size.height / 2 + 10)];
        _leftButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [_leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_leftButton addTarget:self action:@selector(leftButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_leftButton];
        //Add title label
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 20)];
        [_titleLabel setCenter:CGPointMake(SCREEN_WIDTH/2, self.frame.size.height/2 + 10)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [_titleLabel setTextColor:[UIColor whiteColor]];
        if(SCREEN_WIDTH <= 320.0) {
            [_titleLabel setFont: [_titleLabel.font fontWithSize:20]];
            [_leftButton.titleLabel setFont: [_leftButton.titleLabel.font fontWithSize:16]];
            self.rightButton = [[FlexibleButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
        } else {
            [_titleLabel setFont: [_titleLabel.font fontWithSize:20]];
            [_leftButton.titleLabel setFont: [_leftButton.titleLabel.font fontWithSize:18]];
            self.rightButton = [[FlexibleButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
        }
        
        
        [self addSubview:_titleLabel];
        //Add right button

        [_rightButton setBackgroundColor:[UIColor clearColor]];
        [_rightButton.titleLabel setFont: [_rightButton.titleLabel.font fontWithSize:15]];
        [_rightButton setCenter:CGPointMake(SCREEN_WIDTH - 30, self.frame.size.height / 2 + 10)];
        [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightButton addTarget:self action:@selector(rightButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_rightButton setBackgroundImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
        [_rightButton setBackgroundColor:[UIColor clearColor]];
        [self addSubview:_rightButton];
        
    }
    return self;
}
-(void)leftButtonClicked {
    [self.delegate didClickLeftButton];
}
-(void)rightButtonClicked {
    [self.delegate didClickRightButton];
}
-(void)setTitleLabelName:(NSString *)name {
    [self.titleLabel setText:name];
}
-(void)setLeftButtonName:(NSString *)name {
    [self.leftButton setTitle:name forState:UIControlStateNormal];
}
@end
