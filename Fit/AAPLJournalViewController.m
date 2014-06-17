/*
    Copyright (C) 2014 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    
                Displays information retrieved from HealthKit about the food items consumed today.
            
*/

#import "AAPLJournalViewController.h"
#import "AAPLFoodPickerViewController.h"
#import "AAPLFoodItem.h"
@import HealthKit;

NSString *const AAPLJournalViewControllerTableViewCellReuseIdentifier = @"cell";
NSString *const AAPLCumulativeCaffeineLevelIdentifier = @"AAPLCumulativeCaffeineLevel";


@interface AAPLJournalViewController()

@property (nonatomic) NSMutableArray *foodItems;
@property (nonatomic) NSNumber *cumulativeCaffeineLevel;

@end


@implementation AAPLJournalViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.foodItems = [[NSMutableArray alloc] init];
    
    [self updateJournal];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateJournal) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIApplicationDidBecomeActiveNotification object:nil];
}

#pragma mark - Using HealthKit APIs

- (void)updateJournal {
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDate *now = [NSDate date];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitYear|NSCalendarUnitMonth|NSCalendarUnitDay fromDate:now];
    
    NSDate *startDate = [calendar dateFromComponents:components];
    
    NSDate *endDate = [calendar dateByAddingUnit:NSCalendarUnitDay value:1 toDate:startDate options:0];
    
    HKSampleType *sampleType = [HKSampleType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryChloride];
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionNone];

    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:sampleType predicate:predicate limit:0 sortDescriptors:nil resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
        if (error) {
            NSLog(@"An error occured fetching the user's tracked food. In your app, try to handle this gracefully. The error was: %@.", error);
            abort();
        }

        dispatch_async(dispatch_get_main_queue(), ^{
            [self.foodItems removeAllObjects];
			
            self.cumulativeCaffeineLevel = [(HKQuantitySample *)results.lastObject metadata][AAPLCumulativeCaffeineLevelIdentifier];
			
            for (HKQuantitySample *sample in results) {
                NSString *foodName = sample.metadata[HKMetadataKeyFoodType];
                double caffeineLevel = [sample.quantity doubleValueForUnit:[HKUnit gramUnitWithMetricPrefix:HKMetricPrefixMilli]];
                
              AAPLFoodItem *foodItem = [AAPLFoodItem foodItemWithName:foodName caffeineLevel:caffeineLevel date:sample.endDate];
                
                [self.foodItems addObject:foodItem];
            }
            
            [self.tableView reloadData];
        });
    }];
    
    [self.healthStore executeQuery:query];
}

- (void)addFoodItem:(AAPLFoodItem *)originalFoodItem {
    AAPLFoodItem *foodItem = [AAPLFoodItem foodItemWithName:originalFoodItem.name caffeineLevel:originalFoodItem.caffeineLevel
                                                       date:[NSDate date]];

    HKQuantityType *quantityType = [HKQuantityType quantityTypeForIdentifier:HKQuantityTypeIdentifierDietaryChloride];

    AAPLFoodItem *lastMeasurement = self.foodItems.firstObject;
    NSNumber *cumulativeValue = [self newCaffeineLevelWithPreviousSample:lastMeasurement newFoodItem:foodItem];
  _cumulativeCaffeineLevel = cumulativeValue;
	
    HKQuantity *quantity = [HKQuantity quantityWithUnit:[HKUnit gramUnitWithMetricPrefix:HKMetricPrefixMilli] doubleValue:foodItem.caffeineLevel];
    
    NSDate *now = [NSDate date];

    NSDictionary *metadata = @{ HKMetadataKeyFoodType:foodItem.name, AAPLCumulativeCaffeineLevelIdentifier:cumulativeValue };
    
    HKQuantitySample *calorieSample = [HKQuantitySample quantitySampleWithType:quantityType quantity:quantity startDate:now endDate:now metadata:metadata];
    
    [self.healthStore saveObject:calorieSample withCompletion:^(BOOL success, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (success) {
                [self.foodItems insertObject:foodItem atIndex:0];
                
                NSIndexPath *indexPathForInsertedFoodItem = [NSIndexPath indexPathForRow:0 inSection:0];
                
                [self.tableView insertRowsAtIndexPaths:@[indexPathForInsertedFoodItem] withRowAnimation:UITableViewRowAnimationAutomatic];
              [self.tableView reloadData];
            }
            else {
                NSLog(@"An error occured saving the food %@. In your app, try to handle this gracefully. The error was: %@.", foodItem.name, error);
                abort();
            }
        });
    }];
}

- (NSNumber *)newCaffeineLevelWithPreviousSample:(AAPLFoodItem *)sample newFoodItem:(AAPLFoodItem *)foodItem
{
    double initialCaffeineLevel = sample.caffeineLevel;
    NSTimeInterval timeSinceConsumption = [sample.date timeIntervalSinceNow];
    NSTimeInterval halfLife = 5.7 * 3600;

    double currentCaffeineLevel = foodItem.caffeineLevel + initialCaffeineLevel * pow(0.5, timeSinceConsumption / halfLife);

    return [NSNumber numberWithDouble:currentCaffeineLevel];
}

#pragma mark - UITableViewDelegate

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
  UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 280, 40.0f)];
  label.text = [NSString stringWithFormat:@"Current caffeine level is %@",
                [[self energyFormatter] stringFromValue:[_cumulativeCaffeineLevel doubleValue] unit:NSMassFormatterUnitGram]];
  label.font = [UIFont boldSystemFontOfSize:16.0f];

  UIView *wrapper = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320.0f, 40.0f)];
  wrapper.backgroundColor = [UIColor colorWithWhite:0.8 alpha:1];
  [wrapper addSubview:label];
  return wrapper;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
  return 40.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.foodItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AAPLJournalViewControllerTableViewCellReuseIdentifier forIndexPath:indexPath];
    
    AAPLFoodItem *foodItem = self.foodItems[indexPath.row];

    cell.textLabel.text = foodItem.name;

    NSMassFormatter *massFormatter = [self energyFormatter];
    cell.detailTextLabel.text = [massFormatter stringFromValue:foodItem.caffeineLevel / 1000 unit:NSMassFormatterUnitGram];

    return cell;
}

#pragma mark - Segue Interaction

- (IBAction)performUnwindSegue:(UIStoryboardSegue *)segue {
    AAPLFoodPickerViewController *foodPickerViewController = [segue sourceViewController];
    
    AAPLFoodItem *selectedFoodItem = foodPickerViewController.selectedFoodItem;
    
    [self addFoodItem:selectedFoodItem];
}

#pragma mark - Convenience

- (NSMassFormatter *)energyFormatter {
    static NSMassFormatter *energyFormatter;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        energyFormatter = [[NSMassFormatter alloc] init];
        energyFormatter.unitStyle = NSFormattingUnitStyleLong;
        energyFormatter.numberFormatter.maximumFractionDigits = 4;
    });
    
    return energyFormatter;
}

@end
