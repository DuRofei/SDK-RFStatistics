//
//  NSString+SubString.h
//  WeaponsPublicSentiment
//
//  Created by wiseweb on 16/11/25.
//  Copyright © 2016年 wiseweb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (SubString)
- (NSArray *)componentsSeparatedFromString:(NSString *)fromString toString:(NSString *)toString;
@end
