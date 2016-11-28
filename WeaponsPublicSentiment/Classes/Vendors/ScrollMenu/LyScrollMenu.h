//
//  LyScrollMenu.h
//  LyScrollMenu
//
//  Created by Lying on 16/6/27.
//  Copyright © 2016年 Lying. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LyScrollMenuDelegate <NSObject>
/**
 *  代理方法
 *
 *  @param currentView 当前的UIview
 *  @param index       当前view的索引
 */
- (void)LyScrollMenuCurrentView:(UIView *)currentView didSelectItemWithIndex:(NSInteger)index;

@end

@interface LyScrollMenu : UIView

/**
 *  初始化方法1
 *  在屏幕内最多显示的标题个数默认为5个
 *
 *  @param viewArr      scrollView上要添加的view数组   -> @[VC1.view,VC2.view,VC3.view,VC4.view,VC5.view]
 *  @param titleArr     标题数组    -> @[@"标题1",@"标题2",@"标题3",@"标题4",@"标题5"],
 *  
 */
-(instancetype)initWithFrame:(CGRect)frame ControllerViewArray:(NSArray *)viewArr TitleArray:(NSArray *)titleArr;


/**
 *  初始化方法2
 *  可设置最多显示的标题个数
 *
 *  @param viewArr      scrollView上要添加的view数组   -> @[VC1.view,VC2.view,VC3.view,VC4.view,VC5.view]
 *  @param titleArr     标题数组    -> @[@"标题1",@"标题2",@"标题3",@"标题4",@"标题5"]
 *  @param maxNum       在屏幕内最多显示的标题个数
 *
 */
-(instancetype)initWithFrame:(CGRect)frame ControllerViewArray:(NSArray *)viewArr TitleArray:(NSArray *)titleArr MaxShowTitleNum:(NSInteger)maxNum;


@property (nonatomic ,weak) id <LyScrollMenuDelegate> delegate;

@end

