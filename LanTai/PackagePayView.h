//
//  PackagePayView.h
//  LanTai
//
//  Created by comdosoft on 13-12-31.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "BaseViewController.h"
#import "packagePayInterface.h"

@protocol PackagePayViewDelegate;
@interface PackagePayView : BaseViewController<packagePayInterfaceDelegate>

@property (nonatomic, strong) packagePayInterface *p_payInterface;
@property (nonatomic, strong) IBOutlet UIView *subview;
@property (nonatomic, strong) IBOutlet UISegmentedControl *segBtn;
@property (nonatomic, assign) id<PackagePayViewDelegate>delegate;
@property (nonatomic, strong) NSString *order_id;
@property (nonatomic, assign) int type;//0:取消订单   1:付款成功
@end


@protocol PackagePayViewDelegate <NSObject>
@optional
- (void)dismissPackagePayView:(PackagePayView *)packagePayView andResult:(NSDictionary*)result;
@end