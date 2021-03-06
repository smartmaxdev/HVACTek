//
//  PlatinumOptionsVC.m
//  Signature
//
//  Created by Iurie Manea on 17.03.2015.
//  Copyright (c) 2015 Unifeyed. All rights reserved.
//

#import "SummaryOfFindingVC.h"
#import "ViewOptionsVC.h"
#import "SummaryOfFindingCell.h"
#import "ServiceOptionVC.h"
#import "IAQDataModel.h"
#import "HealthyHomeSolutionsSortVC.h"
#import "MediaLibraryVC.h"
@interface SummaryOfFindingVC ()
@property (weak, nonatomic) IBOutlet UITableView  *tableView;
@property (weak, nonatomic) IBOutlet UIButton     *btnContinue;
@property (weak, nonatomic) IBOutlet UIButton *pictureButton;
@end

static NSString *kSummaryOfFindingCellID = @"SummaryOfFindingCell";

@implementation SummaryOfFindingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"Summary of Findings";
    
    UIBarButtonItem *techButton = [[UIBarButtonItem alloc] initWithTitle:@"Tech" style:UIBarButtonItemStylePlain target:self action:@selector(tapTechButton)];
    [self.navigationItem setRightBarButtonItem:techButton];
    
    [self.tableView registerNib:[UINib nibWithNibName:kSummaryOfFindingCellID bundle:nil] forCellReuseIdentifier:kSummaryOfFindingCellID];
      
    self.btnContinue.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.pictureButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    for (UIButton* bigButton in self.bigButtonArray) {
        bigButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
        bigButton.userInteractionEnabled = false;
    }
    
}
- (void) tapTechButton {
    [super tapTechButton];
    [IAQDataModel sharedIAQDataModel].currentStep = IAQSummaryOfFinding;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDelegate & DataSource
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor clearColor]];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[IAQDataModel sharedIAQDataModel].iaqSortedProductsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    IAQProductModel *iaqProductModel = [IAQDataModel sharedIAQDataModel].iaqSortedProductsArray[indexPath.row];
    
    SummaryOfFindingCell *cell = [tableView dequeueReusableCellWithIdentifier:kSummaryOfFindingCellID];
  
    cell.lbTitle.text = iaqProductModel.title;

    return cell;
}

#pragma mark - button event
-(IBAction)nextButtonClick:(id)sender {
    
    int viewsToPop = 5;//go to cutomer's choice screen
    [self.navigationController popToViewController: self.navigationController.viewControllers[self.navigationController.viewControllers.count-viewsToPop-1] animated:NO];
    
    [IAQDataModel sharedIAQDataModel].currentStep = IAQNone;
    [IAQDataModel sharedIAQDataModel].isfinal = 1;
    NSUserDefaults* userdefault = [NSUserDefaults standardUserDefaults];
    
    [userdefault setObject:[NSNumber numberWithInt:1] forKey:@"isfinal"];
    [userdefault setObject:[NSNumber numberWithInteger:IAQCustomerChoiceFinal]  forKey:@"iaqCurrentStep"];
    [userdefault synchronize];
    
}

- (IBAction)libraryButtonClick:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TechnicianAppStoryboard" bundle:nil];
    
    MediaLibraryVC* mediaLibraryVC = [storyboard instantiateViewControllerWithIdentifier:@"MediaLibraryVC"];
    [self.navigationController pushViewController:mediaLibraryVC animated:true];
    
}
@end
