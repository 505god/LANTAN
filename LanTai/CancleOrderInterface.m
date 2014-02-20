//
//  CancleOrderInterface.m
//  LanTai
//
//  Created by comdosoft on 13-12-12.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "CancleOrderInterface.h"

@implementation CancleOrderInterface
-(void)getCancleOrderInterfaceDelegateWithorderId:(NSString *)order_id; {
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    
    [reqheaders setValue:[NSString stringWithFormat:@"%@",order_id] forKey:@"order_id"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",[DataService sharedService].store_id] forKey:@"store_id"];
    
    self.interfaceUrl = [NSString stringWithFormat:@"%@%@",[DataService sharedService].kHost,kcancleOrder];
    
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
                            [self.delegate getCancleOrderInfoDidFinished:jsonData];
                        }
                        @catch (NSException *exception) {
                            [self.delegate getCancleOrderInfoDidFailed:@"获取数据失败!"];
                        }
                    }else {
                        [self.delegate getCancleOrderInfoDidFailed:[jsonData objectForKey:@"msg"]];
                    }
                    
                }else {
                    [self.delegate getCancleOrderInfoDidFailed:@"获取数据失败!"];
                }
            }
        }
    }else {
        [self.delegate getCancleOrderInfoDidFailed:@"获取数据失败!"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate getCancleOrderInfoDidFailed:@"请求失败!"];
}

@end
