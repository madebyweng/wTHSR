//
//  WebViewController.m
//  wTHSR
//
//  Created by Weng on 2016/7/8.
//  Copyright © 2016年 Milch Mobile LTD. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()
@property (nonatomic, strong) UIWebView *webview;
@end

@implementation WebViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.webview = [[UIWebView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.webview];
    
    NSURLRequest *r = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://madebyweng.github.io/"]];
    [self.webview loadRequest:r];
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
