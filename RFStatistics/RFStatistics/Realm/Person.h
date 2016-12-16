//
//  Person.h
//  RFStatistics
//
//  Created by wiseweb on 16/12/16.
//  Copyright © 2016年 wiseweb. All rights reserved.
//

#import <Realm/Realm.h>

@interface Person : RLMObject
@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) int age;
@end

RLM_ARRAY_TYPE(Person)
