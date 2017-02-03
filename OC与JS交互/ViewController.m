//
//  ViewController.m
//  OC与JS交互
//
//  Created by 梁森 on 17/1/31.
//  Copyright © 2017年 Personal Project. All rights reserved.
//

#import "ViewController.h"
#import <SDWebImage/SDWebImageDownloader.h>
@interface ViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"123");
    // Do any additional setup after loading the view, typically from a nib.
    self.webView.delegate = self;
    NSURL *url = [NSURL URLWithString:@"http://m.dianping.com/tuan/deal/15379196"];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [self.webView loadRequest:request];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    [webView stringByEvaluatingJavaScriptFromString:
          @"var figure = document.getElementsByTagName('figure')[0];"
           "var imgSrc = figure.children[0]; "
           "imgSrc.onclick = function(){window.location.href='aiyou://src='+this.src;};"];
    
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
    if ([request.URL.scheme isEqualToString:@"aiyou"]) {
        NSString *str = request.URL.absoluteString;
        NSRange range = [str rangeOfString:@"aiyou://src="];
        NSString *subStr = [str substringFromIndex:range.location+range.length];
        SDWebImageDownloader *downLoader = [[SDWebImageDownloader alloc] init];
        [downLoader downloadImageWithURL:[NSURL URLWithString:subStr] options:SDWebImageDownloaderProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize, NSURL * _Nullable targetURL) {
            NSLog(@"%ld",receivedSize/expectedSize);
        } completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, BOOL finished) {
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }];
        return NO;
    }
    
    return YES;
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    NSLog(@"完成");
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
