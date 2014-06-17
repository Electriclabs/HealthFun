/*
    Copyright (C) 2014 Apple Inc. All Rights Reserved.
    See LICENSE.txt for this sample’s licensing information
    
    Abstract:
    
                A UIViewController subclass that manages the selection of a food item.
            
*/

#import "AAPLFoodPickerViewController.h"
#import "AAPLFoodItem.h"

NSString *const AAPLFoodPickerViewControllerTableViewCellIdentifier = @"cell";
NSString *const AAPLFoodPickerViewControllerUnwindSegueIdentifier = @"AAPLFoodPickerViewControllerUnwindSegueIdentifier";

@interface AAPLFoodPickerViewController()

@property (nonatomic, strong) NSArray *foodItems;

@end


@implementation AAPLFoodPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // A hard-coded list of possible food items. In your application, you can decide how these should be represented / created.
    self.foodItems = @[
                       [AAPLFoodItem foodItemWithName:@"Coffee (brewed)" caffeineLevel:108 date:nil],
                       [AAPLFoodItem foodItemWithName:@"Coffee (drip)" caffeineLevel:145 date:nil],
                       [AAPLFoodItem foodItemWithName:@"Espresso" caffeineLevel:77 date:nil],
                       [AAPLFoodItem foodItemWithName:@"Coca Cola" caffeineLevel:34 date:nil],
                       [AAPLFoodItem foodItemWithName:@"Red Bull" caffeineLevel:80 date:nil],
                       [AAPLFoodItem foodItemWithName:@"Lucozade" caffeineLevel:36 date:nil],
                       [AAPLFoodItem foodItemWithName:@"Black Tea" caffeineLevel:42 date:nil],
                       [AAPLFoodItem foodItemWithName:@"Green Tea" caffeineLevel:25 date:nil],
                       [AAPLFoodItem foodItemWithName:@"Diet Coke" caffeineLevel:45 date:nil]
    ];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.foodItems.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:AAPLFoodPickerViewControllerTableViewCellIdentifier forIndexPath:indexPath];
    
    AAPLFoodItem *foodItem = self.foodItems[indexPath.row];
    
    cell.textLabel.text = foodItem.name;
    
    NSMassFormatter *energyFormatter = [self energyFormatter];
  cell.detailTextLabel.text = [energyFormatter stringFromValue:foodItem.caffeineLevel / 1000 unit:NSMassFormatterUnitGram];

    return cell;
}

#pragma mark - Convenience

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:AAPLFoodPickerViewControllerUnwindSegueIdentifier]) {
        NSIndexPath *indexPathForSelectedRow = self.tableView.indexPathForSelectedRow;

        self.selectedFoodItem = self.foodItems[indexPathForSelectedRow.row];
    }
}

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
