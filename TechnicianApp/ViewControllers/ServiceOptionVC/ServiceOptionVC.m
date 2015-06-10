//
//  ServiceOptionVC.m
//  Signature
//
//  Created by Andrei Zaharia on 12/12/14.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//

#import "ServiceOptionVC.h"
#import "RecommendationTableViewCell.h"
#import "ViewOptionsVC.h"
#import "CustomerChoiceVC.h"
#import "PlatinumOptionsVC.h"

@interface ServiceOptionVC ()

@property (weak, nonatomic) IBOutlet UITableView  *tableView;
@property (weak, nonatomic) IBOutlet UIButton     *btnContinue;
@property (strong, nonatomic) NSMutableArray      *options;
@property (strong, nonatomic) NSMutableDictionary *customerSelectedOptions;
@property (nonatomic, assign) BOOL                isDiscountedPriceSelected;
@property (nonatomic, assign) BOOL                isDiagnositcOnlyPriceSelected;

@end

@implementation ServiceOptionVC

static NSString *kCELL_IDENTIFIER = @"RecommendationTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.title = @"Customer's Choice";
    [self.tableView registerNib:[UINib nibWithNibName:kCELL_IDENTIFIER bundle:nil] forCellReuseIdentifier:kCELL_IDENTIFIER];

    if (self.optionsDisplayType == odtEditing) {
        self.options = @[@{@"title": @"Platinum", @"isEditable": @(NO), @"backgroundImage" : [UIImage imageNamed:@"bg-platinum"], @"items" : @[].mutableCopy}.mutableCopy,
                         @{@"title": @"Gold", @"isEditable": @(NO), @"backgroundImage" : [UIImage imageNamed:@"bg-gold"], @"items" : @[].mutableCopy}.mutableCopy,
                         @{@"title": @"Silver", @"isEditable": @(NO), @"backgroundImage" : [UIImage imageNamed:@"bg-silver"], @"items" : @[].mutableCopy}.mutableCopy,
                         @{@"title": @"Bronze", @"isEditable": @(NO), @"backgroundImage" : [UIImage imageNamed:@"bg-bronze"], @"items" : @[].mutableCopy}.mutableCopy,
                         @{@"title": @"Basic", @"isEditable": @(NO), @"backgroundImage" : [UIImage imageNamed:@"bg-basic"], @"items" : @[].mutableCopy}.mutableCopy].mutableCopy;

    }

    self.tableView.allowsSelection = _optionsDisplayType == odtReadonlyWithPrice;

    if (self.priceBookAndServiceOptions) {
        [self resetOptions];
    } else {
        [self.tableView reloadData];
    }

//    self.btnContinue.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    ViewOptionsVC *vc = [segue destinationViewController];
    if ([vc isKindOfClass:[ViewOptionsVC class]]) {

        ViewOptionsVC *vc = [segue destinationViewController];
        vc.priceBookAndServiceOptions = self.options;

    } else if ([vc isKindOfClass:[ServiceOptionVC class]]) {

        ServiceOptionVC *vc = [segue destinationViewController];
        vc.optionsDisplayType         = odtReadonlyWithPrice;
        vc.priceBookAndServiceOptions = self.options;

    } else if ([vc isKindOfClass:[CustomerChoiceVC class]]) {

        CustomerChoiceVC *vc = [segue destinationViewController];
        vc.fullServiceOptions = self.options.firstObject[@"items"];
        vc.isDiscounted       = self.isDiscountedPriceSelected;
        if (self.isDiagnositcOnlyPriceSelected) {

            PricebookItem *diagnosticOnlyItem = [[DataLoader sharedInstance] diagnosticOnlyOption];

            PricebookItem *diagnosticOnlyItemNoTitle = [PricebookItem new];
            diagnosticOnlyItemNoTitle.itemID     = diagnosticOnlyItem.itemID;
            diagnosticOnlyItemNoTitle.itemNumber = diagnosticOnlyItem.itemNumber;
            diagnosticOnlyItemNoTitle.itemGroup  = diagnosticOnlyItem.itemGroup;
            diagnosticOnlyItemNoTitle.amount     = diagnosticOnlyItem.amount;

            NSDictionary *d = @{
                @"items" : @[diagnosticOnlyItemNoTitle],
                @"title" : @"Diagnostic Only"
            };

            vc.selectedServiceOptions = d;
        } else {
            vc.selectedServiceOptions = self.customerSelectedOptions;
        }
    } else if ([vc isKindOfClass:[PlatinumOptionsVC class]]) {

        PlatinumOptionsVC *vc = [segue destinationViewController];
        vc.priceBookAndServiceOptions = self.options;
    }
}

- (void)setPriceBookAndServiceOptions:(NSArray *)priceBookAndServiceOptions {

    _priceBookAndServiceOptions = priceBookAndServiceOptions;
    if (self.optionsDisplayType == odtEditing) {

        if (self.options.count) {

            [self resetOptions];
        }
    } else {
        self.options = _priceBookAndServiceOptions.mutableCopy;
    }

}

- (void)resetOptions {

    if (self.optionsDisplayType == odtEditing) {

        for (NSInteger i = 0; i < self.options.count; i++) {
            NSMutableDictionary *option = self.options[i];
            if (i == 0 || (i == 1 && [[self.options[i-1][@"items"] filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isMain == NO"]] count])) {
                option[@"items"]      = self.priceBookAndServiceOptions.mutableCopy;
                option[@"isEditable"] = @(i == 1);
            } else {
                option[@"items"]      = @[].mutableCopy;
                option[@"isEditable"] = @(NO);
            }

        }
        self.btnContinue.hidden = [self.options[1][@"items"] count] > 1;
        [self.tableView reloadData];
    }
}

- (void)didSelectOptionsWithRow:(NSInteger)index withOptionIndex:(NSInteger)optionIndex {

    NSMutableDictionary *option = self.options[index];
    NSMutableArray      *items  = option[@"items"];
    [items removeObjectAtIndex:optionIndex];
    option[@"items"]      = items;
    option[@"isEditable"] = @(NO);
    NSArray *editableItems = [items filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isMain == NO"]];
    if (editableItems.count > 0 && self.options.count > index+1) {
        NSMutableDictionary *nextOption = self.options[index+1];
        nextOption[@"items"]      = items.mutableCopy;
        nextOption[@"isEditable"] = @(items.count > 1);
    }

    self.btnContinue.hidden = ([editableItems count] > 0) && (self.options.lastObject != option);

    [self.tableView reloadData];
}

- (IBAction)btnDiagnosticOnlyTouch:(id)sender {
    self.isDiagnositcOnlyPriceSelected = YES;
    self.isDiscountedPriceSelected     = NO;
    [self performSegueWithIdentifier:@"customerChoiceSegue" sender:self];
}

#pragma mark - UITableViewDelegate & DataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *items = [self.options objectAtIndex:indexPath.section];
    return [RecommendationTableViewCell heightWithData:items];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.options.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak ServiceOptionVC *weakSelf = self;
    NSDictionary           *option   = self.options[indexPath.row];
    NSArray                *items    = option[@"items"];

    RecommendationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCELL_IDENTIFIER];
    cell.gradientView.image        = option[@"backgroundImage"];
    cell.lbRecommandationName.text = option[@"title"];
    cell.rowIndex                  = indexPath.row;
    if (self.optionsDisplayType == odtEditing) {
        cell.isEditable = [option[@"isEditable"] boolValue];
    }
    cell.optionsDisplayType = self.optionsDisplayType;

    [cell setOnOptionReset:^(NSInteger rowIndex, NSInteger itemIndex){
         [weakSelf resetOptions];
     }];

    [cell displayServiceOptions:items];
    [cell setOnOptionSelected:^(NSInteger rowIndex, NSInteger itemIndex){
         [weakSelf didSelectOptionsWithRow:rowIndex withOptionIndex:itemIndex];
     }];

    [cell setOnPriceSelected:^(NSInteger rowIndex, BOOL isDiscounted) {
         weakSelf.isDiscountedPriceSelected = isDiscounted;
         weakSelf.isDiagnositcOnlyPriceSelected = NO;
         weakSelf.customerSelectedOptions = self.options[indexPath.row];
         [weakSelf performSegueWithIdentifier:@"customerChoiceSegue" sender:self];
     }];
    return cell;
}

@end