//
//  HealthViewController.h
//  autohome
//
//  Created by vincent on 10/21/15.
//  Copyright (c) 2015 vincent. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HKSampleType, HKUnit;

@interface HealthViewController : UIViewController

@property (strong, nonatomic) HKSampleType *sampleType;
@property (strong, nonatomic) HKUnit *preferredUnit;

@end
