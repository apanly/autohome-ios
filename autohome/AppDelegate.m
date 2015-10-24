//
//  AppDelegate.m
//  autohome
//
//  Created by vincent on 7/9/15.
//  Copyright (c) 2015 vincent. All rights reserved.
//

#import "AppDelegate.h"
#import "HomeViewController.h"
#import "MenuViewController.h"
#import "AFHTTPRequestOperationManager.h"
#import "DataHelper.h"

@import HealthKit;

@interface AppDelegate ()

@property (strong, nonatomic) HKHealthStore *healthStore;
@property (strong, nonatomic) HKSampleType *sampleType;


@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window=[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

    
    // healthkit code
    [self initHealthKit];
    
    
    HomeViewController *homeView = [[HomeViewController alloc] init];
    
    MenuViewController *menuView = [[ MenuViewController alloc] init];
    
    menuView.selectedIndex = 0;
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:homeView];
    
    SlideMenuView *slideMenu = [[ SlideMenuView alloc] initWithRootController:nav];
    
    slideMenu.leftViewController = menuView;
    
    self.slideMenu = slideMenu;
    self.window.rootViewController = slideMenu;
    
    [self.window makeKeyAndVisible];
    
    return YES;
}



#pragma mark  -- health code
- (void) initHealthKit {
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
            //NSLog(@"..HealthKit authorization granted.....");
            // get the preferred units for the quantity types
            [self.healthStore preferredUnitsForQuantityTypes:shareTypes completion:^(NSDictionary *preferredUnits, NSError *error) {
                //NSLog(@"..preferred units.... %@", preferredUnits);
            }];
            
            HKQuantityType *quantityType = [HKObjectType quantityTypeForIdentifier:HKQuantityTypeIdentifierStepCount];
            [self.healthStore enableBackgroundDeliveryForType:quantityType frequency:HKUpdateFrequencyImmediate withCompletion:^(BOOL success, NSError *error)
             {
                 if (success)
                 {
                     [self getStepsData];
                 }
             }];
        }
    }];
}


- (void)getStepsData {
    // observe updates for this quantity type
    HKObserverQuery *query = [[HKObserverQuery alloc] initWithSampleType:self.sampleType predicate:nil updateHandler:^(HKObserverQuery *query, HKObserverQueryCompletionHandler completionHandler,NSError *error) {
        
        if (!error) {
            //NSLog(@"Oberserver fire for .... %@", query.sampleType.identifier);
            [self formatHealthData];
        }
        
        // call if HealthStore.enableBackgroundDelivery is turned on
//        if (completionHandler){
//            NSLog(@"Completed");
//            completionHandler();
//        }
    }];
    
    [self.healthStore executeQuery:query];
}


- (void)formatHealthData {
    
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




- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
