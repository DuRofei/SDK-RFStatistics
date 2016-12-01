//
//  UIAlertAction+Statistic.m
//  WeaponsPublicSentiment
//
//  Created by wiseweb on 16/11/29.
//  Copyright © 2016年 wiseweb. All rights reserved.
//

#import "UIAlertAction+Statistic.h"
#import "Aspects.h"
#import "Swizzling.h"

@implementation UIAlertAction (Statistic)

+ (void)load
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        SEL originalSel = @selector(actionWithTitle:style:handler:);
        SEL swizzledSel = @selector(sw_actionWithTitle:style:handler:);
        [Swizzling swizzleWithClass:[self class] originalSelector:originalSel swizzledSelector:swizzledSel];
    });
}

+ (instancetype)sw_actionWithTitle:(nullable NSString *)title style:(UIAlertActionStyle)style handler:(void (^ __nullable)(UIAlertAction *action))handler
{
    UIAlertAction *alertAction = [[self class] sw_actionWithTitle:title style:style handler:handler];
    return alertAction;
}

- (NSDictionary *)dictionaryFromUserStatisticsConfigPlist
{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"AllEvents" ofType:@"plist"];
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile:filePath];
    return dic;
}
@end
