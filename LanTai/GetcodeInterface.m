//
//  GetcodeInterface.m
//  LanTai
//
//  Created by comdosoft on 13-12-10.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "GetcodeInterface.h"

@implementation GetcodeInterface
-(void)getCodeInterfaceDelegateWithCrid:(NSString *)crid {
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    
    [reqheaders setValue:[NSString stringWithFormat:@"%@",crid] forKey:@"cid"];
    
    self.interfaceUrl = [NSString stringWithFormat:@"%@%@",[DataService sharedService].kHost,NSendMeg];
    
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
                            [self.delegate getCodeInfoDidFinished];
                        }
                        @catch (NSException *exception) {
                            [self.delegate getCodeInfoDidFailed:@"获取数据失败!"];
                        }
                    }else {
                        [self.delegate getCodeInfoDidFailed:[jsonData objectForKey:@"msg"]];
                    }
                    
                }else {
                    [self.delegate getCodeInfoDidFailed:@"获取数据失败!"];
                }
            }
        }
    }else {
        [self.delegate getCodeInfoDidFailed:@"获取数据失败!"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate getCodeInfoDidFailed:@"请求失败!"];
}

@end
