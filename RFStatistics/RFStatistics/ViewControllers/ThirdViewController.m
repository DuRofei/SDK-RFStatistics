//
//  ThirdViewController.m
//  RFStatistics
//
//  Created by wiseweb on 16/11/30.
//  Copyright © 2016年 wiseweb. All rights reserved.
//

#import "ThirdViewController.h"
#import "AViewController.h"
#import "BViewController.h"
#import "CViewController.h"

@interface ThirdViewController ()

@end

@implementation ThirdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSLog(@"看我来到了thirdcontroller了");
    
    AViewController *avc = [[AViewController alloc]init];
    UINavigationController *anav = [[UINavigationController alloc]initWithRootViewController:avc];
    anav.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"A" image:nil tag:0];
    
    BViewController *bvc = [[BViewController alloc]init];
    UINavigationController *bnav = [[UINavigationController alloc]initWithRootViewController:bvc];
    bnav.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"B" image:nil tag:1];
    
    CViewController *cvc = [[CViewController alloc]init];
    UINavigationController *cnav = [[UINavigationController alloc]initWithRootViewController:cvc];
    cnav.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"A" image:nil tag:2];
    
    UITabBarController *tabbars = [[UITabBarController alloc]init];
    [tabbars setViewControllers:@[anav,bnav,cnav]];
    
    [self.navigationController pushViewController:tabbars animated:NO];
    // Do any additional setup after loading the view.
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
