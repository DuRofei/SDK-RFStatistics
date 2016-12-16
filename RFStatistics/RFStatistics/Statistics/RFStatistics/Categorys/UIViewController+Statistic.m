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
@interface UIViewController ()
//@property (nonatomic) NSTimeInterval enterTime;
//@property (nonatomic) NSTimeInterval leaveTime;

@end

@implementation UIViewController (Statistic)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
//        SEL originalSelector_enter = @selector(viewWillAppear:);
//        SEL swizzledSelector_enter = @selector(sw_viewWillAppear:);
//        [Swizzling swizzleWithClass:[self class] originalSelector:originalSelector_enter swizzledSelector:swizzledSelector_enter];
        
        SEL originalSelector_enter1 = @selector(viewDidLoad);
        SEL swizzledSelector_enter1 = @selector(rf_viewDidLoad);
        [Swizzling swizzleWithClass:[self class] originalSelector:originalSelector_enter1 swizzledSelector:swizzledSelector_enter1];
        
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

- (void)rf_viewDidLoad {
    [self rf_viewDidLoad];
    [self inject_viewWillAppear];
}

- (void)sw_viewWillDisappear:(BOOL)animated
{
    [self inject_viewWillDisappear];
    [self sw_viewWillDisappear:animated];
}

//利用hook 统计所有页面的停留时长
- (void)inject_viewWillAppear
{
    NSTimeInterval enter = [[NSDate date]timeIntervalSince1970];
    NSString *enterTime = [NSString stringWithFormat:@"%f",enter];
    NSString *pageID = @"enter";
    if ([self isKindOfClass:[UIAlertController class]]) {
        NSLog(@"controller = %@",[self class]);
    }
    NSString *controller = [NSString stringWithFormat:@"%@",[self class]];
    if (pageID) {
        if ([self isKindOfClass:[UIAlertController class]]) {
            NSLog(@"controller = %@",[self class]);
            UIAlertController *alertC = (UIAlertController *)self;
            NSDictionary *dic = @{@"pageID":pageID,
                                  @"pageName":controller,
                                  @"alertTitle":alertC.title,
                                  @"alertMessage":alertC.message,
                                  @"enterTime":enterTime};
            if (dic) {
                [UserStatistic sendEventToServer:dic];
            }
        } else {
            NSDictionary *dic = @{@"pageID":pageID,
                                  @"pageName":controller,
                                  @"enterTime":enterTime};
            if (dic) {
                [UserStatistic sendEventToServer:dic];
            }
        }
    }
}

- (void)inject_viewWillDisappear
{
    NSTimeInterval leave = [[NSDate date]timeIntervalSince1970];
    NSString *leaveTime = [NSString stringWithFormat:@"%f",leave];
    NSString *pageID = @"leave";
    if (pageID) {
        NSDictionary *dic = @{@"pageID":pageID,
                              @"leaveTime":leaveTime};
        if (dic) {
            [UserStatistic sendEventToServer:dic];
        }
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

//- (void)setEnterTime:(NSTimeInterval)enterTime {
//    objc_setAssociatedObject(self, @selector(enterTime),enterTime, OBJC_ASSOCIATION_COPY_NONATOMIC);
//
//}
//
//- (NSTimeInterval)enterTime {
//    return objc_getAssociatedObject(self, @selector(enterTime));
//}
//
//- (void)setLeaveTime:(NSTimeInterval)leaveTime {
//    
//}
//
//- (NSTimeInterval)leaveTime {
//    return 0;
//}

@end
