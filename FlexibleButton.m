//
//  FlexibleButton.m
//  saveMoneyOC
//
//  Created by 浦明晖 on 6/12/16.
//  Copyright © 2016 浦明晖. All rights reserved.
//

#import "FlexibleButton.h"

@implementation FlexibleButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    CGRect bounds = self.bounds;
    CGFloat widthDelta = 45.0 - bounds.size.width;
    CGFloat heightDelta = 45.0 - bounds.size.height;
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    return CGRectContainsPoint(bounds, point);
}
@end
