//
//  APIViewController.m
//  autohome
//
//  Created by vincent on 8/23/15.
//  Copyright (c) 2015 vincent. All rights reserved.
//

#import "APIViewController.h"
#import "AppGlobal.h"
#import "XHShockHUD.h"

@interface APIViewController (){
    float height;
    float width;
    NSString *apiKeyName;
}
@property (strong,nonatomic) UITextField *textAPI;

@end

@implementation APIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"API设置";
    [self initConstant];
    [self initUI];
    // Do any additional setup after loading the view.
}

- (void) initConstant{
    height = [AppGlobal getScreenHeight];
    width = [AppGlobal getScreenWidth];
    apiKeyName = @"api_url";
}

- (void) initUI{
    
    CGRect frame = CGRectMake(5, 10.0 + [AppGlobal getSpanWidth], width -10, 40);
    
    UITextField *textAPI = [[UITextField alloc] initWithFrame:frame];
    
    textAPI.layer.cornerRadius=8.0f;
    textAPI.layer.masksToBounds=YES;
    textAPI.layer.borderColor=[[UIColor grayColor] CGColor];
    textAPI.layer.borderWidth= 1.0f;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 40)];
    textAPI.leftView = paddingView;
    textAPI.leftViewMode = UITextFieldViewModeAlways;
    textAPI.placeholder = @"请输入API网址,不要输入http://";
    
    NSString *api_url = [self getValByKey:apiKeyName];
    if( api_url){
        api_url = [api_url stringByReplacingOccurrencesOfString:@"http://" withString:@""];
        [textAPI setText:api_url ];
    }
    
    self.textAPI = textAPI;
    
    
    frame = CGRectMake(5, 60.0 + [AppGlobal getSpanWidth] , width -10, 40);
    
    UIButton *saveButton = [[UIButton alloc] initWithFrame:frame ];
    [saveButton setTitle:@"保存" forState:UIControlStateNormal];
    //    设置内容字体大小
    saveButton.titleLabel.font = [UIFont systemFontOfSize:18];
    //    设置内容文字的颜色
    [saveButton setTitleColor:[UIColor orangeColor]forState:UIControlStateNormal];
    saveButton.layer.cornerRadius=8.0f;
    saveButton.layer.masksToBounds=YES;
    saveButton.layer.borderColor=[[UIColor grayColor] CGColor];
    saveButton.layer.borderWidth= 1.0f;
    
    [saveButton addTarget:self action:@selector(save:) forControlEvents:UIControlEventTouchUpInside];

    
    [self.view addSubview:textAPI];
    [self.view addSubview:saveButton];
}


- (void)save:(id)sender {
    
    NSString *api_url = _textAPI.text;
    
    NSString *preg_www = @"^([\\w-]+\\.)+[\\w-]+(/[\\w-./?%&=]*)?$";
    
    NSPredicate* preg_wwwTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", preg_www];
    
    if( ![preg_wwwTest evaluateWithObject:api_url] ){
        
        [self.view showHUDWithText:@"API设置网址格式不对\r\n请不要输入http://" hudSize:CGSizeMake(200, 130) hudType:kXHHUDError animationType:kXHHUDFade delay:1.];
        return;
    }
    
    api_url = [@"http://" stringByAppendingString:api_url];
    
    [self setValByKey:@"api_url" val:api_url];
    
    [self.view showHUDWithText:@"设置成功!!" hudSize:CGSizeMake(200, 80) hudType:kXHHUDSuccess animationType:kXHHUDFade delay:1.];

}


- (NSString *) getSettingPath
{
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,YES);
    NSString *ourDocumentPath =[documentPaths objectAtIndex:0];
    
    NSString *filePath =[ourDocumentPath stringByAppendingPathComponent:@"setting"];
    return filePath;
}


- (NSString *) getValByKey:(NSString *) key{
    NSString *ret = nil;
    NSString *filePath =[ self getSettingPath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if( ![fileManager fileExistsAtPath:filePath] ){
        return ret;
    }
    NSMutableDictionary *data=[NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    ret = [data objectForKey:key];
    return ret;
}

- (BOOL) setValByKey:(NSString *) key val:(NSString *) val {
    NSMutableDictionary *setting= nil;
    NSString *filePath =[ self getSettingPath];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if( [fileManager fileExistsAtPath:filePath] ){
        
        setting = [NSMutableDictionary dictionaryWithContentsOfFile:filePath];
    }else{
        
        setting = [NSMutableDictionary dictionaryWithCapacity:1];
    }
    
    [setting setObject:val forKey:key];
    [setting writeToFile:filePath atomically:YES];
    
    return true;
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
