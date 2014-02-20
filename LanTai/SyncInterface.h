//
//  SyncInterface.h
//  LanTai
//
//  Created by comdosoft on 13-12-12.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "BaseInterface.h"
@protocol SyncInterfaceDelegate;
@interface SyncInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id <SyncInterfaceDelegate> delegate;

-(void)getSyncInterfaceDelegateWithSyncInfo:(NSString *)syncInfo;
@end

@protocol SyncInterfaceDelegate <NSObject>

-(void)getSyncInfoDidFinished:(NSDictionary *)result;
-(void)getSyncInfoDidFailed:(NSString *)errorMsg;

@end

