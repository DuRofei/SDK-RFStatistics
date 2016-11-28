//
//  EarlywarningTableViewCell.m
//  CNTVPublicSentiment
//
//  Created by wiseweb on 16/11/14.
//  Copyright © 2016年 wiseweb. All rights reserved.
//

#import "EarlywarningTableViewCell.h"
@interface EarlywarningTableViewCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *publishtimeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *rankLabel;

@end

@implementation EarlywarningTableViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.titleLabel       = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, 50)];
        self.publishtimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, kScreenWidth / 2 - 10, 20)];
        self.authorLabel      = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth / 2, 50, kScreenWidth / 2 - 10, 20)];
        self.rankLabel  = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 90, 60, 80, 40)];
        
        self.titleLabel.numberOfLines = 0;
        
        [self.titleLabel       setFont:[UIFont systemFontOfSize:17]];
        [self.publishtimeLabel setFont:[UIFont systemFontOfSize:14]];
        [self.authorLabel      setFont:[UIFont systemFontOfSize:14]];
        [self.rankLabel        setFont:[UIFont systemFontOfSize:17]];
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.publishtimeLabel];
        [self addSubview:self.authorLabel];
        [self addSubview:self.rankLabel];
        
        self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)setModel:(BaseModel *)model {
    [self.titleLabel       setText:model.title];
    [self.publishtimeLabel setText:[NSString stringWithFormat:@"%@",model.publishtime]];
    [self.authorLabel      setText:model.author];
    [self.rankLabel        setText:model.rank];
    
    if ([model.rank isEqualToString:@"黄色预警"]) {
        self.rankLabel.textColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:1.0];
    } else if ([model.rank isEqualToString:@"红色预警"]) {
        self.rankLabel.textColor = [UIColor redColor];
    } else if ([model.rank isEqualToString:@"橙色预警"]) {
        self.rankLabel.textColor = [UIColor orangeColor];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end
