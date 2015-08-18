//
//  SlideMenuView.h
//  autohome
//
//  Created by vincent on 7/9/15.
//  Copyright (c) 2015 vincent. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SlideMenuView : UIViewController
@property(nonatomic, strong) UIViewController *leftViewController;
@property(nonatomic, strong) UIViewController *rootViewController;
@property(nonatomic, strong) UIImageView *backgroundImageView;
- (id)initWithRootController:(UIViewController *)rootViewController;
@end
