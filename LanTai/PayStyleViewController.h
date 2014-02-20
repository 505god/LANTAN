//
//  PayStyleViewController.h
//  LanTaiOrder
//
//  Created by Ruby on 13-3-13.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "GetcodeInterface.h"
#import "ChangePwdInterface.h"
#import "OrderInfo.h"

@protocol PayStyleViewDelegate;

@interface PayStyleViewController : UIViewController<UIAlertViewDelegate,GetcodeInterfaceDelegate,ChangePwdInterfaceDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UIView *subview;
@property (nonatomic,strong) ChangePwdInterface *changePwdInterface;
@property (nonatomic,strong) GetcodeInterface *getcodeInterface;

@property (nonatomic,assign) id<PayStyleViewDelegate> delegate;
@property (nonatomic,strong) NSMutableDictionary *order;
@property (nonatomic,strong) NSMutableArray *save_cardArray;
@property (nonatomic,strong) IBOutlet UISwitch *billingBtn;
@property (nonatomic,assign) BOOL isSuccess;
@property (nonatomic,strong) IBOutlet UIView *payStyleView,*cardView,*passView;
@property (nonatomic,strong) IBOutlet UISegmentedControl *segBtn;
//储值卡页面
@property (nonatomic, strong) IBOutlet UITextField *txtPwd;
@property (nonatomic, strong) IBOutlet UIButton *cardBackBtn,*forgetBtn,*cardSureBtn;
//修改密码页面
@property (strong, nonatomic) IBOutlet UITextField *pTxt1;
@property (strong, nonatomic) IBOutlet UITextField *pTxt2;
@property (strong, nonatomic) IBOutlet UITextField *cTxt;
@property (strong, nonatomic) IBOutlet UIButton *cancleBtn;
@property (strong, nonatomic) IBOutlet UIButton *sureBtn;
@property (strong, nonatomic) IBOutlet UIButton *codeBtn;
@property (strong, nonatomic) IBOutlet UIButton *forgetBackBtn;

@property (nonatomic,assign) int payType;
@property (nonatomic,assign) NSInteger pageValue;

@property (nonatomic,strong) NSMutableArray *waittingCarsArr;
@property (nonatomic,strong) NSMutableDictionary *beginningCarsDic;
@property (nonatomic,strong) NSMutableArray *finishedCarsArr;

//－－－多个储值卡
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSString *sv_relation_id;

@end

@protocol PayStyleViewDelegate <NSObject>
@optional
- (void)closePopVieww:(PayStyleViewController *)payStyleViewController;
@end
