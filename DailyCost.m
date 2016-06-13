//
//  DailyCost.m
//  saveMoneyOC
//
//  Created by 浦明晖 on 5/24/16.
//  Copyright © 2016 浦明晖. All rights reserved.
//

#import "DailyCost.h"
#import "AppDelegate.h"
@implementation DailyCost

// Insert code here to add functionality to your managed object subclass
+(void)addCostWithPurpose:(NSString *)purpose memo:(NSString *)memo amount:(NSNumber *)amount date:(NSDate *)date isCost:(NSNumber*)isCost picture:(NSData *)picture purposeImageNumber:(NSString *)purposeImageNumber {
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    DailyCost *dailyCost = (DailyCost*)[NSEntityDescription insertNewObjectForEntityForName:@"DailyCost" inManagedObjectContext:context];
    dailyCost.purpose = purpose;
    dailyCost.amount = amount;
    dailyCost.date = date;
    dailyCost.memo = memo;
    dailyCost.purposeImageNumber = purposeImageNumber;
    dailyCost.picture = picture;
    dailyCost.isCost = isCost;
    [context save:nil];
}
+(void)editCost:(NSString *)purpose memo:(NSString *)memo amount:(NSNumber *)amount date:(NSDate *)date isCost:(NSNumber*)isCost picture:(NSData *)picture purposeImageNumber:(NSString *)purposeImageNumber editedCost:(id)editedCost {
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    DailyCost *dailyCost = (DailyCost*)editedCost;
    dailyCost.purpose = purpose;
    dailyCost.amount = amount;
    dailyCost.date = date;
    dailyCost.memo = memo;
    dailyCost.purposeImageNumber = purposeImageNumber;
    dailyCost.picture = picture;
    dailyCost.isCost = isCost;
    [context save:nil];
}
+(void)deleteCostWithIdentification:(DailyCost *)deletedCost {
    NSManagedObjectContext *context = [(AppDelegate *)[[UIApplication sharedApplication] delegate] managedObjectContext];
    DailyCost *dailyCost = (DailyCost*)deletedCost;
    [context deleteObject:dailyCost];
    [context save:nil];
    
}
@end
