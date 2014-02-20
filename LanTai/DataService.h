//
//  DataService.h
//  LanTaiOrder
//
//  Created by Ruby on 13-1-23.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"

@interface DataService : NSObject

@property (nonatomic,strong) NSString *kHost;
@property (nonatomic,strong) NSString *kDomain;
@property (nonatomic,strong) NSString *str_ip;

@property (nonatomic,strong) NSString *kPosAppId;
@property (nonatomic,strong) NSString *user_id,*reserve_count,*store_id;
@property (nonatomic,strong) NSMutableArray *reserve_list;
@property (nonatomic,strong) NSMutableDictionary *workingOrders;

@property (nonatomic,assign) int payNumber;//判断是否弹出pay的popView:1弹出，0不弹出
@property (nonatomic,strong) NSMutableArray *doneArray;//已投诉得数组
@property (nonatomic,assign) int tagOfBtn;//判断生日按钮

@property (nonatomic,assign) BOOL firstTime;
@property (nonatomic,assign) BOOL first;//判断 number_id 是否加载数据；
@property (nonatomic,strong) NSMutableArray *row_id_countArray;//套餐卡
@property (nonatomic,strong) NSMutableArray *row_id_numArray;//活动打折卡
@property (nonatomic,strong) NSMutableDictionary *price_id;//选择产品价格／服务的id 
@property (nonatomic,strong) NSMutableDictionary *number_id;//选择产品服务的id 和数量
@property (nonatomic,strong) NSMutableArray *productList;

@property (nonatomic,assign) BOOL ReservationFirst;//判断预约是否是第一次；
@property (nonatomic,assign) BOOL refreshing;//判断跟页面刷新

@property (nonatomic,strong) NSMutableDictionary *packageCard_dic;//套餐卡
//总价
@property (nonatomic,assign) CGFloat total_count;
@property (nonatomic,strong) NSMutableArray *row;

@property (nonatomic,strong) NSMutableArray *matchArray;//匹配车牌号前2位数组
@property (nonatomic,strong) NSMutableArray *sectionArray;

//产品／服务 id_count_price
@property (nonatomic,strong) NSMutableArray *id_count_price;
//活动
@property (nonatomic,strong) NSMutableArray *saleArray;

@property (nonatomic,strong) NSMutableArray *packageList;
@property (nonatomic,strong) NSMutableArray *package_product;//套餐卡选择的产品、服务
@property (nonatomic,strong) NSMutableArray *service_array;//后台获取的服务；
//保存打折卡优惠信息
@property (nonatomic,strong) NSMutableArray *svcardArray;//row_id_numArray

@property (nonatomic,assign) int isJurisdiction;//pad端付款权限

@property (nonatomic, assign) NSInteger payViewFrom;//付款页面来源

@property (nonatomic, strong) UserModel *userModel;
/**
 *  /////
 */
@property (nonatomic, assign) BOOL isLoging;
@property (nonatomic, assign) BOOL isError;

//判断是否调用设置储值卡密码的接口
@property (nonatomic, assign) int setpwd;
+ (DataService *)sharedService;

@end
