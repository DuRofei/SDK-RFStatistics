//
//  UITouch+Statistic.m
//  RFStatistics
//
//  Created by wiseweb on 16/12/14.
//  Copyright © 2016年 wiseweb. All rights reserved.
//

#import "UITouch+Statistic.h"
#import "UserStatistic.h"
#import <objc/runtime.h>

@implementation UITouch (Statistic)
+ (void)load {
    Method origion = class_getInstanceMethod([self class], @selector(setView:));
    Method custom = class_getInstanceMethod([self class], @selector(rf_setView:));
    method_exchangeImplementations(origion, custom);
    
    Method origion2 = class_getInstanceMethod([self class], @selector(setGestureRecognizers:));
    Method custom2 = class_getInstanceMethod([self class], @selector(rf_setGestureRecognizers:));
    method_exchangeImplementations(origion2, custom2);
}

- (void)rf_setGestureRecognizers:(UIGestureRecognizer *)gestureRecognizer {
    NSLog(@"gestureRecognizer = %@",gestureRecognizer);
}

- (void)rf_setView:(UIView *)view {
    [self rf_setView:view];
//    NSLog(@"view = %@",view);
    NSMutableDictionary *mDic = [NSMutableDictionary dictionary];
    NSTimeInterval time = [[NSDate date]timeIntervalSince1970];
    NSString *touchTime = [NSString stringWithFormat:@"%f",time];
    NSString *tapCount = [NSString stringWithFormat:@"%zi",self.tapCount];
    NSString *phase = [NSString stringWithFormat:@"%zi",self.phase];
    [mDic setObject:touchTime forKey:@"touchTime"];
    [mDic setObject:tapCount forKey:@"touchTapCount"];
    [mDic setObject:phase forKey:@"touchPhase"];
    if ([view isKindOfClass:NSClassFromString(@"UITableViewCellContentView")]) {
        UITableViewCell *cell = (UITableViewCell *)view;
        [mDic setObject:@"UITableViewCell" forKey:@"touchView"];

        for (int i = 0; i < cell.subviews.count; i ++) {
            if ([cell.subviews[i] isKindOfClass:[UILabel class]]) {
                UILabel *label = (UILabel *)cell.subviews[i];
                NSString *labelText = [NSString stringWithFormat:@"labelText%d",i];
                [mDic setObject:label.text forKey:labelText];
//                NSLog(@"cell.label.text = %@",label.text);
            }
        }
//        NSLog(@"cell.subviews = %@",cell.subviews);
        NSDictionary *dic = [NSDictionary dictionaryWithDictionary:mDic];
        [UserStatistic sendEventToServer:dic];

    } else if ([view isKindOfClass:NSClassFromString(@"_UIAlertControllerActionView")]) {
        if (view.subviews[0]) {
            if (view.subviews[0].subviews[0]) {
                if ([view.subviews[0].subviews[0] isKindOfClass:[UILabel class]]) {
                    UILabel *label = (UILabel *)view.subviews[0].subviews[0];
                    NSString *actionTitle = label.text;
                    [mDic setObject:@"UIAlertController" forKey:@"touchView"];
                    [mDic setObject:actionTitle forKey:@"actionTitle"];
                    NSDictionary *dic = [NSDictionary dictionaryWithDictionary:mDic];
                    [UserStatistic sendEventToServer:dic];
                }
            }
        }
    }
}

@end
