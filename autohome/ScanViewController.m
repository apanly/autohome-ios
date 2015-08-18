//
//  ScanViewController.m
//  autohome
//
//  Created by vincent on 8/16/15.
//  Copyright (c) 2015 vincent. All rights reserved.
//
#import "AppDelegate.h"
#import "ScanViewController.h"
#import "HomeViewController.h"
#import "ZBarSDK.h"

static float marginTop = 65;
static float toolBarHeight  = 40;
static float width = 0;
static float height = 0;


@interface ScanViewController (){
    int counter ;
    NSString *code_type;
}

@property (strong, nonatomic) UIImageView *resultImage;
@property (strong,nonatomic) UITextView *resultText;
@property (strong,nonatomic) NSString *code;
@end

@implementation ScanViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"二维码/条形码";
    self.view.backgroundColor = [UIColor whiteColor];
    [self initConstant];
    [self initUI];
    
}

- (void)initConstant{
    counter = 0;
    width = self.view.frame.size.width;
    height = self.view.frame.size.height;
}


- (void)initUI {
    
    UIButton *buttonScan = [[UIButton alloc] initWithFrame:CGRectMake(0 , 0, 50, 30)];
    [buttonScan setTitle:@"扫码" forState:UIControlStateNormal];
    [buttonScan setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    [buttonScan addTarget:self action:@selector(scan:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:buttonScan];
    
    self.navigationItem.rightBarButtonItem = barItem;
    
    
    UIImageView *resultImage = [[UIImageView alloc] initWithFrame:CGRectMake(0 , marginTop, width, height - toolBarHeight - marginTop - 100)];
    CALayer *lay  = resultImage.layer;//获取ImageView的层
    lay.borderColor = [[UIColor grayColor] CGColor];
    lay.borderWidth = 1.0f;
    
    [lay setMasksToBounds:YES];
    [lay setCornerRadius:3.0];//值越大，角度越圆
    self.resultImage = resultImage;
    [self.view addSubview:resultImage];
    
    UITextView * resultText = [ [UITextView alloc] initWithFrame:CGRectMake(0, resultImage.frame.size.height + marginTop, width, 100)];
    
    resultText.editable = NO;
    resultText.selectable = NO;
    resultText.layer.borderColor = UIColor.grayColor.CGColor;
    resultText.layer.borderWidth = 1.0f;
    resultText.layer.cornerRadius = 3.0f;
    resultText.layer.masksToBounds = YES;
    self.resultText = resultText;
    [self appendResult:@"请点击右上角的扫码"];
    [self.view addSubview:resultText];

    
    UIButton *buttonSave = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, width, 30 )];
    [buttonSave setTitle:@"提交到我的图书馆" forState:UIControlStateNormal];
    [buttonSave setTitleColor:[UIColor blackColor]forState:UIControlStateNormal];
    [buttonSave addTarget:self action:@selector(submit:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIToolbar *toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, height - toolBarHeight, width, toolBarHeight) ];
    
    UIBarButtonItem *itemRight = [[UIBarButtonItem alloc] initWithCustomView:buttonSave];
    
    [toolBar setItems:[NSArray arrayWithObjects:itemRight, nil] animated:YES];
    
    [self.view addSubview:toolBar];
}

- (void)appendResult:(NSString *) res{
    [self.resultText insertText:[res stringByAppendingString:@"\n"]];
    [self.resultText scrollRectToVisible:CGRectMake(0, self.resultText.contentSize.height-15, self.resultText.contentSize.width, 10) animated:YES];
}

- (void)clearResult{
    [self.resultText setText:@""];
}

- (void)submit:(id)sender{    
    if (self.code == nil) {
        [self appendResult:@"请先扫码之后在提交!"];
        return;
    }
    
    // 1.设置请求路径
    NSURL *URL=[NSURL URLWithString:@"http://blog.dr.local.com/library/scan"];//不需要传递参数
    
    //    2.创建请求对象
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:URL];//默认为get请求
    request.timeoutInterval=5.0;//设置请求超时为5秒
    request.HTTPMethod=@"POST";//设置请求方法
    
    //设置请求体
    NSString *param=[NSString stringWithFormat:@"isbn=%@&type=%@",self.code,code_type];
    [self appendResult:[@"准备提交到我的图书馆!\n参数:" stringByAppendingString:param]];
    //把拼接后的字符串转换为data，设置请求体
    request.HTTPBody=[param dataUsingEncoding:NSUTF8StringEncoding];
    
    //客户端类型，只能写英文
    [request setValue:@"IOS/auto-home" forHTTPHeaderField:@"User-Agent"];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
    
}


- (void)scan:(id)sender {
    
    /*扫描二维码部分：
     导入ZBarSDK文件并引入一下框架
     AVFoundation.framework
     CoreMedia.framework
     CoreVideo.framework
     QuartzCore.framework
     libiconv.dylib
     引入头文件#import “ZBarSDK.h” 即可使用
     当找到条形码时，会执行代理方法
     
     - (void) imagePickerController: (UIImagePickerController*) reader didFinishPickingMediaWithInfo: (NSDictionary*) info
     
     最后读取并显示了条形码的图片和内容。*/
    
    NSLog(@"%i",counter);
    if (counter > 3) {
        [self clearResult];
        counter = 0;
    }
    
    [self appendResult:@"准备扫码"];
    
    ZBarReaderViewController *reader = [ZBarReaderViewController new];
    reader.readerDelegate = self;
    reader.supportedOrientationsMask = ZBarOrientationMaskAll;
    reader.showsZBarControls = YES;
    
    ZBarImageScanner *scanner = reader.scanner;
    
    [scanner setSymbology: ZBAR_I25
                   config: ZBAR_CFG_ENABLE
                       to: 0];
    
    [self presentViewController:reader animated:YES completion:nil];

    
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    id<NSFastEnumeration> results = [info objectForKey:ZBarReaderControllerResults];
    
    ZBarSymbol * symbol;
    for(symbol in results)
        break;
    
    self.resultImage.image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    self.code = symbol.data;
    
    NSString *type = @"EAN13";
    
    switch (symbol.type) {
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
    
    NSString *result = [NSString stringWithFormat:@"扫码结果:%@,类型:%@",self.code, type];
    [self appendResult:result];
}




- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{

}

// 当收到服务器返回的数据时触发, 返回的可能是资源片段
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    if (json == nil) {
        [self appendResult:@"系统繁忙请稍后再试\n"];
        return;
    }
    
    int code = [[json objectForKey:@"code"] intValue];
    
    
    if (code  == 200) {
        NSDictionary *ret  = [json objectForKey:@"data"];
        [self appendResult:[@"书籍名称:\n" stringByAppendingString:[ret objectForKey:@"name"]]];
    }else{
        NSString *msg  = [json objectForKey:@"msg"];
        [self appendResult:[@"服务端返回错误\n" stringByAppendingString:msg]];
    }
    counter++;
}

// 当服务器返回所有数据时触发, 数据返回完毕
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{

}


// 请求数据失败时触发
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSString *result = [NSString stringWithFormat:@"提交失败!!\r\n%@",[error localizedDescription]];
    [self appendResult:result];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
