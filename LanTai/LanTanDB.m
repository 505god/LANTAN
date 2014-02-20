//
//  LanTanDB.m
//  LanTai
//
//  Created by comdosoft on 13-12-4.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "LanTanDB.h"

@implementation LanTanDB

-(BOOL)addDataWithModelModel:(ModelModel *)model;//模型
{
    BOOL res = [self.db executeUpdate:@"insert into carModel (name , model_id , car_brand_id ) values (?,?,?)"
                ,model.name
                ,model.model_id
                ,model.brand_id];
    return res;
}
-(BOOL)addDataWithBrandModel:(BrandModel *)model;//品牌
{
    BOOL res = [self.db executeUpdate:@"insert into carBrand (name , brand_id , car_capital_id ) values (?,?,?)"
                ,model.name
                ,model.brand_id
                ,model.capital_id];
    return res;
}
-(BOOL)addDataWithCapitalModel:(CapitalModel *)model;//检索
{
    BOOL res = [self.db executeUpdate:@"insert into carCapital (name , capital_id) values (?,?)"
                ,model.name
                ,model.capital_id];
    return res;
}

-(NSArray *)getLocalBrand;
{
    FMResultSet * rs = [self.db executeQuery:@"select id , name , capital_id from carCapital"];
    NSMutableArray *array = [NSMutableArray array];
    while ([rs next]) {
        CapitalModel *nm = [[CapitalModel alloc] init];
        nm.name = [rs stringForColumn:@"name"];
        nm.capital_id = [rs stringForColumn:@"capital_id"];
        [array addObject:nm];
    }
    [rs close];
    return array;
}

-(BOOL)addDataWithDictionary:(OrderInfo *)model; {
    BOOL res = [self.db executeUpdate:@"insert into orderInfo (order_id,customer_id,car_num_id,content,oprice,is_please,total_price,prods,brand,year,birth,cdistance,userName,phone,sex,billing,pay_type,is_free,status,store_id,reason,request,cproperty,ccompany) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)"
                ,model.order_id
                ,model.customer_id
                ,model.car_num_id
                ,model.content
                ,model.oprice
                ,model.is_please
                ,model.total_price
                ,model.prods
                ,model.brand
                ,model.year
                ,model.birth
                ,model.cdistance
                ,model.userName
                ,model.phone
                ,model.sex
                ,model.billing
                ,model.pay_type
                ,model.is_free
                ,model.status
                ,model.store_id
                ,model.reason
                ,model.request
                ,model.cproperty
                ,model.ccompany];
    return res;
}
-(OrderInfo *)getLocalOrderInfoWhereSid:(NSString *)sid {
    FMResultSet * rs = [self.db executeQuery:@"select id ,order_id,customer_id,car_num_id,content,oprice,is_please,total_price,prods,brand,year,birth,cdistance,userName,phone,sex,billing,pay_type,is_free,status,store_id,reason,request,cproperty,ccompany from orderInfo where order_id = ?",sid];
    
    OrderInfo *model = [[OrderInfo alloc] init];
    while ([rs next]) {
        model.order_id = [rs stringForColumn:@"order_id"];
        model.customer_id= [rs stringForColumn:@"customer_id"];
        model.car_num_id= [rs stringForColumn:@"car_num_id"];
        model.content= [rs stringForColumn:@"content"];
        model.oprice= [rs stringForColumn:@"oprice"];
        model.is_please= [rs stringForColumn:@"is_please"];
        model.total_price= [rs stringForColumn:@"total_price"];
        model.prods= [rs stringForColumn:@"prods"];
        model.brand= [rs stringForColumn:@"brand"];
        model.year= [rs stringForColumn:@"year"];
        model.birth= [rs stringForColumn:@"birth"];
        model.cdistance= [rs stringForColumn:@"cdistance"];
        model.userName= [rs stringForColumn:@"userName"];
        model.phone= [rs stringForColumn:@"phone"];
        model.sex= [rs stringForColumn:@"sex"];
        model.billing= [rs stringForColumn:@"billing"];
        model.pay_type= [rs stringForColumn:@"pay_type"];
        model.is_free= [rs stringForColumn:@"is_free"];
        model.status= [rs stringForColumn:@"status"];
        model.store_id= [rs stringForColumn:@"store_id"];
        model.reason= [rs stringForColumn:@"reason"];
        model.request= [rs stringForColumn:@"request"];
        model.cproperty = [rs stringForColumn:@"cproperty"];
        model.ccompany = [rs stringForColumn:@"ccompany"];

    }
    [rs close];
    return model;
}
-(NSArray *)getLocalOrderInfo; {
    FMResultSet * rs = [self.db executeQuery:@"select id ,order_id,customer_id,car_num_id,content,oprice,is_please,total_price,prods,brand,year,birth,cdistance,userName,phone,sex,billing,pay_type,is_free,status,store_id,reason,request,cproperty,ccompany from orderInfo"];
    NSMutableArray *array = [NSMutableArray array];
    while ([rs next]) {
        OrderInfo *model = [[OrderInfo alloc] init];
        model.order_id = [rs stringForColumn:@"order_id"];
        model.customer_id= [rs stringForColumn:@"customer_id"];
        model.car_num_id= [rs stringForColumn:@"car_num_id"];
        model.content= [rs stringForColumn:@"content"];
        model.oprice= [rs stringForColumn:@"oprice"];
        model.is_please= [rs stringForColumn:@"is_please"];
        model.total_price= [rs stringForColumn:@"total_price"];
        model.prods= [rs stringForColumn:@"prods"];
        model.brand= [rs stringForColumn:@"brand"];
        model.year= [rs stringForColumn:@"year"];
        model.birth= [rs stringForColumn:@"birth"];
        model.cdistance= [rs stringForColumn:@"cdistance"];
        model.userName= [rs stringForColumn:@"userName"];
        model.phone= [rs stringForColumn:@"phone"];
        model.sex= [rs stringForColumn:@"sex"];
        model.billing= [rs stringForColumn:@"billing"];
        model.pay_type= [rs stringForColumn:@"pay_type"];
        model.is_free= [rs stringForColumn:@"is_free"];
        model.status= [rs stringForColumn:@"status"];
        model.store_id= [rs stringForColumn:@"store_id"];
        model.reason= [rs stringForColumn:@"reason"];
        model.request= [rs stringForColumn:@"request"];
        model.cproperty= [rs stringForColumn:@"cproperty"];
        model.ccompany = [rs stringForColumn:@"ccompany"];
        [array addObject:model];
    }
    [rs close];
    return array;
}
-(BOOL)deleteDataFromOrder {
    BOOL res = [self.db executeUpdate:@"delete from orderInfo"];
    return res;
}
-(BOOL)updateOrderInfoWithOrder:(OrderInfo *)model WhereSid:(NSString *)sid {
    return [self.db executeUpdate:@"update orderInfo set customer_id=?,car_num_id=?,content=?,oprice=?,is_please=?,total_price=?,prods=?,brand=?,year=?,birth=?,cdistance=?,userName=?,phone=?,sex=?,billing=?,pay_type=?,is_free=?,status=?,store_id=?,cproperty=?,ccompany=? where order_id= ?",model.customer_id,model.car_num_id,model.content,model.oprice,model.is_please,model.total_price,model.prods,model.brand,model.year,model.birth,model.cdistance,model.userName,model.phone,model.sex,model.billing,model.pay_type,model.is_free,model.status,model.store_id,model.cproperty,model.ccompany, sid];
}

-(BOOL)updateOrderInfoReason:(NSString *)reason Reaquest:(NSString *)request WhereSid:(NSString *)sid; {
    return [self.db executeUpdate:@"update orderInfo set reason=?,request=? where order_id= ?",reason,request,sid];
}

@end
