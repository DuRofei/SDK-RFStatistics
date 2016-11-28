//
//  BaseViewController.h
//  CNTVPublicSentiment
//
//  Created by wiseweb on 16/11/9.
//  Copyright © 2016年 wiseweb. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface BaseViewController : UIViewController


// 网络请求
- (void)requestWithPara:(NSMutableDictionary *)para path:(NSString *)path method:(NSString *)method tag:(NSInteger)tag;

- (void)requestFinish:(id)data tag:(NSInteger)tag;

- (void)requestFail:(id)error tag:(NSInteger)tag;

// 显示提示信息
- (void)showCustomMessage:(NSString*)message;

- (void)showTextMessage:(NSString *)message;

- (void)showWaitMessage;

- (void)performDismiss;

- (void)showWaitHUD;

@end
