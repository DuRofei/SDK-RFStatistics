//
//  UIViewController+Statistic.m
//  WeaponsPublicSentiment
//
//  Created by wiseweb on 16/11/29.
//  Copyright © 2016年 wiseweb. All rights reserved.
//

#import "UIViewController+Statistic.h"
#import "Swizzling.h"
#import "UserStatistic.h"

@implementation UIViewController (Statistic)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        // When swizzling a class method, use the following:
        // Class class = object_getClass((id)self);
        
        SEL originalSelector_enter = @selector(viewWillAppear:);
        SEL swizzledSelector_enter = @selector(sw_viewWillAppear:);
        [Swizzling swizzleWithClass:[self class] originalSelector:originalSelector_enter swizzledSelector:swizzledSelector_enter];
        
        SEL originalSelector_leave = @selector(viewWillDisappear:);
        SEL swizzledSelector_leave = @selector(sw_viewWillDisappear:);
        [Swizzling swizzleWithClass:[self class] originalSelector:originalSelector_leave swizzledSelector:swizzledSelector_leave];
    });
}

#pragma mark - Method Swizzling

- (void)sw_viewWillAppear:(BOOL)animated
{
    //插入需要执行的代码
    [self inject_viewWillAppear];
    [self sw_viewWillAppear:animated];
}

- (void)sw_viewWillDisappear:(BOOL)animated
{
    [self inject_viewWillDisappear];
    [self sw_viewWillDisappear:animated];
}

//利用hook 统计所有页面的停留时长
- (void)inject_viewWillAppear
{
    NSString *pageID = [self pageEventID:YES];
    if (pageID) {
        [UserStatistic sendEventToServer:pageID];
    }
}

- (void)inject_viewWillDisappear
{
    NSString *pageID = [self pageEventID:NO];
    if (pageID) {
        [UserStatistic sendEventToServer:pageID];
    }
}

- (NSString *)pageEventID:(BOOL)isEnterPage
{
    NSDictionary *configDict = [self dictionaryFromUserStatisticsConfigPlist];
    NSString *selfClassName = NSStringFromClass([self class]);
    return configDict[selfClassName][@"PageEventIDs"][isEnterPage ? @"Enter" : @"Leave"];
}

- (NSDictionary *)dictionaryFromUserStatisticsConfigPlist
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"AllEvents" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return dic;
}

- (UIViewController *)topMostViewController
{
    if (self.presentedViewController == nil || [self.presentedViewController isKindOfClass:[UIImagePickerController class]]) {
        
        return self;
        
    } else if ([self.presentedViewController isKindOfClass:[UINavigationController class]]) {
        
        UINavigationController *navigationController = (UINavigationController *)self.presentedViewController;
        UIViewController *lastViewController = [[navigationController viewControllers] lastObject];
        
        return [lastViewController topMostViewController];
    }
    
    UIViewController *presentedViewController = (UIViewController *)self.presentedViewController;
    
    return [presentedViewController topMostViewController];
}
@end
