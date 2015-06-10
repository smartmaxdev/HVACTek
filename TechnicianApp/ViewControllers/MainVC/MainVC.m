//
//  MainVC.m
//  Signature
//
//  Created by Iurie Manea on 12/8/14.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//

#import "MainVC.h"
#import "CustomerOverviewVC.h"
#import "SummaryOfFindingsOptionsVC.h"
#import "SummaryOfFindingsVC.h"
#import "CustomerChoiceVC.h"

@interface MainVC ()
@property (strong, nonatomic) IBOutlet UIButton *btnTechApp;
@property (strong, nonatomic) IBOutlet UIButton *btnAdd2CardApp;

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.isTitleViewHidden = YES;
    
    self.btnAdd2CardApp.hidden = !([[DataLoader sharedInstance].currentUser.add2cart boolValue]);
    self.btnTechApp.hidden = !([[DataLoader sharedInstance].currentUser.tech boolValue]);
}

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

- (IBAction)btnAdd2CartTouch:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Storyboard" bundle:nil];

    UIViewController *vc = [storyboard instantiateInitialViewController];
    [self.navigationController pushViewController:vc animated:YES];
}


- (IBAction)CustomerOverviewTest:(id)sender {
  
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TechnicianAppStoryboard" bundle:nil];
    CustomerChoiceVC *vc = [storyboard instantiateViewControllerWithIdentifier:@"CustomerChoiceVC"];
        [self.navigationController pushViewController:vc animated:YES];
        
   
}

- (IBAction)btnTehnicianApp:(id)sender {
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak typeof (self) weakSelf = self;
    
//    [[DataLoader sharedInstance]connectToSWAPIonSucces:^(NSString *message) {
        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
        if (weakSelf == weakSelf.navigationController.topViewController) {
            [weakSelf performSegueWithIdentifier:@"tehnicianHome" sender:self];
        }        
//    } onError:^(NSError *error) {
//        [MBProgressHUD hideAllHUDsForView:weakSelf.view animated:YES];
//        ShowOkAlertWithTitle(error.localizedDescription, weakSelf);
//    }];

}
@end