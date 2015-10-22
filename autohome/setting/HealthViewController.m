//
//  HealthViewController.m
//  autohome
//
//  Created by vincent on 10/21/15.
//  Copyright (c) 2015 vincent. All rights reserved.
//

#import "HealthViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "DataHelper.h"
#import <HealthKit/HKDefines.h>
#import <HealthKit/HKWorkout.h>

@import HealthKit;

@interface HealthViewController ()

@property (strong, nonatomic) NSArray *results;
@property (strong, nonatomic) HKHealthStore *healthStore;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) NSNumberFormatter *numberFormatter;

- (void)refreshData;

@end

@implementation HealthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    // create quantity types we care about
    self.healthStore = [[HKHealthStore alloc] init];
    
    self.sampleType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    [self requestHealthAuth];
    
    [self getStepsData];
}

- (void)requestHealthAuth {
    HKAuthorizationStatus status = [self.healthStore authorizationStatusForType:self.sampleType];
    
    if (status == HKAuthorizationStatusSharingAuthorized) {
        return;
    }
    
    
    HKQuantityType *weight = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBodyMass];
    HKQuantityType *bloodGlucose = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierBloodGlucose];
    HKQuantityType *steps = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
    
    // authorization types
    NSSet *shareTypes = [NSSet setWithObjects:weight, bloodGlucose, steps, nil];

    [self.healthStore requestAuthorizationToShareTypes:shareTypes readTypes:shareTypes completion:^(BOOL success, NSError *error) {
        if (success) {
            NSLog(@"..HealthKit authorization granted.....");
            // get the preferred units for the quantity types
            [self.healthStore preferredUnitsForQuantityTypes:shareTypes completion:^(NSDictionary *preferredUnits, NSError *error) {
                NSLog(@"..preferred units.... %@", preferredUnits);
            }];
        }
    }];
}

- (void)getStepsData {
    // observe updates for this quantity type
    HKObserverQuery *query = [[HKObserverQuery alloc] initWithSampleType:self.sampleType predicate:nil updateHandler:^(HKObserverQuery *query, HKObserverQueryCompletionHandler completionHandler,NSError *error) {
        if (!error) {
            NSLog(@"Oberserver fire for .... %@", query.sampleType.identifier);
            [self refreshData];
        }
        
        // call if HealthStore.enableBackgroundDelivery is turned on
        //        completionHandler();
    }];
    
    [self.healthStore executeQuery:query];
}



#pragma mark - Private methods
- (void)refreshData {
    
    NSDate *date = [NSDate date];
    NSTimeZone *zone = [NSTimeZone systemTimeZone];
    NSInteger interval = [zone secondsFromGMTForDate: date];
    NSDate *localeDate = [date  dateByAddingTimeInterval: interval];

    
    NSSortDescriptor *timeSortDescriptor = [[NSSortDescriptor alloc] initWithKey:HKSampleSortIdentifierEndDate ascending:YES];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"UTC"]];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    
    NSString *todayDate = [dateFormatter stringFromDate:localeDate];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    

    NSDate *startDate =  [dateFormatter dateFromString:[todayDate stringByAppendingString:@" 00:00:00"]];
    
    NSDate *endDate = [dateFormatter dateFromString:[todayDate stringByAppendingString:@" 23:59:59"]];
    
    NSPredicate *predicate = [HKQuery predicateForSamplesWithStartDate:startDate endDate:endDate options:HKQueryOptionNone];
    
    
    HKSampleQuery *query = [[HKSampleQuery alloc] initWithSampleType:self.sampleType predicate:predicate limit:HKObjectQueryNoLimit sortDescriptors:@[timeSortDescriptor] resultsHandler:^(HKSampleQuery *query, NSArray *results, NSError *error) {
        
        if (!error) {
            self.results = results;
            
            [self post2blog:results];
        }else {
            NSLog(@"Error... %@", error);
        }
    }];
    
    [self.healthStore executeQuery:query];
}

- (void)post2blog:(NSArray *)results {
    
    //NSLog(@"Results.....%@", results);
    NSLog(@"Results.....%@", @"start");
    
    int count = results.count;
    HKQuantitySample *sample;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSMutableArray *post_data = [[NSMutableArray alloc]initWithCapacity:5];
    
    for( int i=0; i<count; i++){
        sample = [results objectAtIndex:i];
        NSString *tmp_str = [NSString stringWithFormat:@"%@#%@#%@",sample.quantity,[dateFormatter stringFromDate:sample.startDate],[dateFormatter stringFromDate:sample.endDate]];
        [post_data addObject:tmp_str];
    }
    
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager.requestSerializer setTimeoutInterval:3];  //Time out after 3 seconds
    
    NSString *userAgent = [manager.requestSerializer  valueForHTTPHeaderField:@"User-Agent"];
    userAgent = [userAgent stringByAppendingPathComponent:@" IOS/auto-home_v1.0"];
    
    [manager.requestSerializer setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    //[manager.requestSerializer setValue:@"auto-home_v1.0" forHTTPHeaderField:@"Version"];
    
    NSDictionary *parameters = @{@"data":post_data};
    
    
    [manager POST:[DataHelper getHealthSite] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
