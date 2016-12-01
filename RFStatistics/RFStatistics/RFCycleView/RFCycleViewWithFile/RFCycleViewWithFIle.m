//
//  RFCycleViewWithFIle.m
//  RFCycleView
//
//  Created by DuRofei on 16/9/21.
//  Copyright © 2016年 DuRofei. All rights reserved.
//

#import "RFCycleViewWithFIle.h"

@interface RFCycleViewWithFIle ()<UIScrollViewDelegate>
//scrollView
@property (nonatomic, strong) UIScrollView    *imgScrollView;
//pageControl
@property (nonatomic, strong) UIPageControl   *imgPageControl;
//ImageViewArray
@property (nonatomic, strong) NSMutableArray  *imgViewArray;
//存放图片的数组
@property (nonatomic, strong) NSMutableArray  *imgArray;
//当前展示的图片下标
@property (nonatomic, assign) NSInteger        index;
//timer
@property (nonatomic, strong) NSTimer         *imgTimer;
//点击回调 block
@property (nonatomic, copy)   void(^tapBlock)(NSInteger index);
//参数传过来的url
@property (nonatomic, strong) NSString        *urlString;
//请求下来的轮播图片数组
@property (nonatomic, strong) UIButton        *closeButton;
//轮播图时间间隔
@property (nonatomic, assign) NSTimeInterval   interval;

@end

@implementation RFCycleViewWithFIle



//初始化方法
- (instancetype)initWithFrame:(CGRect)frame interVal:(NSTimeInterval)interval
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imgViewArray = [NSMutableArray new];
        self.imgArray = [NSMutableArray new];
        //这个地方必须是bounds,如果这个类的frame不是从(0,0)开始,那么ScrollView也会相应的根据frame的改变而改变,从而造成超出view范围的情况
        self.imgScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        self.imgScrollView.contentSize = CGSizeMake(frame.size.width * 3, 0);
        [self addSubview:self.imgScrollView];
        for (int i = 0; i < 3; i++) {
            UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(frame.size.width * i, 0, frame.size.width, frame.size.height)];
            [self.imgScrollView addSubview:imgView];
            
            [self.imgViewArray addObject:imgView];
        }
        
        self.imgScrollView.pagingEnabled = YES;
        self.imgScrollView.showsHorizontalScrollIndicator = NO;
        self.imgScrollView.showsVerticalScrollIndicator = NO;
        self.imgScrollView.delegate = self;
        self.imgScrollView.bounces = NO;
        self.interval = interval;
        [self startTimer];
    }
    return self;
    
}
//图片滚动方法
-(void)timerAction{
    [self.imgScrollView setContentOffset:CGPointMake(self.imgScrollView.frame.size.width * 2, 0) animated:YES];
    if (self.imgNameArray.count == 0) {
        return;
    }
    self.index = (self.index + 1) % self.imgNameArray.count;
    if (self.index == self.imgNameArray.count - 1) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(lastPictureActionWithTag:)]) {
            [self.delegate lastPictureActionWithTag:2];
        }
    }
    
}
//滚动动画结束
-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    //回位
    [self.imgScrollView setContentOffset:CGPointMake(scrollView.frame.size.width, 0) animated:NO];
    [self layoutImages];
    
}
//图片名数组setter
-(void)setImgNameArray:(NSMutableArray *)imgNameArray
{
    if (_imgNameArray != imgNameArray) {
        _imgNameArray = imgNameArray;
        NSLog(@"%@",_imgNameArray);
        if (self.imgNameArray.count > 1) {
            if (_imgPageControl == nil) {
                _imgPageControl = [[UIPageControl alloc]init];
                _imgPageControl.numberOfPages = self.imgNameArray.count;
                CGSize size = [_imgPageControl sizeForNumberOfPages:self.imgNameArray.count];
                _imgPageControl.bounds = CGRectMake(0, 0, size.width + 20, size.height);
                _imgPageControl.center = CGPointMake(self.center.x, self.bounds.size.height - 30);
                _imgPageControl.currentPageIndicatorTintColor = [UIColor redColor];
                _imgPageControl.pageIndicatorTintColor = [UIColor blackColor];
                [self addSubview:_imgPageControl];
                //        [_imgPageControl addTarget:self action:@selector(pageChanged:) forControlEvents:UIControlEventValueChanged];
            }
        }else if (self.imgNameArray.count == 1){
            self.imgScrollView.contentSize = CGSizeMake(self.frame.size.width, 0);
            [self.imgTimer invalidate];
            self.imgTimer = nil;
        }
        
        for (int i = 0; i < imgNameArray.count; i++) {
            UIImage *img = [UIImage imageNamed:imgNameArray[i]];
            
            [self.imgArray addObject:img];
            if (i < 3) {
                [self.imgViewArray[i] setImage:img];
            }
        }
        //设置当前偏移量
        [self.imgScrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
        self.index = 0;
        [self layoutImages];
        //点击手指
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCycleViewAction:)];
        [(UIImageView *)self.imgViewArray[1] addGestureRecognizer:tap];
        //打开交互
        [(UIImageView *)self.imgViewArray[1] setUserInteractionEnabled:YES];
    }
    
}
//初始化 timer
- (void)startTimer{
    if (self.interval <= 0) {
        self.imgTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    }else{
        self.imgTimer = [NSTimer scheduledTimerWithTimeInterval:self.interval target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    }
}
- (void)closeCycleViewView:(BOOL)closeView Timer:(BOOL)closeTimer{
    NSLog(@"别点了");
    if (closeView && closeTimer) {
        [self removeFromSuperview];
        [self.imgTimer invalidate];
        self.imgTimer = nil;
    }else if (!closeView && closeTimer){
        [self.imgTimer invalidate];
        self.imgTimer = nil;
    }
}
- (void)startCycleViewTimer:(BOOL)startTimer{
    if (self.imgTimer == nil && startTimer) {
        [self startTimer];
        NSLog(@"看我要开始了");
    }
}

-(void)tapCycleViewAction:(UITapGestureRecognizer *)tap{
    if (self.tapBlock) {
        self.tapBlock(self.index);
    }
    
}
#pragma mark - UIScrollViewDelegate
static CGFloat x = 0;
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    
    x = scrollView.contentOffset.x;
    //未来执行,一直都是未来得不到执行
    [self.imgTimer setFireDate:[NSDate distantFuture]];
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    if (x > scrollView.contentOffset.x) {
        //向右划展示左边的图片
        [self panToleft:NO Index:self.index];
    }else if (x < scrollView.contentOffset.x){
        [self panToleft:YES Index:self.index ];
    }
    [self.imgTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:2]];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.imgScrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, 0)];
}

#pragma mark - 向左滑动,向右滑动结束切换
-(void)panToleft:(BOOL)left Index:(NSInteger)index{
    if (self.imgNameArray.count == 0) {
        return;
    }else if (self.imgNameArray.count > 1){
        if (!left) {
            self.index = (index - 1 + self.imgNameArray.count) % self.imgNameArray.count;
        }else{
            self.index = (index + 1) % self.imgNameArray.count;
            
        }
        //切换图片
        [self layoutImages];
        //回位操作
        [self.imgScrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
    }

    
}

-(void)layoutImages{
    if (self.imgNameArray.count == 0) {
        return;
    }
    for (int i = 0; i < 3; i++) {
        [self.imgViewArray[i] setImage:self.imgArray[(self.index - 1 + i + self.imgNameArray.count) % self.imgNameArray.count]];
    }
    
}
-(void)setIndex:(NSInteger)index
{
    if (_index != index) {
        _index = index;
        self.imgPageControl.currentPage = index;
    }
    
}
//添加block
-(void)addTapBlock:(void (^)(NSInteger))block
{
    self.tapBlock = block;
}

@end
