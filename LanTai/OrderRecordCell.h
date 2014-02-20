//
//  OrderRecordCell.h
//  LanTai
//
//  Created by comdosoft on 13-12-27.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderRecordCell : UITableViewCell

@property (nonatomic,strong) UILabel *lblCode,*lblDate,*lblTotal,*lblPay;
@property (nonatomic,strong) UIButton *btnComplaint;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier items:(NSMutableArray *)items;
@end
