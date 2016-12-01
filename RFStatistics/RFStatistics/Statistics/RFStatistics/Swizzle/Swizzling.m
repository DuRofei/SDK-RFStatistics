//
//  Swizzling.m
//  WeaponsPublicSentiment
//
//  Created by wiseweb on 16/11/29.
//  Copyright © 2016年 wiseweb. All rights reserved.
//

#import "Swizzling.h"
#import <objc/runtime.h>

@implementation Swizzling

+ (void)swizzleWithClass:(Class)classes originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector {
    Class className = classes;
    
    Method originalMethod = class_getInstanceMethod(className, originalSelector);
    Method swizzledMethod = class_getInstanceMethod(className, swizzledSelector);
    
    BOOL didAddMethod = class_addMethod(className,
                    originalSelector,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(className,
                            swizzledSelector,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
@end
