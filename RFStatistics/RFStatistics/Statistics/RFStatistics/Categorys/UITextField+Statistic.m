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
    NSString *idxPathString = [NSString stringWithFormat:@"%@", textF.text];
    NSMutableString *identifierString = [[NSMutableString alloc] init];
    if (NSStringFromClass([textField class])) {
        [identifierString appendString:[NSString stringWithFormat:@"#%@",NSStringFromClass([textField class])]];
    }
    
    if (identifierString) {
        [identifierString appendString:[NSString stringWithFormat:@"#%@",idxPathString]];
    }
    if (NSStringFromClass([self class])) {
        [identifierString appendString:[NSString stringWithFormat:@"#%@",NSStringFromClass([self class])]];
    }
    [UserStatistic sendEventToServer:identifierString];
}

//- (void)rf_textFieldDidEndEditing:(UITextField *)textField  {
//    
//}

@end
