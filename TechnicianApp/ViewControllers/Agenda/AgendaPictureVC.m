//
//  AgendaPictureVC.m
//  Signature
//
//  Created by Dorin on 8/26/15.
//  Copyright (c) 2015 Unifeyed. All rights reserved.
//

#import "AgendaPictureVC.h"
#import "QuestionsVC.h"

@interface AgendaPictureVC ()

@property (weak, nonatomic) IBOutlet UIButton *continueBtn;
@property (weak, nonatomic) IBOutlet UIView *agendaView;

@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;
@property (weak, nonatomic) IBOutlet UILabel *label3;
@property (weak, nonatomic) IBOutlet UILabel *label4;
@property (weak, nonatomic) IBOutlet UILabel *label5;
@property (weak, nonatomic) IBOutlet UILabel *label6;

@property (weak, nonatomic) IBOutlet UIView *view1;


@end

@implementation AgendaPictureVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureColorScheme];
    
    self.title = NSLocalizedString(@"Expectations", nil);
    
    UIBarButtonItem *iaqButton = [[UIBarButtonItem alloc] initWithTitle:@"IAQ" style:UIBarButtonItemStylePlain target:self action:@selector(tapIAQButton)];
    [self.navigationItem setRightBarButtonItem:iaqButton];
    
    if (self.isAutoLoad && [TechDataModel sharedTechDataModel].currentStep > AgendaPicture) {
        QuestionsVC* currentViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"QuestionsVC"];
        currentViewController.questionType = 0;
        currentViewController.isAutoLoad = true;
        [self.navigationController pushViewController:currentViewController animated:false];
    }else {
        [[TechDataModel sharedTechDataModel] saveCurrentStep:AgendaPicture];
    }
    
}

#pragma mark - Color Scheme
- (void)configureColorScheme {
    self.continueBtn.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.agendaView.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.view1.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    
    self.label1.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.label2.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.label3.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.label4.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.label5.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.label6.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)continueBtnClicked:(UIButton *)sender {

    
    
    Job *job = [[[DataLoader sharedInstance] currentUser] activeJob];
    if (!job.startTime) {
        job.startTime = [NSDate date];
        [job.managedObjectContext save];
    }
    
    
    job.startTimeQuestions = [NSDate date];
    [job.managedObjectContext save];
    
    [self performSegueWithIdentifier:@"customerQuestionsSegue" sender:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    
}


@end
