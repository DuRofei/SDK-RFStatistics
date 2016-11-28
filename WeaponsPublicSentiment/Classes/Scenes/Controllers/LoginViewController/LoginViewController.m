//
//  LoginViewController.m
//  CNTVPublicSentiment
//
//  Created by wiseweb on 16/11/9.
//  Copyright © 2016年 wiseweb. All rights reserved.
//

#import "LoginViewController.h"
#import "InformationViewController.h"
#import "SearchViewController.h"
#import "EarlywarningViewController.h"
#import "MoreViewController.h"
#import "PublicReportViewController.h"
#import "UIImage+Tint.h"
#import "AppDelegate.h"
#import "JPUSHService.h"

@interface LoginViewController ()
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) UISwitch *rememberPassword;
@property (nonatomic, strong) MBProgressHUD *hud;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self layoutViews];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getThePush:) name:@"pushIndex" object:nil];
    self.title = @"央视舆情";
    self.navigationController.navigationBarHidden = YES;
    self.username.text = [[NSUserDefaults standardUserDefaults]stringForKey:@"用户名"];
    if ([[[NSUserDefaults standardUserDefaults] stringForKey:@"状态"]isEqualToString:@"1"]) {
        self.password.text = [[NSUserDefaults standardUserDefaults] stringForKey:@"密码"];
        [self doPush:NO];
    }

}

#pragma mark - 加载UI
- (void)layoutViews {
    __weak typeof(self)weakself = self;
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    imageView.image = [UIImage imageNamed:@"bg.jpg"];
    [self.view addSubview:imageView];
    UIImageView *wisewebView = [[UIImageView alloc]init];
    wisewebView .image = [UIImage imageNamed:@"网智logo.png"];
    [imageView addSubview:wisewebView ];
    [wisewebView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(imageView).with.offset(30);
        make.right.mas_equalTo(imageView.mas_right);
        make.size.mas_equalTo(CGSizeMake(85, 39));
    }];
    
    UIImageView *weaponView = [[UIImageView alloc]init];
    weaponView.image = [UIImage imageNamed:@"login_logo.png"];
    [imageView addSubview:weaponView];
    [weaponView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(wisewebView.mas_bottom).with.offset(30);
        make.centerX.equalTo(imageView);
        make.left.mas_equalTo(imageView).with.offset(30);
        make.right.mas_equalTo(imageView).with.offset(-30);
        make.height.mas_equalTo(weaponView.mas_width).multipliedBy(0.29);
    }];

    UIView *lineView1 = [[UIView alloc]init];
    lineView1.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
    [imageView addSubview:lineView1];

    UIView *lineView2 = [[UIView alloc]init];
    lineView2.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1];
    [imageView addSubview:lineView2];
    
    UIImageView *userIconView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 30, 30)];
    userIconView.image = [UIImage imageNamed:@"mlogin1.png"];
    [imageView addSubview:userIconView];
    
    UIImageView *passIconView = [[UIImageView alloc]init];
    passIconView.image = [UIImage imageNamed:@"mlogin2.png"];
    [imageView addSubview:passIconView];
    
    self.username = [[UITextField alloc]init];
    self.username.returnKeyType = UIReturnKeyNext;
    self.username.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.username.delegate = self;
    self.username.placeholder = @"请输入用户名";
    self.username.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.username];
    
    self.password = [[UITextField alloc]init];
    self.password.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.password.delegate = self;
    self.password.placeholder = @"请输入密码";
    self.password.secureTextEntry = YES;
    self.password.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.view addSubview:self.password];
    
    [lineView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(lineView2.mas_top).with.offset(-60);
        make.left.mas_equalTo(imageView).with.offset(30);
        make.right.mas_equalTo(imageView).with.offset(-30);
        make.height.mas_equalTo(1);
    }];
    [lineView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(lineView1);
        make.centerX.equalTo(lineView1);
    }];
    [userIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(lineView1.mas_left);
        make.bottom.mas_equalTo(lineView1.mas_top).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [passIconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(imageView);
        make.left.mas_equalTo(lineView2.mas_left);
        make.bottom.mas_equalTo(lineView2.mas_top).with.offset(-10);
        make.size.mas_equalTo(CGSizeMake(30, 30));
    }];
    [self.username mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(userIconView);
        make.left.mas_equalTo(userIconView.mas_right).with.offset(20);
        make.right.mas_equalTo(lineView1);
    }];
    [self.password mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(passIconView);
        make.centerX.equalTo(weakself.username);
        make.size.mas_equalTo(weakself.username);
    }];
    
    self.rememberPassword = [[UISwitch alloc]init];
    [self.view addSubview:self.rememberPassword];
    
    UILabel *label = [[UILabel alloc]init];
    label.text = @"记住密码?";
    [label setFont:[UIFont systemFontOfSize:13]];
    label.textColor = [UIColor whiteColor];
    [self.view addSubview:label];
    
    [self.rememberPassword mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(lineView2).with.offset(15);
        make.right.mas_equalTo(imageView).with.offset(-90);
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakself.rememberPassword);
        make.left.mas_equalTo(weakself.rememberPassword.mas_right).with.offset(10);
        make.size.mas_equalTo(CGSizeMake(90, 15));
    }];

    
    UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [loginButton setTitle:@"登录" forState:UIControlStateNormal];
    [loginButton.titleLabel setFont:[UIFont systemFontOfSize:23]];
    loginButton.backgroundColor = RGBAlphaColorValue(0X2a7a80);
    loginButton.layer.cornerRadius = 5;
    [loginButton addTarget:self action:@selector(loginBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:loginButton];
    
    [loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(imageView);
        make.bottom.mas_equalTo(imageView).with.offset(-kScreenHeight/4);
        make.left.mas_equalTo(imageView).with.offset(30);
        make.right.mas_equalTo(imageView).with.offset(-30);
        make.height.mas_equalTo(50);
    }];
}

- (void)loginBtnAction {
    if ([self.username.text length]>0 &&[self.password.text length]>0) {
        [self showWaitMessage];
        NSString *url_apiPath = [[NSString alloc]initWithFormat:@"loginCheck.action"];
        NSMutableDictionary *url_params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           self.username.text, @"username",
                                           [[self md5:self.password.text] lowercaseString], @"password",[FCUUID uuidForDevice], @"appKey",
                                           nil];
        [self requestWithPara:url_params path:url_apiPath method:@"GET" tag:1];
        [self.username resignFirstResponder];
        [self.password resignFirstResponder];
        
    } else if (self.username.text.length  == 0 && self.password.text.length > 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入用户名" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:sureAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if (self.password.text.length  == 0 && self.username.text.length > 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:sureAction];
        [self presentViewController:alertController animated:YES completion:nil];
    } else if (self.username.text.length  == 0 && self.password.text.length == 0) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"请输入用户名及密码" message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:sureAction];
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - textfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (self.password == textField) {
        [self loginBtnAction];
        [textField resignFirstResponder];
    } else {
        [self.password becomeFirstResponder];
    }
    return YES;
}

#pragma mark - 网络请求返回方法
- (void)requestFinish:(id)data tag:(NSInteger)tag {
    [self performDismiss];
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
//    NSLog(@"dic = %@",dic);
    if (tag == 1) {
        if ([[dic objectForKey:@"entity"] isKindOfClass:[NSNull class]]) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"登录失败" message:@"用户名或密码错误" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:sureAction];
            [self presentViewController:alertController animated:YES completion:nil];
            return;
        }
        NSString *verifycode=[[NSString alloc]initWithFormat:@"%@",[[dic objectForKey:@"entity"] objectForKey:@"verifycode"]];
//        NSLog(@"verifycode = %@",verifycode);
        if ([verifycode isEqualToString:@"2"]) {
            NSNumber *selected =[NSNumber numberWithBool:_rememberPassword.isOn];
            [[NSUserDefaults standardUserDefaults] setObject:selected.stringValue forKey:@"状态"];
            [[NSUserDefaults standardUserDefaults] setObject:self.username.text forKey:@"用户名"];
            [[NSUserDefaults standardUserDefaults] setObject:self.password.text forKey:@"密码"];
            [[NSUserDefaults standardUserDefaults] setObject:[[NSString alloc]initWithFormat:@"%@",[[dic objectForKey:@"entity"] objectForKey:@"userId"]] forKey:@"userId"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [JPUSHService setAlias:[[NSUserDefaults standardUserDefaults] objectForKey:@"userId"] callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
            [self doPush:YES];
        } else {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"登录失败" message:@"用户名或密码错误" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:sureAction];
            [self presentViewController:alertController animated:YES completion:nil];
        }

    } else if (tag == 2) {
        if ([[dic objectForKey:@"entity"] isKindOfClass:[NSNull class]]) {
            return;
        }
        NSString *verifycode=[[NSString alloc]initWithFormat:@"%@",[[dic objectForKey:@"entity"] objectForKey:@"verifycode"]];
        if ([verifycode isEqualToString:@"4"]) {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"下线通知" message:@"您的帐号在别处登录" preferredStyle:UIAlertControllerStyleAlert];
            __weak typeof(self)weakself = self;
            UIAlertAction *sureAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"状态"];
                [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"token"];
                [JPUSHService setAlias:@"" callbackSelector:nil object:self];
                [weakself.navigationController popToRootViewControllerAnimated:YES];
                [weakself.timer invalidate];
            }];
            [alertController addAction:sureAction];
            [self presentViewController:alertController animated:YES completion:nil];
        } else if ([verifycode isEqualToString:@"5"]) {
            return;
        }
    }
}

- (void)requestFail:(id)error tag:(NSInteger)tag {

}

#pragma mark - push
- (void)doPush:(BOOL)animated {
    _timer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(timerAction) userInfo:nil repeats:YES];
    InformationViewController *informationView=[[InformationViewController alloc]init];
    informationView.title=@"舆情信息";
    UINavigationController *nav1=[[UINavigationController alloc]initWithRootViewController:informationView];
    UIImage *image1 = [[UIImage imageNamed:@"舆情信息"] imageWithTintOriginalColor:[UIColor blackColor]];
    UIImage *image11 = [[UIImage imageNamed:@"舆情信息"] imageWithTintOriginalColor:RGBAlphaColorValue(0X2a7a80)];
    nav1.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"舆情信息" image:image1 selectedImage:image11];
    
    PublicReportViewController *reportView=[[PublicReportViewController alloc]init];
    reportView.title=@"舆情报告";
    UINavigationController *nav2=[[UINavigationController alloc]initWithRootViewController:reportView];
    UIImage *image2 = [[UIImage imageNamed:@"舆情报告"] imageWithTintOriginalColor:[UIColor blackColor]];
    UIImage *image22 = [[UIImage imageNamed:@"舆情报告"] imageWithTintOriginalColor:RGBAlphaColorValue(0X2a7a80)];
    nav2.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"舆情报告" image:image2 selectedImage:image22];
    
    EarlywarningViewController *YQEarlyWarningView=[[EarlywarningViewController alloc]init];
    YQEarlyWarningView.title=@"舆情预警";
    UINavigationController *nav3=[[UINavigationController alloc]initWithRootViewController:YQEarlyWarningView];
    UIImage *image3 = [[UIImage imageNamed:@"预警"] imageWithTintOriginalColor:[UIColor blackColor]];
    UIImage *image33 = [[UIImage imageNamed:@"预警"] imageWithTintOriginalColor:RGBAlphaColorValue(0X2a7a80)];
    nav3.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"舆情预警" image:image3 selectedImage:image33];
    
    SearchViewController *YQSearchView = [[SearchViewController alloc]init];
    YQSearchView.title=@"舆情检索";
    UINavigationController *nav4=[[UINavigationController alloc]initWithRootViewController:YQSearchView];
    UIImage *image4 = [[UIImage imageNamed:@"舆情检索.png"] imageWithTintOriginalColor:[UIColor blackColor]];
    UIImage *image44 = [[UIImage imageNamed:@"舆情检索.png"] imageWithTintOriginalColor:RGBAlphaColorValue(0X2a7a80)];
    nav4.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"舆情检索" image:image4 selectedImage:image44];
    
    MoreViewController *MoreView=[[MoreViewController alloc]init];
    MoreView.title=@"更多";
    UINavigationController *nav5=[[UINavigationController alloc]initWithRootViewController:MoreView];
    UIImage *image5 = [[UIImage imageNamed:@"更多"] imageWithTintOriginalColor:[UIColor blackColor]];
    UIImage *image55 = [[UIImage imageNamed:@"更多"] imageWithTintOriginalColor:RGBAlphaColorValue(0X2a7a80)];
    nav5.tabBarItem = [[UITabBarItem alloc]initWithTitle:@"更多" image:image5 selectedImage:image55];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       [UIColor blackColor], NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateNormal];
    UIColor *titleHighlightedColor = RGBAlphaColorValue(0X2a7a80);
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                       titleHighlightedColor, NSForegroundColorAttributeName,
                                                       nil] forState:UIControlStateSelected];
    
    self.tabbar=[[UITabBarController alloc]init];
    [self.tabbar setViewControllers:@[nav1,nav2,nav3,nav4,nav5]];
    if (!_rememberPassword.isOn) {
        self.password.text = nil;
    }

    [self.navigationController pushViewController:self.tabbar animated:animated];
}

- (void)getThePush:(NSNotification *)notification {
    NSInteger pushindex = [[notification.userInfo valueForKey:@"moduleKey"] integerValue];
    if (pushindex == 1) {
        self.tabbar.selectedIndex = 0;
    } else if (pushindex == 2) {
        self.tabbar.selectedIndex = 2;
    } else if (pushindex == 3) {
        self.tabbar.selectedIndex = 1;
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"againrefresh" object:self userInfo:notification.userInfo];
}

- (void)timerAction {
    NSString *urlStr = [NSString stringWithFormat: @"findAppKey.action?userId=%@&appKey=%@", [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"],[FCUUID uuidForDevice]];
    [self requestWithPara:nil path:urlStr method:kGET tag:2];
//    NSLog(@"正在检查是否在别处登录");
}


#pragma mark - other method
- (void)tagsAliasCallback:(int)iResCode tags:(NSSet *)tags alias:(NSString *)alias {
    NSLog(@"iResCode: %d, \n alias: %@\n", iResCode, alias);
}
//
//- (NSString *)logSet:(NSSet *)dic {
//    if (![dic count]) {
//        return nil;
//    }
//    NSString *tempStr1 =
//    [[dic description] stringByReplacingOccurrencesOfString:@"\\u"
//                                                 withString:@"\\U"];
//    NSString *tempStr2 =
//    [tempStr1 stringByReplacingOccurrencesOfString:@"\"" withString:@"\\\""];
//    NSString *tempStr3 =
//    [[@"\"" stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
//    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
//    NSString *str = [NSPropertyListSerialization propertyListWithData:tempData options:NSPropertyListImmutable format:NULL error:NULL];
//    return str;
//}

-(NSString *)md5:(NSString *)inPutText {
    const char *str = [inPutText UTF8String];
    if (str == NULL) {
        str = "";
    }
    unsigned char r[CC_MD5_DIGEST_LENGTH];
    CC_MD5(str, (CC_LONG)strlen(str), r);
    NSString *filename = [[NSString stringWithFormat:@"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
                          r[0], r[1], r[2], r[3], r[4], r[5], r[6], r[7], r[8], r[9], r[10], r[11], r[12], r[13], r[14], r[15]]uppercaseString];
    return filename;
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
}

//- (BOOL)textFieldShouldReturn:(UITextField *)textField {
//
//    return YES;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter]removeObserver:@"pushIndex"];
}


@end
