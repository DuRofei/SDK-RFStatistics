//
//  Swizzling.h
//  WeaponsPublicSentiment
//
//  Created by wiseweb on 16/11/29.
//  Copyright © 2016年 wiseweb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Swizzling : NSObject

+ (void)swizzleWithClass:(Class)classes originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;

@end
