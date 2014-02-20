//
//  ComplainInterface.m
//  LanTai
//
//  Created by comdosoft on 13-12-10.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "ComplainInterface.h"

@implementation ComplainInterface
-(void)getComplainInterfaceDelegateWithReson:(NSString *)reason andRequest:(NSString *)request andOrder:(NSString *)order {
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    
    [reqheaders setValue:[NSString stringWithFormat:@"%@",reason] forKey:@"reason"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",request] forKey:@"request"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",[DataService sharedService].store_id] forKey:@"store_id"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",order] forKey:@"order_id"];
    
    self.interfaceUrl = [NSString stringWithFormat:@"%@%@",[DataService sharedService].kHost,kComplaint];
    
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
                            [self.delegate getComplainInfoDidFinished];
                        }
                        @catch (NSException *exception) {
                            [self.delegate getComplainInfoDidFailed:@"获取数据失败!"];
                        }
                    }else {
                        [self.delegate getComplainInfoDidFailed:[jsonData objectForKey:@"msg"]];
                    }
                    
                }else {
                    [self.delegate getComplainInfoDidFailed:@"获取数据失败!"];
                }
            }
        }
    }else {
        [self.delegate getComplainInfoDidFailed:@"获取数据失败!"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate getComplainInfoDidFailed:@"请求失败!"];
}

@end
