//
//  UITabBarController+Statistic.m
//  RFStatistics
//
//  Created by wiseweb on 16/12/12.
//  Copyright © 2016年 wiseweb. All rights reserved.
//

#import "UITabBarController+Statistic.h"
#import "UserStatistic.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "UITabBarItem+Statistic.h"

@implementation UITabBarController (Statistic)
+ (void)load {
    Method origion = class_getInstanceMethod([self class], @selector(setDelegate:));
    Method custom = class_getInstanceMethod([self class], @selector(rf_setDelegate:));
    method_exchangeImplementations(origion, custom);
    
    Method origion2 = class_getInstanceMethod([self class], @selector(setSelectedViewController:));
    Method custom2 = class_getInstanceMethod([self class], @selector(rf_setSelectedViewController:));
    method_exchangeImplementations(origion2, custom2);
    
//    Method origion4 = class_getInstanceMethod([self class], @selector(setSelectedIndex:));
//    Method custom4 = class_getInstanceMethod([self class], @selector(rf_setSelectedIndex:));
//    method_exchangeImplementations(origion4, custom4);

}

//- (void)rf_setSelectedIndex:(NSUInteger)selectedIndex {
////    NSLog(@"tabbaritem.selectedindex = %zi",selectedIndex);
//}


- (void)rf_setSelectedViewController:(__kindof UIViewController *)selectedViewController {
    [self rf_setSelectedViewController:selectedViewController];
    NSString *tabbarVC = [NSString stringWithFormat:@"%@",[selectedViewController.childViewControllers[0] class]];
    NSString *tabbarTitle = [NSString stringWithFormat:@"%@",selectedViewController.tabBarItem.rf_tabbarTitle];
    NSTimeInterval time = [[NSDate date]timeIntervalSince1970];
    NSString *eventTime = [NSString stringWithFormat:@"%f",time];
    NSDictionary *dic = @{@"controller":tabbarVC,
                          @"eventTime":eventTime,
                          @"tabbarTitle":tabbarTitle};
    [UserStatistic sendEventToServer:dic];
}

- (void)rf_setDelegate:(id<UITabBarControllerDelegate>)delegate {
    [self rf_setDelegate:delegate];
    
    if (class_addMethod([delegate class], NSSelectorFromString(@"rf_didSelectViewController"), (IMP)rf_didSelectViewController, "v@:@")) {
        Method didSelectOriginalMethod = class_getInstanceMethod([delegate class], NSSelectorFromString(@"rf_didSelectViewController"));
        Method didSelectSwizzledMethod = class_getInstanceMethod([delegate class], @selector(tabBar:didSelectItem:));
        
        method_exchangeImplementations(didSelectOriginalMethod, didSelectSwizzledMethod);
    }
}

void rf_didSelectViewController(id self, SEL _cmd, id viewController) {
    SEL selector = NSSelectorFromString(@"rf_didSelectItem");
    ((void(*)(id, SEL, id))objc_msgSend)(self, selector, viewController);
    UIViewController *viewC = (UIViewController *)viewController;
    NSString *idxPathString = [NSString stringWithFormat:@"%@", viewC.title];
    NSMutableString *identifierString = [[NSMutableString alloc] init];
    if (NSStringFromClass([viewController class])) {
        [identifierString appendString:[NSString stringWithFormat:@"#%@",NSStringFromClass([viewController class])]];
    }
    
    if (identifierString) {
        [identifierString appendString:[NSString stringWithFormat:@"#%@",idxPathString]];
    }
    if (NSStringFromClass([self class])) {
        [identifierString appendString:[NSString stringWithFormat:@"#%@",NSStringFromClass([self class])]];
    }
    NSLog(@"tabbar = %@",identifierString);
    //    [UserStatistic sendEventToServer:identifierString];
    
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    
}


@end
