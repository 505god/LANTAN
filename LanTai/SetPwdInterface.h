//
//  SetPwdInterface.h
//  LanTai
//
//  Created by comdosoft on 13-12-25.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "BaseInterface.h"
@protocol SetPwdInterfaceDelegate;
@interface SetPwdInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id <SetPwdInterfaceDelegate> delegate;

-(void)getSetPwdInterfaceDelegateWithCsrid:(NSString *)csrid andPwd:(NSString *)pwd andCid:(NSString *)cid andOid:(NSString *)oid;
@end

@protocol SetPwdInterfaceDelegate <NSObject>

-(void)getSetPwdInfoDidFinished:(NSDictionary *)result;
-(void)getSetPwdInfoDidFailed:(NSString *)errorMsg;

@end
