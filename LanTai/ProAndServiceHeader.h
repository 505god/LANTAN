//
//  ProAndServiceHeader.h
//  LanTai
//
//  Created by comdosoft on 13-12-3.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProAndServiceHeader : UITableViewHeaderFooterView

//产品，服务
@property (nonatomic, strong) UILabel *lab1;
@property (nonatomic, strong) UILabel *lab2;
@property (nonatomic, strong) UILabel *lab3;

//卡类
@property (nonatomic, strong) UILabel *lab4;
@property (nonatomic, strong) UILabel *lab5;

//订单
@property (nonatomic, strong) UILabel *nameLab,*priceLab,*countLab,*totalPrice;;

@end
