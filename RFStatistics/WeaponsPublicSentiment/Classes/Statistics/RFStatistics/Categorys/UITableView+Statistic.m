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

@implementation UITableView (Statistic)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL setDelegate = @selector(setDelegate:);
        SEL sw_setDelegate = @selector(sw_setDelegate:);
        [Swizzling swizzleWithClass:[self class] originalSelector:setDelegate swizzledSelector:sw_setDelegate];
    });
}

- (void)sw_setDelegate:(id<UITableViewDelegate>)delegate
{
    [self sw_setDelegate:delegate];
    
    if (class_addMethod([delegate class], NSSelectorFromString(@"sw_didSelectRowAtIndexPath"), (IMP)sw_didSelectRowAtIndexPath, "v@:@@")) {
        Method didSelectOriginalMethod = class_getInstanceMethod([delegate class], NSSelectorFromString(@"sw_didSelectRowAtIndexPath"));
        Method didSelectSwizzledMethod = class_getInstanceMethod([delegate class], @selector(tableView:didSelectRowAtIndexPath:));
        
        method_exchangeImplementations(didSelectOriginalMethod, didSelectSwizzledMethod);
    }
}

void sw_didSelectRowAtIndexPath(id self, SEL _cmd, id tableView, id indexPath)
{
    NSString *eventID = nil;
    //只统计触摸结束时
//    if ([[[(_cmd) allTouches] anyObject] phase] == UITouchPhaseEnded)
//    {
        NSString *actionString = NSStringFromSelector(_cmd);
        NSString *targetName = NSStringFromClass([self class]);
        NSDictionary *configDict = [self dictionaryFromUserStatisticsConfigPlist];
        eventID = configDict[targetName][@"ControlEventIDs"][actionString];
//    }
    if (eventID != nil)
    {
        [UserStatistic sendEventToServer:eventID];
    }
    SEL selector = NSSelectorFromString(@"sw_didSelectRowAtIndexPath");
    ((void(*)(id, SEL, id, id))objc_msgSend)(self, selector, tableView, indexPath);
}

- (NSDictionary *)dictionaryFromUserStatisticsConfigPlist
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"AllEvents" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return dic;
}

@end
