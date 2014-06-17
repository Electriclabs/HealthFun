//
//  APPLSleepViewModel.h
//  Fit
//
//  Created by Christopher Anderson on 17/06/2014.
//  Copyright (c) 2014 Apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class APPLSleepViewModel;

@protocol APPLSleepViewModelDelegate <NSObject>
- (void) sleepModel:(APPLSleepViewModel*)sleepModel didGetDayStarting:(NSDate*)startDate sleepPeriods:(NSArray*)sleepPeriods;
@end

@interface APPLSleepViewModel : NSObject
@property (nonatomic, weak) id<APPLSleepViewModelDelegate> delegate;

- (void)processPedometerForDate:(NSDate*)date;

@end
