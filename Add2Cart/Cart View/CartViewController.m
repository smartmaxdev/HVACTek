//
//  CartViewController.m
//  Unifeiyed Quoting
//
//  Created by James Buckley on 14/07/2014.
//  Copyright (c) 2014 unifeiyed. All rights reserved.
//

#import "CartViewController.h"
#import "CartCell.h"
#import "Add2CartData.h"
@interface CartViewController ()<UITableViewDataSource, UITableViewDelegate, CartCellDelegate>

@property (strong, nonatomic) NSMutableArray *productList;


@property (strong, nonatomic) IBOutlet UILabel *lblSystemRebate;
@property (strong, nonatomic) IBOutlet UILabel *lblFinancingD;
@property (strong, nonatomic) IBOutlet UILabel *lblFinancingSum;
@property (strong, nonatomic) IBOutlet UILabel *lblInvestment;
@property (weak, nonatomic) IBOutlet UIImageView *logoImageView;




@end

@implementation CartViewController
@synthesize cartItems;
@synthesize rebates;
@synthesize yourOrderLabel, afterSavingsLabel, finance, monthlypayment, productsView;
@synthesize months;
@synthesize managedObjectContext;
@synthesize prodFRC;



- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self configureUpperView];
    [self configureColorScheme];
    [self configureVC];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    UIBarButtonItem *btnShare = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(home)];
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    [self.navigationItem setLeftBarButtonItems:[NSArray arrayWithObjects:backButton, btnShare, nil]];
    [self.btnEmail setHidden:YES];

}

#pragma mark - Color Scheme
- (void)configureColorScheme {
    self.view.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary50];
    self.cartstableView.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary50];
    
    __weak UIImageView *weakImageView = self.logoImageView;
    [self.logoImageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[[[DataLoader sharedInstance] currentCompany] logo]]]
                              placeholderImage:[UIImage imageNamed:@"bg-top-bar"]
                                       success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                           
                                           UIImageView *strongImageView = weakImageView;
                                           if (!strongImageView) return;
                                           
                                           strongImageView.image = image;
                                       }
                                       failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                           //
                                       }];
}

#pragma mark - Upper View
- (void)configureUpperView {
    CGFloat round = 20;
    UIView *upperArcView = [[UIView alloc] initWithFrame:CGRectMake(0, 174, self.view.width, 20)];
    upperArcView.backgroundColor = [UIColor cs_getColorWithProperty:kColorPrimary];
    
    UIBezierPath *aPath = [UIBezierPath bezierPath];
    
    CGSize viewSize = upperArcView.bounds.size;
    CGPoint startPoint = CGPointZero;
    
    [aPath moveToPoint:startPoint];
    
    [aPath addLineToPoint:CGPointMake(startPoint.x+viewSize.width, startPoint.y)];
    [aPath addLineToPoint:CGPointMake(startPoint.x+viewSize.width, startPoint.y+viewSize.height-round)];
    [aPath addQuadCurveToPoint:CGPointMake(startPoint.x,startPoint.y+viewSize.height-round) controlPoint:CGPointMake(startPoint.x+(viewSize.width/2), 20)];
    [aPath closePath];
    
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = upperArcView.bounds;
    layer.path = aPath.CGPath;
    upperArcView.layer.mask = layer;
    
    [self.view addSubview:upperArcView];
}

-(void)configureVC{
    [self.cartstableView registerNib:[UINib nibWithNibName:@"CartCell" bundle:nil] forCellReuseIdentifier:@"CartCell1"];
     self.cartstableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

-(float) parseTheString:(NSString *) string {
    NSArray *strip = [[NSArray alloc]init];
    strip = [string componentsSeparatedByString:@"$"];
    
    if (strip.count > 1) {
    
    
    NSString *stringy = strip[1];
    //    NSLog(@"Strip holds %d the first is %@ and second %@",strip.count, strip[0], strip[1]);
    
    
    NSMutableString *strippedString = [NSMutableString stringWithCapacity:stringy.length];
    
    NSScanner *scanner = [NSScanner scannerWithString:stringy];
    NSCharacterSet *numbers = [NSCharacterSet characterSetWithCharactersInString:@"0123456789."];
    while ([scanner isAtEnd] == NO) {
        NSString *buffer;
        if ([scanner scanCharactersFromSet:numbers intoString:&buffer]) {
            [strippedString appendString:buffer];
        } else {
            [scanner setScanLocation:([scanner scanLocation] + 1)];
        }
    }
    NSLog(@"%@", strippedString); // "123123123"
    
    return [strippedString floatValue];
    } else {
        return  [string floatValue];
    }
}

- (IBAction)btnDone:(id)sender {
    
    [self resetRebatesOnHome];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
}

-(void) home {
    [self resetRebatesOnHome];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void) back {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)email:(id)sender {
    
    // Email Subject
    NSString *emailTitle = @"Quote from Signature Quote App";
    // Email Content
    NSString *messageBody = [NSString stringWithFormat:@"\nProducts for Quote:\n\n\n%@,",products];
    // To address
    //NSArray *toRecipents = [NSArray arrayWithObject:@"quizfeedback@cisi.org"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    mc.mailComposeDelegate = self;
    [mc setSubject:emailTitle];
    [mc setMessageBody:messageBody isHTML:NO];
    //[mc setToRecipients:toRecipents];
    [[mc navigationBar] setTintColor:[UIColor whiteColor]];
    [[mc navigationBar] setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    // Present mail view controller on screen
    [self presentViewController:mc animated:YES completion:NULL];

}

- (IBAction)mainMenu:(id)sender {
    //[self performSegueWithIdentifier:@"main" sender:self];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Tableview Delegates
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.carts.count;
};

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CartCell *acell = [tableView dequeueReusableCellWithIdentifier:@"CartCell1" forIndexPath:indexPath];
    acell.delegate = self;
    acell.cart = self.carts[indexPath.row];
//    if (self.carts.count <= 1) {
//        testerViewController * vc =(testerViewController*)self.testerVC;
//        if (vc.isEditing) {
//            acell.lblCartNumber.text = [NSString stringWithFormat:@"Your Cart %lu",[[NSUserDefaults standardUserDefaults] integerForKey:@"workingCurrentCartIndex"] + 1];
//        }else{
//            if(self.isViewingCart) {
//                acell.lblCartNumber.text = [NSString stringWithFormat:@"Your Cart 1"];
//            }else{
//                acell.lblCartNumber.text = [NSString stringWithFormat:@"Your Cart %lu",vc.savedCarts.count + 1];
//            }
//        }
//    }else{
        acell.lblCartNumber.text = [NSString stringWithFormat:@"Your Cart %li",(long)indexPath.row +1 ];

//    }
    acell.editButton.tag = indexPath.row;
    [acell updateProductList];
       return acell;
};

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableDictionary * ar = self.carts[indexPath.row];
    NSMutableArray * crti = [ar objectForKey:@"cartItems"];
    NSMutableArray * nsar  = [[NSMutableArray alloc]init];
    
    for (int x = 0; x < crti.count; x++){
        Item *itm = crti[x];
        
        if ( [itm.type isEqualToString:@"TypeOne"] || [itm.type isEqualToString:@"TypeTwo"] || [itm.type isEqualToString:@"TypeThree"] ) {
            // do nothing
            
        } else {
            if (itm.modelName != nil) {
                if (![nsar containsObject:itm.modelName])
                    [nsar addObject:itm.modelName];
            }
            
        }
        
        
    }
    
      return 230 + (50 * nsar.count);
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 5;
}

#pragma mark - CartCell Delegate
-(void)editCard:(NSMutableDictionary*)cart withIndex:(NSInteger)cartIndex andMonths:(NSNumber *)monthCount {
    
     testerViewController * vc =(testerViewController*)self.testerVC;
    
    int editIndex = 0;
    if ([Add2CartData.sharedAdd2CartData.savedCarts containsObject:cart]) {//exist cart edit
        editIndex = (int)[Add2CartData.sharedAdd2CartData.savedCarts indexOfObject:cart];
        [vc.cartItems removeAllObjects];
        [vc.cartItems addObjectsFromArray:[cart objectForKey:@"cartItems"]];
       
        vc.fastMonth = [monthCount intValue];
        vc.mode = 1;//edit mode
        vc.editingIndex = editIndex;
        [[NSUserDefaults standardUserDefaults] setInteger:editIndex forKey:@"workingCurrentCartIndex"];
        [self.navigationController popViewControllerAnimated:YES];
        
        [self.delegate editCardSelected];
    }else{//edit new cart
        
        vc.mode = 0;
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
};



-(void)save:(NSMutableDictionary*)cart withIndex:(NSInteger)cartIndex andMonths:(NSNumber *)monthCount {
    
    testerViewController * vc =(testerViewController*)self.testerVC;
    
    
    if ([Add2CartData.sharedAdd2CartData.savedCarts containsObject:cart]) {//save existing cart
        vc.fastMonth = [monthCount intValue];
        [Add2CartData.sharedAdd2CartData.savedCarts replaceObjectAtIndex:cartIndex withObject:cart];
        [vc.cartItems removeAllObjects];
        vc.mode = 0;
        [self.delegate saveCartSelected];
    }else {
        
        if (Add2CartData.sharedAdd2CartData.savedCarts.count < 3) {
            [Add2CartData.sharedAdd2CartData.savedCarts addObject:cart];
            [vc.cartItems removeAllObjects];
            
            vc.fastMonth = [monthCount intValue];
            
            int newIndex = [Add2CartData.sharedAdd2CartData.savedCarts count] < 3 ? (int)[Add2CartData.sharedAdd2CartData.savedCarts count] : 2;
            [[NSUserDefaults standardUserDefaults] setInteger:newIndex forKey:@"workingCurrentCartIndex"];
            vc.mode = 0;
            [self.delegate saveCartSelected];
        }
    }
    
    [self.navigationController popViewControllerAnimated:YES];
    
};

-(void)done{
    testerViewController * vc =(testerViewController*)self.testerVC;
    [vc clearCart];
    [self resetRebatesOnHome];
    [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
};

#pragma mark - Reset Rebates on Home
-(void)resetRebatesOnHome {
    for (int i = 0; i < 3; i++) {
        NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"Item" inManagedObjectContext:managedObjectContext];
        NSSortDescriptor *nameSort = [[NSSortDescriptor alloc]initWithKey:@"ord" ascending:YES];
        NSPredicate *cartPredicate = [NSPredicate predicateWithFormat:@"currentCart = %d", i];
        NSArray *sortDescriptors = [[NSArray alloc] initWithObjects:nameSort, nil];
        fetchRequest.sortDescriptors = sortDescriptors;
        [fetchRequest setEntity:entity];
        [fetchRequest setPredicate:cartPredicate];
        
        NSError *fetchingError = nil;
        
        allData = [[NSArray alloc]init];
        allData = [self.managedObjectContext
                   executeFetchRequest:fetchRequest error:&fetchingError];
        
        [self resetAllRebates];
    }
}

-(void)resetAllRebates {
    for (int j = 0; j  < allData.count; j++){
        Item *itm = allData[j];
        if ([itm.type isEqualToString:@"Rebates"]) {
            itm.include = [NSNumber numberWithBool:NO];
        }
    }
    
    NSError *error;
    if (![managedObjectContext save:&error]) {
        NSLog(@"Cannot save ! %@ %@",error,[error localizedDescription]);
    }
}

@end
