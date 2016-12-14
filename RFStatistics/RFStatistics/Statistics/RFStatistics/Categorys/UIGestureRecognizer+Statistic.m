//
//  UIGestureRecognizer+Statistic.m
//  RFStatistics
//
//  Created by wiseweb on 16/12/13.
//  Copyright © 2016年 wiseweb. All rights reserved.
//

#import "UIGestureRecognizer+Statistic.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation UIGestureRecognizer (Statistic)
+ (void)load {
    Method origion = class_getInstanceMethod([self class], @selector(setDelegate:));
    Method custom = class_getInstanceMethod([self class], @selector(rf_setDelegate:));
    method_exchangeImplementations(origion, custom);
    
}

- (void)rf_setDelegate:(id<UIGestureRecognizerDelegate>)delegate {
    [self rf_setDelegate:delegate];
    
    if (class_addMethod([delegate class], NSSelectorFromString(@"rf_gestureRecognizerShouldBegin"), (IMP)rf_gestureRecognizerShouldBegin, "v@:@")) {
        Method didSelectOriginalMethod = class_getInstanceMethod([delegate class], NSSelectorFromString(@"rf_gestureRecognizerShouldBegin"));
        Method didSelectSwizzledMethod = class_getInstanceMethod([delegate class], @selector(gestureRecognizerShouldBegin:));
        
        method_exchangeImplementations(didSelectOriginalMethod, didSelectSwizzledMethod);
    }
}


void rf_gestureRecognizerShouldBegin(id self, SEL _cmd, id gestureRecognizer) {
//    SEL selector = NSSelectorFromString(@"rf_gestureRecognizerShouldBegin");
//    ((void(*)(id, SEL, id))objc_msgSend)(self, selector, gestureRecognizer);
//    NSLog(@"gestureRecognizer = %@",gestureRecognizer);
    UIGestureRecognizer *ges = (UIGestureRecognizer *)gestureRecognizer;
    if ([ges isKindOfClass:[UITapGestureRecognizer class]]) {
//        NSLog(@"++++++UITapGestureRecognizer");
        if ([ges.view isKindOfClass:[UILabel class]]) {
            UILabel *label = (UILabel *)ges.view;
            NSLog(@"ges.label.text = %@",label.text);
        } else if ([ges.view isKindOfClass:NSClassFromString(@"UITableViewCellContentView")]) {
            UITableViewCell *cell = (UITableViewCell *)ges.view;
            NSLog(@"cell.subviews = %@",cell.subviews);
        }
    } else if ([ges isKindOfClass:NSClassFromString(@"UIScrollViewPanGestureRecognizer")]) {
//        NSLog(@"++++++UIScrollViewPanGestureRecognizer");
    } else if ([ges isKindOfClass:NSClassFromString(@"UITextTapRecognizer")]) {
        return;
    }
    NSLog(@"ges.view = %@",ges.view);
}


@end
