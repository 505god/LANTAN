//
//  SyncInterface.m
//  LanTai
//
//  Created by comdosoft on 13-12-12.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "SyncInterface.h"

@implementation SyncInterface
-(void)getSyncInterfaceDelegateWithSyncInfo:(NSString *)syncInfo; {
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    
    [reqheaders setValue:[NSString stringWithFormat:@"%@",syncInfo] forKey:@"syncInfo"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",[DataService sharedService].store_id] forKey:@"store_id"];
    
    self.interfaceUrl = [NSString stringWithFormat:@"%@%@",[DataService sharedService].kHost,ksync];
    
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
                            [self.delegate getSyncInfoDidFinished:jsonData];
                        }
                        @catch (NSException *exception) {
                            [self.delegate getSyncInfoDidFailed:@"获取数据失败!"];
                        }
                    }else {
                        [self.delegate getSyncInfoDidFailed:[jsonData objectForKey:@"msg"]];
                    }
                    
                }else {
                    [self.delegate getSyncInfoDidFailed:@"获取数据失败!"];
                }
            }
        }
    }else {
        [self.delegate getSyncInfoDidFailed:@"获取数据失败!"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate getSyncInfoDidFailed:@"请求失败!"];
}
@end
