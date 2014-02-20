//
//  GetServiceInterface.m
//  LanTai
//
//  Created by comdosoft on 13-12-7.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "GetServiceInterface.h"
//status:1 有符合工位 2 没工位 3 多个工位 4 工位上暂无技师  5 多个车牌
@implementation GetServiceInterface

-(void)getServiceInterfaceDelegateWithNum:(NSString *)num andService:(NSString *)service {
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    
    [reqheaders setValue:[NSString stringWithFormat:@"%@",num] forKey:@"num"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",service] forKey:@"service_id"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",[DataService sharedService].store_id] forKey:@"store_id"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",[DataService sharedService].user_id] forKey:@"user_id"];
    
    self.interfaceUrl = [NSString stringWithFormat:@"%@%@",[DataService sharedService].kHost,kMakeOrder];
    
    self.baseDelegate = self;
    self.headers = reqheaders;
    
    [self connect];
}

#pragma mark - BaseInterfaceDelegate
-(void)parseResult:(ASIHTTPRequest *)request{
    NSDictionary *resultHeaders = [[request responseHeaders] allKeytoLowerCase];
    if (resultHeaders) {
        NSData *data = [[NSData alloc]initWithData:[request responseData]];
        id jsonObject=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        if (jsonObject !=nil) {
            if ([jsonObject isKindOfClass:[NSDictionary class]]) {
                NSDictionary *result=(NSDictionary *)jsonObject;
                if ([[result objectForKey:@"status"]integerValue]==1) {
                    [self.delegate getServiceInfoDidFinished:result];
                }else {
                    [self.delegate getServiceInfoDidFailed:[result objectForKey:@"msg"]];
                }
            }
        }
    }else {
        [self.delegate getServiceInfoDidFailed:@"连接失败"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate getServiceInfoDidFailed:@"请求失败!"];
}

@end
