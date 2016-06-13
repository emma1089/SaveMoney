//
//  DailyCost.h
//  saveMoneyOC
//
//  Created by 浦明晖 on 5/24/16.
//  Copyright © 2016 浦明晖. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface DailyCost : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

+(void)addCostWithPurpose:(NSString *)purpose memo:(NSString *)memo amount:(NSNumber *)amount date:(NSDate *)date isCost:(NSNumber*)isCost picture:(NSData *)picture purposeImageNumber:(NSString *)purposeImageNumber;
+(void)editCost:(NSString *)purpose memo:(NSString *)memo amount:(NSNumber *)amount date:(NSDate *)date isCost:(NSNumber*)isCost picture:(NSData *)picture purposeImageNumber:(NSString *)purposeImageNumber editedCost:(id)editedCost;
+(void)deleteCostWithIdentification:(DailyCost*)deletedCost;
@end

NS_ASSUME_NONNULL_END

#import "DailyCost+CoreDataProperties.h"
