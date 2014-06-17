//
//  AAPLConsumedFoodItem.h
//  Fit
//
//  Created by Andrew Naylor on 17/06/2014.
//  Copyright (c) 2014 Andrew Naylor. All rights reserved.
//

#import "AAPLFoodItem.h"

@interface AAPLConsumedFoodItem : AAPLFoodItem

+ (instancetype)foodItemWithName:(NSString *)name caffeineLevel:(double)caffeineLevel cumulativeCaffeineLevel:(double)cumulativeCaffeineLevel date:(NSDate *)date;

@property (nonatomic) double cumulativeCaffeineLevel;
@property (nonatomic) NSDate *date;

@end
