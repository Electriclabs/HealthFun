//
//  APPLSleepViewModel.m
//  Fit
//
//  Created by Christopher Anderson on 17/06/2014.
//  Copyright (c) 2014 Apple. All rights reserved.
//

#import "APPLSleepViewModel.h"
#import "AAPLAppDelegate.h"

@import CoreMotion;
@import HealthKit;

@interface APPLSleepViewModel ()
@property (nonatomic, strong) CMPedometer *pedometer;
@property (nonatomic, strong) NSMutableDictionary *dayToSleepData;
@end

@implementation APPLSleepViewModel


- (instancetype)init {
    self = [super init];
    if (self) {
        _pedometer = [[CMPedometer alloc] init];
        _dayToSleepData = [NSMutableDictionary dictionary];
    }
    return self;
}




- (void)processPedometerForDate:(NSDate*)date {
    NSCalendar *calendar = [NSCalendar currentCalendar];

    NSDate *startDate = [calendar startOfDayForDate:date ?: [NSDate date]];
    
    NSMutableArray *sleepPeriods = [NSMutableArray array];
    
    HKCategoryType *sleep = [HKCategoryType categoryTypeForIdentifier:HKCategoryTypeIdentifierSleepAnalysis];
    
    __block NSInteger count = 0;
    for (NSInteger i = 0; i < 24; i++) {
        NSDateComponents *components = [[NSDateComponents alloc] init];
        [components setHour:1];
        
        NSDate *endDate = [calendar dateByAddingComponents:components toDate:startDate options:0];

        [sleepPeriods addObject:@0];
        
        [_pedometer queryPedometerDataFromDate:startDate toDate:endDate withHandler:^(CMPedometerData *pedometerData, NSError *error) {
            if ([pedometerData.numberOfSteps integerValue] > 10) {
                sleepPeriods[i] = @1;
            } else {
                
                HKCategorySample *sample = [HKCategorySample  categorySampleWithType:sleep value:HKCategoryValueSleepAnalysisAsleep startDate:startDate endDate:endDate];
                AAPLAppDelegate *appDelegate = (AAPLAppDelegate*) [[UIApplication sharedApplication] delegate];
                
                
                [appDelegate.healthStore  saveObject:sample withCompletion:^(BOOL success, NSError *error) {
                    
                }];
            }
            
          
            
            if (++count == 24) {
                if ([_delegate respondsToSelector:@selector(sleepModel:didGetDayStarting:sleepPeriods:)]) {
                    [_delegate sleepModel:self didGetDayStarting:date sleepPeriods:sleepPeriods];
                }
            }
        }];
        startDate = endDate;
    }
    

}

@end
