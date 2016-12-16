//
//  FirstViewController.m
//  RFStatistics
//
//  Created by wiseweb on 16/11/30.
//  Copyright © 2016年 wiseweb. All rights reserved.
//

#import "FirstViewController.h"
#import "Masonry.h"
#import "SecondViewController.h"
#import "ThirdViewController.h"
#import "AViewController.h"
#import "BViewController.h"
#import "CViewController.h"
#import "DViewController.h"

@interface FirstViewController ()<UITextFieldDelegate,UITabBarControllerDelegate>
@property (nonatomic, strong) NSString *labelStr;
@property (nonatomic, strong) NSString *textfieldStr;
@property (nonatomic, strong) UITextField *textField1;
@property (nonatomic, strong) UITextField *textField2;
@property (nonatomic, strong) UIButton *button3;




@end

@implementation FirstViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button1 setTitle:@"button1" forState:UIControlStateNormal];
    button1.backgroundColor = [UIColor redColor];
    [button1 addTarget:self action:@selector(button1Action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    
    UISwitch *switch1 = [[UISwitch alloc]init];
    [self.view addSubview:switch1];
    
    [button1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(100);
        make.left.mas_offset(50);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    
    UILabel *label1 = [[UILabel alloc]init];
    label1.backgroundColor = [UIColor greenColor];
    label1.text = @"看我是个label哈哈";
//    label1.userInteractionEnabled = YES;

    [self.view addSubview:label1];
    
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(200);
        make.left.mas_equalTo(50);
        make.size.mas_equalTo(CGSizeMake(150, 30));
    }];
    
    self.textField1 = [[UITextField alloc]init];
    self.textField1.placeholder = @"请输入文字";
    self.textField1.layer.borderWidth = 1;
    self.textfieldStr = self.textField1.text;
//    self.textField1.delegate = self;
    [self.view addSubview:self.textField1];
    
    [self.textField1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(300);
        make.left.mas_equalTo(50);
        make.size.mas_equalTo(CGSizeMake(150, 30));
    }];
    
    self.textField2 = [[UITextField alloc]init];
    self.textField2.placeholder = @"请输入文字222";
    self.textField2.layer.borderWidth = 1;
    self.textfieldStr = self.textField2.text;
    self.textField2.delegate = self;
    [self.view addSubview:self.textField2];
    
    [self.textField2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(350);
        make.left.mas_equalTo(50);
        make.size.mas_equalTo(CGSizeMake(150, 30));
    }];
    
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    [button2 setTitle:@"button2" forState:UIControlStateNormal];
    button2.backgroundColor = [UIColor redColor];
    [button2 addTarget:self action:@selector(button2Action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    
    [button2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(100);
        make.left.mas_offset(150);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    
    self.button3 = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.button3 setTitle:@"button3" forState:UIControlStateNormal];
    self.button3.backgroundColor = [UIColor redColor];
    [self.button3 addTarget:self action:@selector(button3Action) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button3];
    
    
    [self.button3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_offset(100);
        make.left.mas_offset(250);
        make.size.mas_equalTo(CGSizeMake(60, 30));
    }];
    

    
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)button1Action{
    SecondViewController *secondVC = [[SecondViewController alloc]init];
    [self.navigationController pushViewController:secondVC animated:YES];
}

- (void)button2Action{
    AViewController *avc = [[AViewController alloc]init];
    UINavigationController *anav = [[UINavigationController alloc]initWithRootViewController:avc];
    anav.tabBarItem = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemSearch tag:0];
//    [self setTabBarItem:anav.tabBarItem Title:@"A" withTitleSize:20 andFoneName:@"Marion-Italic" selectedImage:nil withTitleColor:nil unselectedImage:nil withTitleColor:nil];
    
    BViewController *bvc = [[BViewController alloc]init];
    UINavigationController *bnav = [[UINavigationController alloc]initWithRootViewController:bvc];
    bnav.tabBarItem = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemMore tag:1];
//    [self setTabBarItem:bnav.tabBarItem Title:@"B" withTitleSize:20 andFoneName:@"Marion-Italic" selectedImage:nil withTitleColor:nil unselectedImage:nil withTitleColor:nil];
    
    CViewController *cvc = [[CViewController alloc]init];
    UINavigationController *cnav = [[UINavigationController alloc]initWithRootViewController:cvc];
    cnav.tabBarItem = [[UITabBarItem alloc]initWithTabBarSystemItem:UITabBarSystemItemContacts tag:2];
//    [self setTabBarItem:cnav.tabBarItem Title:@"C" withTitleSize:20 andFoneName:@"Marion-Italic" selectedImage:nil withTitleColor:nil unselectedImage:nil withTitleColor:nil];
    
    DViewController *dvc = [[DViewController alloc]init];
    UINavigationController *dnav = [[UINavigationController alloc]initWithRootViewController:dvc];
    dnav.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"D" image:nil tag:3];
    
    UITabBarController *tabbars = [[UITabBarController alloc]init];
    tabbars.delegate = self;
    [tabbars setViewControllers:@[anav,bnav,cnav,dnav]];
    
    [self.navigationController pushViewController:tabbars animated:YES];
}

- (void)button3Action{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"登录" message:@"请输入帐号密码" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"cancel" style:UIAlertActionStyleCancel handler:nil];
    [alertController addAction:action1];
    [alertController addAction:action2];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入帐号";
    }];
    [alertController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"请输入密码";
    }];
    [self presentViewController:alertController animated:YES completion:nil];
    
    
//    
////    SecontViewController *secondVC = [[SecontViewController alloc]init];
////    [self.navigationController pushViewController:secondVC animated:YES];
//    NSString *title = [self.button3 currentTitle];
////    NSLog(@"button3.title = %@",title);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.textField1 resignFirstResponder];
    [self.textField2 resignFirstResponder];

}

- (void)setTabBarItem:(UITabBarItem *)tabbarItem
                Title:(NSString *)title
        withTitleSize:(CGFloat)size
          andFoneName:(NSString *)foneName
        selectedImage:(NSString *)selectedImage
       withTitleColor:(UIColor *)selectColor
      unselectedImage:(NSString *)unselectedImage
       withTitleColor:(UIColor *)unselectColor{
    
    //设置图片
    tabbarItem = [tabbarItem initWithTitle:title image:[[UIImage imageNamed:unselectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[[UIImage imageNamed:selectedImage]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
//    //未选中字体颜色
//    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:unselectColor,NSFontAttributeName:[UIFont fontWithName:foneName size:size]} forState:UIControlStateNormal];
//    
//    //选中字体颜色
//    [[UITabBarItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:selectColor,NSFontAttributeName:[UIFont fontWithName:foneName size:size]} forState:UIControlStateSelected];
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
//    NSLog(@"text = %@",textField.text);
//    NSLog(@"placeHolder = %@",textField.placeholder);
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    
}

@end
