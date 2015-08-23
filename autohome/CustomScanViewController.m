//
//  CustomScanViewController.m
//  autohome
//
//  Created by vincent on 8/21/15.
//  Copyright (c) 2015 vincent. All rights reserved.
//

#import "CustomScanViewController.h"
#import "UIColor+Tools.h"
#import "AFHTTPRequestOperationManager.h"
#import "DataHelper.h"


#define SCANVIEW_EdgeTop 40.0

#define SCANVIEW_EdgeLeft 50.0


#define TINTCOLOR_ALPHA 0.2 //浅色透明度

#define DARKCOLOR_ALPHA 0.5 //深色透明度

static float VIEW_WIDTH = 0;
static float VIEW_HEIGHT = 0;



@interface CustomScanViewController ()<ZBarReaderViewDelegate>{
    UIView *_QrCodeline;
    
    NSTimer *_timer;
    //设置扫描画面
    UIView *_scanView;
    
    ZBarReaderView *_readerView;
    NSString *code;
    NSString *code_type;
    int counter ;
}

@property (strong,nonatomic) UITextView *resultText;

@end

@implementation CustomScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initConstant];
    [ self initUI];
    [ self setScanView ];
    _readerView = [[ ZBarReaderView alloc ] init ];
    _readerView . frame = CGRectMake ( 0 , 64 , VIEW_WIDTH , VIEW_HEIGHT - 64 );
    _readerView . tracksSymbols = NO ;
    _readerView . readerDelegate = self ;
    [ _readerView addSubview : _scanView ];
    //关闭闪光灯
    _readerView . torchMode = 0 ;
    [ self . view addSubview : _readerView ];
    //扫描区域
    //readerView.scanCrop =
    [ _readerView start ];
    [ self createTimer ];
}

- (void)initConstant{
    counter = 0;
    self.navigationItem.title = @"二维码/条形码";
    self.view.backgroundColor = [UIColor whiteColor];
    VIEW_WIDTH = self.view.frame.size.width;
    VIEW_HEIGHT = self.view.frame.size.height;
}

- (void) initUI{
    
    //用于开关灯操作的button
    UIButton *openButton=[[ UIButton alloc ] initWithFrame : CGRectMake ( 0 , 0 , 50 , 30 )];
    [openButton setTitle : @"闪光" forState: UIControlStateNormal ];
    [openButton setTitleColor :[ UIColor blackColor ] forState : UIControlStateNormal ];
    openButton.titleLabel . textAlignment = NSTextAlignmentCenter ;
    openButton.backgroundColor =[ UIColor clearColor ];
    openButton.titleLabel . font =[ UIFont systemFontOfSize : 16.0 ];
    [openButton addTarget : self action : @selector (openLight) forControlEvents : UIControlEventTouchUpInside ];

    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:openButton];
    
    self.navigationItem.rightBarButtonItem = barItem;
}

- (void)appendResult:(NSString *) res
{
    [self.resultText insertText:[res stringByAppendingString:@"\n"]];
    [self.resultText scrollRectToVisible:CGRectMake(0, self.resultText.contentSize.height - 20, self.resultText.contentSize.width, 20) animated:YES];
}

- (void)clearResult
{
    [self.resultText setText:@""];
}

- (void) sendScanResult
{
    if (code == nil || code_type == nil) {
        [self appendResult:@"请先扫码之后在提交!"];
        return;
    }
    
    [self appendResult:@"准备提交到我的图书馆"];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    
    [manager.requestSerializer setTimeoutInterval:3];  //Time out after 3 seconds
    
    NSString *userAgent = [manager.requestSerializer  valueForHTTPHeaderField:@"User-Agent"];
    userAgent = [userAgent stringByAppendingPathComponent:@" IOS/auto-home_v1.0"];
    
    [manager.requestSerializer setValue:userAgent forHTTPHeaderField:@"User-Agent"];
    //[manager.requestSerializer setValue:@"auto-home_v1.0" forHTTPHeaderField:@"Version"];
    
    NSDictionary *parameters = @{@"isbn":code,@"type": code_type};
    counter++;
    [self appendResult:[DataHelper getApiLibrarySite]];
    
    [manager POST:[DataHelper getApiLibrarySite] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"JSON: %@", responseObject);
        
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        if (json == nil) {
            [self appendResult:@"系统繁忙请稍后再试\n"];
            return;
        }
        
        int res_code = [[json objectForKey:@"code"] intValue];
        
        
        if (res_code  == 200) {
            NSDictionary *ret  = [json objectForKey:@"data"];
            [self appendResult:[@"书籍名称:" stringByAppendingString:[ret objectForKey:@"name"]]];
        }else{
            NSString *msg  = [json objectForKey:@"msg"];
            [self appendResult:[@"服务端返回错误:" stringByAppendingString:msg]];
        }
        [self restartTimer];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self appendResult:[@"错误:" stringByAppendingString:error.localizedDescription]];
        [self restartTimer];
    }];

}

#pragma mark -- ZBarReaderViewDelegate
-( void )readerView:( ZBarReaderView *)readerView didReadSymbols:( ZBarSymbolSet *)symbols fromImage:( UIImage *)image
{
    
    if (counter > 3) {
        [self clearResult];
        counter = 0;
    }
    

    [self pauseTimer];
    const zbar_symbol_t *symbol = zbar_symbol_set_first_symbol (symbols. zbarSymbolSet );
    
    code  = [ NSString stringWithUTF8String : zbar_symbol_get_data (symbol)];
    
    NSString *type = @"EAN13";
    switch (zbar_symbol_get_type(symbol)) {
        case ZBAR_QRCODE://二维码
            type = @"QRCODE";
            break;
        case ZBAR_EAN13://
            type = @"EAN13";
            break;
        case ZBAR_ISBN13:
            type = @"ISBN13";
            break;
        default:
            break;
    }
    code_type = type;
    UIPasteboard *pasteboard=[ UIPasteboard generalPasteboard ];
    //然后，可以使用如下代码来把一个字符串放置到剪贴板上：
    pasteboard.string = code;
    
    [self appendResult:[NSString stringWithFormat:@"扫码结果:%@,类型:%@",code, type]];
    
    [self sendScanResult];
    
}
//二维码的扫描区域
- ( void )setScanView
{
    _scanView =[[ UIView alloc ] initWithFrame : CGRectMake ( 0 , 0 , VIEW_WIDTH , VIEW_HEIGHT - 64 )];
    _scanView . backgroundColor =[ UIColor clearColor ];
    //最上部view
    UIView * upView = [[ UIView alloc ] initWithFrame : CGRectMake ( 0 , 0 , VIEW_WIDTH , SCANVIEW_EdgeTop )];
    upView. alpha = TINTCOLOR_ALPHA ;
    upView. backgroundColor = [ UIColor blackColor ];
    [ _scanView addSubview :upView];
    //左侧的view
    UIView *leftView = [[ UIView alloc ] initWithFrame : CGRectMake ( 0 , SCANVIEW_EdgeTop , SCANVIEW_EdgeLeft , VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft )];
    leftView. alpha = TINTCOLOR_ALPHA ;
    leftView. backgroundColor = [ UIColor blackColor ];
    [ _scanView addSubview :leftView];
    /******************中间扫描区域****************************/
    UIImageView *scanCropView=[[ UIImageView alloc ] initWithFrame : CGRectMake ( SCANVIEW_EdgeLeft , SCANVIEW_EdgeTop , VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft , VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft )];
    //scanCropView.image=[UIImage imageNamed:@""];
    scanCropView. layer . borderColor =[ UIColor getThemeColor ].CGColor ;
    scanCropView. layer . borderWidth = 2.0 ;
    scanCropView. backgroundColor =[ UIColor clearColor ];
    [ _scanView addSubview :scanCropView];
    //右侧的view
    UIView *rightView = [[ UIView alloc ] initWithFrame : CGRectMake ( VIEW_WIDTH - SCANVIEW_EdgeLeft , SCANVIEW_EdgeTop , SCANVIEW_EdgeLeft , VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft )];
    rightView. alpha = TINTCOLOR_ALPHA ;
    rightView. backgroundColor = [ UIColor blackColor ];
    [ _scanView addSubview :rightView];
    
    
    //底部view
    UIView *downView = [[ UIView alloc ] initWithFrame : CGRectMake ( 0 , VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft + SCANVIEW_EdgeTop , VIEW_WIDTH , VIEW_HEIGHT -( VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft + SCANVIEW_EdgeTop )- 64 )];
    //downView.alpha = TINTCOLOR_ALPHA;
    downView. backgroundColor = [[ UIColor blackColor ] colorWithAlphaComponent : TINTCOLOR_ALPHA ];
    [ _scanView addSubview :downView];
    //用于说明的label
    UILabel *labIntroudction= [[ UILabel alloc ] init ];
    labIntroudction. backgroundColor = [ UIColor clearColor ];
    labIntroudction. frame = CGRectMake ( 0 , 5 , VIEW_WIDTH , 20 );
    labIntroudction. numberOfLines = 1 ;
    labIntroudction. font =[ UIFont systemFontOfSize : 15.0 ];
    labIntroudction. textAlignment = NSTextAlignmentCenter ;
    labIntroudction. textColor =[ UIColor whiteColor ];
    labIntroudction. text = @"将二维码对准方框，即可自动扫描" ;
    [downView addSubview :labIntroudction];
    
    float darkHeight = downView. frame . size . height - labIntroudction.frame.size.height;
    
    UIView *darkView = [[ UIView alloc ] initWithFrame : CGRectMake ( 0 , labIntroudction.frame.size.height + 15, VIEW_WIDTH , darkHeight )];
    darkView. backgroundColor = [[ UIColor blackColor ]  colorWithAlphaComponent : DARKCOLOR_ALPHA ];
    [downView addSubview :darkView];
    
//    
//    //用于开关灯操作的button
//    UIButton *openButton=[[ UIButton alloc ] initWithFrame : CGRectMake ( 10 , 20 , 300.0 , 40.0 )];
//    [openButton setTitle : @"开启闪光灯" forState: UIControlStateNormal ];
//    [openButton setTitleColor :[ UIColor whiteColor ] forState : UIControlStateNormal ];
//    openButton. titleLabel . textAlignment = NSTextAlignmentCenter ;
//    openButton. backgroundColor =[ UIColor getThemeColor ];
//    openButton. titleLabel . font =[ UIFont systemFontOfSize : 22.0 ];
//    [openButton addTarget : self action : @selector (openLight) forControlEvents : UIControlEventTouchUpInside ];
//    [darkView addSubview :openButton];
    
    UITextView * resultText = [ [UITextView alloc] initWithFrame:CGRectMake(0, 0, VIEW_WIDTH, darkHeight)];
    resultText.textColor = [ UIColor getThemeColor ];
    resultText.font = [ UIFont systemFontOfSize : 18.0 ];
    resultText.editable = NO;
    resultText.selectable = NO;
    resultText.backgroundColor = [[ UIColor blackColor ]  colorWithAlphaComponent : DARKCOLOR_ALPHA ];
    resultText.layer.cornerRadius = 3.0f;
    resultText.layer.masksToBounds = YES;
    self.resultText = resultText;
    [darkView addSubview:resultText];
    //画中间的基准线
    _QrCodeline = [[ UIView alloc ] initWithFrame : CGRectMake ( SCANVIEW_EdgeLeft , SCANVIEW_EdgeTop , VIEW_WIDTH - 2 * SCANVIEW_EdgeLeft , 2 )];
    _QrCodeline . backgroundColor = [ UIColor getThemeColor ];
    [ _scanView addSubview : _QrCodeline ];
    
    [self appendResult:@"准备扫描"];
}

- ( void )openLight
{
    if ( _readerView . torchMode == 0 ) {
        _readerView . torchMode = 1 ;
    } else
    {
        _readerView . torchMode = 0 ;
    }
}

- ( void )viewWillDisappear:( BOOL )animated
{
    [ super viewWillDisappear :animated];
    if ( _readerView . torchMode == 1 ) {
        _readerView . torchMode = 0 ;
    }
    [ self stopTimer ];
    [ _readerView stop ];
}
//二维码的横线移动
- ( void )moveUpAndDownLine
{
    CGFloat Y= _QrCodeline . frame . origin . y ;
    //CGRectMake(SCANVIEW_EdgeLeft, SCANVIEW_EdgeTop, VIEW_WIDTH-2*SCANVIEW_EdgeLeft, 1)]
    if (VIEW_WIDTH- 2 *SCANVIEW_EdgeLeft+SCANVIEW_EdgeTop==Y){
        [UIView beginAnimations: @"asa" context: nil ];
        [UIView setAnimationDuration: 1 ];
        _QrCodeline.frame=CGRectMake(SCANVIEW_EdgeLeft, SCANVIEW_EdgeTop, VIEW_WIDTH- 2 *SCANVIEW_EdgeLeft, 1 );
        [UIView commitAnimations];
    } else if (SCANVIEW_EdgeTop==Y){
        [UIView beginAnimations: @"asa" context: nil ];
        [UIView setAnimationDuration: 1 ];
        _QrCodeline.frame=CGRectMake(SCANVIEW_EdgeLeft, VIEW_WIDTH- 2 *SCANVIEW_EdgeLeft+SCANVIEW_EdgeTop, VIEW_WIDTH- 2 *SCANVIEW_EdgeLeft, 1 );
        [UIView commitAnimations];
    }
}
- ( void )createTimer
{
    //创建一个时间计数
    _timer=[NSTimer scheduledTimerWithTimeInterval: 1.0 target: self selector: @selector (moveUpAndDownLine) userInfo: nil repeats: YES ];
}

- (void) pauseTimer
{
    [_timer setFireDate:[NSDate distantFuture]];
}

- (void) restartTimer
{
    [_timer setFireDate:[NSDate distantPast]];
}

- ( void )stopTimer
{
    if ([_timer isValid] == YES ) {
        [_timer invalidate];
        _timer = nil ;
    }
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
