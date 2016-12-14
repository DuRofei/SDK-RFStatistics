//
//  UITextField+Statistic.m
//  RFStatistics
//
//  Created by wiseweb on 16/12/1.
//  Copyright © 2016年 wiseweb. All rights reserved.
//

#import "UITextField+Statistic.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import "UserStatistic.h"

@implementation UITextField (Statistic)
+ (void)load {
    Method delegateOriginalMethod = class_getInstanceMethod([self class], @selector(setDelegate:));
    Method delegateSwizzledMethod = class_getInstanceMethod([self class], @selector(rf_setDelegate:));
    
    method_exchangeImplementations(delegateOriginalMethod, delegateSwizzledMethod);
}

- (void)rf_setDelegate:(id<UITextFieldDelegate>)delegate {
    [self rf_setDelegate:delegate];
    
    if (class_addMethod([delegate class], NSSelectorFromString(@"rf_textFieldDidEndEditing"), (IMP)rf_textFieldDidEndEditing, "v@:@")) {
        Method didSelectOriginalMethod = class_getInstanceMethod([delegate class], NSSelectorFromString(@"rf_textFieldDidEndEditing"));
        Method didSelectSwizzledMethod = class_getInstanceMethod([delegate class], @selector(textFieldDidEndEditing:));
        
        method_exchangeImplementations(didSelectOriginalMethod, didSelectSwizzledMethod);
    }
}

void rf_textFieldDidEndEditing(id self, SEL _cmd, id textField) {
    SEL selector = NSSelectorFromString(@"rf_textFieldDidEndEditing");
    ((void(*)(id, SEL, id))objc_msgSend)(self, selector, textField);
    UITextField *textF = (UITextField *)textField;
    NSTimeInterval time = [[NSDate date]timeIntervalSince1970];
    NSString *eventTime = [NSString stringWithFormat:@"%f",time];
    NSDictionary *dic = @{@"eventTime":eventTime,
                          @"placehlder":textF.placeholder,
                          @"inPutText":textF.text};
 
    [UserStatistic sendEventToServer:dic];
    
}

@end
