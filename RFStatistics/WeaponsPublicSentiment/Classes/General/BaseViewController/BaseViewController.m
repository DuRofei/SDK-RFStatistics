//
//  BaseViewController.h
//  CNTVPublicSentiment
//
//  Created by wiseweb on 16/11/9.
//  Copyright © 2016年 wiseweb. All rights reserved.
//

#import "BaseViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "MBProgressHUD+NJ.h"

@interface BaseViewController () {
    UIView *customMessage;
    UILabel *customMessageLabel;
    NSTimer *customMessage_timer;
    UIView *headView;
    UIButton *btn_back;
    UIApplication *app;
}
@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)requestWithPara:(NSMutableDictionary *)para path:(NSString *)path method:(NSString *)method tag:(NSInteger)tag {
    if (![path hasPrefix:@"findAppKey.action"]) {
        app = [ UIApplication  sharedApplication ];
        app.networkActivityIndicatorVisible = YES;
    }
    
    NSString *url = [HostUrl stringByAppendingString:path];
    NSLog(@"url =====>>>>>%@",url);
    NSLog(@"para =====>>>>>%@",para);
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setTimeoutInterval:10];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    __weak typeof(self)weakself = self;
    if ([method isEqualToString:kGET]) {
        [manager GET:url parameters:para progress:^(NSProgress * _Nonnull downloadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [weakself requestFinish:responseObject tag:tag];
            app.networkActivityIndicatorVisible = NO;
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [weakself performDismiss];
            [weakself showTextMessage:@"请检查网络后重试"];
            [weakself requestFail:error tag:tag];
            app.networkActivityIndicatorVisible = NO;
//            NSLog(@"error = %@",error);
        }];
    } else if ([method isEqualToString:kPOST]){
        [manager POST:url parameters:para progress:^(NSProgress * _Nonnull uploadProgress) {
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            [weakself requestFinish:responseObject tag:tag];
            app.networkActivityIndicatorVisible = NO;
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [weakself performDismiss];
            [weakself showTextMessage:@"请检查网络后重试"];
            [weakself requestFail:error tag:tag];
            app.networkActivityIndicatorVisible = NO;
        }];
    }
}

- (void)requestFinish:(id)data tag:(NSInteger)tag {

}

- (void)requestFail:(id)error tag:(NSInteger)tag {

}

- (void)performDismiss {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)showWaitMessage {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = @"正在载入...";
}

- (void)showCustomMessage:(NSString*)message {
    if( customMessage == nil ){
        customMessage = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 260, 40)];
        CGPoint center;
        center.x = self.view.center.x;
        center.y = self.view.frame.size.height * 4.0 / 5.0;
        CGRect frame = customMessage.frame;
        frame.origin.x    = center.x - (frame.size.width  / 2.0);
        frame.origin.y    = center.y - (frame.size.height / 2.0);
        customMessage.frame = frame;
        [customMessage setBackgroundColor:[UIColor blackColor]];
        [customMessage.layer setCornerRadius:5];
        [customMessage setAlpha:0.5f];
        
        customMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, customMessage.frame.size.height/2-11, customMessage.frame.size.width, 22)];
        [customMessageLabel setBackgroundColor:[UIColor clearColor]];
        [customMessageLabel setTextColor:[UIColor whiteColor]];
        [customMessageLabel setTextAlignment:NSTextAlignmentCenter];
        [customMessageLabel setFont:[UIFont systemFontOfSize:17]];
        [customMessage addSubview:customMessageLabel];
        [self.view addSubview:customMessage];
    }
    customMessageLabel.text = message;
    customMessage.hidden = NO;
    [self.view bringSubviewToFront:customMessage];
    
    [UIView animateWithDuration:0.4f animations:^{
        [customMessage setAlpha:0.5f];
    }];
    if ([customMessage_timer isValid]) {
        [customMessage_timer invalidate];
    }
    customMessage_timer = [NSTimer scheduledTimerWithTimeInterval: 3
                                                           target: self
                                                         selector: @selector(onTimer)
                                                         userInfo: nil
                                                          repeats: NO];
}

- (void)showTextMessage:(NSString *)message {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    hud.layer.cornerRadius = 5;
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
    [hud hide:YES afterDelay:3];
}

- (void)showWaitHUD {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDAnimationFade;
    hud.backgroundColor = [UIColor clearColor];
    hud.margin = 10.f;
    hud.yOffset = 150.f;
    hud.removeFromSuperViewOnHide = YES;
}

- (void)onTimer {
    customMessage.hidden = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    if ([self isViewLoaded] && self.view.window == nil) {
        self.view = nil;
        customMessage = nil;
        customMessageLabel = nil;
        customMessage_timer = nil;
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskPortrait;
//}
//
//- (BOOL)shouldAutorotate
//{
//    return NO;
//}















@end
