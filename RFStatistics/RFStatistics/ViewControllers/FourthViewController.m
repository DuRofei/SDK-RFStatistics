//
//  FourthViewController.m
//  RFStatistics
//
//  Created by wiseweb on 16/11/30.
//  Copyright © 2016年 wiseweb. All rights reserved.
//

#import "FourthViewController.h"

@interface FourthViewController ()

@end

@implementation FourthViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    switch ([self.viewID integerValue]) {
        case 1:
            self.view.backgroundColor = [UIColor redColor];
            break;
        case 2:
            self.view.backgroundColor = [UIColor greenColor];
            break;
        case 3:
            self.view.backgroundColor = [UIColor yellowColor];
            break;
        case 4:
            self.view.backgroundColor = [UIColor grayColor];
            break;
        case 5:
            self.view.backgroundColor = [UIColor whiteColor];
            break;
        case 6:
            self.view.backgroundColor = [UIColor blueColor];
            break;
        case 7:
            self.view.backgroundColor = [UIColor magentaColor];
            break;
        case 8:
            self.view.backgroundColor = [UIColor cyanColor];
            break;
        case 9:
            self.view.backgroundColor = [UIColor brownColor];
            break;
            
        default:
            self.view.backgroundColor = [UIColor lightGrayColor];
            break;
    }
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSLog(@"self.view.subviews = %@",self.view);

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
