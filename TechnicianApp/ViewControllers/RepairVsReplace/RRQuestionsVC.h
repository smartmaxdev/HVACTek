//
//  RRQuestionsVC.h
//  Signature
//
//  Created by Dorin on 12/8/15.
//  Copyright © 2015 Unifeyed. All rights reserved.
//

#import "BaseVC.h"

@interface RRQuestionsVC : BaseVC

@property (nonatomic, assign) QuestionType  questionType;
@property(nonatomic, strong) NSMutableArray *questionsArray;

@end
