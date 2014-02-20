//
//  ComplainInterface.h
//  LanTai
//
//  Created by comdosoft on 13-12-10.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "BaseInterface.h"

@protocol ComplainInterfaceDelegate;
@interface ComplainInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id <ComplainInterfaceDelegate> delegate;

-(void)getComplainInterfaceDelegateWithReson:(NSString *)reason andRequest:(NSString *)request andOrder:(NSString *)order;
@end

@protocol ComplainInterfaceDelegate <NSObject>

-(void)getComplainInfoDidFinished;
-(void)getComplainInfoDidFailed:(NSString *)errorMsg;

@end

