//
//  packagePayInterface.h
//  LanTai
//
//  Created by comdosoft on 13-12-31.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "BaseInterface.h"
@protocol packagePayInterfaceDelegate;
@interface packagePayInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id <packagePayInterfaceDelegate> delegate;

-(void)getPackageInterfaceDelegateWithorderId:(NSString *)order_id andType:(NSString *)type andPleased:(NSString *)please;
@end

@protocol packagePayInterfaceDelegate <NSObject>

-(void)getPackageInfoDidFinished:(NSDictionary *)result;
-(void)getPackageInfoDidFailed:(NSString *)errorMsg;

@end

