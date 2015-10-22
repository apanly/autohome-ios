//
//  WWWViewController.m
//  autohome
//
//  Created by vincent on 10/4/15.
//  Copyright (c) 2015 vincent. All rights reserved.
//

#import "WWWViewController.h"
#import <MobileCoreServices/UTCoreTypes.h>
#import "AFHTTPRequestOperationManager.h"
#import "AppGlobal.h"
#import "DataHelper.h"
#import <AssetsLibrary/ALAsset.h>
#import <AssetsLibrary/ALAssetsLibrary.h>
#import <AssetsLibrary/ALAssetsGroup.h>
#import <AssetsLibrary/ALAssetRepresentation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CoreMedia.h>
#import <ImageIO/ImageIO.h>
#import "XHShockHUD.h"




@interface WWWViewController (){
    float height;
    float width;

}

@property(strong,nonatomic) UIActivityIndicatorView *indicator;

@end

@implementation WWWViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initConstant];
    [self initUI];
    
    // Do any additional setup after loading the view.
}

- (void)initConstant {
    height = [AppGlobal getScreenHeight];
    width = [AppGlobal getScreenWidth];
    
}

- (void)initUI {
    self.navigationItem.title = @"郭大帅哥的博客";
    self.view.backgroundColor = [UIColor whiteColor];
    _indicator =  [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 100, 80, 80)];
    _indicator.tag = 103;
    //设置显示样式,见UIActivityIndicatorViewStyle的定义
    _indicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    
    //设置背景色
    _indicator.backgroundColor = [UIColor blackColor];
    //设置背景透明
    _indicator.alpha = 0.5;
    
    //设置背景为圆角矩形
    _indicator.layer.cornerRadius = 6;
    _indicator.layer.masksToBounds = YES;
    //设置显示位置
    [_indicator setCenter:CGPointMake(self.view.frame.size.width / 2.0, self.view.frame.size.height / 2.0)];
    [self.view addSubview:_indicator];
    
    
//    CGRect frame = CGRectMake(5, height - 22, width -10, 40);
//    UIButton *selectMediaButton = [[UIButton alloc] initWithFrame:frame ];
//    [selectMediaButton setTitle:@"上传富媒体" forState:UIControlStateNormal];//    设置内容字体大小
//    selectMediaButton.titleLabel.font = [UIFont systemFontOfSize:18];//    设置内容文字的颜色
//    [selectMediaButton setTitleColor:[UIColor orangeColor]forState:UIControlStateNormal];
//    selectMediaButton.layer.cornerRadius=8.0f;
//    selectMediaButton.layer.masksToBounds=YES;
//    selectMediaButton.layer.borderColor=[[UIColor grayColor] CGColor];
//    selectMediaButton.layer.borderWidth= 1.0f;
//    
//    [selectMediaButton addTarget:self action:@selector(selectMedia:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.view addSubview:selectMediaButton];
    
    //用于开关灯操作的button
    UIButton *selectMediaButton=[[ UIButton alloc ] initWithFrame : CGRectMake ( 0 , 0 , 50 , 30 )];
    [selectMediaButton setTitle : @"+上传" forState: UIControlStateNormal ];
    [selectMediaButton setTitleColor :[ UIColor blackColor ] forState : UIControlStateNormal ];
    selectMediaButton.titleLabel . textAlignment = NSTextAlignmentCenter ;
    selectMediaButton.backgroundColor =[ UIColor clearColor ];
    selectMediaButton.titleLabel . font =[ UIFont systemFontOfSize : 16.0 ];
    [selectMediaButton addTarget : self action : @selector (selectMedia:) forControlEvents : UIControlEventTouchUpInside ];
    
    
    UIBarButtonItem *barItem = [[UIBarButtonItem alloc] initWithCustomView:selectMediaButton];
    
    self.navigationItem.rightBarButtonItem = barItem;
    

}

- (void)selectMedia:(id)sender {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;//设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    picker.mediaTypes =  [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage,(NSString *) kUTTypeMovie, nil];
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)openMedia:(id)sender {
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = YES;//设置拍照后的图片可被编辑
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else{
        NSLog(@"模拟其中无法打开照相机,请在真机中使用");
    }
}

//当选择一张图片后进入这里
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info

{

    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    
    
    if ([type  isEqualToString:(NSString*)kUTTypeImage ])//图片
    {
        //先把图片转成NSData
        UIImage* image = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        NSData *data = UIImageJPEGRepresentation(image, 0.8);
        NSString *tmp_file_name = @"/tmp_auto_home.jpg";

        //图片保存的路径
        //这里将图片放在沙盒的documents文件夹中
        NSString * DocumentsPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
        NSFileManager *fileManager = [NSFileManager defaultManager];//文件管理器
        
        [fileManager createDirectoryAtPath:DocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
        [fileManager createFileAtPath:[DocumentsPath stringByAppendingString:tmp_file_name] contents:data attributes:nil];
        //得到选择后沙盒中图片的完整路径
        NSString *filepath = [[NSString alloc]initWithFormat:@"%@%@",DocumentsPath,  tmp_file_name];
        
        
        
        NSURL *imageURL = [info valueForKey:UIImagePickerControllerReferenceURL];
        
        
        ALAssetsLibrary* assetslibrary = [[ALAssetsLibrary alloc] init];
        
        
        [assetslibrary assetForURL:imageURL
                       resultBlock:^(ALAsset *asset) {
                           NSDictionary *imageMetadata = [[NSMutableDictionary alloc] initWithDictionary:asset.defaultRepresentation.metadata];
                           NSDictionary *gpsDic = [imageMetadata objectForKey:(NSString*)kCGImagePropertyGPSDictionary];
                           NSString *gpsJsonString = [self DataTOjsonString:gpsDic];
                           
                           NSDictionary *tiffDic = [imageMetadata objectForKey:(NSString*) kCGImagePropertyTIFFDictionary];
                           NSString *tiffJsonString = [self DataTOjsonString:tiffDic];

                           //NSLog(@"%@",imageMetadata);
                           //ALAssetRepresentation *representation = [myasset defaultRepresentation];
                           //NSString *fileName = [representation filename];
                           //NSLog(@"fileName : %@",fileName);
                           [self uploadMedia:filepath gpsinfo:gpsJsonString tiffinfo:tiffJsonString];
                           
                       }
                      failureBlock:^(NSError *error) {
                          [self uploadMedia:filepath gpsinfo:@"" tiffinfo:@""];
                          
                      }
         ];

        
    }else if ( [type isEqualToString:(NSString*)kUTTypeMovie] ){//视频
        NSURL *videoURL = [info objectForKey:UIImagePickerControllerMediaURL];
        NSString *videoPath = [videoURL path];
        
        AVURLAsset *avAsset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
        NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:avAsset];
        
        NSString *mp4Quality = AVAssetExportPresetMediumQuality;
        
        if ([compatiblePresets containsObject:mp4Quality]){
            AVAssetExportSession *exportSession = [[AVAssetExportSession alloc]initWithAsset:avAsset presetName:mp4Quality];
                                                   
            NSString *mp4Path = [NSHomeDirectory() stringByAppendingFormat:@"/Documents/tmp_auto_home.mp4"];
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            
            if( [fileManager fileExistsAtPath:mp4Path] ){
                NSError *err;
                [fileManager removeItemAtPath:mp4Path error:&err];
            }

            
            exportSession.outputURL = [NSURL fileURLWithPath: mp4Path];
            exportSession.shouldOptimizeForNetworkUse = TRUE;
            exportSession.outputFileType = AVFileTypeMPEG4;
            [exportSession exportAsynchronouslyWithCompletionHandler:^{
                switch ([exportSession status]) {
                    case AVAssetExportSessionStatusFailed:
                    {
                        NSLog(@"error");
                        break;
                    }
                        
                    case AVAssetExportSessionStatusCancelled:
                        NSLog(@"Export canceled");
                        break;
                    case AVAssetExportSessionStatusCompleted:
                        NSLog(@"Successful!");
                        [self uploadMedia:mp4Path gpsinfo:@"" tiffinfo:@""];

                        break;
                    default:
                        break;
                }
                
            }];
            
        }
        //NSData *data = [NSData dataWithContentsOfFile:videoPath];
    }
    
    
    [picker dismissViewControllerAnimated:YES completion:nil];//关闭相册界面
    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    NSLog(@"您取消了选择图片");
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)uploadMedia:(NSString *)filepath gpsinfo:(NSString *)gpsinfo tiffinfo:(NSString *)tiffinfo  {
    
    [self.view showHUDWithText:@"开始上传富媒体" hudSize:CGSizeMake(200, 130) hudType:kXHHUDInfo animationType:kXHHUDFade delay:1.];
    
    //开始显示Loading动画
    [_indicator startAnimating];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager.requestSerializer setTimeoutInterval:60];  //Time out after 3 seconds
    
    NSString *userAgent = [manager.requestSerializer  valueForHTTPHeaderField:@"User-Agent"];
    userAgent = [userAgent stringByAppendingPathComponent:@" IOS/auto-home_v1.0"];
    
    [manager.requestSerializer setValue:userAgent forHTTPHeaderField:@"User-Agent"];

    NSDictionary *parameters = @{@"token": @"JRf7gJmxzFm7Uu5X",@"gps":gpsinfo,@"tiff":tiffinfo};
    
    [manager POST:[DataHelper getApiUploadMediaUrl] parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //[formData appendPartWithFileData:UIImagePNGRepresentation(image) name:@"file" fileName:fileName mimeType:@"image/png"];
        //[formData appendPartWithFileURL:[NSURL fileURLWithPath:filepath] name:@"richmeida" fileName:@"testImage" mimeType:@"image/png" error:nil];
        //[formData appendPartWithFileURL:upload_file name:@"richmeida" error:nil];
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:filepath] name:@"richmedia" error:nil];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [_indicator stopAnimating];
        
        NSString *html = operation.responseString;
        NSData* data=[html dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary* json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        
        if (json == nil) {
            [self.view showHUDWithText:@"系统繁忙请稍后再试" hudSize:CGSizeMake(200, 130) hudType:kXHHUDError animationType:kXHHUDFade delay:1.];
            return;
        }
        
        int res_code = [[json objectForKey:@"code"] intValue];
        if (res_code  == 200) {
            NSString *msg  = [json objectForKey:@"msg"];
            NSDictionary *ret  = [json objectForKey:@"data"];
            [self.view showHUDWithText:msg hudSize:CGSizeMake(200, 130) hudType:kXHHUDSuccess animationType:kXHHUDFade delay:1.];
        }else{
            NSString *msg  = [json objectForKey:@"msg"];
            [self.view showHUDWithText:msg hudSize:CGSizeMake(200, 130) hudType:kXHHUDError animationType:kXHHUDFade delay:1.];
            NSLog(msg);
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [_indicator stopAnimating];
        [self.view showHUDWithText:[error localizedDescription] hudSize:CGSizeMake(200, 130) hudType:kXHHUDError animationType:kXHHUDFade delay:1.];
        //NSLog(@"Error: %@", error);
    }];
}

/*
将dic转化成json
*/

-(NSString*)DataTOjsonString:(id)object
{
    NSString *jsonString = @"";
    NSError *error;
    
    if( !object ){
        return  jsonString;
    }
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:object
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
        return  jsonString;
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

/*
 //将图片的exif信息写入到图片流
 -(NSData *)saveImageWithImageData:(NSData *)data Properties:(NSDictionary *)properties {
 
 NSMutableDictionary *dataDic=[NSMutableDictionary dictionaryWithDictionary:properties];
 //修改图片Orientation
 dataDic[(NSString *)kCGImagePropertyOrientation]=[NSNumber numberWithInt:kCGImagePropertyOrientationUp];
 
 //设置properties属性
 CGImageSourceRef imageRef =CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
 CFStringRef uti=CGImageSourceGetType(imageRef);
 
 NSMutableData *data1=[NSMutableData data];
 CGImageDestinationRef destination=CGImageDestinationCreateWithData((__bridge CFMutableDataRef)data1, uti, 1, NULL);
 if (!destination) {
 NSLog(@"error");
 return nil;
 }
 
 CGImageDestinationAddImageFromSource(destination, imageRef, 0, (__bridge CFDictionaryRef)dataDic);
 BOOL check=CGImageDestinationFinalize(destination);
 if (!check) {
 NSLog(@"error");
 return nil;
 }
 CFRelease(destination);
 CFRelease(uti);
 
 return data1;
 }
 */

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
