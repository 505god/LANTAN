//
//  CardCell.h
//  LanTai
//
//  Created by comdosoft on 13-12-5.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomImageView+Addition.h"
#import "CustomImageView.h"

@interface CardCell : UITableViewCell
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) CustomImageView *pImg;
@property (nonatomic, strong) UIButton *orderBtn;
@property (nonatomic, strong) UILabel *nameLab,*priceLab;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier withProduct:(NSDictionary *)object indexPath:(NSIndexPath *)idx type:(int)type;
@end

