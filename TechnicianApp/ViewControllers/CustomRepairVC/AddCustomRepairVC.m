//
//  AddCustomRepairVC.m
//  HvacTek
//
//  Created by Dorin on 5/17/16.
//  Copyright © 2016 Unifeyed. All rights reserved.
//

#import "AddCustomRepairVC.h"

@interface AddCustomRepairVC ()
@property (weak, nonatomic) IBOutlet RoundCornerView *roundedView;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *priceTextField;

@end

@implementation AddCustomRepairVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
    
    [self configureColorScheme];
    [self configureController];
}


- (void)configureController {
    self.priceTextField.text = self.defaultPrice;
}


#pragma mark - Color Scheme
- (void)configureColorScheme {
    self.view.backgroundColor = [UIColor colorWithRed:162/255.0f green:162/255.0f blue:162/255.0f alpha:0.7f];
    
    self.roundedView.layer.borderWidth   = 3.0;
    self.roundedView.layer.borderColor   = [UIColor cs_getColorWithProperty:kColorPrimary].CGColor;
    
    self.titleTextField.layer.borderWidth   = .5;
    self.titleTextField.layer.borderColor   = [UIColor cs_getColorWithProperty:kColorPrimary50].CGColor;
    self.titleTextField.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary0];
    self.titleTextField.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.priceTextField.layer.borderWidth   = .5;
    self.priceTextField.layer.borderColor   = [UIColor cs_getColorWithProperty:kColorPrimary50].CGColor;
    self.priceTextField.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary0];
    self.priceTextField.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
}



#pragma mark - Save Button
- (IBAction)saveClicked:(id)sender {
    if (self.titleTextField.text.length > 0 &&  self.priceTextField.text.length > 1) {
        [self addPricebookItem];
        [self dismissController];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"In order to save a new custom repair please enter a title and price." delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
    }
}


#pragma mark - Save Pricebook item
-(void)addPricebookItem {
    
    NSNumber *number = @(ceil([[self getPriceAmountFromString:self.priceTextField.text] doubleValue] * 0.85));
    
    int randomID = 2000 + arc4random_uniform(10000);

    PricebookItem *priceBook = [PricebookItem pricebookWithID:[NSString stringWithFormat:@"%d", randomID]
                                           itemNumber:@"33XX01"
                                            itemGroup:@""
                                         itemCategory:@""
                                                 name:self.titleTextField.text
                                             quantity:@""
                                               amount:[self roundNumber:number]
                                         andAmountESA:[NSNumber numberWithInt:[[self getPriceAmountFromString:self.priceTextField.text] intValue]]];
    
    if ([[[[[DataLoader sharedInstance] currentUser] activeJob] addedCustomRepairsOptions] count] > 0) {
        [[[[[DataLoader sharedInstance] currentUser] activeJob] addedCustomRepairsOptions] addObject:priceBook];
    }else{
        [[[DataLoader sharedInstance] currentUser] activeJob].addedCustomRepairsOptions = [[NSMutableArray alloc] initWithObjects:priceBook, nil];
    }
    
    Job *job = [[[DataLoader sharedInstance] currentUser] activeJob];
    [job.managedObjectContext save];
    
    NSDictionary* userInfo = @{@"addeditem": priceBook};
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddCustomRepairOptionNotification" object:nil userInfo:userInfo];
}


-(NSNumber *)getPriceAmountFromString:(NSString *)priceString {
    
    NSLocale *local = [NSLocale currentLocale];
    NSNumberFormatter *paymentFormatter = [[NSNumberFormatter alloc] init];
    [paymentFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    [paymentFormatter setLocale:local];
    [paymentFormatter setGeneratesDecimalNumbers:NO];
    [paymentFormatter setMaximumFractionDigits:0];
    
    NSNumber *number = [paymentFormatter numberFromString:priceString];
    
    return number;
}


- (NSNumber *)roundNumber:(NSNumber *)number {
    NSNumber *roundedNumber = [NSNumber numberWithFloat:roundf(number.floatValue)];
    return roundedNumber;
}

#pragma mark - UITextField Delegates
- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.priceTextField)
        if (textField.text.length  == 0)
            textField.text = @"$";
}



- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.priceTextField) {
        NSMutableString *mutableString = [[textField text] mutableCopy];
        
        NSLocale *local = [NSLocale currentLocale];
        NSNumberFormatter *paymentFormatter = [[NSNumberFormatter alloc] init];
        [paymentFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        [paymentFormatter setLocale:local];
        [paymentFormatter setGeneratesDecimalNumbers:NO];
        [paymentFormatter setMaximumFractionDigits:0];
        
        if ([mutableString length] == 0) {
            [mutableString setString:[local objectForKey:NSLocaleCurrencySymbol]];
            [mutableString appendString:string];
        } else {
            if ([string length] > 0) {
                [mutableString insertString:string atIndex:range.location];
            } else {
                [mutableString deleteCharactersInRange:range];
            }
        }
        
        NSString *penceString = [[[mutableString stringByReplacingOccurrencesOfString:
                                   [local objectForKey:NSLocaleDecimalSeparator] withString:@""]
                                  stringByReplacingOccurrencesOfString:
                                  [local objectForKey:NSLocaleCurrencySymbol] withString:@""]
                                 stringByReplacingOccurrencesOfString:
                                 [local objectForKey:NSLocaleGroupingSeparator] withString:@""];
        
        NSNumber *someAmount = [NSNumber numberWithDouble:[penceString doubleValue]];
        [textField setText:[paymentFormatter stringFromNumber:someAmount]];
        
        return NO;
    }else{
        return YES;
    }
}


#pragma mark - Dismiss Controller
- (IBAction)cancelClicked:(id)sender {
    [self dismissController];
}


-(void)dismissController {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
