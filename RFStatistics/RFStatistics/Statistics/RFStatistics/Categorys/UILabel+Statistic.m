//
//  UILabel+Statistic.m
//  RFStatistics
//
//  Created by wiseweb on 16/12/9.
//  Copyright © 2016年 wiseweb. All rights reserved.
//

#import "UILabel+Statistic.h"
#import <objc/runtime.h>

@implementation UILabel (Statistic)

//+ (void)load {
//
//    
//    Method origin1 = class_getInstanceMethod([self class], @selector(setText:));
//    Method custom1 = class_getInstanceMethod([self class], @selector(rf_setText:));
//    method_exchangeImplementations(origin1, custom1);
//    
//    Method origin = class_getInstanceMethod([self class], @selector(touchesBegan:withEvent:));
//    Method custom = class_getInstanceMethod([self class], @selector(rf_touchesBegan:withEvent:));
//    method_exchangeImplementations(origin, custom);
//
//}
//
//- (void)rf_setText:(NSString *)text {
//    [self rf_setText:text];
//    NSLog(@"label.text = %@",text);
//    if (![self.superview isKindOfClass:[UIButton class]]) {
//        self.userInteractionEnabled = YES;
//    } else if ([self.superview isKindOfClass:[UITableView class]]) {
//        self.userInteractionEnabled = YES;
//    } else {
//
//    }
//}
//
//
//- (void)rf_touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    if ([self isKindOfClass:[UILabel class]]) {
//        if (event.type == UIEventTypeTouches) {
//            if ([[event.allTouches anyObject] phase] == UITouchPhaseBegan) {
//                for(UITouch *touch in event.allTouches) {
//                    [self logTouchInfo:touch];
//                    //                NSLog(@"touch = %@",touch);
//                }
//            }
//        }
//    }
//}
//
//- (void)logTouchInfo:(UITouch *)touch {
//    CGPoint locInSelf = [touch locationInView:self];
//    CGPoint locInWin = [touch locationInView:nil];
//    NSLog(@"    touch.locationInView = {%2.3f, %2.3f}", locInSelf.x, locInSelf.y);
//    NSLog(@"    touch.locationInWin = {%2.3f, %2.3f}", locInWin.x, locInWin.y);
//    NSLog(@"    touch.phase = %ld", (long)touch.phase);
//    NSLog(@"    touch.tapCount = %lu", (unsigned long)touch.tapCount);
//    NSLog(@"    touch.view = %@", touch.view);
//    if ([touch.view isKindOfClass:[UILabel class]]) {
//        UILabel *label = (UILabel *)touch.view;
//        NSLog(@"label.text = %@",label.text);
//    }
//}

@end


