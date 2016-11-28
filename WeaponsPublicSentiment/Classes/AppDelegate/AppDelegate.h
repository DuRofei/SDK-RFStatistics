//
//  AppDelegate.h
//  CNTVPublicSentiment
//
//  Created by wiseweb on 16/11/9.
//  Copyright © 2016年 wiseweb. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoginViewController.h"
static NSString *appKey = @"e25c972b217117fe7906b444";
static NSString *channel = @"Publish channel";
static BOOL isProduction = TRUE;


@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) LoginViewController *loginView;



@end

