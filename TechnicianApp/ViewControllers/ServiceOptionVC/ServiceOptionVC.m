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
#import "EnlargeOptionsVC.h"
#import "EditServiceOptionsVC.h"
#import "RRFinalChoiceVC.h"

@interface ServiceOptionVC ()
{
    NSString* startTime;
}
@property (weak, nonatomic) IBOutlet UITableView  *tableView;
@property (weak, nonatomic) IBOutlet UIButton     *btnContinue;
@property (weak, nonatomic) IBOutlet UIButton *btnZeroPercent;
@property (strong, nonatomic) NSMutableArray      *options;
@property (strong, nonatomic) NSMutableArray      *removedOptions;
@property (strong, nonatomic) NSMutableDictionary *customerSelectedOptions;
@property (nonatomic, assign) BOOL                isDiscountedPriceSelected;
@property (nonatomic, assign) BOOL                isDiagnositcOnlyPriceSelected;
@property (nonatomic, assign) BOOL isEmptyOptionSelected;
@property (nonatomic, assign) BOOL isInvoiceRRSelected;
@property (readwrite) BOOL timestarted;
@property (readwrite) BOOL editServiceOptionClicked;
@property (nonatomic, strong) NSString *segueIdentifierToUnwindTo;

@end

@implementation ServiceOptionVC

static NSString *kCELL_IDENTIFIER = @"RecommendationTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disappearSelector) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appearSelector) name:UIApplicationWillEnterForegroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disappearSelector) name:UIApplicationWillTerminateNotification object:nil];

    
    self.title = @"Customer's Choice";
    
    UIColor* titleColor = [UIColor colorWithRed:0.0 green:122.0/255.0 blue:1.0 alpha:1.0];
    UIButton *someButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0, 45,25)];
    [someButton setTitle:@" IAQ " forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(tapIAQButton)
         forControlEvents:UIControlEventTouchUpInside];
    [someButton setShowsTouchWhenHighlighted:YES];
    someButton.layer.borderWidth = 1;
    someButton.layer.borderColor = titleColor.CGColor;
    [someButton setTitleColor:titleColor forState:UIControlStateNormal];
    UIBarButtonItem *iaqButton =[[UIBarButtonItem alloc] initWithCustomView:someButton];
    
    [self.navigationItem setRightBarButtonItem:iaqButton];
    
    [self.tableView registerNib:[UINib nibWithNibName:kCELL_IDENTIFIER bundle:nil] forCellReuseIdentifier:kCELL_IDENTIFIER];
    
    self.btnContinue.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.btnZeroPercent.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];

    self.optionsDisplayType = [DataLoader loadOptionsDisplayType];
    
    self.options = @[@{@"ServiceID": @"0", @"title": @"Immediate Repair", @"isEditable": @(NO), @"optionImage" : UIImageJPEGRepresentation([UIImage imageNamed:@"btn_immediateRepair"], 0.0f), @"items" : @[].mutableCopy, @"removedItems" : @[].mutableCopy}.mutableCopy,
                     @{@"ServiceID": @"1", @"title": @"System Preservation", @"isEditable": @(NO), @"optionImage" : UIImageJPEGRepresentation([UIImage imageNamed:@"btn_systemPrevention"], 0.0f), @"items" : @[].mutableCopy, @"removedItems" : @[].mutableCopy}.mutableCopy,
                     @{@"ServiceID": @"2", @"title": @"Clean Air Solution", @"isEditable": @(NO), @"optionImage" : UIImageJPEGRepresentation([UIImage imageNamed:@"btn_cleanAirSolution"], 0.0f), @"items" : @[].mutableCopy, @"removedItems" : @[].mutableCopy}.mutableCopy,
                     @{@"ServiceID": @"3", @"title": @"Total Comfort Enchacement", @"isEditable": @(NO), @"optionImage" : UIImageJPEGRepresentation([UIImage imageNamed:@"btn_totalComfortEnhancement"], 0.0f), @"items" : @[].mutableCopy, @"removedItems" : @[].mutableCopy}.mutableCopy].mutableCopy;
    
    
    if (self.isAutoLoad) {
        _priceBookAndServiceOptions = [DataLoader loadLocalFinalOptions];
        
        if (_priceBookAndServiceOptions == nil || _priceBookAndServiceOptions.count == 0) {
            self.priceBookAndServiceOptions = [DataLoader loadSortFindingOptions];
        
            if (self.priceBookAndServiceOptions) {
                [self resetOptions];
            } else {
                [self.tableView reloadData];
            }
        }else {
            self.options = _priceBookAndServiceOptions.mutableCopy;
        }
        
    }else {
        if (self.optionsDisplayType == odtEditing) {
            if ([DataLoader loadLocalFinalOptions].count > 0) {
                self.priceBookAndServiceOptions = [DataLoader loadLocalFinalOptions];
                self.options = _priceBookAndServiceOptions.mutableCopy;
            }else {
                self.priceBookAndServiceOptions = [DataLoader loadSortFindingOptions];
            }
            
        }else {
            self.priceBookAndServiceOptions = [DataLoader loadLocalFinalOptions];
        }
        
        self.tableView.allowsSelection = _optionsDisplayType == odtReadonlyWithPrice;
        
        if (self.priceBookAndServiceOptions) {
            [self resetOptions];
        } else {
            [self.tableView reloadData];
        }
    }
    self.removedOptions = [[NSMutableArray alloc] initWithArray:[self.options[0] objectForKey:@"items"]];
    
    if (self.isAutoLoad && [TechDataModel sharedTechDataModel].currentStep > ServiceOption1 && [TechDataModel sharedTechDataModel].currentStep < ServiceOption2) {
        
        ViewOptionsVC* currentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewOptionsVC"];
        currentViewController.isAutoLoad = true;
        [DataLoader saveOptionsDisplayType:odtReadonlyWithPrice];
        [self.navigationController pushViewController:currentViewController animated:false];
    }else if (self.isAutoLoad && [TechDataModel sharedTechDataModel].currentStep >= ServiceOption2) {
        NSArray* viewControllers = self.navigationController.viewControllers;
        
        int countOfQuestionVC = 0;
        for (UIViewController* vc in viewControllers) {
            if ([vc isKindOfClass:[ServiceOptionVC class]]) {
                countOfQuestionVC++;
                
            }
        }
        if (countOfQuestionVC == 1) {
            ViewOptionsVC* currentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ViewOptionsVC"];
            currentViewController.isAutoLoad = true;
            [self.navigationController pushViewController:currentViewController animated:false];
        }else {
            
            if ([TechDataModel sharedTechDataModel].currentStep == ServiceOption2) {
                
            }else if ([TechDataModel sharedTechDataModel].currentStep >= RRFinalChoice) {
                Job *job = [[[DataLoader sharedInstance] currentUser] activeJob];
                
                if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isInstantRRFinal"])
                    [self performSegueWithIdentifier:@"showRRQuestionsVC" sender:self];
                else {
                    if (![job.totalInvestmentsRR isEqualToString:@""] && job.totalInvestmentsRR != nil) {
                        [self performSegueWithIdentifier:@"showInstantRRFinalChoiceVC" sender:self];
                    }else{
                        [self performSegueWithIdentifier:@"showRRQuestionsVC" sender:self];
                    }
                }
            }else {
                CustomerChoiceVC* currentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"CustomerChoiceVC"];
                currentViewController.isAutoLoad = true;
                [self.navigationController pushViewController:currentViewController animated:false];
            }
            
        }
    }else {
        if (self.optionsDisplayType == odtEditing) {
            [[TechDataModel sharedTechDataModel] saveCurrentStep:ServiceOption1];
            
        }else {
            [[TechDataModel sharedTechDataModel] saveCurrentStep:ServiceOption2];
        }
    }
}

- (void) tapIAQButton {
    [super tapIAQButton];
    if (self.optionsDisplayType == odtEditing) {
        [TechDataModel sharedTechDataModel].currentStep = ServiceOption1;
        
    }else {
        [TechDataModel sharedTechDataModel].currentStep = ServiceOption2;
    }
    [DataLoader saveFinalOptionsLocal:self.options];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (_segueIdentifierToUnwindTo) {
        [self performSegueWithIdentifier:_segueIdentifierToUnwindTo sender:self];
        self.segueIdentifierToUnwindTo = nil;
        return;
    }
    
    [self.tableView reloadData];
    
    [self appearSelector];
}

- (void) viewWillDisappear:(BOOL)animated {
    [self disappearSelector];
}

- (void) disappearSelector {
    
    if (self.optionsDisplayType == odtEditing) {
        
        if (self.editServiceOptionClicked) {
            return;
        }
        
        if (startTime == nil) {
            return;
        }
    
        NSDateFormatter* df = [[NSDateFormatter alloc]init];
        [df setDateFormat:@"hh:mm:ss"];
        NSString* endTime = [df stringFromDate:[NSDate date]];
    
        [DataLoader saveTimeLog:@{@"start":startTime, @"end":endTime}];
        startTime = nil;
    }
}

- (void) appearSelector {
    if (self.optionsDisplayType == odtEditing) {
        if (self.editServiceOptionClicked) {
            self.editServiceOptionClicked = false;
            return;
        }
        NSDateFormatter* df = [[NSDateFormatter alloc]init];
        [df setDateFormat:@"hh:mm:ss"];
        startTime = [df stringFromDate:[NSDate date]];
        
    
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - EnlargeOptionsVC
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

    if (self.optionsDisplayType == odtEditing && [DataLoader loadLocalFinalOptions].count == 0) {

        for (NSInteger i = 0; i < self.options.count; i++) {
            NSMutableDictionary *option = self.options[i];
            
            option[@"items"]        = self.priceBookAndServiceOptions.mutableCopy;
            option[@"removedItems"] = self.priceBookAndServiceOptions.mutableCopy;
            
        }
        [self.tableView reloadData];
    }
}

- (void)didSelectOptionsWithRow:(NSInteger)index withOptionIndex:(NSInteger)optionIndex {

    NSMutableDictionary *option = self.options[index];
    NSMutableArray      *items  = option[@"items"];
    
    //////
    
    id object = [items objectAtIndex:[items indexOfObject:self.removedOptions[optionIndex]]];
    [self.removedOptions removeObject:object];

    [self.removedOptions insertObject:object atIndex:items.count - 1];

    [items removeObject:object];
    
    /////
    
    option[@"items"]      = items;
    option[@"isEditable"] = @(NO);

    
    NSMutableArray *editableItems = [[NSMutableArray alloc] initWithArray:[items filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"isMain == NO"]]];
    
    if (editableItems.count == 1 & items.count == 1){
        [editableItems removeAllObjects];
    }
    
    if (editableItems.count > 0 && self.options.count > index+1) {
        NSMutableDictionary *nextOption = self.options[index+1];
        nextOption[@"items"]      = items.mutableCopy;
    }

    [self.tableView reloadData];
}

- (IBAction)btnDiagnosticOnlyTouch:(id)sender {
    self.isDiagnositcOnlyPriceSelected = YES;
    self.isDiscountedPriceSelected     = NO;
    [self performSegueWithIdentifier:@"customerChoiceSegue" sender:self];
}

#pragma mark - Repair vs Replace Action
- (IBAction)repairVsReplaceClicked:(UIButton *)sender {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"accessTCOfromAdd2cart"];
    Job *job = [[[DataLoader sharedInstance] currentUser] activeJob];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"isInstantRRFinal"])
        [self performSegueWithIdentifier:@"showRRQuestionsVC" sender:self];
    else {
        if (![job.totalInvestmentsRR isEqualToString:@""] && job.totalInvestmentsRR != nil) {
            [self performSegueWithIdentifier:@"showInstantRRFinalChoiceVC" sender:self];
        }else{
            [self performSegueWithIdentifier:@"showRRQuestionsVC" sender:self];
        }
    }
}

#pragma mark - Clicked Next Without Option
- (IBAction)nextClickedWithOutAnyOption:(UIButton *)sender {
    self.isEmptyOptionSelected = YES;
        [self performSegueWithIdentifier:@"customerChoiceSegue" sender:self];
}

#pragma mark - Options Action
- (void)selectOptionsToEditAtRow:(NSInteger)index {
    
    self.editServiceOptionClicked = true;
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"TechnicianAppStoryboard" bundle:nil];
    EditServiceOptionsVC* vc = [sb instantiateViewControllerWithIdentifier:@"EditServiceOptionsVC"];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.servicesArray = self.options;
    vc.selectedIndex = index;
    [self presentViewController:vc animated:YES completion:nil];

}

#pragma mark - ZeroPercent Button
- (IBAction)zeroPercentButtonClicked:(UIButton *)sender {
    NSURL *url = [NSURL URLWithString:@"http://www.greenskycredit.com/Consumer/"];
    if ([[UIApplication sharedApplication] canOpenURL:url])
    {
        [[UIApplication sharedApplication] openURL:url];
    } else {
        NSLog(@"Can't open url");
    }
}

#pragma mark - Next Action
- (IBAction)nextBtnClicked:(UIButton *)sender {
    self.editServiceOptionClicked = false;
    if ([self servicesOptionsWereEdited]) {
        [self sendScreenshot];
        [self performSegueWithIdentifier:@"showViewOptionsVC" sender:self];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No options have been changed. Are you sure you wish to continue?" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Yes", nil];
        [alert show];
    }
}

- (UIImage *)pb_takeSnapshot {
    UIView *subView = self.view;
    UIGraphicsBeginImageContextWithOptions(subView.bounds.size, YES, 0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [subView.layer renderInContext:context];
    UIImage *snapshotImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return snapshotImage;
}

- (void) sendScreenshot {
    
    NSString *signature = [UIImagePNGRepresentation([self pb_takeSnapshot]) base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    
    [DataLoader saveScreenshot:signature];
}
- (BOOL)servicesOptionsWereEdited {
    for (NSInteger i = 0; i < self.options.count; i++) {
        NSMutableDictionary *option = self.options[i];
        if ([option[@"items"] count] != [option[@"removedItems"] count]) {
            return YES;
        }
    }
    return NO;
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self sendScreenshot];
        [self performSegueWithIdentifier:@"showViewOptionsVC" sender:self];
    }
}

#pragma mark - UITableViewDelegate & DataSource
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *v = [UIView new];
    [v setBackgroundColor:[UIColor clearColor]];
    return v;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *items = [self.options objectAtIndex:indexPath.section];
    
    return [RecommendationTableViewCell heightWithData:items];

}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.options.count;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary0];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak ServiceOptionVC *weakSelf = self;
    NSDictionary           *option   = self.options[indexPath.section];
    NSArray                *items    = option[@"items"];
    NSArray         *removedItems    = option[@"removedItems"];

    RecommendationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCELL_IDENTIFIER];
    cell.choiceImageView.image        = [UIImage imageWithData:option[@"optionImage"]];;
    cell.lbRecommandationName.text    = option[@"title"];
    cell.rowIndex                     = indexPath.section;
    
    if (self.optionsDisplayType == odtEditing) {
        cell.isEditable = [option[@"isEditable"] boolValue];
    }
    cell.optionsDisplayType = self.optionsDisplayType;

    [cell setOnOptionReset:^(NSInteger rowIndex, NSInteger itemIndex){
         [weakSelf resetOptions];
     }];

    [cell displayServiceOptions:items andRemovedServiceOptions:removedItems];
    [cell setOnOptionSelected:^(NSInteger rowIndex, NSInteger itemIndex){
         [weakSelf didSelectOptionsWithRow:rowIndex withOptionIndex:itemIndex];
     }];

    [cell setOnPriceSelected:^(NSInteger rowIndex, BOOL isDiscounted) {
        self.isEmptyOptionSelected = NO;
        weakSelf.isDiscountedPriceSelected = isDiscounted;
        weakSelf.isDiagnositcOnlyPriceSelected = NO;
        weakSelf.customerSelectedOptions = self.options[indexPath.section];
        [weakSelf performSegueWithIdentifier:@"customerChoiceSegue" sender:self];
     }];
    
    [cell setOptionButtonSelected:^(NSInteger rowIndex){
        [weakSelf selectOptionsToEditAtRow:rowIndex];
    }];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSDictionary           *option   = self.options[indexPath.section];
    NSArray                *items    = option[@"items"];
    
    RecommendationTableViewCell *cell = (RecommendationTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    
    UIStoryboard*  sb = [UIStoryboard storyboardWithName:@"TechnicianAppStoryboard"
                                                  bundle:nil];

    EnlargeOptionsVC* vc = [sb instantiateViewControllerWithIdentifier:@"EnlargeOptionsVC"];
    vc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    vc.enlargeOptionName = option[@"title"];
    vc.enlargeTotalPrice = cell.btnPrice1.titleLabel.text;
    vc.enlargeESAPrice = cell.btnPrice2.titleLabel.text;
    vc.enlargeMonthlyPrice = cell.lb24MonthRates.text;
    vc.enlargeSavings = cell.lbESAsaving.text;
    vc.enlargeMidleLabelString = cell.financingLabel.text;
    vc.enlargeOptionsArray = items;
    vc.enlargeFullOptionsArray = [option objectForKey:@"removedItems"];
    vc.parentVC = self;
    
    [self presentViewController:vc animated:YES completion:nil];

}

#pragma mark - Unwind Segues
- (IBAction)unwindToServiceOptionVC:(UIStoryboardSegue *)unwindSegue
{
    if ([unwindSegue.identifier isEqualToString:@"unwindToServiceOptionsFromRRBtn"]){
        self.segueIdentifierToUnwindTo = @"showRRQuestionsVCAfterUnwind";
    }
    if ([unwindSegue.identifier isEqualToString:@"unwindToServiceOptionsFromInvoiceBtn"]){
        self.isEmptyOptionSelected = YES;
        self.isInvoiceRRSelected = YES;
        self.segueIdentifierToUnwindTo = @"customerChoiceSegueAfterUnwind";
    }
    if ([unwindSegue.identifier isEqualToString:@"unwindToServiceOptionsFromCustomersChoice"]){
        self.isInvoiceRRSelected  = NO;
        self.segueIdentifierToUnwindTo = @"showInstantRRFinalChoiceVC";
    }
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    ViewOptionsVC *vc = [segue destinationViewController];
    if ([vc isKindOfClass:[ViewOptionsVC class]]) {
        
        [DataLoader saveFinalOptionsLocal:self.options];
        
    } else if ([vc isKindOfClass:[ServiceOptionVC class]]) {
        
        [DataLoader saveOptionsDisplayType:odtReadonlyWithPrice];
        [DataLoader saveFindingOptionsLocal:self.options];
        
    } else if ([vc isKindOfClass:[CustomerChoiceVC class]]) {
        
        NSDictionary* customerChoiceData;
        if (self.isEmptyOptionSelected) {
            NSDictionary *d = @{};
            customerChoiceData = @{@"fullServiceOptions": self.options.firstObject[@"items"],
                                   @"isDiscounted": [NSNumber numberWithBool:self.isDiscountedPriceSelected],
                                   @"isOnlyDiagnostic": [NSNumber numberWithBool:self.isDiagnositcOnlyPriceSelected],
                                   @"isComingFromInvoice": [NSNumber numberWithBool:self.isInvoiceRRSelected],
                                   @"selectedServiceOptions" : d.mutableCopy}.mutableCopy;
            
        }else{
            customerChoiceData = @{@"fullServiceOptions": self.options.firstObject[@"items"],
                                   @"isDiscounted": [NSNumber numberWithBool:self.isDiscountedPriceSelected],
                                   @"isOnlyDiagnostic": [NSNumber numberWithBool:self.isDiagnositcOnlyPriceSelected],
                                   @"isComingFromInvoice": [NSNumber numberWithBool:self.isInvoiceRRSelected],
                                   @"selectedServiceOptions" : self.customerSelectedOptions.mutableCopy}.mutableCopy;
        }
        
        [DataLoader saveCustomerChoiceData:customerChoiceData];
        
    } else if ([vc isKindOfClass:[PlatinumOptionsVC class]]) {
        
        [DataLoader saveFinalOptionsLocal:self.options];
        
    }
    
    if ([segue.identifier isEqualToString:@"showInstantRRFinalChoiceVC"]) {
        RRFinalChoiceVC *vc = [segue destinationViewController];
        Job *job = [[[DataLoader sharedInstance] currentUser] activeJob];
        vc.totalInvestment = job.totalInvestmentsRR;
    }
    
}

@end
