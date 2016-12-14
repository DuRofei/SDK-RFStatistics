//
//  UIControl+Statistic.m
//  WeaponsPublicSentiment
//
//  Created by wiseweb on 16/11/29.
//  Copyright © 2016年 wiseweb. All rights reserved.
//

#import "UIControl+Statistic.h"
#import "Swizzling.h"
#import "UserStatistic.h"

@class UITabBarButton;

@implementation UIControl (Statistic)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSelector = @selector(sendAction:to:forEvent:);
        SEL swizzledSelector = @selector(sw_sendAction:to:forEvent:);
        [Swizzling swizzleWithClass:[self class] originalSelector:originalSelector swizzledSelector:swizzledSelector];
    });
}

#pragma mark - Method Swizzling
- (void)sw_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event
{
    [self sw_sendAction:action to:target forEvent:event];

    for(UITouch *touch in event.allTouches) {
        [self logTouchInfo:touch];
    }
}


- (void)logTouchInfo:(UITouch *)touch {
    CGPoint locInView = [touch locationInView:self];
    CGPoint locInWin = [touch locationInView:nil];

    NSString *locInViewX = [NSString stringWithFormat:@"%2.3f",locInView.x];
    NSString *locInViewY = [NSString stringWithFormat:@"%2.3f",locInView.y];
    NSString *locInWindowX = [NSString stringWithFormat:@"%2.3f",locInWin.x];
    NSString *locInWindowY = [NSString stringWithFormat:@"%2.3f",locInWin.y];
    NSString *touchPhase = [NSString stringWithFormat:@"%zi",touch.phase];
    NSString *touchTapCount = [NSString stringWithFormat:@"%zi",touch.tapCount];
    NSTimeInterval touchInterval = [[NSDate date]timeIntervalSince1970];
    NSString *touchTime = [NSString stringWithFormat:@"%f",touchInterval];
    if ([touch.view isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)touch.view;
        NSDictionary *dic = @{@"touchView":@"Button",
                              @"buttonTitle":button.currentTitle,
                              @"touchTime":touchTime,
                              @"touchTapCount":touchTapCount,
                              @"touchPhase":touchPhase,
                              @"locInViewX":locInViewX,
                              @"locInViewY":locInViewY,
                              @"locInWindowX":locInWindowX,
                              @"locInWindowY":locInWindowY};
        [UserStatistic sendEventToServer:dic];
    }
//    else if ([touch.view isKindOfClass:NSClassFromString(@"UITabBarButton")]) {
//        UITabBarButton *tabbar = (UITabBarButton *)touch.view;
//        NSLog(@"tabbaritem.title = %@",tabbar);
//    }
}

@end
