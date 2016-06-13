//
//  TimeManager.m
//  saveMoneyOC
//
//  Created by 浦明晖 on 3/6/16.
//  Copyright © 2016 浦明晖. All rights reserved.
//

#import "TimeManager.h"
@interface TimeManager ()

@end

@implementation TimeManager
+(NSDate*)getPreviousDate:(NSDate*)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar dateByAddingUnit:NSCalendarUnitDay value:-1 toDate:date options:0];
}
+(NSDate*)getNextDate:(NSDate*)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:date options:0];
}
+(NSString*)getDateString:(NSDate *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]  isEqual: @"en"]) dateFormatter.dateStyle = NSDateIntervalFormatterMediumStyle;
    else [dateFormatter setDateFormat:@"YYYY年MM月dd日"];
    return [dateFormatter stringFromDate:date];
}
+(NSString*)getDateStringWithouYear:(NSDate*)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    NSString *format = [dateFormatter dateFormat];
    format = [format stringByReplacingOccurrencesOfString:@", y" withString:@""];
    [dateFormatter setDateFormat:format];
    return [dateFormatter stringFromDate:date];
}
+(NSString*)getMonthStringWithYear:(NSDate*)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"appLanguage"]  isEqual: @"en"]) {
        [dateFormatter setDateStyle:NSDateFormatterMediumStyle];
        NSString *format = [dateFormatter dateFormat];
        format = [format stringByReplacingOccurrencesOfString:@"d," withString:@""];
        [dateFormatter setDateFormat:format];
    } else {
        [dateFormatter setDateFormat:@"YYYY年MM月"];
    }
    return [dateFormatter stringFromDate:date];
}
+(NSInteger)daysBetweenTwoDays:(NSDate*)day1 SecondDate:(NSDate*)day2 {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:day1 toDate:day2 options:0];
    return components.day;
}
+(NSDate*)getLastDateOfPreviousMonth:(NSDate*)date {
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    [comps setDay:0];
    NSDate *lastDateOfPreviousMonth = [[NSCalendar currentCalendar] dateFromComponents:comps];
    return lastDateOfPreviousMonth;
}
+(NSDate*)getLastDateOfNextMonth:(NSDate*)date {
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    [comps setMonth:[comps month] + 2];
    [comps setDay:0];
    NSDate *lastDateOfNextMonth = [[NSCalendar currentCalendar] dateFromComponents:comps];
    return lastDateOfNextMonth;
}
+(NSDate*)getLastDateOfThisMonth:(NSDate *)date {
    NSDateComponents *comps = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    [comps setMonth:[comps month] + 1];
    [comps setDay:0];
    NSDate *lastDateOfNextMonth = [[NSCalendar currentCalendar] dateFromComponents:comps];
    return lastDateOfNextMonth;
}
+(NSInteger)getMonth:(NSDate*)date {
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:date];
    return [components month];
}

@end
