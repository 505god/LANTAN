//
//  RecordTableHeader.h
//  LanTai
//
//  Created by comdosoft on 13-12-27.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordTableHeader : UITableViewHeaderFooterView
@property (nonatomic, assign) int number;//0:消费记录  1:套餐卡记录  2:储值卡记录
@property (nonatomic, strong) UILabel *lbl_1,*lbl_2,*lbl_3,*lbl_4;
@end
