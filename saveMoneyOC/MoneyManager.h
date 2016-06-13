//
//  MoneyManager.h
//  saveMoneyOC
//
//  Created by 浦明晖 on 3/16/16.
//  Copyright © 2016 浦明晖. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MoneyManager : NSObject
+(double)getCurrentBudget;
+(double)getCurrentMaxCost;
+(NSMutableDictionary*)countByCategory;
+(NSMutableDictionary*)countByCategory:(NSDate*)date;
+(double)getDailySum:(NSDate*)date;
+(double)getMonthlySum:(NSDate*)date;
+(double)peek:(NSNumber*)price;
@end
