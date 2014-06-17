//
//  AAPLConsumedFoodItem.m
//  Fit
//
//  Created by Andrew Naylor on 17/06/2014.
//  Copyright (c) 2014 Andrew Naylor. All rights reserved.
//

#import "AAPLConsumedFoodItem.h"

@implementation AAPLConsumedFoodItem

+ (instancetype)foodItemWithName:(NSString *)name caffeineLevel:(double)caffeineLevel cumulativeCaffeineLevel:(double)cumulativeCaffeineLevel date:(NSDate *)date {
	AAPLConsumedFoodItem *foodItem = [self foodItemWithName:name caffeineLevel:caffeineLevel];
	foodItem.cumulativeCaffeineLevel = cumulativeCaffeineLevel;
	foodItem.date = date;
	
	return foodItem;
}

- (BOOL)isEqual:(id)object {
	if ([object isKindOfClass:[AAPLConsumedFoodItem class]]) {
		return [super isEqual:object] && [object date] == self.date && [object cumulativeCaffeineLevel] == self.cumulativeCaffeineLevel;
	}
	
	return NO;
}

- (NSString *)description {
	return [@{
			  @"name": self.name,
			  @"caffeineLevel": @(self.caffeineLevel),
			  @"cumulativeCaffeineLevel": @(self.cumulativeCaffeineLevel),
			  @"date": self.date
			  } description];
}

@end
