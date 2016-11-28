//
//  LoginViewController.h
//  CNTVPublicSentiment
//
//  Created by wiseweb on 16/11/9.
//  Copyright © 2016年 wiseweb. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginViewController : BaseViewController<UITextFieldDelegate>
@property (nonatomic, strong) UITextField *username;
@property (nonatomic, strong) UITextField *password;
@property (nonatomic, strong) UITabBarController *tabbar;

@end
