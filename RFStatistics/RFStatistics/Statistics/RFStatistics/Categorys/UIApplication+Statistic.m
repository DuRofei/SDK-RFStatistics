//
//  UIApplication+Statistic.m
//  RFStatistics
//
//  Created by wiseweb on 16/12/9.
//  Copyright © 2016年 wiseweb. All rights reserved.
//

#import "UIApplication+Statistic.h"
#import <objc/runtime.h>

//@implementation UIApplication (Statistic)
//+ (void)load {
//    Method origin = class_getInstanceMethod([self class], @selector(sendEvent:));
//    Method custom = class_getInstanceMethod([self class], @selector(rf_sendEvent:));
//    method_exchangeImplementations(origin, custom);
//}
//
//- (void)rf_sendEvent:(UIEvent *)event {
//    [self rf_sendEvent:event];
//    if (event.type == UIEventTypeTouches) {
//        if ([[event.allTouches anyObject] phase] == UITouchPhaseBegan) {
////            NSLog(@"eventalltouch = %@",event.allTouches);
//            NSLog(@"这里是uiapplication里交换的点击事件");
//            for(UITouch *touch in event.allTouches) {
//                [self logTouchInfo:touch];
//                NSLog(@"touch = %@",touch);
//            }
//        }
//    }
//}
//
//- (void)logTouchInfo:(UITouch *)touch {
////    CGPoint locInSelf = [touch locationInView:self];
////    CGPoint locInWin = [touch locationInView:nil];
////    NSLog(@"    touch.locationInView = {%2.3f, %2.3f}", locInSelf.x, locInSelf.y);
////    NSLog(@"    touch.locationInWin = {%2.3f, %2.3f}", locInWin.x, locInWin.y);
//    NSLog(@"    touch.phase = %ld", (long)touch.phase);
//    NSLog(@"    touch.tapCount = %lu", (unsigned long)touch.tapCount);
//    NSLog(@"    touch.view = %@", touch.view);
//    if ([touch.view isKindOfClass:[UIButton class]]) {
//        UIButton *button = (UIButton *)touch.view;
//        NSLog(@"button.title = %@",button.currentTitle);
//    } else if ([touch.view isKindOfClass:[UILabel class]]) {
//        UILabel *label = (UILabel *)touch.view;
//        NSLog(@"label.text = %@",label.text);
//    }
//    
//}
//
//
//@end
