//
//  DailyCost+CoreDataProperties.h
//  saveMoneyOC
//
//  Created by 浦明晖 on 5/24/16.
//  Copyright © 2016 浦明晖. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "DailyCost.h"

NS_ASSUME_NONNULL_BEGIN

@interface DailyCost (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *amount;
@property (nullable, nonatomic, retain) NSDate *date;
@property (nullable, nonatomic, retain) NSNumber *isCost;
@property (nullable, nonatomic, retain) NSString *memo;
@property (nullable, nonatomic, retain) NSString *purpose;
@property (nullable, nonatomic, retain) NSString *purposeImageNumber;
@property (nullable, nonatomic, retain) NSData *picture;

@end

NS_ASSUME_NONNULL_END
