//
//  MakeOrderInterface.m
//  LanTai
//
//  Created by comdosoft on 13-12-7.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "MakeOrderInterface.h"

@implementation MakeOrderInterface
-(void)getMakeOrderInterfaceDelegateWithContent:(NSString *)content andNum:(NSString *)num {
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    
    [reqheaders setValue:[NSString stringWithFormat:@"%@",content] forKey:@"content"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",num] forKey:@"num"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",[DataService sharedService].store_id] forKey:@"store_id"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",[DataService sharedService].user_id] forKey:@"user_id"];
    
    self.interfaceUrl = [NSString stringWithFormat:@"%@%@",[DataService sharedService].kHost,kMakeNeworder];
    
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
                            [self.delegate getOrderInfoDidFinished:jsonData];
                        }
                        @catch (NSException *exception) {
                            [self.delegate getOrderInfoDidFailed:@"获取数据失败!"];
                        }
                    }else {
                        [self.delegate getOrderInfoDidFailed:[jsonData objectForKey:@"msg"]];
                    }
                    
                }else {
                    [self.delegate getOrderInfoDidFailed:@"获取数据失败!"];
                }
            }
        }
    }else {
        [self.delegate getOrderInfoDidFailed:@"获取数据失败!"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate getOrderInfoDidFailed:@"请求失败!"];
}


@end
