//
//  BaseVC.m
//  Signature
//
//  Created by Iurie Manea on 12/9/14.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//

#import "BaseVC.h"

#import "TechnicianHomeVC.h"
#import "AppDelegate.h"
#import "TechDataModel.h"
#import "QuestionsVC.h"
#import "SummaryOfFindingsOptionsVC.h"
#import "ServiceOptionVC.h"
#import "IAQDataModel.h"
#import "HealthyHomeSolutionsAgreementVC.h"

@interface BaseVC ()

@property(nonatomic, strong) UIImageView *imgTopBar;
@property(nonatomic, strong) UIView *titleView;
@property(nonatomic, strong) UIView *logoView;
@property(nonatomic, strong) UIView *upperArcView;
@property(nonatomic, strong) UIView *bottomArcView;

@end

@implementation BaseVC
@synthesize nextButton;
/*
 
 [self configureColorScheme];
 
 #pragma mark - Color Scheme
 - (void)configureColorScheme {
 self.ButtonView.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
 self.label.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
 }
 
 
 */

- (void)viewDidLoad {
    [super viewDidLoad];

    [self configureBackgroundColor];
    [self configureLogoImage];
    [self configureTitle];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - BackgroundColors
- (void)configureBackgroundColor {
    self.view.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary50];
    
    if (seperatorViewArray) {
        for (UIView* seperatorView in seperatorViewArray) {
            seperatorView.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
        }
    }
    
    nextButton.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
}

#pragma mark - Logo
- (void)configureLogoImage {
    self.logoView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, 100)];
    [self.logoView setBackgroundColor:[UIColor cs_getColorWithProperty:kColorSecondary0]];
    [self.view addSubview:self.logoView];
    
    self.imgTopBar = [[UIImageView alloc] initWithFrame:CGRectMake(159, 64, 450, 100)];
    self.imgTopBar.contentMode = UIViewContentModeScaleAspectFit;
    
    __weak UIImageView *weakImageView = self.imgTopBar;
    [self.imgTopBar setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[[DataLoader sharedInstance] currentCompany] logo]]]
                          placeholderImage:[UIImage imageNamed:@"bg-top-bar"]
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                       
                                       UIImageView *strongImageView = weakImageView;
                                       if (!strongImageView) return;
                                       
                                       strongImageView.image = image;
                                   }
                                   failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                       //
                                   }];
    
    [self.view addSubview:self.imgTopBar];
}

#pragma mark - Title
- (void)configureTitle{
    
    self.titleView = [[UIView alloc] initWithFrame:CGRectMake(-1, self.imgTopBar.bottom + 20, self.view.width+2, 53)];
    [self.titleView setBackgroundColor:[UIColor cs_getColorWithProperty:kColorPrimary30]];
    self.titleView.layer.borderWidth = 1.0;
    self.titleView.layer.borderColor = [UIColor cs_getColorWithProperty:kColorPrimary].CGColor;
    [self.view addSubview:self.titleView];
    
    self.lbTitle = [[UILabel alloc] initWithFrame:self.titleView.bounds];
    self.lbTitle.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:44];
    self.lbTitle.textColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.lbTitle.textAlignment = NSTextAlignmentCenter;
    [self.titleView addSubview:self.lbTitle];
    
    self.lbTitle.text = self.title;
    
    [self configureUpperView];
    [self configureBottomView];
}

- (void)configureUpperView {
    CGFloat round = 20;
    self.upperArcView = [[UIView alloc] initWithFrame:CGRectMake(0, 164, self.view.width, 20)];
    self.upperArcView.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    
    CGSize viewSize = self.upperArcView.bounds.size;
    CGPoint startPoint = CGPointZero;
    
    [aPath moveToPoint:startPoint];
    
    [aPath addLineToPoint:CGPointMake(startPoint.x+viewSize.width, startPoint.y)];
    [aPath addLineToPoint:CGPointMake(startPoint.x+viewSize.width, startPoint.y+viewSize.height-round)];
    [aPath addQuadCurveToPoint:CGPointMake(startPoint.x,startPoint.y+viewSize.height-round) controlPoint:CGPointMake(startPoint.x+(viewSize.width/2), 20)];
    [aPath closePath];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = self.upperArcView.bounds;
    layer.path = aPath.CGPath;
    self.upperArcView.layer.mask = layer;
    
    [self.view addSubview:self.upperArcView];
}

- (void)configureBottomView {
    CGFloat round = 20;
    self.bottomArcView = [[UIView alloc] initWithFrame:CGRectMake(0, 1004, self.view.width, 20)];
    self.bottomArcView.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    self.bottomArcView.layer.affineTransform = CGAffineTransformMakeScale(1, -1);
    
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    
    CGSize viewSize = self.bottomArcView.bounds.size;
    CGPoint startPoint = CGPointZero;
    
    [aPath moveToPoint:startPoint];
    
    [aPath addLineToPoint:CGPointMake(startPoint.x+viewSize.width, startPoint.y)];
    [aPath addLineToPoint:CGPointMake(startPoint.x+viewSize.width, startPoint.y+viewSize.height-round)];
    [aPath addQuadCurveToPoint:CGPointMake(startPoint.x, startPoint.y+viewSize.height-round) controlPoint:CGPointMake(startPoint.x+(viewSize.width/2), 20)];
    [aPath closePath];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = self.bottomArcView.bounds;
    layer.path = aPath.CGPath;
    self.bottomArcView.layer.mask = layer;
    
    [self.view addSubview:self.bottomArcView];
}

#pragma mark
-(void)setTitle:(NSString *)title
{
    [super setTitle:title];
    self.lbTitle.text = title;
}

-(void)setIsTitleViewHidden:(BOOL)isTitleViewHidden
{
    self.titleView.hidden = isTitleViewHidden;
}

-(BOOL)isTitleViewHidden
{
    return self.titleView.hidden;
}

#pragma mark -
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (NSString *)changeCurrencyFormat:(float)number {
    
    NSNumberFormatter *formatterCurrency;
    formatterCurrency = [[NSNumberFormatter alloc] init];
    
    formatterCurrency.numberStyle = NSNumberFormatterCurrencyStyle;
    [formatterCurrency setMaximumFractionDigits:0];
    [formatterCurrency stringFromNumber: @(12345.2324565)];
    
    return [formatterCurrency stringFromNumber:[NSNumber numberWithInt:number]];
}

- (void) tapTechButton {
    
    NSUserDefaults* userdefault = [NSUserDefaults standardUserDefaults];
    NSNumber* techCurrentStep = [userdefault objectForKey:@"techCurrentStep"];
    if (techCurrentStep == nil) {
        techCurrentStep = [NSNumber numberWithInteger:TechnicianHome];
    }
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"TechnicianAppStoryboard" bundle:nil];
    UIViewController* currentViewController;
    
    Job* activeJob = [[[DataLoader sharedInstance] currentUser] activeJob];
    if (activeJob == nil) {
        currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"TechnicianHomeVC"];
    }else {
        switch (techCurrentStep.intValue) {
                
            case TechnicianHome:
                currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"TechnicianHomeVC"];
                break;
            case Dispatch:
                currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"DispatchVC"];
                break;
            case CustomerOverview:
                currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"CustomerOverviewVC"];
                break;
            case SettingAgenda:
                currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"SettingAgendaVC"];
                break;
            case AgendaPicture:
                currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"AgendaPictureVC"];
                break;
            case ESABenefits:
                currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"ESABenefitsVC"];
                break;
            case Questions:
                currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"QuestionsVC"];
                break;
            case Questions1:
                currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"QuestionsVC1"];
                break;
            case UtilityOverpayment:
                currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"UtilityOverpaymentVC"];
                break;
            case ExploreSummary:
                currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"ExploreSummaryVC"];
                break;
            case SummaryOfFindingsOptions1:
            {
                currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"SummaryOfFindingsOptionsVC1"];
                SummaryOfFindingsOptionsVC* questionsVC = (SummaryOfFindingsOptionsVC*) currentViewController;
                
                questionsVC.isiPadCommonRepairsOptions = YES;
                break;
            }
            case SortFindings:
                currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"SortFindingsVC"];
                break;
            case SummaryOfFindingsOptions2:
                currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"SummaryOfFindingsOptionsVC2"];
                break;
            case ViewOptions:
                currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"ViewOptionsVC"];
                break;
            case PlatinumOptions:
                currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"PlatinumOptionsVC"];
                break;
            case RRFinalChoice:
                currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"RRFinalChoiceVC"];
                break;
            case ServiceOption1:
                currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"ServiceOptionVC"];
                break;
            case ServiceOption2:
                currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"ServiceOptionVC2"];
                break;
            case CustomerChoice:
                currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"CustomerChoiceVC"];
                break;
            case AdditionalInfoPage:
                currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"AdditionalInfoPageVC"];
                break;
            case NewCustomerChoice:
            case InvoicePreview:
                currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"NewCustomerChoiceVC"];
                break;
                
            case TechnicianDebrief:
                currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"TechnicianDebriefVC"];
                break;
            default:
                currentViewController = [storyboard instantiateViewControllerWithIdentifier:@"TechnicianHomeVC"];
                break;
        }
    }
    
    
    
    
    AppDelegate * appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    
    UINavigationController *navController = (UINavigationController *)appDelegate.window.rootViewController;
    
    UIViewController* homeViewController = [navController.viewControllers objectAtIndex:1];
    [navController popToViewController:homeViewController animated:true];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, .5), dispatch_get_main_queue(), ^{
        [navController pushViewController:currentViewController animated:true];
    });
    
}

- (void)tapIAQButton {
    NSUserDefaults* userdefault = [NSUserDefaults standardUserDefaults];
    NSNumber* iaqCurrentStep = [userdefault objectForKey:@"iaqCurrentStep"];
    if (iaqCurrentStep == nil) {
        iaqCurrentStep = [NSNumber numberWithInteger:IAQNone];
    }
    [IAQDataModel sharedIAQDataModel].currentStep = [iaqCurrentStep integerValue];
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"IAQStoryboard" bundle:nil];
    HealthyHomeSolutionsAgreementVC* healthyHomeSolutionsAgreementVC = [storyboard instantiateViewControllerWithIdentifier:@"HealthyHomeProcessVC"];
    [self.navigationController pushViewController:healthyHomeSolutionsAgreementVC animated:true];
}


@end
