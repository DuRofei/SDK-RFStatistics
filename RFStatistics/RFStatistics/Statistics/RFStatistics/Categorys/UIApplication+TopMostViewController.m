//
//  UIApplication+TopMostViewController.m
//  RFStatistics
//
//  Created by wiseweb on 16/12/1.
//  Copyright © 2016年 wiseweb. All rights reserved.
//

#import "UIApplication+TopMostViewController.h"
#import "UIViewController+Statistic.h"

@implementation UIApplication (TopMostViewController)
- (UIViewController *)topMostViewController
{
    return [self.keyWindow.rootViewController topMostViewController];
}

- (UIViewController *)currentViewController
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows) {
            if (tmpWin.windowLevel == UIWindowLevelNormal) {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
    } else {
        result = window.rootViewController;
    }
    
    return result;
}
@end
