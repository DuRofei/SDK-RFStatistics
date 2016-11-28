//
//  MoreViewController.m
//  CNTVPublicSentiment
//
//  Created by wiseweb on 16/11/9.
//  Copyright © 2016年 wiseweb. All rights reserved.
//

#import "MoreViewController.h"
#import "JPUSHService.h"

@interface MoreViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *optionArray;


@end

@implementation MoreViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view addSubview:self.tableView];
    self.optionArray = @[@"退出登录",@"关于"];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView reloadData];
}

- (void)logout {
    [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"状态"];
    [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"token"];
    [JPUSHService setAlias:@"" callbackSelector:nil object:self];
    [self.tabBarController.navigationController popToRootViewControllerAnimated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.optionArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text=[self.optionArray objectAtIndex:indexPath.row];
    cell.textLabel.font=[UIFont systemFontOfSize:14];
    [cell.textLabel setLineBreakMode:NSLineBreakByWordWrapping];
    [cell.textLabel setNumberOfLines:0];
    cell.detailTextLabel.font=[UIFont systemFontOfSize:12];
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"是否退出系统" message:nil preferredStyle:UIAlertControllerStyleAlert];
        __weak typeof(self)weakself = self;
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"是" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
             [weakself logout];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"否" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:cancelAction];
        [alertController addAction:sureAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_Name = [infoDictionary objectForKey:@"CFBundleDisplayName"];
        NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
        NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];
        NSString *app_versionbuild = [NSString stringWithFormat:@"版本号:%@.%@",app_Version,app_build];
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:app_Name message:app_versionbuild preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:sureAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
