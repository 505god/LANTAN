//
//  ChangePwdInterface.h
//  LanTai
//
//  Created by comdosoft on 13-12-11.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "BaseInterface.h"

@protocol ChangePwdInterfaceDelegate;
@interface ChangePwdInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id <ChangePwdInterfaceDelegate> delegate;

-(void)ChangePwdInterfaceDelegateWithCrid:(NSString *)crid andCode:(NSString *)code andPasswd:(NSString *)pwd;
@end

@protocol ChangePwdInterfaceDelegate <NSObject>

-(void)getPwdInfoDidFinished;
-(void)getPwdInfoDidFailed:(NSString *)errorMsg;

@end

