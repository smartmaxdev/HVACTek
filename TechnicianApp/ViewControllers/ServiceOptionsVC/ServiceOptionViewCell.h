//
//  ServiceOptionViewCell.h
//  Signature
//
//  Created by Andrei Zaharia on 12/10/14.
//  Copyright (c) 2014 Unifeyed. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HvakTekColorScheme.h"
#import "HealthyHomeSolutionsVC.h"

typedef void (^OnToggleCheckbox)(BOOL selected);

@interface ServiceOptionViewCell : UICollectionViewCell<UITextFieldDelegate>
{
    NSInteger selectedItemIndex;
}
@property (weak, nonatomic) IBOutlet UILabel *lbValue;
@property (weak, nonatomic) IBOutlet UIButton *btnCheckbox;
@property (weak, nonatomic) IBOutlet UITextField *qtyTextField;

@property (nonatomic, copy) OnToggleCheckbox onCheckboxToggle;
@property (nonatomic, strong) HealthyHomeSolutionsVC* parentViewController;
@end
