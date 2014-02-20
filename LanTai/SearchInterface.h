//
//  SearchInterface.h
//  LanTai
//
//  Created by comdosoft on 13-12-7.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "BaseInterface.h"

@protocol SearchInterfaceDelegate;
@interface SearchInterface : BaseInterface<BaseInterfaceDelegate>

@property (nonatomic, assign) id <SearchInterfaceDelegate> delegate;

-(void)getSearchInterfaceDelegateWithText:(NSString *)text andType:(NSString *)type;
@end

@protocol SearchInterfaceDelegate <NSObject>

-(void)getSearchInfoDidFinished:(NSArray *)result;
-(void)getSearchInfoDidFailed:(NSString *)errorMsg;

@end

