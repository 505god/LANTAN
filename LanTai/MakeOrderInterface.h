//
//  MakeOrderInterface.h
//  LanTai
//
//  Created by comdosoft on 13-12-7.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "BaseInterface.h"

@protocol MakeOrderInterfaceDelegate;
@interface MakeOrderInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id <MakeOrderInterfaceDelegate> delegate;

-(void)getMakeOrderInterfaceDelegateWithContent:(NSString *)content andNum:(NSString *)num;
@end

@protocol MakeOrderInterfaceDelegate <NSObject>

-(void)getOrderInfoDidFinished:(NSDictionary *)result;
-(void)getOrderInfoDidFailed:(NSString *)errorMsg;

@end
