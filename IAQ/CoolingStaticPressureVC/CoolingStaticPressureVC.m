//
//  CoolingStaticPressureVC.m
//  HvacTek
//
//  Created by Max on 11/11/17.
//  Copyright © 2017 Unifeyed. All rights reserved.
//

#import "CoolingStaticPressureVC.h"
#import "CHDropDownTextField.h"
#import "CHDropDownTextFieldTableViewCell.h"
#import "HealthyHomeSolutionsVC.h"
@interface CoolingStaticPressureVC () <CHDropDownTextFieldDelegate, UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet RoundCornerView *layer1View;

@property (weak, nonatomic) IBOutlet UITextField *nameField;
@property (weak, nonatomic) IBOutlet UITextField *dateField;
@property (weak, nonatomic) IBOutlet UITextField *filterSizeField;
@property (weak, nonatomic) IBOutlet UITextField *mervRatingField;
@property (weak, nonatomic) IBOutlet CHDropDownTextField *systemTypeField;
@property (weak, nonatomic) IBOutlet UITextField *aField;
@property (weak, nonatomic) IBOutlet UITextField *bField;
@property (weak, nonatomic) IBOutlet UITextField *cField;
@property (weak, nonatomic) IBOutlet UITextField *dField;
@property (weak, nonatomic) IBOutlet UITextField *abField;
@property (weak, nonatomic) IBOutlet UITextField *acField;
@property (weak, nonatomic) IBOutlet UITextField *bdField;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *backgroundLabel;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *borderField;

@end

@implementation CoolingStaticPressureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    for (UILabel* backlabel in self.backgroundLabel) {
        backlabel.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary20];
    }
    
    for (UITextField* iborderfield in self.borderField) {
        iborderfield.clipsToBounds = true;
        iborderfield.layer.borderColor = [UIColor cs_getColorWithProperty:kColorPrimary50].CGColor;
        iborderfield.layer.borderWidth = 1;
        
    }
    
    self.systemTypeField.dropDownTableVisibleRowCount = 4;
    self.systemTypeField.dropDownTableTitlesArray = @[ @"Gas Furnace & Condenser" , @"Air Handler & Condenser", @"Packaged System", @"Other"];
    self.systemTypeField.layer.borderWidth            = 1;
    self.systemTypeField.layer.borderColor            = [UIColor cs_getColorWithProperty:kColorPrimary50].CGColor;
    self.systemTypeField.cellClass = [CHDropDownTextFieldTableViewCell class];
    self.systemTypeField.dropDownTableView.backgroundColor = [UIColor whiteColor];
    self.systemTypeField.dropDownTableView.layer.masksToBounds = YES;
    self.systemTypeField.dropDownTableView.layer.borderWidth = 1.0;
    self.systemTypeField.dropDownTableView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.systemTypeField.tag = 893457;
    
    NSDate *today = [NSDate date];
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy-MM-dd"];
    NSString* dateString = [df stringFromDate:today];
    
    self.dateField.text = dateString;
    
    [self.aField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.bField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.cField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.dField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}
-(IBAction)nextButtonClick:(id)sender {
    if ([self isEmptyField]) {
        TYAlertController* alert = [TYAlertController showAlertWithStyle1:@"" message:@"Please fill out the required fields"];
        [self presentViewController:alert animated:true completion:nil];
        return;
    }
    
    [IAQDataModel sharedIAQDataModel].coolingStaticPressure.customerName = self.nameField.text;
    [IAQDataModel sharedIAQDataModel].coolingStaticPressure.todayDate = self.dateField.text;
    [IAQDataModel sharedIAQDataModel].coolingStaticPressure.filterSize = self.filterSizeField.text;
    [IAQDataModel sharedIAQDataModel].coolingStaticPressure.filterMervRating = self.mervRatingField.text;
    [IAQDataModel sharedIAQDataModel].coolingStaticPressure.systemType = self.systemTypeField.text;
    [IAQDataModel sharedIAQDataModel].coolingStaticPressure.heatingA = self.aField.text;
    [IAQDataModel sharedIAQDataModel].coolingStaticPressure.heatingB = self.bField.text;
    [IAQDataModel sharedIAQDataModel].coolingStaticPressure.heatingC = self.cField.text;
    [IAQDataModel sharedIAQDataModel].coolingStaticPressure.heatingD = self.dField.text;
    
    HealthyHomeSolutionsVC* healthyHomeSolutionsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"HealthyHomeSolutionsVC"];
    [self.navigationController pushViewController:healthyHomeSolutionsVC animated:true];
}

-(BOOL) isEmptyField {
    if (self.nameField.text.length == 0 ||
        self.dateField.text.length == 0 ||
        self.filterSizeField.text.length == 0 ||
        self.mervRatingField.text.length == 0 ||
        self.systemTypeField.text.length == 0 ||
        self.aField.text.length == 0 ||
        self.bField.text.length == 0 ||
        self.cField.text.length == 0 ||
        self.dField.text.length == 0
        ) {
        return true;
    }
    return false;
}

-(void)textFieldDidChange :(UITextField *)theTextField{
    
    if (![self.aField.text isNumeric] ||
        ![self.bField.text isNumeric] ||
        ![self.cField.text isNumeric] ||
        ![self.dField.text isNumeric] ) {
        
        return;
    }
    float aValue = [self.aField.text floatValue];
    float bValue = [self.bField.text floatValue];
    float cValue = [self.cField.text floatValue];
    float dValue = [self.dField.text floatValue];
    
    self.abField.text = [NSString stringWithFormat:@"%.2f", aValue + bValue];
    self.acField.text = [NSString stringWithFormat:@"%.2f", aValue - cValue];
    self.bdField.text = [NSString stringWithFormat:@"%.2f", bValue - dValue];
}

- (void)dropDownTextField:(CHDropDownTextField *)dropDownTextField didChooseDropDownOptionAtIndex:(NSUInteger)index {
    self.systemTypeField.text = self.systemTypeField.dropDownTableTitlesArray[index];
    
}
-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:true];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end