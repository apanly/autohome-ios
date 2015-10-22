//
//  XunFeiViewController.m
//  autohome
//
//  Created by vincent on 9/3/15.
//  Copyright (c) 2015 vincent. All rights reserved.
//

#import "XunFeiViewController.h"
#import "UIColor+Tools.h"
#import "AppGlobal.h"
#import "iflyMSC/IFlyMSC.h"
#import "IFlyFlowerCollector.h"
#import "XHShockHUD.h"
#import "ISRDataHelper.h"
#import "PopupView.h"

/**
 语音听写demo
 使用该功能仅仅需要四步
 1.创建识别对象；
 2.设置识别参数；
 3.有选择的实现识别回调；
 4.启动识别
 */

@interface XunFeiViewController ()<IFlySpeechRecognizerDelegate>
{
    float height;
    float width;
}
@property(strong,nonatomic) UIView *layout;
@property(strong,nonatomic) UITextView *resultTextView;
@property (nonatomic, strong) NSString * result;
@property (nonatomic, strong) NSString *pcmFilePath;//音频文件路径
@property (nonatomic, strong) IFlySpeechRecognizer *iFlySpeechRecognizer;//不带界面的识别对象
@property (nonatomic, strong) IFlyRecognizerView *iflyRecognizerView;//带界面的识别对象
@property (nonatomic, strong) PopupView *popUpView;
@end

@implementation XunFeiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"讯飞语音测试";
    [self initConstant];
    [self initUI];
    [self initXunFei];
    
    [self.view addSubview:_layout];

}

- (void) initConstant{
    height = self.view.frame.size.height;
    width = self.view.frame.size.width;
}

- (void)initUI {
    _layout = [[UIView alloc] initWithFrame:CGRectMake(0, 64, width, height)];
    //_layout.alpha = 0.5;
    _layout.backgroundColor = [UIColor blackColor];
    
                               
    _resultTextView = [[UITextView alloc] initWithFrame:CGRectMake(0,0,width,200)];
    _resultTextView.editable = NO;
    _resultTextView.selectable = NO;
    _resultTextView.font =  [UIFont systemFontOfSize:17];;
    _resultTextView.textColor = [UIColor whiteColor];
    _resultTextView.backgroundColor = [UIColor blackColor];
    _resultTextView.layer.borderColor = UIColor.grayColor.CGColor;
    _resultTextView.layer.borderWidth = 1.0f;
    _resultTextView.layer.cornerRadius = 3.0f;
    _resultTextView.layer.masksToBounds = YES;
    [_layout addSubview:_resultTextView];
    
    CGFloat posY = _resultTextView.frame.origin.y+_resultTextView.frame.size.height/6;
    _popUpView = [[PopupView alloc] initWithFrame:CGRectMake(100, posY, 0, 0) withParentView:_layout];
    
    
    
    float parentHeight = _resultTextView.frame.size.height;
    
    UIButton *startButton = [[UIButton alloc] initWithFrame:CGRectMake(0, parentHeight, 100, 50)];
    [startButton setTitle:@"开始录音" forState:UIControlStateNormal];
    [startButton addTarget : self action : @selector (startRecord) forControlEvents : UIControlEventTouchUpInside ];
    [_layout addSubview:startButton];
    
    UIButton *stopButton =[[UIButton alloc] initWithFrame:CGRectMake(110, parentHeight, 100, 50)];
    [stopButton setTitle:@"停止录音" forState:UIControlStateNormal];
    [stopButton addTarget : self action : @selector (stopRecode) forControlEvents : UIControlEventTouchUpInside ];
    [_layout addSubview:stopButton];

}

- (void) initXunFei{
    NSString *initString = [[NSString alloc] initWithFormat:@"appid=%@",@"55d9e215"];
    [IFlySpeechUtility createUtility:initString];
}



/**
 设置识别参数
 ****/
-(void)initRecognizer
{
    NSLog(@"%s",__func__);
    
    //单例模式，无UI的实例
    if (_iFlySpeechRecognizer == nil) {
        _iFlySpeechRecognizer = [IFlySpeechRecognizer sharedInstance];
            
        [_iFlySpeechRecognizer setParameter:@"" forKey:[IFlySpeechConstant PARAMS]];
            
            //设置听写模式
        [_iFlySpeechRecognizer setParameter:@"iat" forKey:[IFlySpeechConstant IFLY_DOMAIN]];
    }
    _iFlySpeechRecognizer.delegate = self;
        
    if (_iFlySpeechRecognizer != nil) {
            
        //设置最长录音时间
        [_iFlySpeechRecognizer setParameter:@"30000" forKey:[IFlySpeechConstant SPEECH_TIMEOUT]];
        //设置后端点
        [_iFlySpeechRecognizer setParameter:@"3000" forKey:[IFlySpeechConstant VAD_EOS]];
        //设置前端点
        [_iFlySpeechRecognizer setParameter:@"3000" forKey:[IFlySpeechConstant VAD_BOS]];
        //网络等待时间
        [_iFlySpeechRecognizer setParameter:@"20000" forKey:[IFlySpeechConstant NET_TIMEOUT]];
        
        //设置采样率，推荐使用16K
        [_iFlySpeechRecognizer setParameter:@"16000" forKey:[IFlySpeechConstant SAMPLE_RATE]];
        
        //设置语言
        [_iFlySpeechRecognizer setParameter:@"zh_cn" forKey:[IFlySpeechConstant LANGUAGE]];
        //设置方言
        //[_iFlySpeechRecognizer setParameter:@"mandarin" forKey:[IFlySpeechConstant ACCENT]];
        [_iFlySpeechRecognizer setParameter:@"en_us" forKey:[IFlySpeechConstant ACCENT]];
        
        //设置英语
        //[_iFlySpeechRecognizer setParameter:@"en_us" forKey:[IFlySpeechConstant LANGUAGE]];
        //设置是否返回标点符号
        [_iFlySpeechRecognizer setParameter:@"1" forKey:[IFlySpeechConstant ASR_PTT]];
    }
}

- ( void )startRecord
{
    NSLog(@"start");
    if(_iFlySpeechRecognizer == nil)
    {
        [self initRecognizer];
    }
    
    [_iFlySpeechRecognizer cancel];
    
    //设置音频来源为麦克风
    [_iFlySpeechRecognizer setParameter:IFLY_AUDIO_SOURCE_MIC forKey:@"audio_source"];
    
    //设置听写结果格式为json
    [_iFlySpeechRecognizer setParameter:@"json" forKey:[IFlySpeechConstant RESULT_TYPE]];
    
    //保存录音文件，保存在sdk工作路径中，如未设置工作路径，则默认保存在library/cache下
    [_iFlySpeechRecognizer setParameter:@"asr.pcm" forKey:[IFlySpeechConstant ASR_AUDIO_PATH]];
    
    [_iFlySpeechRecognizer setDelegate:self];
    
    BOOL ret = [_iFlySpeechRecognizer startListening];
    
    if (!ret) {
        [_popUpView showText: @"启动识别服务失败，请稍后重试"];//可能是上次请求未结束，暂不支持多路并发
    }
    
    
}

- ( void )stopRecode{
    NSLog(@"stop");
    [_iFlySpeechRecognizer stopListening];
    [_resultTextView resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IFlySpeechRecognizerDelegate

/**
 音量回调函数
 volume 0－30
 ****/
- (void) onVolumeChanged: (int)volume
{
    
    NSString * vol = [NSString stringWithFormat:@"音量：%d",volume];
    [_popUpView showText: vol];//可能是上次请求未结束，暂不支持多路并发
}



/**
 开始识别回调
 ****/
- (void) onBeginOfSpeech
{
    NSLog(@"正在录音");
    [_popUpView showText: @"正在录音"];
}

/**
 停止录音回调
 ****/
- (void) onEndOfSpeech
{
    NSLog(@"停止录音");
    [_popUpView showText: @"停止录音"];
}


/**
 听写结束回调（注：无论听写是否正确都会回调）
 error.errorCode =
 0     听写正确
 other 听写出错
 ****/
- (void) onError:(IFlySpeechError *) error
{
    //NSLog(@"%s",__func__);
    NSString *text ;
    if (error.errorCode == 0 ) {
        if (_result.length == 0) {
            text = @"无识别结果";
        }else {
            text = @"识别成功";
        }
    }else{
        text = [NSString stringWithFormat:@"发生错误：%d %@", error.errorCode,error.errorDesc];
    }
    [_popUpView showText: text];
    NSLog(@"%@",text);
    
}
/**
 无界面，听写结果回调
 results：听写结果
 isLast：表示最后一次
 ****/
- (void) onResults:(NSArray *) results isLast:(BOOL)isLast
{
    
    NSMutableString *resultString = [[NSMutableString alloc] init];
    NSDictionary *dic = results[0];
    for (NSString *key in dic) {
        [resultString appendFormat:@"%@",key];
    }
    _result =[NSString stringWithFormat:@"%@%@", _resultTextView.text,resultString];
    NSString * resultFromJson =  [ISRDataHelper stringFromJson:resultString];
    _resultTextView.text = [NSString stringWithFormat:@"%@%@", _resultTextView.text,resultFromJson];
    
    if (isLast){
        NSLog(@"听写结果(json)：%@测试",  self.result);
    }
    NSLog(@"_result=%@",_result);
    NSLog(@"resultFromJson=%@",resultFromJson);
    NSLog(@"isLast=%d,_textView.text=%@",isLast,_resultTextView.text);
}

@end
