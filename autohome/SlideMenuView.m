//
//  SlideMenuView.m
//  autohome
//
//  Created by vincent on 7/9/15.
//  Copyright (c) 2015 vincent. All rights reserved.
//

#import "SlideMenuView.h"
#import "HomeViewController.h"
#import "AppGlobal.h"

@interface SlideMenuView ()
@property(nonatomic, strong) UIPanGestureRecognizer *rightSide;
@property(nonatomic, strong) UIPanGestureRecognizer *leftSide;
@property(nonatomic, strong) UITapGestureRecognizer *tap;
@property(nonatomic, assign) CGFloat visibleWidthLeft;
@property(nonatomic, assign) CGPoint startPoint;
@property(nonatomic, assign) BOOL isAnimated;
@end

@implementation SlideMenuView

- (id)initWithRootController:(UIViewController *)rootViewController {
    self = [self init];
    if (self) {
        self.rootViewController = rootViewController;
    }
    //[self initBackground];
    return self;
}

- (id)init {
    self.visibleWidthLeft = [AppGlobal getSpanWidth];
    self.view.backgroundColor = [UIColor whiteColor];
    self = [super init];
    if (self) {
        self.isAnimated = NO;
    }
    return self;
}

- (void)initBackground {
    self.backgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bg.png"]];
    self.backgroundImageView.frame = self.view.frame;
    [self.view insertSubview:self.backgroundImageView atIndex:0];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)addmenuItem {
    UIViewController *homeViewcontroller = nil;
    if ([self.rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)self.rootViewController;
        homeViewcontroller = nav.viewControllers.firstObject;
    }
    UIImage* image= [UIImage imageNamed:@"icon-menu"];
    
    CGRect frame= CGRectMake(0, 0, image.size.width, image.size.height);
    
    UIButton *button = [[UIButton alloc] initWithFrame:frame];
    
    [button setBackgroundImage:image forState:UIControlStateNormal];
    
    [button addTarget:self action:@selector(slideOutAnimate) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    homeViewcontroller.navigationItem.leftBarButtonItem = barItem;
}

- (void)setRootViewController:(UIViewController *)rootViewController {
    if(_rootViewController){
        [_rootViewController.view removeFromSuperview];
        _rootViewController = nil;
    }
    _rootViewController = rootViewController;
    if(self.rootViewController){
        UIView *view = self.rootViewController.view;
        view.frame = self.view.frame;
        [self.view insertSubview:view atIndex:2];
        [self addmenuItem];
    }
    
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    pan.delegate = (id <UIGestureRecognizerDelegate>)self;
    [self.rootViewController.view addGestureRecognizer:pan];
    self.rightSide = pan;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    [self.rootViewController.view addGestureRecognizer:tap];
    self.tap = tap;
    tap.enabled = NO;
    
    UIPanGestureRecognizer *leftSide = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handleleftSide:)];
    leftSide.delegate = (id <UIGestureRecognizerDelegate>)self;
    [self.rootViewController.view addGestureRecognizer:leftSide];
    
    
    self.leftSide = leftSide;
    self.leftSide.enabled = NO;
    if (self.isAnimated) {
        CGRect rect = self.rootViewController.view.frame;
        rect.origin.x = 0;
        rect.origin.y = 0;
        rect.size.height = self.view.bounds.size.height ;
        rect.size.width = self.view.bounds.size.width;
        self.rootViewController.view.transform = CGAffineTransformMakeScale(1, 1);
        self.rootViewController.view.frame = rect;
        [self slideOutAnimate];
    }

    
}

- (void)setLeftViewController:(UIViewController *)leftViewController{
    _leftViewController = leftViewController;
    UIView *view = self.leftViewController.view;
    view.frame = self.view.frame;
    [self.view insertSubview:view atIndex:1];
    CGRect rect = self.leftViewController.view.frame;
    rect.origin.x = 0;
    rect.origin.y = 0;
    rect.size.height  = self.view.bounds.size.height;
    rect.size.height = self.view.bounds.size.width;
    self.leftViewController.view.transform = CGAffineTransformMakeScale(1, 1);
    self.leftViewController.view.frame = rect;
    self.leftViewController.view.alpha = 0;

}

- (void)rootIsSCrolling:(BOOL)isScroll {
    UIViewController *mainViewcontroller = nil;
    if ([self.rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)self.rootViewController;
        mainViewcontroller = nav.viewControllers.firstObject;
        mainViewcontroller.view.userInteractionEnabled = isScroll;
    }
}

- (void)handleleftSide:(UIPanGestureRecognizer *)leftSide {
    CGPoint locationPoint = [leftSide locationInView:self.view];
    CGFloat offsetX = - (locationPoint.x - self.startPoint.x);
    if (leftSide.state == UIGestureRecognizerStateChanged) {
        if (locationPoint.x - self.startPoint.x <= -6) {
            CGFloat leftOffsetX = offsetX * self.visibleWidthLeft / (self.view.bounds.size.width - self.visibleWidthLeft);
            
            CGRect rootRect = self.rootViewController.view.frame;
            rootRect.origin.x = [UIScreen mainScreen].bounds.size.width - self.visibleWidthLeft - offsetX;
            self.rootViewController.view.frame = rootRect;
            self.rootViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
            
            CGRect leftRect = self.leftViewController.view.frame;
            leftRect.origin.x = -leftOffsetX;
            leftRect.origin.y = 0;
            self.leftViewController.view.frame = leftRect;
            self.leftViewController.view.transform = CGAffineTransformMakeScale(1.0,1.0 );
            self.leftViewController.view.alpha = 1.0;
        } else {
            return;
        }
        if (offsetX >= (self.view.bounds.size.width - self.visibleWidthLeft)) {
            leftSide.enabled = NO;
        }
    } else if (leftSide.state == UIGestureRecognizerStateCancelled || leftSide.state == UIGestureRecognizerStateEnded) {

        if (offsetX >= [UIScreen mainScreen].bounds.size.width / 2) {
            CGRect rect = self.rootViewController.view.frame;
            rect.origin.x = 0;
            rect.origin.y = 0;
            rect.size.height = self.view.bounds.size.height;
            rect.size.width =  self.view.bounds.size.width;
            CGRect nextrect = self.leftViewController.view.frame;
            nextrect.origin.x = -self.visibleWidthLeft;
            nextrect.origin.y = 0;
            nextrect.size.height = self.view.bounds.size.height;
            nextrect.size.width = self.view.bounds.size.width;
            [UIView animateWithDuration:.5 animations:^{
                self.rootViewController.view.transform = CGAffineTransformMakeScale(1, 1);
                self.rootViewController.view.frame = rect;
                self.leftViewController.view.transform = CGAffineTransformMakeScale(1, 1);
                self.leftViewController.view.frame = nextrect;
                self.leftViewController.view.alpha = 0;
            } completion:^(BOOL finished) {
                self.isAnimated = !self.isAnimated;
                self.rightSide.enabled = YES;
                self.leftSide.enabled = NO;
                self.tap.enabled = NO;
                [self rootIsSCrolling:YES];
            }];
        } else {
            CGRect rect = self.rootViewController.view.frame;
            rect.origin.x = self.view.bounds.size.width - self.visibleWidthLeft;
            rect.origin.y = 0;
            rect.size.height = self.view.bounds.size.height ;
            rect.size.width = self.view.bounds.size.width ;
            CGRect nextrect = self.leftViewController.view.frame;
            nextrect.origin.x = 0;
            nextrect.origin.y = 0;
            nextrect.size.height = self.view.bounds.size.height;
            nextrect.size.width = self.view.bounds.size.width;
            [UIView animateWithDuration:0.5 animations:^{
                self.rootViewController.view.transform = CGAffineTransformMakeScale(1,1);
                self.rootViewController.view.frame = rect;
                self.leftViewController.view.transform = CGAffineTransformMakeScale(1, 1);
                self.leftViewController.view.frame = nextrect;
                self.leftViewController.view.alpha = 1;
            } completion:^(BOOL finished) {
                self.isAnimated = YES;
                self.leftSide.enabled = YES;
                self.tap.enabled = YES;
                [self rootIsSCrolling:NO];
            }];
        }
    }
}


- (void)handleTap:(UITapGestureRecognizer *)tap {
    if (self.isAnimated) {
        [self slideOutAnimate];
    }
}


- (void)handlePan:(UIPanGestureRecognizer *)pan {
    CGPoint locationPoint = [pan locationInView:self.view];
    CGFloat offsetX = locationPoint.x - self.startPoint.x;
    if (pan.state == UIGestureRecognizerStateChanged) {
        if (locationPoint.x - self.startPoint.x >= 6) {
            
            CGFloat leftOffsetX = offsetX * self.visibleWidthLeft / (self.view.bounds.size.width - self.visibleWidthLeft);
            
            CGRect rootRect = self.rootViewController.view.frame;
            
            rootRect.origin.x = 0;
            
            
            self.rootViewController.view.frame = rootRect;
            self.rootViewController.view.transform = CGAffineTransformMakeScale(1 , 1 );
            
            
            CGRect leftRect = self.leftViewController.view.frame;
            leftRect.origin.x = leftOffsetX - self.visibleWidthLeft;
            leftRect.size.width = self.view.bounds.size.width / 2 + leftOffsetX * self.view.bounds.size.width / 2 / self.visibleWidthLeft;
            self.leftViewController.view.frame = leftRect;
            self.leftViewController.view.transform = CGAffineTransformMakeScale(1 , 1);
            
            self.leftViewController.view.alpha = offsetX/(self.view.bounds.size.width - self.visibleWidthLeft) * 1.0;
        } else {
            return;
        }
        
        if (offsetX >= (self.view.bounds.size.width - self.visibleWidthLeft)) {
            pan.enabled = NO;
        }
        
    } else if (pan.state == UIGestureRecognizerStateEnded || pan.state == UIGestureRecognizerStateCancelled) {
        if (offsetX >= [UIScreen mainScreen].bounds.size.width / 2) {
            CGRect rect = self.rootViewController.view.frame;
            rect.origin.x = self.view.bounds.size.width - self.visibleWidthLeft;
            rect.origin.y = 0;
            rect.size.height = self.view.bounds.size.height;
            rect.size.width = self.view.bounds.size.width;
            
            
            CGRect nextrect = self.leftViewController.view.frame;
            nextrect.origin.x = 0;
            nextrect.origin.y = 0;
            nextrect.size.height = self.view.bounds.size.height;
            nextrect.size.width = self.view.bounds.size.width;
            [UIView animateWithDuration:0.5 animations:^{
                self.rootViewController.view.transform = CGAffineTransformMakeScale(1, 1);
                self.rootViewController.view.frame = rect;
                self.leftViewController.view.transform = CGAffineTransformMakeScale(1, 1);
                self.leftViewController.view.frame = nextrect;
                self.leftViewController.view.alpha = 1;
            } completion:^(BOOL finished) {
                self.isAnimated = YES;
                self.leftSide.enabled = YES;
                self.tap.enabled = YES;
                [self rootIsSCrolling:NO];
            }];
        } else {
            CGRect rect = self.rootViewController.view.frame;
            rect.origin.x = 0;
            rect.origin.y = 0;
            rect.size.height = self.view.bounds.size.height;
            rect.size.width = self.view.bounds.size.width;
            CGRect nextrect = self.leftViewController.view.frame;
            nextrect.origin.x = -self.visibleWidthLeft;
            nextrect.origin.y = self.view.bounds.size.height / 8;
            nextrect.size.height = self.view.bounds.size.height / 4 * 3;
            nextrect.size.width = self.view.bounds.size.width / 2;
            [UIView animateWithDuration:0.5 animations:^{
                self.rootViewController.view.transform = CGAffineTransformMakeScale(1.0, 1.0);
                self.rootViewController.view.frame = rect;
                self.leftViewController.view.transform = CGAffineTransformMakeScale(1, 1);
                self.leftViewController.view.frame = nextrect;
                self.leftViewController.view.alpha = 0;
            } completion:^(BOOL finished) {
                self.isAnimated = NO;
                self.tap.enabled = NO;
            }];
        }
    }
}


- (void)slideOutAnimate {
    if(!self.isAnimated){
        CGRect rect = self.rootViewController.view.frame;
        
        rect.origin.x = [UIScreen mainScreen].bounds.size.width - self.visibleWidthLeft;
        rect.origin.y = 0;
        rect.size.height = self.view.bounds.size.height;
        rect.size.width = self.view.bounds.size.width;
    
        CGRect nextrect = self.leftViewController.view.frame;
        nextrect.origin.x = 0;
        nextrect.origin.y = 0;
        nextrect.size.height = self.view.bounds.size.height;
        nextrect.size.width = self.view.bounds.size.width - self.visibleWidthLeft;

        
        
        [UIView animateWithDuration:.5 animations:^{
            self.rootViewController.view.transform = CGAffineTransformMakeScale(1, 1);
            self.rootViewController.view.frame = rect;
            self.leftViewController.view.transform = CGAffineTransformMakeScale(1, 1);
            self.leftViewController.view.frame = nextrect;
            self.leftViewController.view.alpha = 1.0;
            
        } completion:^(BOOL finished) {
            self.isAnimated = !self.isAnimated;
            self.leftSide.enabled = YES;
            self.tap.enabled = YES;
            [self rootIsSCrolling:NO];
        }];
        
    }else{
        
        CGRect rect = self.rootViewController.view.frame;
        rect.origin.x = 0;
        rect.origin.y = 0;
        rect.size.height = self.view.bounds.size.height;
        rect.size.width =  self.view.bounds.size.width;
        
        CGRect nextrect = self.leftViewController.view.frame;
        nextrect.origin.x = -self.visibleWidthLeft;
        nextrect.origin.y = 0;
        nextrect.size.height = self.view.bounds.size.height;
        nextrect.size.width = self.view.bounds.size.width;
        
        [UIView animateWithDuration:.5 animations:^{
            self.rootViewController.view.transform = CGAffineTransformMakeScale(1, 1);
            self.rootViewController.view.frame = rect;
            self.leftViewController.view.transform = CGAffineTransformMakeScale(1, 1);
            self.leftViewController.view.frame = nextrect;
            self.leftViewController.view.alpha = 0;
            
        } completion:^(BOOL finished) {
            self.isAnimated = !self.isAnimated;
            self.rightSide.enabled = YES;
            self.leftSide.enabled = NO;
            self.tap.enabled = NO;
            [self rootIsSCrolling:YES];
        }];
        
    }
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    self.startPoint = [gestureRecognizer locationInView:self.view];
    if (gestureRecognizer == self.rightSide) {
        if ([self.rootViewController isKindOfClass:[UINavigationController class]]) {
            UINavigationController *nav = (UINavigationController *)self.rootViewController;
            NSArray *viewControllers = nav.viewControllers;
            if (viewControllers.count > 1) {
                return NO;
            }
        }
    }
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
