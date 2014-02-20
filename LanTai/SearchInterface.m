//
//  SearchInterface.m
//  LanTai
//
//  Created by comdosoft on 13-12-7.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "SearchInterface.h"

@implementation SearchInterface
-(void)getSearchInterfaceDelegateWithText:(NSString *)text andType:(NSString *)type {
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    
    [reqheaders setValue:[NSString stringWithFormat:@"%@",text] forKey:@"search_text"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",type] forKey:@"search_type"];

    [reqheaders setValue:[NSString stringWithFormat:@"%@",[DataService sharedService].store_id] forKey:@"store_id"];

    
    self.interfaceUrl = [NSString stringWithFormat:@"%@%@",[DataService sharedService].kHost,kNewSearch];
    
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
                if (result) {
                    if ([[result objectForKey:@"status"]intValue] == 1) {
                        @try {
                            NSArray *array = [result objectForKey:@"result"];
                            [self.delegate getSearchInfoDidFinished:array];
                        }
                        @catch (NSException *exception) {
                            [self.delegate getSearchInfoDidFailed:@"获取数据失败"];
                        }
                        
                    }else {
                        [self.delegate getSearchInfoDidFailed:[result objectForKey:@"msg"]];
                    }
                }else {
                    [self.delegate getSearchInfoDidFailed:@"连接失败"];
                }
            }
        }
    }else {
        [self.delegate getSearchInfoDidFailed:@"连接失败"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [self.delegate getSearchInfoDidFailed:@"请求失败!"];
}

@end
