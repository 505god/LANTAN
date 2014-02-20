//
//  GetcodeInterface.h
//  LanTai
//
//  Created by comdosoft on 13-12-10.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "BaseInterface.h"
@protocol GetcodeInterfaceDelegate;
@interface GetcodeInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id <GetcodeInterfaceDelegate> delegate;

-(void)getCodeInterfaceDelegateWithCrid:(NSString *)crid;
@end

@protocol GetcodeInterfaceDelegate <NSObject>

-(void)getCodeInfoDidFinished;
-(void)getCodeInfoDidFailed:(NSString *)errorMsg;

@end
