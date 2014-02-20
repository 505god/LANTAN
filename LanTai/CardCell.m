//
//  CardCell.m
//  LanTai
//
//  Created by comdosoft on 13-12-5.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "CardCell.h"
#import "UIImageView+WebCache.h"

@implementation CardCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withProduct:(NSDictionary *)object indexPath:(NSIndexPath *)idx type:(int)type; {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //图片
        self.pImg = [[CustomImageView alloc]initWithFrame:CGRectMake(10, 6, 50, 31)];
        [self.contentView addSubview:self.pImg];
        //名称
        self.nameLab = [[UILabel alloc]initWithFrame:CGRectMake(65, 7, 200, 30)];
        [self.contentView addSubview:self.nameLab];
        //价格
        self.priceLab = [[UILabel alloc]initWithFrame:CGRectMake(270, 7, 200, 30)];
        [self.contentView addSubview:self.priceLab];
        //下单
        self.orderBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        self.orderBtn.frame = CGRectMake(545, 6, 71, 31);
        [self.orderBtn setBackgroundImage:[UIImage imageNamed:@"order"] forState:UIControlStateNormal];
        [self.orderBtn setTitle:@"下单" forState:UIControlStateNormal];

        [self.contentView addSubview:self.orderBtn];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setUrl:(NSURL *)url {
    [self.pImg setImageWithURL:url placeholderImage:[UIImage imageNamed:@"defualt.jpg"]];
}
@end
