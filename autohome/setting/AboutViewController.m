//
//  AboutViewController.m
//  autohome
//
//  Created by vincent on 8/23/15.
//  Copyright (c) 2015 vincent. All rights reserved.
//

#import "AboutViewController.h"
#import "AppGlobal.h"

@interface AboutViewController ()<UIWebViewDelegate>{
    UIWebView *webView;
    float width;
    float height;
}

@end

@implementation AboutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"联系我";
    
    width = [AppGlobal getScreenWidth];
    height = [AppGlobal getScreenHeight];
    
    webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, width, height + [AppGlobal getStatusBarHeight])];
    NSURLRequest *request =[NSURLRequest requestWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
    
    webView.delegate = self;
    [webView loadRequest:request];
    
    [self.view addSubview: webView];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {

    [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"WebKitCacheModelPreferenceKey"];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitDiskImageCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"WebKitOfflineWebApplicationCacheEnabled"];//自己添加的，原文没有提到。
    [[NSUserDefaults standardUserDefaults] synchronize];
}


- ( void )viewWillDisappear:( BOOL )animated
{
    [webView loadRequest:nil];
    [webView removeFromSuperview];
    webView = nil;
    webView.delegate = nil;
    [webView stopLoading];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
