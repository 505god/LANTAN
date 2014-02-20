//
//  PackagePayView.m
//  LanTai
//
//  Created by comdosoft on 13-12-31.
//  Copyright (c) 2013年 david. All rights reserved.
//

#import "PackagePayView.h"
#import "AppDelegate.h"

@interface PackagePayView ()

@end

@implementation PackagePayView

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.subview.layer setCornerRadius:8];
    [self.subview.layer setMasksToBounds:YES];
}
- (IBAction)closePopup:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:kTip message:@"确定取消订单?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }else {
        if ([[Utils isExistenceNetwork] isEqualToString:@"NotReachable"]) {
            [Utils errorAlert:@"暂无网络!"];
        }else {
//            self.type=1;
//            AppDelegate *app = [AppDelegate shareInstance];
//            [MBProgressHUD showHUDAddedTo:app.window animated:YES];
//            packagePayInterface *log = [[packagePayInterface alloc]init];
//            self.p_payInterface = log;
//            self.p_payInterface.delegate = self;
//            [self.p_payInterface getPackageInterfaceDelegateWithorderId:self.order_id andType:[NSString stringWithFormat:@"%d",self.type]];
        }
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex==0) {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    }else {
        if ([[Utils isExistenceNetwork] isEqualToString:@"NotReachable"]) {
            [Utils errorAlert:@"暂无网络!"];
        }else {
//            self.type=0;
//            AppDelegate *app = [AppDelegate shareInstance];
//            [MBProgressHUD showHUDAddedTo:app.window animated:YES];
//            packagePayInterface *log = [[packagePayInterface alloc]init];
//            self.p_payInterface = log;
//            self.p_payInterface.delegate = self;
//            [self.p_payInterface getPackageInterfaceDelegateWithorderId:self.order_id andType:[NSString stringWithFormat:@"%d",self.type]];
        }
    }
}

#pragma mark packagePayInterfaceDelegate
-(void)getPackageInfoDidFinished:(NSDictionary *)result; {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            AppDelegate *app = [AppDelegate shareInstance];
            [MBProgressHUD hideHUDForView:app.window animated:YES];
            if (self.delegate && [self.delegate respondsToSelector:@selector(dismissPackagePayView:andResult:)]) {
                [self.delegate dismissPackagePayView:self andResult:result];
            }
        });
    });
}
-(void)getPackageInfoDidFailed:(NSString *)errorMsg; {
    AppDelegate *app = [AppDelegate shareInstance];
    [MBProgressHUD hideHUDForView:app.window animated:YES];
    [Utils errorAlert:errorMsg];
}
@end
