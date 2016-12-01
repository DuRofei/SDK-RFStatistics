//
//  RFCycleBaseView.m
//  RFCycleView
//
//  Created by DuRofei on 16/9/23.
//  Copyright © 2016年 DuRofei. All rights reserved.
//

#import "RFCycleBaseView.h"


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
//#import <AFNetworking/AFNetworking.h>
//#import "UIImageView+WebCache.h"
//#import "SDWebImageManager.h"
#import "FirstViewController.h"
@interface RFCycleBaseView ()<UIScrollViewDelegate>

//scrollView
@property (nonatomic, strong) UIScrollView    *imgScrollView;
//pageControl
@property (nonatomic, strong) UIPageControl   *imgPageControl;
//ImageViewArray
@property (nonatomic, strong) NSMutableArray  *imgViewArray;
//存放图片的array
@property (nonatomic, strong) NSMutableArray  *imgArray;
//当前展示的图片下标
@property (nonatomic, assign) NSInteger        index;
//timer
@property (nonatomic, strong) NSTimer         *imgTimer;
//点击回调 block
@property (nonatomic, copy)   void(^tapBlock)(RFCycleViewModel *model);
//参数传过来的url
@property (nonatomic, strong) NSString        *urlString;
//请求下来的轮播图片数组
@property (nonatomic, strong) UIButton        *closeButton;
//轮播图时间间隔
@property (nonatomic, assign) NSTimeInterval   interval;
//数据源数组
@property (nonatomic, strong) NSMutableArray *cycleViewArray;
//缓存的数据源数组
@property (nonatomic, strong) NSMutableArray *CachesCycleViewArray;
//数据源模型
@property (nonatomic, strong) RFCycleViewModel *model;
//图片url数组
@property (nonatomic, strong) NSMutableArray *imgUrlArray;
//存储图片名的数组
@property (nonatomic, strong) NSMutableArray *imgNameArray;
//判断轮播图内容是否已经更新
@property (nonatomic, assign) BOOL isUpdate;
@end

@implementation RFCycleBaseView

//判断某个数据是否已经更新

- (void)analysisCachesData{
    NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
    NSString *fileDir = [cachesPath stringByAppendingPathComponent:@"cycleFile.txt"];
    NSData *data = [NSData dataWithContentsOfFile:fileDir];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSArray *dataArray = dic[@"data"];
    RFCycleViewModel *model = [[RFCycleViewModel alloc]init];
    for (NSDictionary *imageUrlDic in dataArray) {
        [model setValuesForKeysWithDictionary:imageUrlDic];
        [self.cycleViewArray addObject:model];
    }
}

//- (void)requestCycleImageData{
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    [manager GET:_urlString parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
//        NSLog(@"显示当前进程");
//    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
//        NSArray *dataArray = dic[@"data"];
//        RFCycleViewModel *model = [[RFCycleViewModel alloc]init];
//        for (NSDictionary *imageUrlDic in dataArray) {
//            NSString *cid = imageUrlDic[@"cid"];
//            if (cid == model.cid) {
//                self.isUpdate = NO;
//            }else{
//                self.isUpdate = YES;
//                [model setValuesForKeysWithDictionary:imageUrlDic];
//                [self.cycleViewArray addObject:model];
//            }
//        }
//        NSString *cachesPath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
//        NSString *fileDir = [cachesPath stringByAppendingPathComponent:@"cycleFile.txt"];
//        NSFileManager *manager = [[NSFileManager alloc]init];
//        [manager createFileAtPath:fileDir contents:responseObject attributes:nil];
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [self analysisCachesData];
//    }];
//}


@end

