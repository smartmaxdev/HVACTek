//
//  EnlargeOptionsVC.m
//  Signature
//
//  Created by Dorin on 8/28/15.
//  Copyright (c) 2015 Unifeyed. All rights reserved.
//

#import "HealthyHomeSolutionsDetailVC.h"
#import "HealthyHomeSolutionsVC.h"
#import "IAQDataModel.h"
@interface HealthyHomeSolutionsDetailVC ()

@property (weak, nonatomic) IBOutlet UITableView *enlargeTable;
@property (weak, nonatomic) IBOutlet UILabel *totalPriceLbl;
@property (weak, nonatomic) IBOutlet UILabel *ESAPriceLbl;
@property (weak, nonatomic) IBOutlet UILabel *firstLabel;
@property (weak, nonatomic) IBOutlet UILabel *secondLabel;
@property (weak, nonatomic) IBOutlet UILabel *optionNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *thirdLabel;
@property (weak, nonatomic) IBOutlet UIView *separatorView1;
@property (weak, nonatomic) IBOutlet UIView *separatorView2;
@property (weak, nonatomic) IBOutlet UIView *separatorView3;
@property (weak, nonatomic) IBOutlet UIButton *editButton;
@property (weak, nonatomic) NSMutableArray* enlargeOptionsArray;
@end

@implementation HealthyHomeSolutionsDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = NSLocalizedString(@"Customer's Choice", nil);
    
    [self configureColorScheme];
    
    self.optionNameLabel.text = self.enlargeOptionName;
    self.totalPriceLbl.text = self.enlargeTotalPrice;
    self.ESAPriceLbl.text = self.enlargeESAPrice;
    self.firstLabel.text = self.firstLabelString;
    self.secondLabel.text = self.secondLabelString;
    self.thirdLabel.text = self.thirdLabelString;
    
    switch (self.iaqType) {
        case BEST:
            self.enlargeOptionsArray = [IAQDataModel sharedIAQDataModel].iaqBestProductsArray;
            break;
        case BETTER:
            self.enlargeOptionsArray = [IAQDataModel sharedIAQDataModel].iaqBetterProductsArray;
            break;
        case GOOD:
            self.enlargeOptionsArray = [IAQDataModel sharedIAQDataModel].iaqGoodProductsArray;
            break;
            
        default:
            break;
    }

}

#pragma mark - Color Scheme
- (void)configureColorScheme {
    self.separatorView1.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.separatorView2.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.separatorView3.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.optionNameLabel.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.editButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
}

- (void)viewWasTapped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate & DataSource

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.enlargeOptionsArray count] == 0){
        return 0;
    }else{
        return [IAQDataModel sharedIAQDataModel].iaqSortedProductsArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    
    IAQProductModel * iaqModel = [IAQDataModel sharedIAQDataModel].iaqSortedProductsArray[indexPath.row];
    
    NSString * serviceString;
    if ([iaqModel.quantity intValue] > 1) {
        serviceString = [NSString stringWithFormat:@"(%@) ",iaqModel.quantity];
    }else{
        serviceString = @"";
    }
    NSString * nameString = [serviceString stringByAppendingString:iaqModel.title];
    
    if (![self.enlargeOptionsArray containsObject:iaqModel]){
        
        NSDictionary* attributes = @{
                                     NSStrikethroughStyleAttributeName: [NSNumber numberWithInt:NSUnderlineStyleSingle]
                                     };
        NSAttributedString* attrText = [[NSAttributedString alloc] initWithString:nameString attributes:attributes];
        cell.textLabel.attributedText = attrText;
        
        
    }else{
        if (cell.textLabel.attributedText){
            cell.textLabel.attributedText = nil;
        }
        cell.textLabel.text = nameString;
    }
    
    
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font          = [UIFont fontWithName:@"HelveticaNeue-Light" size:17];
    cell.textLabel.textColor     = [UIColor cs_getColorWithProperty:kColorPrimary];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
}
- (IBAction)tapEditButton:(id)sender {
    
    NSArray* viewcontrollers = self.navigationController.viewControllers;
    
    for (UIViewController* viewController in viewcontrollers) {
        if ([viewController isKindOfClass:[HealthyHomeSolutionsVC class]]) {
            [self.navigationController popToViewController:viewController animated:NO];
            return;
        }
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"IAQStoryboard" bundle:nil];
    UIViewController* currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"HealthyHomeSolutionsVC"];
   
    [self.navigationController pushViewController:currentViewController animated:NO];
   
}


@end
