//
//  MoneyManager.m
//  saveMoneyOC
//
//  Created by 浦明晖 on 3/16/16.
//  Copyright © 2016 浦明晖. All rights reserved.
//

#import "MoneyManager.h"
#import "AppDelegate.h"
#import "DailyCost.h"
#import "TimeManager.h"
@implementation MoneyManager
+(double)getCurrentBudget {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults doubleForKey:@"Budget"];
}
+(NSMutableArray*)getAllDailyCosts {
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"DailyCost" inManagedObjectContext:context];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    NSMutableArray *dailyCosts = [[context executeFetchRequest:request error:nil] mutableCopy];
    return dailyCosts;
}
+(double)getDailySum:(NSDate*)date {
    double total = 0;
    NSMutableArray *dailyCosts = [self getAllDailyCosts];
    for(DailyCost *cost in dailyCosts) {
        if(cost.isCost.boolValue == NO) continue;
        if([[TimeManager getDateString:cost.date] isEqualToString:[TimeManager getDateString:date]]) {
            total = total + [cost.amount doubleValue];
        }
    }
    return total;
}

+(double)getMonthlySum:(NSDate*)date {
    double total = 0;
    NSMutableArray *dailyCosts = [self getAllDailyCosts];
    NSInteger currentMonth = [TimeManager getMonth:date];
    for(DailyCost *cost in dailyCosts) {
        if(cost.isCost.boolValue == NO) continue;
        if([TimeManager getMonth:cost.date] == currentMonth) {
            total += [cost.amount doubleValue];
        }
    }
    return total;
}
+(NSMutableDictionary*)countByCategory {
    NSMutableDictionary *result = [[NSMutableDictionary alloc]init];
    NSDate *dateToday = [NSDate date];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:dateToday];
    NSInteger today = [components day];
    NSMutableArray *dailyCosts = [self getAllDailyCosts];
    for(DailyCost *cost in dailyCosts) {
        if([TimeManager daysBetweenTwoDays:cost.date SecondDate:dateToday] >= today | cost.isCost.boolValue == NO) continue;
        if([result valueForKey:cost.purpose] != nil) {
            double updatedValue = [cost.amount doubleValue] + [[result valueForKey:cost.purpose] doubleValue];
            [result setValue:[NSNumber numberWithDouble:updatedValue] forKey:cost.purpose];
        } else {
            [result setValue:cost.amount forKey:cost.purpose];
        }
    }
    NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending: NO];
    NSArray *sortedValues = [[result allValues]sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortOrder]];
    double otherValue = 0;
    if(sortedValues.count > 5) {
        NSMutableArray *truncatedValues = [[sortedValues subarrayWithRange:NSMakeRange(0, 5)]mutableCopy];
        for(int i = 5; i < sortedValues.count; i++) {
            otherValue += [sortedValues[i] doubleValue];
        }
        sortedValues = truncatedValues;
    }
    NSMutableDictionary *final = [[NSMutableDictionary alloc]init];
    NSMutableArray *temp = [sortedValues mutableCopy];
    for(NSString *key in [result allKeys]) {
        if([temp containsObject:[result objectForKey:key]]) {
            NSInteger index = [temp indexOfObject:[result objectForKey:key]];
            [final setValue:[result objectForKey:key] forKey:key];
            [temp removeObjectAtIndex:index];
        }
    }
    if(otherValue) [final setObject:[NSNumber numberWithDouble:otherValue] forKey:@"Other"];
    return final;
}
+(NSMutableDictionary*)countByCategory:(NSDate*)date {
    NSMutableDictionary *result = [[NSMutableDictionary alloc]init];
    NSMutableArray *dailyCosts = [self getAllDailyCosts];
    
    for(DailyCost *cost in dailyCosts) {
        if([TimeManager getMonth:cost.date] != [TimeManager getMonth:date] | cost.isCost.boolValue == NO) continue;
        if([result valueForKey:cost.purpose] != nil) {
            double updatedValue = [cost.amount doubleValue] + [[result valueForKey:cost.purpose] doubleValue];
            [result setValue:[NSNumber numberWithDouble:updatedValue] forKey:cost.purpose];
        } else {
            [result setValue:cost.amount forKey:cost.purpose];
        }
    }
    NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey:@"self" ascending: NO];
    NSArray *sortedValues = [[result allValues]sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortOrder]];
    double otherValue = 0;
    if(sortedValues.count > 5) {
        NSMutableArray *truncatedValues = [[sortedValues subarrayWithRange:NSMakeRange(0, 5)]mutableCopy];
        for(int i = 5; i < sortedValues.count; i++) {
            otherValue += [sortedValues[i] doubleValue];
        }
        sortedValues = truncatedValues;
    }
    NSMutableDictionary *final = [[NSMutableDictionary alloc]init];
    NSMutableArray *temp = [sortedValues mutableCopy];
    for(NSString *key in [result allKeys]) {
        if([temp containsObject:[result objectForKey:key]]) {
            NSInteger index = [temp indexOfObject:[result objectForKey:key]];
            [final setValue:[result objectForKey:key] forKey:key];
            [temp removeObjectAtIndex:index];
        }
    }
    if(otherValue) [final setObject:[NSNumber numberWithDouble:otherValue] forKey:@"Other"];
    return final;
}

+(double)getCurrentMaxCost{
    double total = 0;
    NSDate *startDate = [TimeManager getPreviousDate:[NSDate date]];
    NSDate *lastDate = [TimeManager getLastDateOfThisMonth:[NSDate date]];
    NSInteger gap = [TimeManager daysBetweenTwoDays:[NSDate date] SecondDate:lastDate] + 2;
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:[TimeManager getPreviousDate:startDate]];
    NSInteger today = [components day];
    while (today > 0) {
        total = total + [self getDailySum:startDate];
        startDate = [TimeManager getPreviousDate:startDate];
        today = today - 1;
    }
    
    return  ([self getCurrentBudget] - total) / gap;
}
+(double)peek:(NSNumber*)price {
    double total = 0;
    NSDate *dateToday = [NSDate date];
    NSDateComponents *components = [[NSCalendar currentCalendar] components:NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear fromDate:dateToday];
    NSInteger today = [components day];
    while (today > 0) {
        total = total + [self getDailySum:dateToday];
        dateToday = [TimeManager getPreviousDate:dateToday];
        today = today - 1;
    }
    return  ([self getCurrentBudget] - total - price.doubleValue) / (30 - today);
}
@end
