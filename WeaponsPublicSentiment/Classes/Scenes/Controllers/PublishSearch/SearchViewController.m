//
//  SearchViewController.m
//  CNTVPublicSentiment
//
//  Created by wiseweb on 16/11/9.
//  Copyright © 2016年 wiseweb. All rights reserved.
//

#import "SearchViewController.h"
#import "DOPDropDownMenu.h"
#import "BaseTableViewController.h"
#import "UIView+Massary.h"

@interface SearchViewController ()<DOPDropDownMenuDataSource, DOPDropDownMenuDelegate,UITextFieldDelegate>

@property (nonatomic, strong) NSArray *mediaTypeList;
@property (nonatomic, strong) NSArray *searchRangeList;
@property (nonatomic, strong) NSArray *sortList;
@property (nonatomic, strong) NSString *mediaType;
@property (nonatomic, strong) NSString *searchRange;
@property (nonatomic, strong) NSString *sort;

@property (nonatomic, strong) UIDatePicker *picker;
@property (nonatomic, strong) UIToolbar *toolBar;
@property (nonatomic, strong) UIButton *toolTitleBtn;
@property (nonatomic, strong) UIButton *startTimeBtn;
@property (nonatomic, strong) UIButton *endTimeBtn;
@property (nonatomic, strong) UITextField *keywordField;

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;
@property (nonatomic, strong) MBProgressHUD *hud;
@end

@implementation SearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
 
    self.mediaTypeList = @[@"全部",@"新闻",@"论坛",@"博客",@"微博",@"微信",@"纸媒",@"视频",@"外媒"];
    self.searchRangeList = @[@"全部",@"标题",@"内容"];
    self.sortList = @[@"时间",@"相关度"];

    self.mediaType = self.mediaTypeList[0];
    self.searchRange = self.searchRangeList[0];
    self.sort = self.sortList[0];
    
    [self layoutViews];

}

#pragma mark - load UI
- (void)layoutViews {
    DOPDropDownMenu *menu = [[DOPDropDownMenu alloc] initWithOrigin:CGPointMake(0, 95) andHeight:35];
    menu.dataSource = self;
    menu.delegate = self;
    [self.view addSubview:menu];
    UILabel *label1 = [[UILabel alloc]init];
    label1.text = @"媒体类型:";
    label1.textAlignment = NSTextAlignmentCenter;
    [label1 setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:label1];
    
    UILabel *label2 = [[UILabel alloc]init];
    label2.text = @"查询范围:";
    label2.textAlignment = NSTextAlignmentCenter;
    [label2 setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:label2];
    
    UILabel *label3 = [[UILabel alloc]init];
    label3.text = @"排序方式:";
    label3.textAlignment = NSTextAlignmentCenter;
    [label3 setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:label3];
    
    __weak typeof(self)weakself = self;
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@[label2,label3]);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth / 3, 20));
        make.top.mas_equalTo(weakself.view).with.offset(75);
    }];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(label1);
    }];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(label1);
    }];
    [self.view distributeSpacingHorizontallyWith:@[label1,label2,label3]];
    
    self.keywordField = [[UITextField alloc]init];
    self.keywordField.delegate = self;
    self.keywordField.returnKeyType = UIReturnKeySearch;
    [self.keywordField setBorderStyle:UITextBorderStyleRoundedRect];
    self.keywordField.placeholder = @"请输入搜索关键字";
    [self.view addSubview:self.keywordField];
    [weakself.keywordField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakself.view).with.offset(150);
        make.left.mas_equalTo(weakself.view).with.offset(30);
        make.right.mas_equalTo(weakself.view).with.offset(-30);
        make.height.mas_equalTo(45);
    }];
    
    UILabel *startTimelabel = [[UILabel alloc]init];
    startTimelabel.text = @"起始时间";
    startTimelabel.textAlignment = NSTextAlignmentCenter;
    [startTimelabel setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:startTimelabel];
    
    UILabel *endTimelabel = [[UILabel alloc]init];
    endTimelabel.text = @"截止时间";
    endTimelabel.textAlignment = NSTextAlignmentCenter;
    [endTimelabel setFont:[UIFont systemFontOfSize:14]];
    [self.view addSubview:endTimelabel];
    
    [startTimelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@[endTimelabel]);
        make.size.mas_equalTo(CGSizeMake(kScreenWidth / 2, 20));
        make.top.mas_equalTo(weakself.keywordField).with.offset(60);
    }];
    [endTimelabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(startTimelabel);
    }];
    [self.view distributeSpacingHorizontallyWith:@[startTimelabel,endTimelabel]];
    
    self.picker = [[UIDatePicker alloc]init];
    NSTimeInterval start = [[NSDate date] timeIntervalSince1970] - 60*60*12*7;
    self.startDate = [NSDate dateWithTimeIntervalSince1970:start];
    self.endDate = [NSDate date];
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    self.picker.locale = locale;
    [self.picker setAccessibilityLanguage:@"zh_CN"];
    self.picker.datePickerMode=UIDatePickerModeDate;
    [self.view addSubview:self.picker];
    [self.picker mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(kScreenWidth);
        make.bottom.mas_equalTo(weakself.view).with.offset(-20);
        make.height.mas_equalTo(180);
    }];
    
    self.toolBar = [[UIToolbar alloc]init];
    self.toolBar.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:self.toolBar];
    [self.toolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(weakself.picker).with.offset(-40);
        make.width.mas_equalTo(kScreenWidth);
        make.height.mas_equalTo(50);
    }];
    
    self.picker.hidden = YES;
    self.toolBar.hidden = YES;
    
    UIButton *okButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [okButton setTitle:@"确定" forState:UIControlStateNormal];
    [okButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [okButton addTarget:self action:@selector(okBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.toolBar addSubview:okButton];
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [self.toolBar addSubview:cancelButton];
    
    self.toolTitleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.toolTitleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.toolBar addSubview:self.toolTitleBtn];
    
    [okButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@[cancelButton,weakself.toolTitleBtn,weakself.toolBar]);
        make.size.mas_equalTo(CGSizeMake(50, 50));
        make.left.mas_equalTo(weakself.view).with.offset(15);
    }];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(okButton);
        make.right.mas_equalTo(weakself.view).with.offset(-15);
    }];
    [self.toolTitleBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(80, 50));
        make.centerX.equalTo(weakself.view);
    }];
    
    self.startTimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.startTimeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.startTimeBtn setTitle:[self stringFromDate:self.startDate] forState:UIControlStateNormal];
    [self.startTimeBtn addTarget:self action:@selector(selectStartTimeBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.startTimeBtn];
    
    self.endTimeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.endTimeBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.endTimeBtn setTitle:[self stringFromDate:self.endDate] forState:UIControlStateNormal];
    [self.endTimeBtn addTarget:self action:@selector(selectEndTimeBtn) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.endTimeBtn];
    
    [self.startTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(weakself.endTimeBtn);
        make.width.mas_equalTo(startTimelabel);
        make.height.mas_equalTo(40);
        make.top.mas_equalTo(startTimelabel).with.offset(20);
    }];
    [self.endTimeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(weakself.startTimeBtn);
    }];
    [self.view distributeSpacingHorizontallyWith:@[self.startTimeBtn,self.endTimeBtn]];
    
    UIButton *searchBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [searchBtn setTitle:@"搜索" forState:UIControlStateNormal];
    searchBtn.layer.cornerRadius = 10;
    [searchBtn.titleLabel setFont:[UIFont systemFontOfSize:23]];
    [searchBtn setTintColor:[UIColor whiteColor]];
    searchBtn.backgroundColor = RGBAlphaColorValue(0X2a7a80);
    [searchBtn addTarget:self action:@selector(doSearch) forControlEvents:UIControlEventTouchUpInside];
    [self.view insertSubview:searchBtn belowSubview:self.toolBar];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(60);
        make.right.mas_equalTo(-60);
        make.top.mas_equalTo(weakself.startTimeBtn).with.offset(60);
        make.height.mas_equalTo(50);
    }];
}

- (NSString *)stringFromDate:(NSDate *)date{
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *destDateString = [dateFormatter stringFromDate:date];
    return destDateString;
}

#pragma mark - DOPDropDownMenuDelegate
- (NSInteger)numberOfColumnsInMenu:(DOPDropDownMenu *)menu {
    return 3;
}

- (NSInteger)menu:(DOPDropDownMenu *)menu numberOfRowsInColumn:(NSInteger)column {
    switch (column) {
        case 0: return self.mediaTypeList.count;
            break;
        case 1: return self.searchRangeList.count;
            break;
        case 2: return self.sortList.count;
            break;
        default:
            return 0;
            break;
    }
}

- (NSString *)menu:(DOPDropDownMenu *)menu titleForRowAtIndexPath:(DOPIndexPath *)indexPath {
    switch (indexPath.column) {
        case 0:
            return self.mediaTypeList[indexPath.row];
            break;
        case 1:
            return self.searchRangeList[indexPath.row];
            break;
        case 2:
            return self.sortList[indexPath.row];
            break;
        default:
            return nil;
            break;
    }
}

- (void)menu:(DOPDropDownMenu *)menu didSelectRowAtIndexPath:(DOPIndexPath *)indexPath {
//    NSLog(@"column:%li row:%li", (long)indexPath.column, (long)indexPath.row);
    
    switch (indexPath.column) {
        case 0:
            self.mediaType = self.mediaTypeList[indexPath.row];
            break;
        case 1:
            self.searchRange = self.searchRangeList[indexPath.row];
            break;
        case 2:
            self.sort = self.sortList[indexPath.row];
            break;
        default:
            break;
    }
    
//    NSLog(@"%@",[menu titleForRowAtIndexPath:indexPath]);
}

#pragma mark - textfieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if (textField.text.length > 0) {
        [textField resignFirstResponder];
        [self doSearch];
    } else {
        [textField resignFirstResponder];
        [self showTextMessage:@"请输入搜索关键字"];
    }
    return YES;
}

#pragma mark - buttonActions
- (void)doSearch {
    [self okBtnAction];

    
    if ([self.keywordField.text length] > 0) {
        NSString * str1 =[self.keywordField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        if (str1.length != 0) {
            BaseTableViewController *baseTC = [[BaseTableViewController alloc]init];
            baseTC.isSearch = YES;
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];

            if ([self.mediaType isEqualToString:@"微信"]) {
                dic[@"groupId"] = @11;
            } else if ([self.mediaType isEqualToString:@"纸媒"]) {
                dic[@"groupId"] = @5;
            } else if ([self.mediaType isEqualToString:@"视频"]) {
                dic[@"groupId"] = @6;
            } else if ([self.mediaType isEqualToString:@"外媒"]) {
                dic[@"groupId"] = @7;
            } else {
                dic[@"groupId"] = [NSNumber numberWithUnsignedInteger:[self.mediaTypeList indexOfObject:self.mediaType]];
            }
            dic[@"userId"] = [[NSUserDefaults standardUserDefaults] stringForKey:@"userId"];
            dic[@"starttime"] = [self stringFromDate:self.startDate];
            dic[@"endtime"] = [self stringFromDate:self.endDate];
            dic[@"keyword"] = self.keywordField.text;
            dic[@"searchType"] = [NSNumber numberWithUnsignedInteger:[self.searchRangeList indexOfObject:self.searchRange]];
            dic[@"order"] = @"desc";
            
            if ([self.sort isEqualToString:@"时间"]) {
                dic[@"orderby"] = @"publishtime";
            }
            else {
                dic[@"orderby"] = @"relevance";
            }
            baseTC.searchParam = dic;
            baseTC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:baseTC animated:YES];
            self.keywordField.text = nil;
            [self.keywordField resignFirstResponder];
        } else {
            [self showTextMessage:@"请输入有效的关键字"];
            [self.keywordField resignFirstResponder];
            self.keywordField.text = nil;
        }

    } else {
        [self.keywordField resignFirstResponder];
        [self showTextMessage:@"请输入关键字"];
    }
}

- (void)selectStartTimeBtn {
    [self.keywordField resignFirstResponder];
    self.picker.hidden = NO;
    [self.toolTitleBtn setTitle:@"起始时间" forState:UIControlStateNormal];
    [self.picker setDate:self.startDate animated:NO];
    self.toolBar.hidden = NO;
    self.picker.maximumDate = self.endDate;
    self.picker.minimumDate = nil;
}

- (void)selectEndTimeBtn {
    [self.toolTitleBtn setTitle:@"截止时间" forState:UIControlStateNormal];
    
    [self.picker setDate:self.endDate animated:NO];
    
    [self.keywordField resignFirstResponder];
    self.picker.hidden = NO;
    self.toolBar.hidden = NO;
    NSDate* maxDate = [NSDate date];
    self.picker.maximumDate = [NSDate date];
    self.picker.minimumDate = self.startDate;
    self.picker.date = maxDate;
}

-(void)cancelBtnAction {
    self.toolBar.hidden=YES;
    self.picker.hidden=YES;
}

- (void)okBtnAction {
    self.toolBar.hidden=YES;
    self.picker.hidden=YES;
    if ([self.toolTitleBtn.titleLabel.text isEqualToString:@"起始时间"]) {
        self.startDate = self.picker.date;
        [self.startTimeBtn setTitle:[self stringFromDate:self.startDate] forState:UIControlStateNormal];
    }
    else {
        self.endDate = self.picker.date;
        [self.endTimeBtn setTitle:[self stringFromDate:self.endDate] forState:UIControlStateNormal];
    }
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.keywordField resignFirstResponder];
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
    self.keywordField.text = nil;
}

@end
