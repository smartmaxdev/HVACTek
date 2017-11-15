//
//  BreatheEasyHealthyHomeVC.m
//  HvacTek
//
//  Created by Max on 11/10/17.
//  Copyright © 2017 Unifeyed. All rights reserved.
//

#import "BreatheEasyHealthyHomeVC.h"

@interface BreatheEasyHealthyHomeVC ()
@property (weak, nonatomic) IBOutlet UIImageView *dividerImageView;
@property (weak, nonatomic) IBOutlet RoundCornerView *layer1View;
@end

@implementation BreatheEasyHealthyHomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.layer1View bringSubviewToFront:self.dividerImageView];
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

@end