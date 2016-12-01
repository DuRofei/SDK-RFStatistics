//
//  SecondViewController.m
//  RFStatistics
//
//  Created by wiseweb on 16/11/30.
//  Copyright © 2016年 wiseweb. All rights reserved.
//

#import "SecondViewController.h"
#import "RFCycleView.h"

@interface SecondViewController ()<RFCycleViewDelegate>

@property (nonatomic, strong) RFCycleView *cycleView;
@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    

    
    NSMutableArray *array = [@[@"c1.jpg",@"c2.jpg",@"c3.jpg",@"c4.jpg",@"c5.jpg",@"c6.jpg",@"c7.jpg",@"c8.jpg"]mutableCopy];
    self.cycleView = [[RFCycleView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) interVal:2 url:nil bundleImageArray:array];
    [self.cycleView closeButtonPostion:CloseButton_Bottom];
    [self.cycleView pageControlPostion:PageControl_Left];
    self.cycleView.isNeedUpdate = NO;
    
    
    self.cycleView.delegate = self;
    [self.view addSubview:self.cycleView];
    [self.cycleView addTapBlock:^(RFCycleViewModel *model, NSInteger index) {
        NSLog(@"当前点击第%ld个",index + 1);
        NSLog(@"model = %@",model);
    }];
    
}



- (void)isCloseCycleView:(BOOL)isOrNot{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)lastPictureActionWithTag:(NSInteger)tag{
    NSLog(@"%ld",tag);
    NSLog(@"已经是最后一张图片啦");
}

@end
