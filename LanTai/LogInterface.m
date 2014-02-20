//
//  LogInterface.m
//  CaiJinTong
//
//  Created by comdosoft on 13-9-17.
//  Copyright (c) 2013年 CaiJinTong. All rights reserved.
//

#import "LogInterface.h"
#import "LanTanDB.h"
#import "UserModel.h"
@implementation LogInterface

-(void)getLogInterfaceDelegateWithName:(NSString *)theName andPassWord:(NSString *)thePassWord {
    NSMutableDictionary *reqheaders = [[NSMutableDictionary alloc] init];
    
    [reqheaders setValue:[NSString stringWithFormat:@"%@",theName] forKey:@"user_name"];
    [reqheaders setValue:[NSString stringWithFormat:@"%@",thePassWord] forKey:@"user_password"];

    self.interfaceUrl = [NSString stringWithFormat:@"%@%@",[DataService sharedService].kHost,kLogin];

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
                if (jsonData) {
                     NSString *text = [jsonData objectForKey:@"info"];
                    if (text.length == 0) {
                        @try {
                            NSDictionary *staff = [jsonData objectForKey:@"staff"];
                            
                            UserModel *user = [[UserModel alloc]init];
                            user.userId = [NSString stringWithFormat:@"%@",[staff objectForKey:@"user_id"]];
                            user.storeId = [NSString stringWithFormat:@"%@",[staff objectForKey:@"store_id"]];
                            user.userName = [NSString stringWithFormat:@"%@",[staff objectForKey:@"username"]];
                            user.userImg = [NSString stringWithFormat:@"%@",[staff objectForKey:@"photo"]];
                            user.userPartment = [NSString stringWithFormat:@"%@",[staff objectForKey:@"department"]];
                            user.userPost = [NSString stringWithFormat:@"%@",[staff objectForKey:@"position"]];
                            user.name = [NSString stringWithFormat:@"%@",[staff objectForKey:@"name"]];
                            user.store_name =[NSString stringWithFormat:@"%@",[staff objectForKey:@"store_name"]];
                            [DataService sharedService].userModel = user;
                            [DataService sharedService].isJurisdiction = [[staff objectForKey:@"cash_auth"]integerValue];
                            [DataService sharedService].user_id = [NSString stringWithFormat:@"%@",[staff objectForKey:@"user_id"]];
                            [DataService sharedService].store_id = [NSString stringWithFormat:@"%@",[staff objectForKey:@"store_id"]];
                            [DataService sharedService].firstTime = YES;
                            
                            [self.delegate getLogInfoDidFinished:staff];
                        }
                        @catch (NSException *exception) {
                            [self.delegate getLogInfoDidFailed:@"登录失败!"];
                        }
                    }else {
                        [self.delegate getLogInfoDidFailed:text];
                    }
                }else {
                    [self.delegate getLogInfoDidFailed:@"登录失败!"];
                }
            }
        }
    }else {
        [self.delegate getLogInfoDidFailed:@"登录失败!"];
    }
}
-(void)requestIsFailed:(NSError *)error{
    [DataService sharedService].isError = YES;
    [self.delegate getLogInfoDidFailed:@"请求失败!"];
}

@end
