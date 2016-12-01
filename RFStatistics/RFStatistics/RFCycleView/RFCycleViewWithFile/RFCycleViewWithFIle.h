//
//  RFCycleViewWithFIle.h
//  RFCycleView
//
//  Created by DuRofei on 16/9/21.
//  Copyright © 2016年 DuRofei. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  协议
 */
@protocol RFCycleViewWithFileDelegate <NSObject>
/**
 *  轮播到最后一张图片时候的协议方法
 */
- (void)lastPictureActionWithTag:(NSInteger)tag;
@end

@interface RFCycleViewWithFIle : UIView

@property (nonatomic, strong) NSMutableArray  *imgNameArray;

/**
 *  协议代理
 */
@property (nonatomic, weak) id <RFCycleViewWithFileDelegate> delegate;

/**
 *  调用并初始化轮播图方法
 */
- (instancetype)initWithFrame:(CGRect)frame interVal:(NSTimeInterval)interval;
/**
 *  设置是否关闭view或者定时器
 */
- (void)closeCycleViewView:(BOOL)closeView Timer:(BOOL)closeTimer;
/**
 *  设置打开定时器
 */
- (void)startCycleViewTimer:(BOOL)startTimer;

/**
 *  点击图片时,index回调方法
 */
- (void)addTapBlock:(void(^)(NSInteger index))block;

@end
