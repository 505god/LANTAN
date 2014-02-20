//
//  GetServiceInterface.h
//  LanTai
//
//  Created by comdosoft on 13-12-7.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "BaseInterface.h"

@protocol GetServiceInterfaceDelegate;
@interface GetServiceInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id <GetServiceInterfaceDelegate> delegate;

-(void)getServiceInterfaceDelegateWithNum:(NSString *)num andService:(NSString *)service;
@end

@protocol GetServiceInterfaceDelegate <NSObject>

-(void)getServiceInfoDidFinished:(NSDictionary *)result;
-(void)getServiceInfoDidFailed:(NSString *)errorMsg;

@end
