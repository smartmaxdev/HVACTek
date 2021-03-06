//
//  RRQuestionsVC.m
//  Signature
//
//  Created by Dorin on 12/8/15.
//  Copyright © 2015 Unifeyed. All rights reserved.
//

#import "RRQuestionsVC.h"
#import "RRQuestionsView.h"
#import <BCGenieEffect/UIView+Genie.h>
#import "RROverviewVC.h"

@interface RRQuestionsVC ()

@property (weak, nonatomic) IBOutlet RoundCornerView *vwContent;
@property(nonatomic, assign) NSInteger currentRRQuestionIndex;
@property(nonatomic, strong) RRQuestionsView *currentRRQuestionView;
@property(nonatomic, strong) RRQuestionsView *nextRRQuestionView;
@property (weak, nonatomic) IBOutlet UILabel *repVSrepLabel;

@end

@implementation RRQuestionsVC

#pragma mark - View Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary50];
    
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
    
    self.title = @"Customer's Choice";
    [self loadQuestionsData];
    
}
- (void) tapIAQButton {
    [super tapIAQButton];
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:_currentRRQuestionIndex] forKey:@"currentRRQuestionIndex"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [TechDataModel sharedTechDataModel].currentStep = RRFinalChoice;
    Job *job = [[[DataLoader sharedInstance] currentUser] activeJob];
    
    if (self.questionType == qRepairVsReplace) {
        job.rrQuestions = self.questionsArray;
        [job.managedObjectContext save];
    }
    
}

#pragma mark - Load Questions
- (void)loadQuestionsData {
    self.questionType = qRepairVsReplace;
    
    __weak typeof(self) weakSelf = self;
    [[DataLoader sharedInstance] getQuestionsOfType:self.questionType onSuccess:^(NSArray *resultQuestions) {
        weakSelf.questionsArray = [NSMutableArray arrayWithArray:resultQuestions];
        [weakSelf prepareRRQuestionToDisplay];
        
        if (self.isAutoLoad && [[NSUserDefaults standardUserDefaults] objectForKey:@"currentQuestionIndex"]) {
            _currentRRQuestionIndex = [[[NSUserDefaults standardUserDefaults] objectForKey:@"_currentRRQuestionIndex"] integerValue];
            
            weakSelf.currentRRQuestionView.questionRR = [_questionsArray objectAtIndex:_currentRRQuestionIndex];
        }
        
        
    } onError:^(NSError *error) {
    
    }];
}

#pragma mark - Prepare Questions
-(void)prepareRRQuestionToDisplay
{
    __weak typeof(self) weakSelf = self;
    
    void (^onBackButtonTouch)(RRQuestionsView *sender) = ^(RRQuestionsView *view) {
        weakSelf.currentRRQuestionIndex--;
        if (weakSelf.currentRRQuestionIndex>=0)
        {
            [weakSelf showNextRRQuestionView:view moveFromRightToLeft:NO];
        }
        else
        {
            weakSelf.currentRRQuestionIndex = 0;
            [weakSelf.navigationController popViewControllerAnimated:YES];
    
        }
    };
    
    void (^onNextButtonTouch)(RRQuestionsView *sender) = ^(RRQuestionsView *view) {
        
        if (view.questionRR.required && view.questionRR.answer.length == 0) {
            
            ShowOkAlertWithTitle(@"This question is required", weakSelf);
        }
        else {
            weakSelf.currentRRQuestionIndex++;
            if (weakSelf.currentRRQuestionIndex<=weakSelf.questionsArray.count)
            {
                [weakSelf showNextRRQuestionView:view  moveFromRightToLeft:YES];
            }
            else
            {
                weakSelf.currentRRQuestionIndex = weakSelf.questionsArray.count-1;
            }
        }
    };
    
    self.currentRRQuestionView = [[[NSBundle mainBundle] loadNibNamed:@"RRQuestionsView" owner:self options:nil] firstObject];
    self.currentRRQuestionView.center = CGPointMake(self.vwContent.middlePoint.x, self.questionViewPositionY);
    self.currentRRQuestionView.questionRR = _questionsArray.firstObject;
    [self.currentRRQuestionView setOnBackButtonTouch:onBackButtonTouch];
    [self.currentRRQuestionView setOnNextButtonTouch:onNextButtonTouch];
    
    
    self.nextRRQuestionView = [[[NSBundle mainBundle] loadNibNamed:@"RRQuestionsView" owner:self options:nil] firstObject];
    self.nextRRQuestionView.center = CGPointMake(self.vwContent.middlePoint.x, self.questionViewPositionY);
    [self.nextRRQuestionView setOnBackButtonTouch:onBackButtonTouch];
    [self.nextRRQuestionView setOnNextButtonTouch:onNextButtonTouch];
    
    [self configureBackgroundColor];
    
    [self.vwContent addSubview:self.nextRRQuestionView];
    [self.vwContent addSubview:self.currentRRQuestionView];
    
    self.nextRRQuestionView.hidden = YES;
    CGRect endRect = CGRectMake(0, self.questionViewPositionY, -50, 60);
    [self.nextRRQuestionView genieInTransitionWithDuration:0.05
                                         destinationRect:endRect
                                         destinationEdge:BCRectEdgeRight
                                              completion:^{
                                                  weakSelf.nextRRQuestionView.hidden = NO;
                                              }];
}

#pragma mark - BackgroundColors
- (void)configureBackgroundColor {
    self.currentRRQuestionView.answerTextField.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.currentRRQuestionView.answerTextField.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary0];
    self.currentRRQuestionView.questionTextView.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.currentRRQuestionView.answerTextField.layer.borderWidth = 1.0;
    self.currentRRQuestionView.answerTextField.layer.borderColor = [UIColor cs_getColorWithProperty:kColorPrimary50].CGColor;
    self.currentRRQuestionView.sep1.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.currentRRQuestionView.sep2.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    [self.currentRRQuestionView.btnBack setTitleColor:[UIColor cs_getColorWithProperty:kColorPrimary] forState:UIControlStateNormal];
    [self.currentRRQuestionView.btnNext setTitleColor:[UIColor cs_getColorWithProperty:kColorPrimary] forState:UIControlStateNormal];
    [self.currentRRQuestionView.btnBack setTitleColor:[UIColor cs_getColorWithProperty:kColorPrimary0] forState:UIControlStateHighlighted];
    [self.currentRRQuestionView.btnNext setTitleColor:[UIColor cs_getColorWithProperty:kColorPrimary0] forState:UIControlStateHighlighted];
    
    self.nextRRQuestionView.answerTextField.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.nextRRQuestionView.answerTextField.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary0];
    self.nextRRQuestionView.questionTextView.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.nextRRQuestionView.answerTextField.layer.borderWidth = 1.0;
    self.nextRRQuestionView.answerTextField.layer.borderColor = [UIColor cs_getColorWithProperty:kColorPrimary50].CGColor;
    self.nextRRQuestionView.sep1.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.nextRRQuestionView.sep2.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    [self.nextRRQuestionView.btnBack setTitleColor:[UIColor cs_getColorWithProperty:kColorPrimary] forState:UIControlStateNormal];
    [self.nextRRQuestionView.btnNext setTitleColor:[UIColor cs_getColorWithProperty:kColorPrimary] forState:UIControlStateNormal];
    [self.nextRRQuestionView.btnBack setTitleColor:[UIColor cs_getColorWithProperty:kColorPrimary0] forState:UIControlStateHighlighted];
    [self.nextRRQuestionView.btnNext setTitleColor:[UIColor cs_getColorWithProperty:kColorPrimary0] forState:UIControlStateHighlighted];
}

#pragma mark - QuestionView Y Position
-(CGFloat)questionViewPositionY
{
    return self.vwContent.middleY - (self.view.middleY - self.vwContent.middleY) + 50;
}

#pragma mark - Next Question Animation
-(void)showNextRRQuestionView:(RRQuestionsView*)currentView moveFromRightToLeft:(BOOL)moveFromRightToLeft
{
    RRQuestionsView *nextView = (currentView == self.currentRRQuestionView ? self.nextRRQuestionView : self.currentRRQuestionView);
    if (self.currentRRQuestionIndex>=0 && self.currentRRQuestionIndex<self.questionsArray.count)
    {
        __weak typeof(self) weakSelf = self;
        
        if ([[weakSelf.questionsArray[weakSelf.currentRRQuestionIndex] name] isEqualToString:@"RR5"]){
          
            for (Question *object in weakSelf.questionsArray) {
                if ([object.name isEqualToString:@"RR2"]){
                    if (object.answer != nil && ![object.answer isEqualToString:@""]){
                        nextView.systemLastPeriod = object.answer;
                    }
                }
            }
        }
        nextView.questionRR = weakSelf.questionsArray[weakSelf.currentRRQuestionIndex];
        
        if (moveFromRightToLeft)
        {
            CGRect endRect = CGRectMake(0, weakSelf.questionViewPositionY, -50, 60);
            [currentView genieInTransitionWithDuration:0.4
                                       destinationRect:endRect
                                       destinationEdge:BCRectEdgeRight
                                            completion:^{
                                                
                                                CGRect startRect = CGRectMake(weakSelf.vwContent.width, weakSelf.questionViewPositionY, 50, 60);
                                                [nextView genieOutTransitionWithDuration:0.4
                                                                               startRect:startRect
                                                                               startEdge:BCRectEdgeLeft
                                                                              completion:nil];
                                            }];
        }
        else
        {
            CGRect endRect = CGRectMake(weakSelf.view.width, weakSelf.questionViewPositionY, 50, 60);
            [currentView genieInTransitionWithDuration:0.4
                                       destinationRect:endRect
                                       destinationEdge:BCRectEdgeLeft
                                            completion:^{
                                                
                                                CGRect startRect = CGRectMake(0, weakSelf.questionViewPositionY, -50, 60);
                                                [nextView genieOutTransitionWithDuration:0.4
                                                                               startRect:startRect
                                                                               startEdge:BCRectEdgeRight
                                                                              completion:nil];
                                            }];
        }
        [nextView.answerTextField becomeFirstResponder];
    }
    else
    {
        self.currentRRQuestionIndex--;
        
        Job *job = [[[DataLoader sharedInstance] currentUser] activeJob];
        if (self.questionType == qRepairVsReplace) {
            job.rrQuestions = self.questionsArray;
            [job.managedObjectContext save];
            [self performSegueWithIdentifier:@"showRROverviewVC" sender:self];
        }      
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showRROverviewVC"]) {
        RROverviewVC *vc = [segue destinationViewController];
        vc.overviewArray = self.questionsArray;
    }
}


@end
