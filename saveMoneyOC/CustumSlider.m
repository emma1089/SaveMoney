//
//  CustumSlider.m
//  saveMoneyOC
//
//  Created by 浦明晖 on 5/30/16.
//  Copyright © 2016 浦明晖. All rights reserved.
//

#import "CustumSlider.h"

@implementation CustumSlider

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {
    CGRect unadjustedThumbRect = [super thumbRectForBounds:bounds trackRect:rect value:value];
    CGFloat thumbOffSetToApplyOnEachSide = unadjustedThumbRect.size.width / 2.0;
    CGFloat minOffsetToAdd = -thumbOffSetToApplyOnEachSide + 2;
    CGFloat maxOffsetToAdd = thumbOffSetToApplyOnEachSide - 2;
    CGFloat offsetValue = minOffsetToAdd + (maxOffsetToAdd - minOffsetToAdd) * value;
    
    CGPoint origin = unadjustedThumbRect.origin;
    origin.x += offsetValue;
    return CGRectMake(origin.x, origin.y, unadjustedThumbRect.size.width, unadjustedThumbRect.size.height);

}
@end
