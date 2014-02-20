//
//  SetPwdInterface.m
//  LanTai
//
//  Created by comdosoft on 13-12-25.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "SetPwdInterface.h"

@implementation SetPwdInterface
-(void)getSetPwdInterfaceDelegateWithCsrid:(NSString *)csrid andPwd:(NSString *)pwd andCid:(NSString *)cid andOid:(NSString *)oid; {
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    
    [reqheaders setValue:[NSString stringWithFormat:@"%@",csrid] forKey:@"svid"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",pwd] forKey:@"password"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",cid] forKey:@"customer_id"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",oid] forKey:@"order_id"];
//    self.interfaceUrl = [NSString stringWithFormat:@"%@%@",[DataService sharedService].kHost,ksetpwd];
    
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
                NSDictionary *jsonData=(NSDictionary *)jsonObject;
                DLog(@"jsonData = %@",jsonData);
                if (jsonData) {
                    if ([[jsonData objectForKey:@"status"]intValue]==1) {
                        @try {
                            [self.delegate getSetPwdInfoDidFinished:jsonData];
                        }
                        @catch (NSException *exception) {
                            [self.delegate getSetPwdInfoDidFailed:@"获取数据失败!"];
                        }
                    }else {
                        [self.delegate getSetPwdInfoDidFailed:[jsonData objectForKey:@"msg"]];
                    }
                    
                }else {
                    [self.delegate getSetPwdInfoDidFailed:@"获取数据失败!"];
                }
            }
        }
    }else {
        [self.delegate getSetPwdInfoDidFailed:@"获取数据失败!"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate getSetPwdInfoDidFailed:@"请求失败!"];
}

@end
