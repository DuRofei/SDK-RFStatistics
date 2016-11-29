//
//  EarlywarningViewController.m
//  CNTVPublicSentiment
//
//  Created by wiseweb on 16/11/9.
//  Copyright © 2016年 wiseweb. All rights reserved.
//

static NSString *earlywarningCellID = @"earlywarningCellID";
#import "EarlywarningViewController.h"
#import "EarlywarningTableViewCell.h"
#import "BaseModel.h"
#import "DetailViewController.h"

@interface EarlywarningViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign) NSInteger addNum;

@end

@implementation EarlywarningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = [NSMutableArray array];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
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
        if (pushindex == 2) {
            [self.tableView.mj_header beginRefreshing];
        }
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    EarlywarningTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:earlywarningCellID];
    if (!cell) {
        cell = [[EarlywarningTableViewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    }
    BaseModel *model = self.dataArray[indexPath.row];
    [cell setModel:model];
 

    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    DetailViewController *detailVC = [[DetailViewController alloc]init];
    UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:detailVC];
    BaseModel *model = self.dataArray[indexPath.row];
    [detailVC setModel:model];
    [self presentViewController:navC animated:YES completion:nil];
}

- (void)requestDataWithTag:(NSInteger)tag {
    [self showWaitMessage];
    NSString *url_apiPath = [[NSString alloc]initWithFormat:@"findEarlyWarningInfo.action"];
    NSMutableDictionary *url_params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                [[NSString alloc]initWithFormat:@"%ld",(long)self.addNum], @"start",
                                @"10", @"size",
                                [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"], @"userId",
                                @"publishtime", @"orderby",
                                @"desc", @"order",
                                nil];
    [self requestWithPara:url_params path:url_apiPath method:kGET tag:tag];
}

- (void)requestFinish:(id)data tag:(NSInteger)tag {
    if (data == nil) {
        return;
    }
    [self performDismiss];
    id jsonValue = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
//    NSLog(@"jsonValue = %@",jsonValue);
    NSMutableArray *array = [NSMutableArray array];
    array = [jsonValue valueForKey:@"result"];
    NSMutableArray *tempArray = [NSMutableArray array];
    for (NSDictionary *dic in array) {
        BaseModel *model = [[BaseModel alloc]init];
        [model setValuesForKeysWithDictionary:dic];
        [tempArray addObject:model];
    }
    if (tag == 1) {
        self.dataArray = tempArray;
    } else if (tag == 2) {
        [self.dataArray addObjectsFromArray:tempArray];
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
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter]removeObserver:@"againrefresh"];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
