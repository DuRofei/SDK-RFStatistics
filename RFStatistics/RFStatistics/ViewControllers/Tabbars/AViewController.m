//
//  AViewController.m
//  RFStatistics
//
//  Created by wiseweb on 16/11/30.
//  Copyright © 2016年 wiseweb. All rights reserved.
//

#import "AViewController.h"
#import "SGTopTitleView.h"
#import "FourthViewController.h"
@interface  AViewController()<SGTopTitleViewDelegate,UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *mainScrollView;
@property (nonatomic, strong) NSArray *titlesArray;
@property (nonatomic, strong) NSMutableArray *tableViewsArray;
@property (nonatomic, strong) SGTopTitleView *topTitleView;
@property (nonatomic, assign) NSInteger index;

@end

@implementation AViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableViewsArray = [NSMutableArray array];
    self.titlesArray = @[@"新闻",@"论坛",@"博客",@"微博",@"微信",@"纸媒",@"视频",@"外媒"];
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    for (int i = 0; i < self.titlesArray.count; i ++) {
        FourthViewController *vc = [[FourthViewController alloc]init];
        NSString *groupId = [NSString stringWithFormat:@"%d",i + 1];
        vc.viewID = groupId;
        [self.tableViewsArray addObject:vc];
    }
    self.topTitleView = [SGTopTitleView topTitleViewWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, 44)];
    _topTitleView.scrollTitleArr = [NSArray arrayWithArray:_titlesArray];
    _topTitleView.titleAndIndicatorColor = [UIColor redColor];
    //    _topTitleView.showsTitleBackgroundIndicatorStyle = YES;
    _topTitleView.delegate_SG = self;
    [self.view addSubview:_topTitleView];
    
    self.mainScrollView = [[UIScrollView alloc] init];
    _mainScrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    _mainScrollView.contentSize = CGSizeMake(self.view.frame.size.width * _titlesArray.count, 0);
    _mainScrollView.backgroundColor = [UIColor clearColor];
    _mainScrollView.pagingEnabled = YES;
    _mainScrollView.bounces = NO;
    _mainScrollView.showsHorizontalScrollIndicator = NO;
    _mainScrollView.delegate = self;
    [self.view addSubview:_mainScrollView];
    
    UIViewController *viewC = self.tableViewsArray[0];
    [self.mainScrollView addSubview:viewC.view];
    [self.view insertSubview:_mainScrollView belowSubview:_topTitleView];
    
}



#pragma mark - - - SGTopScrollMenu代理方法
- (void)SGTopTitleView:(SGTopTitleView *)topTitleView didSelectTitleAtIndex:(NSInteger)index {
    CGFloat offsetX = index * self.view.frame.size.width;
    self.mainScrollView.contentOffset = CGPointMake(offsetX, 0);
    [self showVc:index];
}


- (void)showVc:(NSInteger)index {
    CGFloat offsetX = index * self.view.frame.size.width;
    FourthViewController *vc = self.tableViewsArray[index];
    if (vc.isViewLoaded) return;
    [self.mainScrollView addSubview:vc.view];
    vc.view.frame = CGRectMake(offsetX, 0, self.view.frame.size.width, self.view.frame.size.height);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    self.index = index;
    [self showVc:index];
    UILabel *selLabel = self.topTitleView.allTitleLabel[index];
    
    [self.topTitleView scrollTitleLabelSelecteded:selLabel];
    [self.topTitleView scrollTitleLabelSelectededCenter:selLabel];
}


@end
