//
//  BaseDao.m
//  CaiJinTongApp
//
//  Created by comdosoft on 13-11-7.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "BaseDao.h"
#import <sys/xattr.h>

@implementation BaseDao

-(id)init
{
    if (self = [super init]) {
        //paths： ios下Document路径，Document为ios中可读写的文件夹
        NSFileManager *filemgr =[NSFileManager defaultManager];
        
        if (Platform>5.0) {
            
            //如果系统是5.0.1及其以上这么干
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentDirectory = [paths objectAtIndex:0];
            
            NSString *newDir = [documentDirectory stringByAppendingPathComponent:@"Application"];
            
            if ([filemgr createDirectoryAtPath:newDir withIntermediateDirectories:YES attributes:nil error: NULL] == NO)
            {
                // Failed to create directory
            }
            
            [self addSkipBackupAttributeToItemAtURL:[NSURL fileURLWithPath:newDir]];
            
            //dbPath： 数据库路径，在Document中。
            NSString *dbPath = [newDir stringByAppendingPathComponent:@"lantan.db"];
            //创建数据库实例 db  这里说明下:如果路径中不存在"AiMeiYue.db"的文件,sqlite会自动创建"AiMeiYue.db"
            self.db = [FMDatabase databaseWithPath:dbPath] ;
            
        }else{
            
            //如果系统是5.0及其以上这么干
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
            NSString *documentDirectory = [paths objectAtIndex:0];
            
            NSString *newDir = [documentDirectory stringByAppendingPathComponent:@"Application"];
            if ([filemgr createDirectoryAtPath:newDir withIntermediateDirectories:YES attributes:nil error: NULL] == NO)
            {
                // Failed to create directory
            }
            
            //dbPath： 数据库路径，在Document中。
            NSString *dbPath = [newDir stringByAppendingPathComponent:@"lantan.db"];
            //创建数据库实例 db  这里说明下:如果路径中不存在"AiMeiYue.db"的文件,sqlite会自动创建"AiMeiYue.db"
            self.db = [FMDatabase databaseWithPath:dbPath] ;
        }
        
        if (![self.db open]) {
            self.db = nil;
        }
        

        //车辆品牌检索表
        FMResultSet *carCapital = [self.db executeQuery:@"select name from SQLITE_MASTER where name = 'carCapital'"];
        if (![carCapital next]) {
            [carCapital close];
            [self.db executeUpdate:@"CREATE TABLE carCapital (id INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL  UNIQUE , name VARCHAR , capital_id VARCHAR)"];
        }
        
        [carCapital close];
        //车辆品牌
        FMResultSet *carBrand = [self.db executeQuery:@"select name from SQLITE_MASTER where name = 'carBrand'"];
        if (![carBrand next]) {
            [carBrand close];
            [self.db executeUpdate:@"CREATE TABLE carBrand (id INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL  UNIQUE , name VARCHAR , brand_id VARCHAR , car_capital_id VARCHAR)"];
        }
        
        [carBrand close];
        //车辆型号
        FMResultSet *carModel = [self.db executeQuery:@"select name from SQLITE_MASTER where name = 'carModel'"];
        if (![carModel next]) {
            [carModel close];
            [self.db executeUpdate:@"CREATE TABLE carModel (id INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL  UNIQUE , name VARCHAR , model_id VARCHAR , car_brand_id VARCHAR)"];
        }
        
        [carModel close];
        //产品服务表
        FMResultSet *rs_product = [self.db executeQuery:@"select name from SQLITE_MASTER where name = 'product'"];
        if (![rs_product next]) {
            [rs_product close];
            [self.db executeUpdate:@"CREATE TABLE product (id INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL  UNIQUE , orderid VARCHAR , ordercode VARCHAR,product VARCHAR)"];
        }
        
        [rs_product close];
        //卡类表
        FMResultSet *rs_card = [self.db executeQuery:@"select name from SQLITE_MASTER where name = 'card'"];
        if (![rs_card next]) {
            [rs_card close];
            [self.db executeUpdate:@"CREATE TABLE card (id INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL  UNIQUE , orderid VARCHAR , ordercode VARCHAR,product VARCHAR)"];
        }
        
        [rs_card close];
        //卡类关联表_打折卡，套餐卡
        FMResultSet *rs_card_package = [self.db executeQuery:@"select name from SQLITE_MASTER where name = 'pcard'"];
        if (![rs_card_package next]) {
            [rs_card_package close];
            [self.db executeUpdate:@"CREATE TABLE pcard (id INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL  UNIQUE , orderid VARCHAR , ordercode VARCHAR,product VARCHAR)"];
        }
        
        [rs_card_package close];
        //卡类关联表_储值卡
        FMResultSet *rs_card_svcard = [self.db executeQuery:@"select name from SQLITE_MASTER where name = 'ccard'"];
        if (![rs_card_svcard next]) {
            [rs_card_svcard close];
            [self.db executeUpdate:@"CREATE TABLE ccard (id INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL  UNIQUE , orderid VARCHAR , ordercode VARCHAR,product VARCHAR)"];
        }
        
        [rs_card_svcard close];
        
        //订单表
        FMResultSet *rs_order = [self.db executeQuery:@"select order_id from SQLITE_MASTER where name = 'orderInfo'"];
        if (![rs_order next]) {
            [rs_order close];
            [self.db executeUpdate:@"CREATE TABLE orderInfo (id INTEGER PRIMARY KEY  AUTOINCREMENT  NOT NULL  UNIQUE , order_id VARCHAR , customer_id VARCHAR , car_num_id VARCHAR , content VARCHAR , oprice VARCHAR , is_please VARCHAR , total_price VARCHAR , prods VARCHAR , brand VARCHAR , year VARCHAR , birth VARCHAR , cdistance VARCHAR , userName VARCHAR , phone VARCHAR , sex VARCHAR , billing VARCHAR , pay_type VARCHAR , is_free VARCHAR , status VARCHAR , store_id VARCHAR , reason VARCHAR , request VARCHAR , cproperty VARCHAR , ccompany VARCHAR)"];
        }
        
        [rs_order close];
 
    }
    return self;
}
//添加不用备份的属性5.0.1
- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{

    if (Platform>=5.1) {//5.1的阻止备份
        
        assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
        
        NSError *error = nil;
        BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                      forKey: NSURLIsExcludedFromBackupKey error: &error];
        if(!success){
        }
        return success;
    }else if (Platform>5.0 && Platform<5.1){//5.0.1的阻止备份
        assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);
        
        const char* filePath = [[URL path] fileSystemRepresentation];
        
        const char* attrName = "com.apple.MobileBackup";
        u_int8_t attrValue = 1;
        
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        return result == 0;
    }
    return YES;
}

@end
