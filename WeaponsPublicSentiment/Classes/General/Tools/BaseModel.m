//
//  BaseModel.m
//  CNTVPublicSentiment
//
//  Created by wiseweb on 16/11/18.
//  Copyright © 2016年 wiseweb. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        _ID = value;
    }
}
@end
