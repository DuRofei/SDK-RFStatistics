//
//  BaseTableViewCell.m
//  CNTVPublicSentiment
//
//  Created by DuRofei on 16/11/12.
//  Copyright © 2016年 wiseweb. All rights reserved.
//

#import "BaseTableViewCell.h"
@interface  BaseTableViewCell()
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *publishtimeLabel;
@property (nonatomic, strong) UILabel *contentLabel;
@property (nonatomic, strong) UILabel *reporttypeLabel;
@end

@implementation BaseTableViewCell
 

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.titleLabel       = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth - 20, 50)];
        self.publishtimeLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 60, kScreenWidth / 2 - 10, 20)];
        self.authorLabel      = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth / 2, 60, kScreenWidth / 2 - 10, 20)];
        
        [self.titleLabel       setFont:[UIFont systemFontOfSize:17]];
        [self.publishtimeLabel setFont:[UIFont systemFontOfSize:14]];
        [self.authorLabel      setFont:[UIFont systemFontOfSize:14]];
        
        self.titleLabel.numberOfLines = 0;
        self.authorLabel.textColor      = RGBAlphaColorValue(0X2a7a80);
        self.publishtimeLabel.textColor = [UIColor lightGrayColor];

        [self addSubview:self.titleLabel];
        [self addSubview:self.publishtimeLabel];
        [self addSubview:self.authorLabel];
    }
    return self;
}

- (void)setModel:(BaseModel *)model {
    [self.titleLabel       setText:model.title];
    [self.publishtimeLabel setText:[NSString stringWithFormat:@"%@",model.publishtime]];
    [self.authorLabel      setText:model.author];
    [self.contentLabel     setText:model.summary];
    
}

@end
