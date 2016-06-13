//
//  TimeManager.h
//  saveMoneyOC
//
//  Created by 浦明晖 on 3/6/16.
//  Copyright © 2016 浦明晖. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TimeManager : NSObject

+(NSDate*)getPreviousDate:(NSDate*)date;
+(NSDate*)getNextDate:(NSDate*)date;
+(NSString*)getDateString:(NSDate*)date;
+(NSString*)getDateStringWithouYear:(NSDate*)date;
+(NSInteger)daysBetweenTwoDays:(NSDate*)day1 SecondDate:(NSDate*)day2;
+(NSDate*)getLastDateOfPreviousMonth:(NSDate*)date;
+(NSDate*)getLastDateOfNextMonth:(NSDate*)date;
+(NSDate*)getLastDateOfThisMonth:(NSDate *)date;
+(NSInteger)getMonth:(NSDate*)date;
+(NSString*)getMonthStringWithYear:(NSDate*)date;
@end
