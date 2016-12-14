//
//  UserStatistic.h
//  WeaponsPublicSentiment
//
//  Created by wiseweb on 16/11/29.
//  Copyright © 2016年 wiseweb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserStatistic : NSObject
/**
 *  初始化配置，一般在launchWithOption中调用
 */
+ (void)configure;

+ (void)enterPageViewWithPageID:(NSString *)pageID;

+ (void)leavePageViewWithPageID:(NSString *)pageID;

+ (void)sendEventToServer:(NSDictionary *)eventId;
@end
