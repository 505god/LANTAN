//
//  LanTanDB.h
//  LanTai
//
//  Created by comdosoft on 13-12-4.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "BaseDao.h"
#import "ModelModel.h"
#import "BrandModel.h"
#import "CapitalModel.h"
#import "OrderInfo.h"
#import "UserModel.h"

@interface LanTanDB : BaseDao
//车辆品牌、模型
-(BOOL)addDataWithModelModel:(ModelModel *)model;//模型
-(BOOL)addDataWithBrandModel:(BrandModel *)model;//品牌
-(BOOL)addDataWithCapitalModel:(CapitalModel *)model;//检索
-(NSArray *)getLocalBrand;

//订单
-(BOOL)addDataWithDictionary:(OrderInfo *)model;
-(OrderInfo *)getLocalOrderInfoWhereSid:(NSString *)sid;
-(NSArray *)getLocalOrderInfo;
-(BOOL)deleteDataFromOrder;
-(BOOL)updateOrderInfoWithOrder:(OrderInfo *)model WhereSid:(NSString *)sid;
-(BOOL)updateOrderInfoReason:(NSString *)reason Reaquest:(NSString *)request WhereSid:(NSString *)sid;

@end
