//
//  AppDelegate.m
//  CNTVPublicSentiment
//
//  Created by wiseweb on 16/11/9.
//  Copyright © 2016年 wiseweb. All rights reserved.
//
#import "AppDelegate.h"
#import "JPUSHService.h"
#import <AdSupport/AdSupport.h>
#import <AudioToolbox/AudioToolbox.h>
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
#import <UserNotifications/UserNotifications.h>
#endif

static SystemSoundID push = 0;



@interface AppDelegate ()<JPUSHRegisterDelegate>

@end

@implementation AppDelegate {
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [RFStatistics sharedInstance].analyticsIdentifierBlock = ^(NSString *identifier) {
        NSLog(@"aop:::%@", identifier);
    };
    
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];

    if ([[NSUserDefaults standardUserDefaults] stringForKey:@"状态"] == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:@"未登录" forKey:@"状态"];
    }
    self.loginView = [[LoginViewController alloc]init];
    UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:self.loginView];
    self.window.rootViewController = navC;
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyWindow];
    
    
    // 注册apns通知
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) // iOS10
    {
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
#endif
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) // iOS8, iOS9
    {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert) categories:nil];
    }
    

    // 广告标识符
    NSString *advertisingId = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    
    // 如不需要使用IDFA，advertisingIdentifier 可为nil
    // 注册极光推送
    [JPUSHService setupWithOption:launchOptions appKey:appKey channel:channel apsForProduction:isProduction advertisingIdentifier:advertisingId];
    
    //2.1.9版本新增获取registration id block接口。
    [JPUSHService registrationIDCompletionHandler:^(int resCode, NSString *registrationID) {
        if(resCode == 0)
        {
            // iOS10获取registrationID放到这里了, 可以存到缓存里, 用来标识用户单独发送推送
            NSLog(@"registrationID获取成功：%@",registrationID);
            [[NSUserDefaults standardUserDefaults] setObject:registrationID forKey:@"registrationID"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        else
        {
            NSLog(@"registrationID获取失败，code：%d",resCode);
        }
    }];
    [JPUSHService resetBadge];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
    return YES;
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    [JPUSHService resetBadge];
    [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
}





#pragma mark *** 注册APNs成功并上报DeviceToken ***

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    
    /// Required - 注册 DeviceToken
    [JPUSHService registerDeviceToken:deviceToken];
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"状态"]isEqualToString:@"已登录"]) {
        [JPUSHService setAlias:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"]
              callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    }
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet *)tags alias:(NSString *)alias {
    NSLog(@"iResCode: %d, \n alias: %@\n", iResCode, alias);
}


#pragma mark *** 实现注册APNs失败接口（可选） ***
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    //Optional
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    
    // Required, iOS 7 Support
    [JPUSHService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
    if (application.applicationState == UIApplicationStateActive) {
        NSLog(@">>>>>>>>>>>程序启动");
        if (userInfo) {
            [self playSound];
            NSLog(@"userinfo =====>>>>>>%@",userInfo);
            [self goToMssageViewControllerWith:userInfo];
        }
    } else {
        NSLog(@">>>>>>>>>>>>>>程序未启动");
        [JPUSHService resetBadge];
        if (userInfo) {
            //​发通知
            [self playSound];
            NSLog(@"userinfo =====>>>>>>%@",userInfo);
            //也可以写个方法让他跳转到指定页面
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self goToMssageViewControllerWith:userInfo];
            });
        }
    }
}

#pragma mark *** 添加处理APNs通知回调方法 ***
#pragma mark- JPUSHRegisterDelegate

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        if (userInfo){
            [self playSound];
            //​发通知
            NSLog(@"userinfo =====>>>>>>%@",userInfo);
            [self goToMssageViewControllerWith:userInfo];
        }
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
}

// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    [JPUSHService resetBadge];
    if([response.notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        if (userInfo){
            //​发通知
            NSLog(@"userinfo =====>>>>>>%@",userInfo);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self goToMssageViewControllerWith:userInfo];
            });
        }
    }
    completionHandler();  // 系统要求执行这个方法
}

- (void)goToMssageViewControllerWith:(NSDictionary *)userInfo{
    if ([[userInfo allKeys] containsObject:@"moduleKey"]) {
        NSString *moduleKeyStr = [userInfo valueForKey:@"moduleKey"];
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        [dic setValue:moduleKeyStr forKey:@"moduleKey"];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"pushIndex" object:self userInfo:dic];
    }
}

-(void) playSound
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"push" ofType:@"wav"];
    NSLog(@"path = %@",path);
    if (path) {
        //注册声音到系统
        AudioServicesCreateSystemSoundID((__bridge CFURLRef)[NSURL fileURLWithPath:path],&push);
        AudioServicesPlaySystemSound(push);
        //        AudioServicesPlaySystemSound(push);//如果无法再下面播放，可以尝试在此播放
    }
//    AudioServicesPlaySystemSound(1106);

//    AudioServicesPlaySystemSound(push);   //播放注册的声音，（此句代码，可以在本类中的任意位置调用，不限于本方法中）
    
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);   //让手机震动
}

@end
