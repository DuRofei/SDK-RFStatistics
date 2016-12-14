//
//  UITableView+Statistic.m
//  WeaponsPublicSentiment
//
//  Created by wiseweb on 16/11/29.
//  Copyright © 2016年 wiseweb. All rights reserved.
//

#import "UITableView+Statistic.h"
#import "Swizzling.h"
#import "UserStatistic.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "UIApplication+TopMostViewController.h"


@implementation UITableView (Statistic)

+ (void)load
{
    Method delegateOriginalMethod = class_getInstanceMethod([self class], @selector(setDelegate:));
    Method delegateSwizzledMethod = class_getInstanceMethod([self class], @selector(rf_setDelegate:));
    
    method_exchangeImplementations(delegateOriginalMethod, delegateSwizzledMethod);

}

- (void)rf_setDelegate:(id<UITableViewDelegate>)delegate
{
    [self rf_setDelegate:delegate];
    
    if (class_addMethod([delegate class], NSSelectorFromString(@"rf_didSelectRowAtIndexPath"), (IMP)rf_didSelectRowAtIndexPath, "v@:@@")) {
        Method didSelectOriginalMethod = class_getInstanceMethod([delegate class], NSSelectorFromString(@"rf_didSelectRowAtIndexPath"));
        Method didSelectSwizzledMethod = class_getInstanceMethod([delegate class], @selector(tableView:didSelectRowAtIndexPath:));
        
        method_exchangeImplementations(didSelectOriginalMethod, didSelectSwizzledMethod);
    }
}

void rf_didSelectRowAtIndexPath(id self, SEL _cmd, id tableView, id indexPath)
{
    SEL selector = NSSelectorFromString(@"rf_didSelectRowAtIndexPath");
    ((void(*)(id, SEL, id, id))objc_msgSend)(self, selector, tableView, indexPath);
    
    NSIndexPath *indexPath2 = (NSIndexPath *)indexPath;
    NSString *cellSection = [NSString stringWithFormat:@"%zi",indexPath2.section];
    NSString *cellRow = [NSString stringWithFormat:@"%zi",indexPath2.row];
    NSString *controller = NSStringFromClass([self class]);
    
    NSTimeInterval time = [[NSDate date]timeIntervalSince1970];
    NSString *eventTime = [NSString stringWithFormat:@"%f",time];
    
    NSDictionary *dic = @{@"controller":controller,
                          @"eventTime":eventTime,
                          @"cellSection":cellSection,
                          @"cellRow":cellRow};
    
    [UserStatistic sendEventToServer:dic];
}

- (id)displayIdentifier:(id)source
{
    if ([source isKindOfClass:[UIView class]]) {
        for (UIView *next = [source superview]; next; next = next.superview) {
            UIResponder *nextResponder = [next nextResponder];
            if ([nextResponder isKindOfClass:[UIViewController class]]) {
                return (id)nextResponder;
            } else if ([nextResponder isKindOfClass:[UIApplication class]]) {
                return [[UIApplication sharedApplication] topMostViewController];
            }
        }
    } else if ([source isKindOfClass:[UIGestureRecognizer class]]) {
        UIGestureRecognizer *gestureSource = (UIGestureRecognizer *)source;
        if ([gestureSource.view isKindOfClass:[NSClassFromString(@"_UIAlertControllerView") class]]) {
            return gestureSource.view;
        }
        
        return [self displayIdentifier:gestureSource.view];
    }
    return nil;
}



- (NSDictionary *)dictionaryFromUserStatisticsConfigPlist
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"AllEvents" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return dic;
}

@end
