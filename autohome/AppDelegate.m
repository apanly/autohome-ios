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

@interface AppDelegate (){
    BOOL isOut;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window=[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    
    
    isOut = NO;
    
    [self makeLaunchView];
    
    
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

//假引导页面
-(void)makeLaunchView{
    NSArray *arr=[NSArray arrayWithObjects:@"lanch.jpeg",@"lanch.jpeg",@"lanch.jpeg",@"lanch.jpeg",@"lanch.jpeg", nil];//数组内存放的是我要显示的假引导页面图片

    UIScrollView *scr=[[UIScrollView alloc] initWithFrame:self.window.bounds];
    scr.contentSize=CGSizeMake(320*arr.count, self.window.frame.size.height);
    scr.pagingEnabled=YES;
    scr.tag=7000;
    scr.delegate=self;
    [self.window addSubview:scr];
    for (int i=0; i<arr.count; i++) {
        UIImageView *img=[[UIImageView alloc] initWithFrame:CGRectMake(i*320, 0, 320, self.window.frame.size.height)];
        img.image=[UIImage imageNamed:arr[i]];
        [scr addSubview:img];
    }
}

#pragma mark scrollView的代理
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    //这里是在滚动的时候判断 我滚动到哪张图片了，如果滚动到了最后一张图片，那么
    //如果在往下面滑动的话就该进入到主界面了，我这里利用的是偏移量来判断的，当
    //一共五张图片，所以当图片全部滑完后 又像后多滑了30 的时候就做下一个动作
    if (scrollView.contentOffset.x>4*320+30) {
        isOut=YES;//这是我声明的一个全局变量Bool 类型的，初始值为no，当达到我需求的条件时将值改为yes
        
    }
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
