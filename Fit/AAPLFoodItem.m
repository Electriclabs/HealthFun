/*
    Copyright (C) 2014 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    
                A simple model class to represent food and its associated energy.
            
*/

#import "AAPLFoodItem.h"

@implementation AAPLFoodItem

+ (instancetype)foodItemWithName:(NSString *)name caffeineLevel:(double)caffeineLevel date:(NSDate *)date {
    AAPLFoodItem *foodItem = [[self alloc] init];
    
    foodItem.name = name;
    foodItem.caffeineLevel = caffeineLevel;
  foodItem.date = date;

    return foodItem;
}

- (BOOL)isEqual:(id)object {
    if ([object isKindOfClass:[AAPLFoodItem class]]) {
        return [object caffeineLevel] == self.caffeineLevel && [self.name isEqualToString:[object name]];
    }
    
    return NO;
}

- (NSString *)description {
    return [@{
        @"name": self.name,
        @"caffeineLevel": @(self.caffeineLevel)
    } description];
}

@end
