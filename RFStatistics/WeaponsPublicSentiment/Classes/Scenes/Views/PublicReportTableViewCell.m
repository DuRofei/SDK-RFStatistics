//
//  PublicReportTableViewCell.m
//  CNTVPublicSentiment
//
//  Created by wiseweb on 16/11/18.
//  Copyright © 2016年 wiseweb. All rights reserved.
//

#import "PublicReportTableViewCell.h"

@interface PublicReportTableViewCell ()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *publishtimeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *reportTypeLabel;
@end


@implementation PublicReportTableViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.titleLabel       = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, 50)];
        self.publishtimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 50, kScreenWidth / 2 - 10, 20)];
        self.authorLabel      = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth / 2, 50, kScreenWidth / 2 - 10, 20)];
        self.reportTypeLabel  = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth - 130, 65, 130, 40)];
        
        self.titleLabel.numberOfLines = 0;
        
        [self.titleLabel       setFont:[UIFont systemFontOfSize:17]];
        [self.publishtimeLabel setFont:[UIFont systemFontOfSize:14]];
        [self.authorLabel      setFont:[UIFont systemFontOfSize:14]];
        [self.reportTypeLabel        setFont:[UIFont systemFontOfSize:15]];
        
        [self.reportTypeLabel setTextColor:RGBAlphaColorValue(0X2a7a80)];
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.publishtimeLabel];
        [self addSubview:self.authorLabel];
        [self addSubview:self.reportTypeLabel];
        
        self.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    }
    return self;
}

- (void)setModel:(BaseModel *)model {
    [self.titleLabel       setText:model.title];
    [self.publishtimeLabel setText:[NSString stringWithFormat:@"%@",model.publishtime]];
    [self.authorLabel      setText:model.author];
    [self.reportTypeLabel  setText:model.reporttype];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}


@end
