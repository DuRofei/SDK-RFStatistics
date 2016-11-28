//
//  BaseTableViewController.h
//  CNTVPublicSentiment
//
//  Created by wiseweb on 16/11/11.
//  Copyright © 2016年 wiseweb. All rights reserved.
//
#import "BaseViewController.h"
#import "InformationViewController.h"
@protocol BaseTableViewDelegate <NSObject>

- (void)PushDetail:(NSString *)str_newid;

@end

@interface BaseTableViewController : BaseViewController
@property (nonatomic, weak)id<BaseTableViewDelegate>delegate;
@property (nonatomic, copy) NSString *groupID;
@property (nonatomic, assign) BOOL isSearch;
@property (nonatomic, strong) NSMutableDictionary *searchParam;


- (void)viewDidCurrentView;

@end
