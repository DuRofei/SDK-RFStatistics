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
    [self performUserStastisticsAction:action to:target forEvent:event];
    [self sw_sendAction:action to:target forEvent:event];
    

//    for(UITouch *touch in event.allTouches) {
//        [self logTouchInfo:touch];
//        NSLog(@"touch = %@",touch);
//    }
    
    
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        SEL swizzledSelector = @selector(sw_action);
//        [Swizzling swizzleWithClass:[self class] originalSelector:action swizzledSelector:swizzledSelector];
//    });
}

- (void)sw_action {
//    NSLog(@"%@",self.)
}

//- (void)logTouchInfo:(UITouch *)touch {
//    CGPoint locInSelf = [touch locationInView:self];
//    CGPoint locInWin = [touch locationInView:nil];
//    NSLog(@"    touch.locationInView = {%2.3f, %2.3f}", locInSelf.x, locInSelf.y);
//    NSLog(@"    touch.locationInWin = {%2.3f, %2.3f}", locInWin.x, locInWin.y);
//    NSLog(@"    touch.phase = %ld", (long)touch.phase);
//    NSLog(@"    touch.tapCount = %lu", (unsigned long)touch.tapCount);
//    NSLog(@"    touch.view = %@", touch.view);
//    UIButton *button = (UIButton *)touch.view;
//    NSLog(@"button.title = %@",button.currentTitle);
//    
//}


- (void)performUserStastisticsAction:(SEL)action to:(id)target forEvent:(UIEvent *)event;
{
    NSString *eventID = nil;
    //只统计触摸结束时
    if ([[[event allTouches] anyObject] phase] == UITouchPhaseEnded)
    {
        NSString *actionString = NSStringFromSelector(action);
        NSString *targetName = NSStringFromClass([target class]);
        NSDictionary *configDict = [self dictionaryFromUserStatisticsConfigPlist];
        eventID = configDict[targetName][@"ControlEventIDs"][actionString];
    }
    if (eventID != nil)
    {
        [UserStatistic sendEventToServer:eventID];
    }
}

- (NSDictionary *)dictionaryFromUserStatisticsConfigPlist
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"AllEvents" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return dic;
}



@end
