//
//  RFCycleView.m
//  RFCycleView
//
//  Created by DuRofei on 16/9/20.
//  Copyright © 2016年 DuRofei. All rights reserved.
//

#import "RFCycleView.h"
//#import <AFNetworking/AFNetworking.h>
//#import "UIImageView+WebCache.h"
//#import "SDWebImageManager.h"
#import "FirstViewController.h"

@interface RFCycleView ()<UIScrollViewDelegate>

//scrollView
@property (nonatomic, strong) UIScrollView    *imgScrollView;
//pageControl
@property (nonatomic, strong) UIPageControl   *imgPageControl;
//ImageViewArray
@property (nonatomic, strong) NSMutableArray  *imgViewArray;
//当前展示的图片下标
@property (nonatomic, assign) NSInteger        index;
//timer
@property (nonatomic, strong) NSTimer         *imgTimer;
//点击回调 block
@property (nonatomic, copy)   void(^tapBlock)(RFCycleViewModel *model,NSInteger index);
//参数传过来的url
@property (nonatomic, strong) NSString        *urlString;
//轮播图时间间隔
@property (nonatomic, assign) NSTimeInterval   interval;
//数据源数组
@property (nonatomic, strong) NSMutableArray *cycleViewArray;
//拖动偏移量
@property (nonatomic, assign) CGFloat x;
//button的frame
@property (nonatomic, assign) CGRect ButtonFrame;
//存放bundle里边的图片的数组
@property (nonatomic, strong) NSMutableArray *bundleImgArray;

@property (nonatomic, strong) UIButton *closeButton;

@end

@implementation RFCycleView
//获取相关参数,并且初始化视图
- (instancetype)initWithFrame:(CGRect)frame interVal:(NSTimeInterval)interval url:(NSString *)url bundleImageArray:(NSMutableArray *)bundleImgArr{
    self = [super initWithFrame:frame];
    self.backgroundColor = [UIColor yellowColor];
    if (self) {
        if (url != nil) {
            self.urlString = [NSString stringWithString:url];
        }
        self.interval = interval;
        self.imgViewArray = [NSMutableArray new];
        self.cycleViewArray = [NSMutableArray new];
        self.bundleImgArray = [NSMutableArray new];
        self.bundleImgArray = bundleImgArr;
        
        self.imgScrollView = [[UIScrollView alloc]initWithFrame:self.bounds];
        self.imgScrollView.contentSize = CGSizeMake(frame.size.width * 3, 0);
        self.imgScrollView.backgroundColor = [UIColor greenColor];
        self.imgScrollView.showsHorizontalScrollIndicator = NO;
        self.imgScrollView.pagingEnabled = YES;
        self.imgScrollView.bounces = NO;
        self.imgScrollView.delegate = self;
        [self addSubview:self.imgScrollView];

        self.index = 0;

        self.imgPageControl = [[UIPageControl alloc]init];
        self.imgPageControl.numberOfPages = 0;
        CGSize size;
        if (self.bundleImgArray.count == 0) {
            size = [self.imgPageControl sizeForNumberOfPages:self.cycleViewArray.count];
        } else {
            size = [self.imgPageControl sizeForNumberOfPages:self.bundleImgArray.count];
        }
        self.imgPageControl.bounds = CGRectMake(0, 0, size.width + 20, size.height);
        self.imgPageControl.center = CGPointMake(self.center.x, self.bounds.size.height - 30);
        self.imgPageControl.currentPageIndicatorTintColor = [UIColor redColor];
        self.imgPageControl.pageIndicatorTintColor = [UIColor blackColor];
        [self addSubview:self.imgPageControl];
        [self.imgScrollView setContentOffset:CGPointMake(self.frame.size.width, 0)animated:NO];
        
        self.closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.closeButton setTitle:@"Stop" forState:UIControlStateNormal];
        self.closeButton.frame = CGRectMake(self.frame.size.width - 50, self.center.y, 40, 40);
        self.closeButton.backgroundColor = [UIColor redColor];
        [self.closeButton addTarget:self action:@selector(closeCycleButtonAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:self.closeButton];
        
        NSMutableArray *array = self.bundleImgArray;
        if (array.count == 0) {
//            self.cycleViewArray = [self requestCycleImageData];
        } else {
            self.imgPageControl.numberOfPages = self.bundleImgArray.count;
        }
        if (self.bundleImgArray.count == 1 || self.cycleViewArray.count == 1) {
            self.imgPageControl.numberOfPages = 0;
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
            [self.imgScrollView addSubview:imageView];
            [self.imgViewArray addObject:imageView];
        } else {
            for (int i = 0; i < 3; i++) {
                UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(frame.size.width * i, 0, frame.size.width, frame.size.height)];
                [self.imgScrollView addSubview:imgView];
                [self.imgViewArray addObject:imgView];
            }
        }
        if (self.bundleImgArray.count != 0) {
            [self layoutImages];
            [self startTimer];
        }
    }
    return self;
}

//- (NSMutableArray *)requestCycleImageData{
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    __block NSMutableArray *array = [NSMutableArray new];
//    [manager GET:self.urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        NSLog(@"显示当前进程");
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        if (self.delegate && [self.delegate respondsToSelector:@selector(loadDataFinished)]) {
//            [self.delegate loadDataFinished];
//        }
//        NSLog(@">>>>>成功");
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        if (dic != nil) {
//            if (self.delegate && [self.delegate respondsToSelector:@selector(isupdated:)]) {
//                [self.delegate isupdated:YES];
//            }
//            NSFileManager *manager = [NSFileManager defaultManager];
//            NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
//            NSString *filePath = [cachesPath stringByAppendingPathComponent:@"cycleFile.txt"];
//            if (![manager fileExistsAtPath:filePath]) {
//                self.isNeedUpdate = YES;
//            }
//            if (self.isNeedUpdate == YES) {
//                NSArray *dataArray = dic[@"data"];
//                for (NSDictionary *imageUrlDic in dataArray) {
//                    RFCycleViewModel *model = [[RFCycleViewModel alloc]init];
//                    [model setValuesForKeysWithDictionary:imageUrlDic];
//                    [array addObject:model];
//                }
//                NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
//                NSString *fileDir = [cachesPath stringByAppendingPathComponent:@"cycleFile.txt"];
//                NSFileManager *manager = [[NSFileManager alloc]init];
//                [manager createFileAtPath:fileDir contents:responseObject attributes:nil];
//            } else if (self.isNeedUpdate == NO){
//                self.cycleViewArray = [self analysisCachesData];
//                NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
//                NSString *fileDir = [cachesPath stringByAppendingPathComponent:@"cycleFile.txt"];
//                NSFileManager *manager = [[NSFileManager alloc]init];
//                [manager createFileAtPath:fileDir contents:responseObject attributes:nil];
//            }
//        } else {
//            if (self.delegate && [self.delegate respondsToSelector:@selector(lastPictureActionWithTag:)]) {
//                [self.delegate isupdated:NO];
//            }
//            array = [self analysisCachesData];
//        }
//        [self layoutImages];
//        [self startTimer];
//        self.imgPageControl.numberOfPages = self.cycleViewArray.count;
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        self.cycleViewArray = [self analysisCachesData];
//        [self layoutImages];
//        [self startTimer];
//        self.imgPageControl.numberOfPages = self.cycleViewArray.count;
//    }];
//    return array;
//}

- (NSMutableArray *)analysisCachesData{
    NSFileManager *manager = [NSFileManager defaultManager];
    NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *filePath = [cachesPath stringByAppendingPathComponent:@"cycleFile.txt"];
    NSMutableArray *array = [NSMutableArray new];
    if ([manager fileExistsAtPath:filePath]) {
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *dataArray = dic[@"data"];
        for (NSDictionary *imageUrlDic in dataArray) {
            RFCycleViewModel *model = [[RFCycleViewModel alloc]init];
            [model setValuesForKeysWithDictionary:imageUrlDic];
            [array addObject:model];
        }
    }
    return array;
}

- (void)startTimer{
    if ((self.bundleImgArray.count == 0 && self.cycleViewArray.count == 0) || self.bundleImgArray.count == 1 || self.cycleViewArray.count == 1) {
        return;
    }
    if (self.bundleImgArray.count != 1 || self.cycleViewArray.count != 1) {
        if (self.interval <= 0) {
            self.imgTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        }else{
            self.imgTimer = [NSTimer scheduledTimerWithTimeInterval:self.interval target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
        }
    }
}

- (void)timerAction{
    if (self.bundleImgArray.count == 0) {
        [self.imgScrollView setContentOffset:CGPointMake(self.imgScrollView.frame.size.width * 2, 0) animated:YES];
        self.index = (self.index + 1) % self.cycleViewArray.count;
        if (self.index == self.cycleViewArray.count - 1) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(lastPictureActionWithTag:)]) {
                [self.delegate lastPictureActionWithTag:2];
            }
        }
    } else {
        [self.imgScrollView setContentOffset:CGPointMake(self.imgScrollView.frame.size.width * 2, 0) animated:YES];
        self.index = (self.index + 1) % self.bundleImgArray.count;
        if (self.index == self.bundleImgArray.count - 1) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(lastPictureActionWithTag:)]) {
                [self.delegate lastPictureActionWithTag:2];
            }
        }
    }
}

- (void)closeButtonPostion:(CycleViewCloseButtonPostion)postion{
    switch (postion) {
        case CloseButton_Top:
            self.closeButton.frame = CGRectMake(self.bounds.size.width - 50, 200, 40, 40);
            break;
        case CloseButton_Middle:
            self.closeButton.frame = CGRectMake(self.bounds.size.width - 50, self.center.y, 40, 40);
            break;
        default:
            self.closeButton.frame = CGRectMake(self.bounds.size.width - 50, self.frame.size.height - 50, 40, 40);
            break;
    }
}

- (void)pageControlPostion:(PageControlPostion)postion{
    CGSize size;
    if (self.bundleImgArray.count == 0) {
        size = [self.imgPageControl sizeForNumberOfPages:self.cycleViewArray.count];
    } else {
        size = [self.imgPageControl sizeForNumberOfPages:self.bundleImgArray.count];
    }
    switch (postion) {
        case PageControl_Left:
            self.imgPageControl.frame = CGRectMake(10, self.bounds.size.height - 50, size.width, size.height);
            break;
        case PageControl_Middle:
            self.imgPageControl.frame = CGRectMake(self.center.x, self.bounds.size.height - 50, size.width, size.height);
            break;
        default:
            self.imgPageControl.frame = CGRectMake(self.bounds.size.width - size.width - 10, self.bounds.size.height - 50, size.width, size.height);
            break;
    }
}

- (void)layoutImages{
    if (self.bundleImgArray.count == 0 && self.cycleViewArray.count == 0) {
        return;
    }
    if (self.bundleImgArray.count == 1 || self.cycleViewArray.count == 1) {
        self.imgScrollView.contentSize = CGSizeMake(self.imgScrollView.frame.size.width, 0);
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCycleViewAction:)];
        [(UIImageView *)self.imgViewArray[0] addGestureRecognizer:tap];
        [(UIImageView *)self.imgViewArray[0] setUserInteractionEnabled:YES];
    } else {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCycleViewAction:)];
        [(UIImageView *)self.imgViewArray[1] addGestureRecognizer:tap];
        [(UIImageView *)self.imgViewArray[1] setUserInteractionEnabled:YES];
    }
    if (self.bundleImgArray.count == 0) {
        if (self.cycleViewArray.count == 1) {
            RFCycleViewModel* tempItem = self.cycleViewArray[0];
            if(tempItem!=nil){
//                [self.imgViewArray[0] sd_setImageWithURL:[NSURL URLWithString:tempItem.image] placeholderImage:[UIImage imageNamed:@"c2.jpg"]];
            }
        } else {
            for (int i = 0; i < 3; i ++) {
                RFCycleViewModel* tempItem = [self.cycleViewArray objectAtIndex:(self.index - 1 + i + self.cycleViewArray.count) % self.cycleViewArray.count];
                if(tempItem!=nil){
//                    [self.imgViewArray[i] sd_setImageWithURL:[NSURL URLWithString:tempItem.image] placeholderImage:[UIImage imageNamed:@"c1.jpg"]];
                }
            }
        }
    } else {
        if (self.bundleImgArray.count == 1) {
            UIImage *image = [UIImage imageNamed:self.bundleImgArray[0]];
            [self.imgViewArray[0] setImage:image];
        } else {
            for (int i = 0; i < 3; i ++) {
                UIImage *image = [UIImage imageNamed:self.bundleImgArray[(self.index - 1 + i + self.bundleImgArray.count) % self.bundleImgArray.count]];
                [self.imgViewArray[i] setImage:image];
            }
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    self.x = scrollView.contentOffset.x;
    [self.imgTimer setFireDate:[NSDate distantFuture]];
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (self.x > scrollView.contentOffset.x) {
        [self panToLeft:NO Index:self.index];
    }else if (self.x < scrollView.contentOffset.x){
        [self panToLeft:YES Index:self.index];
    }
    [self.imgTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:2]];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    [self.imgScrollView setContentOffset:CGPointMake(scrollView.frame.size.width, 0) animated:NO];
    [self layoutImages];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.imgScrollView setContentOffset:CGPointMake(scrollView.contentOffset.x, 0)];
}
- (void)tapCycleViewAction:(UITapGestureRecognizer *)tap{
    if (self.cycleViewArray.count == 0) {
        if (self.tapBlock) {
            self.tapBlock(nil,self.index);
        }
    } else {
        if (self.tapBlock) {
            self.tapBlock(self.cycleViewArray[self.index],self.index);
        }
    }
}
- (void)panToLeft:(BOOL)left Index:(NSInteger)index{
    if (self.cycleViewArray.count == 0 && self.bundleImgArray.count == 0) {
        return;
    }
    if (self.bundleImgArray.count == 0) {
        if (self.cycleViewArray.count > 1) {
            if (!left) {
                self.index = (index - 1 + self.cycleViewArray.count) % self.cycleViewArray.count;
            }else{
                self.index = (index + 1) % self.cycleViewArray.count;
            }
            [self layoutImages];
            [self.imgScrollView setContentOffset:CGPointMake(self.frame.size.width, 0)animated:NO];
        }
    } else {
        if (self.bundleImgArray.count > 1) {
            if (!left) {
                self.index = (index - 1 + self.bundleImgArray.count) % self.bundleImgArray.count;
            }else{
                self.index = (index + 1) % self.bundleImgArray.count;
            }
            [self layoutImages];
            [self.imgScrollView setContentOffset:CGPointMake(self.frame.size.width, 0)animated:NO];
        }
    }
}

- (void)setIndex:(NSInteger)index{
    if (_index != index) {
        _index = index;
        self.imgPageControl.currentPage = index;
    }
}

- (void)addTapBlock:(void (^)(RFCycleViewModel *, NSInteger))block{
    self.tapBlock = block;
}

- (void)closeCycleButtonAction{
    [self removeFromSuperview];
    [self.imgTimer invalidate];
    self.imgTimer = nil;
    if (self.delegate && [self.delegate respondsToSelector:@selector(isCloseCycleView:)]) {
        [self.delegate isCloseCycleView:YES];
    }
}

- (void)stopOrStartTimer:(BOOL)stopOrStartTimer{
    if (stopOrStartTimer == YES) {
        if (self.imgTimer != nil) {
            [self.imgTimer invalidate];
            self.imgTimer = nil;
        }
    } else {
        if (self.imgTimer == nil) {
            [self startTimer];
        }
    }
}

@end
