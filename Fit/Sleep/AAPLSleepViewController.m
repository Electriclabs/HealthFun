//
//  AAPLSleepViewController.m
//  Fit
//
//  Created by Christopher Anderson on 17/06/2014.
//  Copyright (c) 2014 Apple. All rights reserved.
//

#import "AAPLSleepViewController.h"
#import "APPLSleepViewModel.h"

@import  HealthKit;


@interface AAPLSleepViewController ()<APPLSleepViewModelDelegate>
@property (nonatomic, strong) APPLSleepViewModel *sleepViewModel;
@end

@implementation AAPLSleepViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    _sleepViewModel = [[APPLSleepViewModel alloc] init];
    [_sleepViewModel processPedometerForDate:nil];
}

- (void) sleepModel:(APPLSleepViewModel*)sleepModel didGetDayStarting:(NSDate*)startDate sleepPeriods:(NSArray*)sleepPeriods {
   
}

@end
