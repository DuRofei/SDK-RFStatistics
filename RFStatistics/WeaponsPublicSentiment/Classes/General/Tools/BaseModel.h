//
//  BaseModel.h
//  CNTVPublicSentiment
//
//  Created by wiseweb on 16/11/18.
//  Copyright © 2016年 wiseweb. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject
@property (nonatomic, assign) NSInteger ID;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSDate *publishtime;
@property (nonatomic, strong) NSString *summary;
@property (nonatomic, strong) NSString *docurl;
@property (nonatomic, strong) NSString *rank;
@property (nonatomic, strong) NSString *reporturl;
@property (nonatomic, strong) NSString *reporttype;


@end
