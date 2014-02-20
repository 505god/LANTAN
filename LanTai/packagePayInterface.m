//
//  packagePayInterface.m
//  LanTai
//
//  Created by comdosoft on 13-12-31.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "packagePayInterface.h"

@implementation packagePayInterface
-(void)getPackageInterfaceDelegateWithorderId:(NSString *)order_id andType:(NSString *)type andPleased:(NSString *)please{
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    
    [reqheaders setValue:[NSString stringWithFormat:@"%@",order_id] forKey:@"order_id"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",type] forKey:@"type"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",please] forKey:@"is_pleased"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",[DataService sharedService].store_id] forKey:@"store_id"];
    
    self.interfaceUrl = [NSString stringWithFormat:@"%@%@",[DataService sharedService].kHost,kConfirm_package];
    
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
                            [self.delegate getPackageInfoDidFinished:jsonData];
                        }
                        @catch (NSException *exception) {
                            [self.delegate getPackageInfoDidFailed:@"获取数据失败!"];
                        }
                    }else {
                        [self.delegate getPackageInfoDidFailed:[jsonData objectForKey:@"msg"]];
                    }
                    
                }else {
                    [self.delegate getPackageInfoDidFailed:@"获取数据失败!"];
                }
            }
        }
    }else {
        [self.delegate getPackageInfoDidFailed:@"获取数据失败!"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate getPackageInfoDidFailed:@"请求失败!"];
}


@end
