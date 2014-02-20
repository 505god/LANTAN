//
//  CancleOrderInterface.h
//  LanTai
//
//  Created by comdosoft on 13-12-12.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "BaseInterface.h"

@protocol CancleOrderInterfaceDelegate;
@interface CancleOrderInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id <CancleOrderInterfaceDelegate> delegate;

-(void)getCancleOrderInterfaceDelegateWithorderId:(NSString *)order_id;
@end

@protocol CancleOrderInterfaceDelegate <NSObject>

-(void)getCancleOrderInfoDidFinished:(NSDictionary *)result;
-(void)getCancleOrderInfoDidFailed:(NSString *)errorMsg;

@end

