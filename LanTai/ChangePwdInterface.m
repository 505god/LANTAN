//
//  ChangePwdInterface.m
//  LanTai
//
//  Created by comdosoft on 13-12-11.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "ChangePwdInterface.h"

@implementation ChangePwdInterface
-(void)ChangePwdInterfaceDelegateWithCrid:(NSString *)crid andCode:(NSString *)code andPasswd:(NSString *)pwd {
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    
    [reqheaders setValue:[NSString stringWithFormat:@"%@",crid] forKey:@"cid"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",code] forKey:@"verify_code"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",pwd] forKey:@"n_password"];
    
    self.interfaceUrl = [NSString stringWithFormat:@"%@%@",[DataService sharedService].kHost,NChange];
    
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
                    if ([[jsonData objectForKey:@"msg_type"]intValue]==0) {
                        @try {
                            [self.delegate getPwdInfoDidFinished];
                        }
                        @catch (NSException *exception) {
                            [self.delegate getPwdInfoDidFailed:@"获取数据失败!"];
                        }
                    }else {
                        [self.delegate getPwdInfoDidFailed:[jsonData objectForKey:@"msg"]];
                    }
                    
                }else {
                    [self.delegate getPwdInfoDidFailed:@"获取数据失败!"];
                }
            }
        }
    }else {
        [self.delegate getPwdInfoDidFailed:@"获取数据失败!"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate getPwdInfoDidFailed:@"请求失败!"];
}

@end
