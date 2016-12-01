//
//  RFCycleViewModel.m
//  RFCycleView
//
//  Created by DuRofei on 16/9/22.
//  Copyright © 2016年 DuRofei. All rights reserved.
//

#import "RFCycleViewModel.h"

@implementation RFCycleViewModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if([key isEqualToString:@"id"])
        self.ID = value;

}
@end
