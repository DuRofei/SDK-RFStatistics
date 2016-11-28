//
//  BaseTableViewController.m
//  CNTVPublicSentiment
//
//  Created by wiseweb on 16/11/11.
//  Copyright © 2016年 wiseweb. All rights reserved.
//
static NSString *informationCell = @"informationCell";

#import "BaseTableViewController.h"
#import "BaseModel.h"
#import "BaseTableViewCell.h"
#import "InformationViewController.h"
#import "DetailViewController.h"
#import "WYWebController.h"


@interface BaseTableViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, assign) int addNum;
@property (nonatomic, strong) UIScrollView *scrollViewId;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) id totalcount;
@property (nonatomic, strong) UILabel *totalLabel;




@end

@implementation BaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    if (self.isSearch) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    } else {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 108, kScreenWidth, kScreenHeight - 115)];
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, kScreenWidth, 15)];
        self.tableView.tableHeaderView = headerView;
    }
    [self.view addSubview:self.tableView];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;    
    
    __weak typeof(self)weakself = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakself.addNum = 0;
        [weakself requestDataWithTag:1];
    }];
    [self againRefresh:nil];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakself requestDataWithTag:2];
    }];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(againRefresh:) name:@"againrefresh" object:nil];
}

- (void)againRefresh:(NSNotification *)notification {
    if (notification == nil) {
        [self.tableView.mj_header beginRefreshing];
    } else {
        NSInteger pushindex = [[notification.userInfo valueForKey:@"moduleKey"] integerValue];
        if (pushindex == 1) {
            [self.tableView.mj_header beginRefreshing];
        }
    }
}

- (void)viewDidCurrentView {
    NSLog(@"加载为当前视图 = %@",self.title);
}


- (void)requestDataWithTag:(NSInteger)tag {
    [self showWaitMessage];

    if (self.isSearch) {
        NSString *url_apiPath = [[NSString alloc]initWithFormat:@"solrSearchInfo.action"];
        self.searchParam[@"start"] = [[NSString alloc]initWithFormat:@"%d",self.addNum];
        self.searchParam[@"size"] = @"10";
        [self requestWithPara:self.searchParam path:url_apiPath method:kGET tag:tag];
    } else {
        if ([self.groupID isEqualToString:@"5"]) {
            self.groupID = @"11";
        }
        if ([self.groupID isEqualToString:@"6"]) {
            self.groupID = @"5";
        }
        if ([self.groupID isEqualToString:@"7"]) {
            self.groupID = @"6";
        }
        if ([self.groupID isEqualToString:@"8"]) {
            self.groupID = @"7";
        }
        NSString *url_apiPath = [[NSString alloc]initWithFormat:@"findDocInfo.action"];
        NSMutableDictionary *url_params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           self.groupID, @"groupId",
                                           [[NSString alloc]initWithFormat:@"%d",self.addNum], @"start",
                                           @"10", @"size",
                                           [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"], @"userId",
                                           @"publishtime", @"orderby",
                                           @"desc", @"order",
                                           nil];
        [self requestWithPara:url_params path:url_apiPath method:kGET tag:tag];
    }
}

- (void)requestFinish:(id)data tag:(NSInteger)tag {
    [self performDismiss];
    if (data == nil) {
        return;
    }
    id jsonValue=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"jsonValue = %@",jsonValue);
    NSMutableArray *array = [NSMutableArray array];
    
    if (self.isSearch) {
        self.totalcount = [jsonValue objectForKey:@"totalCount"];
    }
    
    array = [NSMutableArray arrayWithArray:[jsonValue objectForKey:@"result"]];
    NSMutableArray *statusArray = [NSMutableArray array];
    for (NSMutableDictionary *docDic in array) {
        BaseModel *model = [[BaseModel alloc]init];
        [model setValuesForKeysWithDictionary:docDic];
        [statusArray addObject:model];
    }

    if (tag == 1) {
        self.dataArray = statusArray;
    } else if (tag == 2) {
        [self.dataArray addObjectsFromArray:statusArray];
    }
    

    if (self.isSearch) {
        if ([self.searchParam[@"order"] isEqualToString:@"asc"]) {
            for (int i = 0; i < self.dataArray.count; i ++) {
                for (int j = i + 1; j < self.dataArray.count; j ++) {
                    BaseModel *modeli = self.dataArray[i];
                    BaseModel *modelj = self.dataArray[j];
                    int result = [self compareOneDay:modeli.publishtime withAnotherDay:modelj.publishtime];
                    if (result == 1) {
                        [self.dataArray exchangeObjectAtIndex:i withObjectAtIndex:j];
                    }
                }
            }
        } else {
            for (int i = 0; i < self.dataArray.count; i ++) {
                for (int j = i + 1; j < self.dataArray.count; j ++) {
                    BaseModel *modeli = self.dataArray[i];
                    BaseModel *modelj = self.dataArray[j];
                    int result = [self compareOneDay:modeli.publishtime withAnotherDay:modelj.publishtime];
                    if (result == -1) {
                        [self.dataArray exchangeObjectAtIndex:i withObjectAtIndex:j];
                    }
                }
            }
        }

    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
    self.addNum += 10;
    [self.tableView.mj_header endRefreshing];
    
    if (self.dataArray.count == 0) {
        [self showTextMessage:@"暂无数据"];
    }

    if (self.dataArray.count % 10 == 0) {
        [self.tableView.mj_footer endRefreshing];
    } else {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
}

- (void)requestFail:(id)error tag:(NSInteger)tag {
    [self.tableView.mj_header endRefreshing];
//    NSLog(@"shibailelellelelelelelelelelelelelelelel");
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (self.isSearch) {
        self.totalLabel = [[UILabel alloc]init];
        self.totalLabel.frame = CGRectMake(0, 0, kScreenWidth, 14);
        self.totalLabel.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
        self.totalLabel.text = [NSString stringWithFormat:@"检索到%@条数据",self.totalcount];
        [self.totalLabel setFont:[UIFont systemFontOfSize:12]];
        self.totalLabel.textAlignment = NSTextAlignmentCenter;
    }
    return self.totalLabel;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (self.isSearch) {
        return 30;
    } else {
        return 0;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 90;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailViewController *detailVC = [[DetailViewController alloc]init];
    UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:detailVC];
    BaseModel *model = self.dataArray[indexPath.row];
    [detailVC setModel:model];
    [self presentViewController:navC animated:YES completion:nil];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:informationCell];
    if (!cell) {
        cell = [[BaseTableViewCell alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    }
    BaseModel *model = self.dataArray[indexPath.row];
    [cell setModel:model];
    return cell;
}

#pragma mark - 比较两个date的大小
- (int)compareOneDay:(NSDate *)oneDay withAnotherDay:(NSDate *)anotherDay
{
    NSComparisonResult result = [oneDay compare:anotherDay];
    if (result == NSOrderedDescending) {
        return 1;
    }
    else if (result == NSOrderedAscending){
        return -1;
    }
    return 0;
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter]removeObserver:@"againrefresh"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
