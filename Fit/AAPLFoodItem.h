/*
    Copyright (C) 2014 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    
                A simple model class to represent food and its associated energy.
            
*/

@import Foundation;

@interface AAPLFoodItem : NSObject

+ (instancetype)foodItemWithName:(NSString *)name caffeineLevel:(double)caffeineLevel date:(NSDate *)date;

@property (nonatomic, copy) NSString *name;
@property (nonatomic) double caffeineLevel;
@property (nonatomic) NSDate *date;

@end
