//
//  ExploreSummaryVC.m
//  Signature
//
//  Created by Iurie Manea on 1/9/15.
//  Copyright (c) 2015 Unifeyed. All rights reserved.
//

#import "ExploreSummaryVC.h"
#import "QuestionsVC.h"
#import "QuestionSummaryCell.h"
#import "Question.h"

@interface ExploreSummaryVC ()<UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ExploreSummaryVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.tableView registerNib:[UINib nibWithNibName:@"QuestionSummaryCell" bundle:nil] forCellReuseIdentifier:@"QuestionSummaryCell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)btnContinueTouch:(id)sender {
    [self performSegueWithIdentifier:@"technicianQuestionsSegue" sender:self];
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

    if ([segue.destinationViewController isKindOfClass:[QuestionsVC class]]) {
        QuestionsVC    *vc  = (QuestionsVC *)segue.destinationViewController;
        NSMutableArray *arr = _questions.mutableCopy;
        vc.questionType = qtTechnician;
        vc.questions    = arr;
    }
}

@end