//
//  QuestionSummaryCell.m
//  Signature
//
//  Created by Iurie Manea on 1/9/15.
//  Copyright (c) 2015 Unifeyed. All rights reserved.
//

#import "QuestionSummaryCell.h"

@implementation QuestionSummaryCell

- (void)awakeFromNib {

    [super awakeFromNib];
    
    self.backgroundColor = [UIColor clearColor];
    self.selectedBackgroundView = [UIView new];
    // Initialization code
//    self.backgroundColor                = [UIColor clearColor];
//    self.backgroundView.backgroundColor = [UIColor clearColor];
//    self.contentView.backgroundColor    = [UIColor clearColor];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end