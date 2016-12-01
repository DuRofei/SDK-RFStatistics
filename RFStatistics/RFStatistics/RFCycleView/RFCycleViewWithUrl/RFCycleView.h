//
//  RFCycleView.h
//  RFCycleView
//
//  Created by DuRofei on 16/9/20.
//  Copyright © 2016年 DuRofei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RFCycleViewModel.h"
#import "RFCycleBaseView.h"

/**
 *  协议
 */
@protocol RFCycleViewDelegate <NSObject>
/**
 *  轮播到最后一张图片时候的协议方法
 */
- (void)lastPictureActionWithTag:(NSInteger)tag;

/**
 *数据是否已经更新
 */
- (void)isupdated:(BOOL)isOrNot;

/**
 *轮播图是否已经关闭
 */
- (void)isCloseCycleView:(BOOL)isOrNot;

/**
 *数据加载完成时回调
 */
- (void)loadDataFinished;

@end

/**
 *关闭按钮显示位置
 */
typedef enum{
    CloseButton_Top,
    CloseButton_Middle,
    CloseButton_Bottom,
}CycleViewCloseButtonPostion;

/**
 *pageControl显示的位置
 */
typedef enum{
    PageControl_Left,
    PageControl_Middle,
    PageControl_Right,
}PageControlPostion;

@interface RFCycleView : UIView
//@property (nonatomic, assign) BOOL             isPriorGetDataInNet;

/**
 *  协议代理
 */
@property (nonatomic, weak) id <RFCycleViewDelegate> delegate;

/**
 *  调用并初始化轮播图方法
 */
- (instancetype)initWithFrame:(CGRect)frame interVal:(NSTimeInterval)interval url:(NSString *)url bundleImageArray:(NSMutableArray *)bundleImgArr;

/**
 *关闭按钮显示的位置,默认居中
 */
- (void)closeButtonPostion:(CycleViewCloseButtonPostion)postion;

/**
 *pageControl现实的位置,默认居中
 */
- (void)pageControlPostion:(PageControlPostion)postion;


/**
 *  点击图片时,index回调方法
 */
- (void)addTapBlock:(void(^)(RFCycleViewModel *model,NSInteger index))block;

/**
 *是否需要更新UI,YES:更新  NO:数据更新,但是UI下次显示,默认为NO
 */
@property (nonatomic, assign) BOOL isNeedUpdate;

/**
 *是否关闭定时器,YES:开启   NO:关闭
 */
- (void)stopOrStartTimer:(BOOL)stopOrStartTimer;

@end
