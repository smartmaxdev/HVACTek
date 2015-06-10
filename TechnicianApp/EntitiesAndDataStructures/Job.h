//
//  Job.h
//  Signature
//
//  Created by Mihai Tugui on 4/8/15.
//  Copyright (c) 2015 Unifeyed. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface Job : NSManagedObject

@property (nonatomic, retain) NSNumber * amount;
@property (nonatomic, retain) NSDate * completionTime;
@property (nonatomic, retain) NSDate * dispatchTime;
@property (nonatomic, retain) NSDate * endTimeQuestions;
@property (nonatomic, retain) NSString * jobID;
@property (nonatomic, retain) NSNumber * jobStatus;
@property (nonatomic, retain) NSDate * startTime;
@property (nonatomic, retain) NSDate * startTimeQuestions;
@property (nonatomic, retain) id swapiJobInfo;
@property (nonatomic, retain) User *user;

@end