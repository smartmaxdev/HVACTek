//
//  ExploreSummaryVC.m
//  Signature
//
//  Created by Iurie Manea on 1/9/15.
//  Copyright (c) 2015 Unifeyed. All rights reserved.
//

#import "ExploreSummaryVC.h"
///#import "QuestionsVC.h"
#import "QuestionSummaryCell.h"
#import "Question.h"
#import "SummaryOfFindingsOptionsVC.h"
#import "DataLoader.h"

@interface ExploreSummaryVC ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *continueBtn;
@end

@implementation ExploreSummaryVC

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
    
    [self.tableView registerNib:[UINib nibWithNibName:@"QuestionSummaryCell" bundle:nil] forCellReuseIdentifier:@"QuestionSummaryCell"];
    
    if (self.isAutoLoad && [TechDataModel sharedTechDataModel].currentStep > ExploreSummary) {
        SummaryOfFindingsOptionsVC* currentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"SummaryOfFindingsOptionsVC1"];
        currentViewController.isAutoLoad = true;
        currentViewController.isiPadCommonRepairsOptions = YES;
        [self.navigationController pushViewController:currentViewController animated:false];
    }else {
        [[TechDataModel sharedTechDataModel] saveCurrentStep:ExploreSummary];
    }
    
}

- (void) tapIAQButton {
    [super tapIAQButton];
    [TechDataModel sharedTechDataModel].currentStep = ExploreSummary;
}

#pragma mark - Color Scheme
- (void)configureColorScheme {
    self.continueBtn.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.titleLabel.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    
    NSMutableArray * questionsCustomer = [[[[[DataLoader sharedInstance] currentUser] activeJob] custumerQuestions] mutableCopy];
    NSArray * questionsTech = [[[[[DataLoader sharedInstance] currentUser] activeJob] techObservations] mutableCopy];
    [questionsCustomer addObjectsFromArray:questionsTech];
    self.questions = [[NSArray alloc] initWithArray:questionsCustomer];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnContinueTouch:(id)sender {
    //[self performSegueWithIdentifier:@"technicianQuestionsSegue" sender:self];
    [self performSegueWithIdentifier:@"selectOptionsIpadRepairsSegue" sender:self];
}

#pragma mark - UITableViewDataSource, UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.questions.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    QuestionSummaryCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"QuestionSummaryCell"];
    Question            *q    = self.questions[indexPath.row];
    cell.lbQuestion.text = q.question;
    cell.lbAnswer.text   = q.answer;
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    [cell setBackgroundColor:[UIColor clearColor]];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

//    if ([segue.destinationViewController isKindOfClass:[QuestionsVC class]]) {
//        QuestionsVC    *vc  = (QuestionsVC *)segue.destinationViewController;
//        NSMutableArray *arr = _questions.mutableCopy;
//        vc.questionType = qtTechnician;
//        vc.questions    = arr;
//    }
    
    
    
    if ([segue.destinationViewController isKindOfClass:[SummaryOfFindingsOptionsVC class]])
    {
        SummaryOfFindingsOptionsVC *vc = (SummaryOfFindingsOptionsVC*)segue.destinationViewController;
        vc.isiPadCommonRepairsOptions = YES;
        
    }
}

@end
