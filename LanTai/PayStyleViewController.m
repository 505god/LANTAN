//
//  PayStyleViewController.m
//  LanTaiOrder
//
//  Created by Ruby on 13-3-13.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "PayStyleViewController.h"
#import <CommonCrypto/CommonCrypto.h>
#import "UIViewController+MJPopupViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "CarObj.h"
#import "LanTanDB.h"
#import "AppDelegate.h"

@interface PayStyleViewController ()

@end

const CGFloat kScroll1ObjHeight	= 40;
const CGFloat kScroll1ObjWidth	= 120;
@implementation PayStyleViewController

-(CarObj *)setAttributeWithDictionary:(NSDictionary *)result {
    CarObj *carobject = [[CarObj alloc]init];
    carobject.carID = [NSString stringWithFormat:@"%@",[result objectForKey:@"car_num_id"]];
    carobject.carPlateNumber = [NSString stringWithFormat:@"%@",[result objectForKey:@"num"]];
    carobject.orderId = [NSString stringWithFormat:@"%@",[result objectForKey:@"id"]];
    carobject.status =[NSString stringWithFormat:@"%@",[result objectForKey:@"status"]];
    if (![[result objectForKey:@"station_id"]isKindOfClass:[NSNull class]] && [result objectForKey:@"station_id"]!=nil) {
        carobject.stationId =[NSString stringWithFormat:@"%@",[result objectForKey:@"station_id"]];
    }
    carobject.serviceName = [NSString stringWithFormat:@"%@",[result objectForKey:@"service_name"]];
    carobject.lastTime = [NSString stringWithFormat:@"%@",[result objectForKey:@"cost_time"]];
    carobject.workOrderId = [NSString stringWithFormat:@"%@",[result objectForKey:@"wo_id"]];
    if (![[result objectForKey:@"wo_started_at"]isKindOfClass:[NSNull class]] && [result objectForKey:@"wo_started_at"]!=nil) {
        carobject.serviceStartTime = [NSString stringWithFormat:@"%@",[result objectForKey:@"wo_started_at"]];
    }
    if (![[result objectForKey:@"wo_ended_at"]isKindOfClass:[NSNull class]] && [result objectForKey:@"wo_ended_at"]!=nil) {
        carobject.serviceEndTime = [NSString stringWithFormat:@"%@",[result objectForKey:@"wo_ended_at"]];
    }
    return carobject;
}

#pragma mark - 支付
-(void)payWithType:(NSData *)data {
    id jsonObject=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if (jsonObject !=nil) {
        if ([jsonObject isKindOfClass:[NSDictionary class]]) {
            NSDictionary *jsonData=(NSDictionary *)jsonObject;
            DLog(@"jsonData = %@",jsonData);
            if ([[jsonData objectForKey:@"status"]intValue] == 1) {
                [Utils errorAlert:@"交易成功!"];
                NSDictionary *order_dic = [jsonData objectForKey:@"orders"];
                NSMutableDictionary *dic = [[NSMutableDictionary alloc]init];
                //排队等候
                if (![[order_dic objectForKey:@"0"]isKindOfClass:[NSNull class]] && [order_dic objectForKey:@"0"]!= nil) {
                    NSArray *waiting_array = [order_dic objectForKey:@"0"];
                    if (waiting_array.count>0) {
                        self.waittingCarsArr = [[NSMutableArray alloc]init];
                        for (int i=0; i<waiting_array.count; i++) {
                            NSDictionary *resultt = [waiting_array objectAtIndex:i];
                            CarObj *carobject = [self setAttributeWithDictionary:resultt];
                            [self.waittingCarsArr addObject:carobject];
                        }
                        [dic setObject:self.waittingCarsArr forKey:@"wait"];
                    }
                }
                //施工中
                if (![[order_dic objectForKey:@"1"]isKindOfClass:[NSNull class]] && [order_dic objectForKey:@"1"]!= nil) {
                    NSArray *working_array = [order_dic objectForKey:@"1"];
                    if (working_array.count>0) {
                        self.beginningCarsDic = [[NSMutableDictionary alloc]init];
                        for (int i=0; i<working_array.count; i++) {
                            NSDictionary *resultt = [working_array objectAtIndex:i];
                            CarObj *carobject = [self setAttributeWithDictionary:resultt];
                            [self.beginningCarsDic setObject:carobject forKey:carobject.stationId];
                        }
                        [dic setObject:self.beginningCarsDic forKey:@"work"];
                    }
                }
                //等待付款
                if (![[order_dic objectForKey:@"2"]isKindOfClass:[NSNull class]] && [order_dic objectForKey:@"2"]!= nil) {
                    
                    NSArray *finish_array = [order_dic objectForKey:@"2"];
                    if (finish_array.count>0) {
                        self.finishedCarsArr = [[NSMutableArray alloc]init];
                        for (int i=0; i<finish_array.count; i++) {
                            NSDictionary *resultt = [finish_array objectAtIndex:i];
                            CarObj *carobject = [self setAttributeWithDictionary:resultt];
                            [self.finishedCarsArr addObject:carobject];
                        }
                        [dic setObject:self.finishedCarsArr forKey:@"finish"];
                    }
                }
                
                self.isSuccess = TRUE;
                if (self.delegate && [self.delegate respondsToSelector:@selector(closePopVieww:)]) {
                    [self.delegate closePopVieww:self];
                }
            }else {
                [Utils errorAlert:[NSString stringWithFormat:@"%@",[jsonData objectForKey:@"msg"]]];
                self.isSuccess = FALSE;
            }
        }
    }
    AppDelegate *app = [AppDelegate shareInstance];
    [MBProgressHUD hideHUDForView:app.window animated:YES];
}
- (void)pay:(int)type{
    self.payType = type;
    if (self.order) {
        NSString *billing = @"1";
        if (self.billingBtn.isOn) {
            billing = @"1";
        }else{
            billing = @"0";
        }
        NSMutableDictionary *params=[[NSMutableDictionary alloc] initWithDictionary:self.order];
        [params setObject:[DataService sharedService].store_id forKey:@"store_id"];
        [params setObject:billing forKey:@"billing"];
        [params setObject:[NSNumber numberWithInt:self.payType] forKey:@"pay_type"];
        
        if (self.payType == 5) {
            [params setObject:[NSNumber numberWithInt:1] forKey:@"is_free"];
        }else if (self.payType == 1){
            [params setObject:[NSNumber numberWithInt:0] forKey:@"is_free"];
            [params setObject:[NSString stringWithFormat:@"%@",self.sv_relation_id] forKey:@"csrid"];
            [params setObject:self.txtPwd.text forKey:@"password"];
        }else {
            [params setObject:[NSNumber numberWithInt:0] forKey:@"is_free"];
        }
        
        if ([[Utils isExistenceNetwork] isEqualToString:@"NotReachable"]) {
            if (self.payType == 1) {
                [Utils errorAlert:@"无网络情况下不支持储值卡付款"];
            }else {
                LanTanDB *lantanDb = [[LanTanDB alloc]init];
                BOOL isFinish = NO;
                OrderInfo *model = [lantanDb getLocalOrderInfoWhereSid:[params objectForKey:@"order_id"]];
                model.customer_id=[NSString stringWithFormat:@"%@",[params objectForKey:@"customer_id"]];
                model.car_num_id=[NSString stringWithFormat:@"%@",[params objectForKey:@"car_num_id"]];
                model.content=[NSString stringWithFormat:@"%@",[params objectForKey:@"content"]];
                model.oprice=[NSString stringWithFormat:@"%@",[params objectForKey:@"oprice"]];
                model.is_please=[NSString stringWithFormat:@"%@",[params objectForKey:@"is_please"]];
                model.total_price=[NSString stringWithFormat:@"%@",[params objectForKey:@"total_price"]];
                model.prods=[NSString stringWithFormat:@"%@",[params objectForKey:@"prods"]];
                model.brand=[NSString stringWithFormat:@"%@",[params objectForKey:@"brand"]];
                model.year=[NSString stringWithFormat:@"%@",[params objectForKey:@"year"]];
                model.birth=[NSString stringWithFormat:@"%@",[params objectForKey:@"birth"]];
                model.cdistance=[NSString stringWithFormat:@"%@",[params objectForKey:@"cdistance"]];
                model.userName=[NSString stringWithFormat:@"%@",[params objectForKey:@"userName"]];
                model.phone=[NSString stringWithFormat:@"%@",[params objectForKey:@"phone"]];
                model.sex=[NSString stringWithFormat:@"%@",[params objectForKey:@"sex"]];
                model.billing=[NSString stringWithFormat:@"%@",[params objectForKey:@"billing"]];
                model.pay_type=[NSString stringWithFormat:@"%@",[params objectForKey:@"pay_type"]];
                model.is_free=[NSString stringWithFormat:@"%@",[params objectForKey:@"is_free"]];
                model.status =[NSString stringWithFormat:@"%d",1];
                model.store_id =[NSString stringWithFormat:@"%@",[params objectForKey:@"store_id"]];
                model.cproperty = [NSString stringWithFormat:@"%@",[params objectForKey:@"cproperty"]];
                model.ccompany = [NSString stringWithFormat:@"%@",[params objectForKey:@"cgroup_name"]];
                if (model.reason == NULL) {
                    model.order_id =[NSString stringWithFormat:@"%@",[params objectForKey:@"order_id"]];
                    model.reason = @"";
                    model.request = @"";
                    isFinish = [lantanDb addDataWithDictionary:model];
                    
                }else {
                    isFinish = [lantanDb updateOrderInfoWithOrder:model WhereSid:[params objectForKey:@"order_id"]];
                }
                if (isFinish) {
                    self.isSuccess = TRUE;
                    if (self.delegate && [self.delegate respondsToSelector:@selector(closePopVieww:)]) {
                        [self.delegate closePopVieww:self];
                    }
                }else {
                    [Utils errorAlert:@"付款失败"];
                }
            }
        }else {
            AppDelegate *app = [AppDelegate shareInstance];
            [MBProgressHUD showHUDAddedTo:app.window animated:YES];
            
            NSMutableURLRequest *request=[Utils getRequest:params string:[NSString stringWithFormat:@"%@%@",[DataService sharedService].kHost,kNewPay]];
            NSOperationQueue *queue=[[NSOperationQueue alloc] init];
            [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *respone,NSData *data,NSError *error) {
                 if ([data length]>0 && error==nil) {
                     [self performSelectorOnMainThread:@selector(payWithType:) withObject:data waitUntilDone:NO]; 
                 }
             }
             ];
        }
    }
}
#pragma mark 页面返回
-(IBAction)goBackBtnPressed:(id)sender {
    CGRect frame1 = CGRectMake(0, 0, 425, 222);
    CGRect frame2 = CGRectMake(-425, 0, 425, 222);
    if (self.pageValue == 1) {
        [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self.payStyleView setFrame:frame1];
            [self.cardView setFrame:frame2];
        }
                         completion:^(BOOL finished){
                             self.pageValue = 0;

                         }];
    }else if (self.pageValue == 2) {
        [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self.cardView setFrame:frame1];
            [self.passView setFrame:frame2];
        }
                         completion:^(BOOL finished){
                             self.pageValue = 1;

                         }];
    }
}
#pragma mark - 根据不同的支付方式
- (IBAction)closePopup:(UISegmentedControl *)sender
{
    if (sender.selectedSegmentIndex == 0) {
        [self pay:0];
    }else if (sender.selectedSegmentIndex == 1 && self.order){
        if(self.save_cardArray.count==0) {
            [Utils errorAlert:@"您没有合适的储值卡"];
        }else {
            CGRect frame1 = CGRectMake(0, 0, 425, 222);
            CGRect frame2 = CGRectMake(-425, 0, 425, 222);
            [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionBeginFromCurrentState animations:^{
                [self.cardView setFrame:frame1];
                [self.payStyleView setFrame:frame2];
            }
                             completion:^(BOOL finished){
                                 self.pageValue = 1;
                             }];
        }
        
    }else if (sender.selectedSegmentIndex == 2) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:kTip message:@"确定免单?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [alertView dismissWithClickedButtonIndex:0 animated:YES];
    }else {
        [self pay:5];
    }
}
#pragma mark  储值卡付款页面

- (IBAction)clickCardSureBtn:(id)sender{
    [self.txtPwd resignFirstResponder];
    if (self.sv_relation_id != nil) {
        NSString *regexCall = @"\\d{6}";
        NSPredicate *predicateCall = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexCall];
        if ([predicateCall evaluateWithObject:self.txtPwd.text]) {
            if ([[Utils isExistenceNetwork] isEqualToString:@"NotReachable"]) {
                [Utils errorAlert:@"暂无网络!"];
            }else {
                [self pay:1];
            }
        }else {
            [Utils errorAlert:@"请输入正确的密码!"];
        }
    }else {
        [Utils errorAlert:@"请先选择储值卡!"];
    }
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)layoutScrollButtons
{
	UIButton *btn = nil;
	NSArray *subviews = [self.scrollView subviews];
    
	CGFloat curXLoc = 0;
	for (btn in subviews)
	{
		if ([btn isKindOfClass:[UIButton class]] && btn.tag >= 0)
		{
			CGRect frame = btn.frame;
			frame.origin = CGPointMake(curXLoc, 0);
			btn.frame = frame;
			
			curXLoc += (kScroll1ObjWidth);
		}
	}
	[self.scrollView setContentSize:CGSizeMake((self.save_cardArray.count * kScroll1ObjWidth), [self.scrollView bounds].size.height)];
}
//对储值卡余额排序
- (void)bubbleSort:(NSMutableArray *)array {
    int i, y;
    BOOL bFinish = YES;
    for (i = 1; i<= [array count] && bFinish; i++) {
        bFinish = NO;
        for (y = (int)[array count]-1; y>=i; y--) {
            NSDictionary * sv_dic1 = (NSDictionary *)[array objectAtIndex:y];
            NSDictionary * sv_dic2 = (NSDictionary *)[array objectAtIndex:y-1];
            if (([[sv_dic1 objectForKey:@"l_price"] floatValue] - [[sv_dic2 objectForKey:@"l_price"] floatValue])>0.000001) {
                [array exchangeObjectAtIndex:y-1 withObjectAtIndex:y];
                bFinish = YES;
            }
        }
    }
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.sv_relation_id = nil;
    [self.subview.layer setCornerRadius:8];
    [self.subview.layer setMasksToBounds:YES];
    
    self.payType = -1;
    self.pageValue = 0;
    self.codeBtn.userInteractionEnabled = YES;

    [self bubbleSort:self.save_cardArray];
    
    [self.scrollView setContentOffset:CGPointMake(0, 0)];
    
    UIButton *button = nil;
	NSArray *subviews = [self.scrollView subviews];
	for (button in subviews)
	{
		if ([button isKindOfClass:[UIButton class]])
		{
            [button removeFromSuperview];
		}
	}
    for(int i = 0; i < [self.save_cardArray count]; i++){
        NSDictionary * sv_dic = [self.save_cardArray objectAtIndex:i];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        [btn setTitle:[NSString stringWithFormat:@"%@",[sv_dic objectForKey:@"svname"]] forState:UIControlStateNormal];
        btn.tag = i;
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [btn addTarget:self action:@selector(cardbuttonPressed:) forControlEvents:UIControlEventTouchUpInside];

        if (i == 0) {
            //计算余额
            CGFloat left_price = [[sv_dic objectForKey:@"l_price"]floatValue];
            if (left_price - [[self.order objectForKey:@"total_price"]floatValue]>=0) {
                [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"button_red"] forState:UIControlStateNormal];
                self.sv_relation_id = [NSString stringWithFormat:@"%@",[sv_dic objectForKey:@"csrid"]];
            }else {
                [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:@"button_gray"] forState:UIControlStateNormal];
            }
        }else {
            [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage imageNamed:@"button_gray"] forState:UIControlStateNormal];
        }
        
        CGRect rect = btn.frame;
        rect.size.height = kScroll1ObjHeight;
        rect.size.width = kScroll1ObjWidth;
        btn.frame = rect;
        
        [self.scrollView addSubview:btn];
    }
    [self layoutScrollButtons];
    
    //监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name: UIKeyboardWillHideNotification object:nil];
}
-(void)cardbuttonPressed:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSDictionary * sv_dic = [self.save_cardArray objectAtIndex:button.tag];
    //计算余额
    CGFloat left_price = [[sv_dic objectForKey:@"l_price"]floatValue];
    if (left_price - [[self.order objectForKey:@"total_price"]floatValue]>=0) {
        self.sv_relation_id = [NSString stringWithFormat:@"%@",[sv_dic objectForKey:@"csrid"]];
        
        for(UIButton *btn in [self.scrollView subviews]){
            if ([btn isKindOfClass:[UIButton class]]){
                if(btn.tag == button.tag){
                    [UIView animateWithDuration:0.5f animations:^{
                        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                        [btn setBackgroundImage:[UIImage imageNamed:@"button_red"] forState:UIControlStateNormal];
                    }];
                }else{
                    [UIView animateWithDuration:0.5f animations:^{
                        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
                        [btn setBackgroundImage:[UIImage imageNamed:@"button_gray"] forState:UIControlStateNormal];
                    }];
                }
            }
        }
    }else {
        [Utils errorAlert:@"此卡余额不足!"];
    }
    
    DLog(@"sv = %@",self.sv_relation_id);
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}
#pragma mark 修改储值卡密码页面
//修改密码
-(IBAction)clickPassword:(id)sender {
    if (self.sv_relation_id != nil) {
        CGRect frame1 = CGRectMake(0, 0, 425, 222);
        CGRect frame2 = CGRectMake(-425, 0, 425, 222);
        [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self.passView setFrame:frame1];
            [self.cardView setFrame:frame2];
        }
                         completion:^(BOOL finished){
                             self.pageValue = 2;
                             
                         }];
    }else {
        [Utils errorAlert:@"请先选择储值卡!"];
    }
}
//获取验证码
-(IBAction)codeBtnPressed:(id)sender {
    if ([[Utils isExistenceNetwork] isEqualToString:@"NotReachable"]) {
        [Utils errorAlert:@"暂无网络!"];
    }else{
        AppDelegate *app = [AppDelegate shareInstance];
        [MBProgressHUD showHUDAddedTo:app.window animated:YES];
        GetcodeInterface *log = [[GetcodeInterface alloc]init];
        self.getcodeInterface = log;
        self.getcodeInterface.delegate = self;
        [self.getcodeInterface getCodeInterfaceDelegateWithCrid:self.sv_relation_id];
    }
}
//取消修改密码
-(IBAction)cancleBtnPressed:(id)sender {
    CGRect frame1 = CGRectMake(0, 0, 425, 222);
    CGRect frame2 = CGRectMake(-425, 0, 425, 222);
    [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self.cardView setFrame:frame1];
        [self.passView setFrame:frame2];
    }
                     completion:^(BOOL finished){
                         self.pageValue = 1;
                     }];
}
-(IBAction)passSureBtnPressed:(id)sender {
    [self.pTxt1 resignFirstResponder];
    [self.pTxt2 resignFirstResponder];
    [self.cTxt resignFirstResponder];
    NSString *regexCall = @"\\d{6}";
    NSPredicate *predicateCall = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regexCall];
    if ([predicateCall evaluateWithObject:self.pTxt1.text]) {
        if ([self.pTxt1.text isEqualToString:self.pTxt2.text]) {
            if (self.cTxt.text.length>0) {
                if ([[Utils isExistenceNetwork] isEqualToString:@"NotReachable"]) {
                    [Utils errorAlert:@"暂无网络!"];
                }else {
                    AppDelegate *app = [AppDelegate shareInstance];
                    [MBProgressHUD showHUDAddedTo:app.window animated:YES];
                    ChangePwdInterface *log = [[ChangePwdInterface alloc]init];
                    self.changePwdInterface = log;
                    self.changePwdInterface.delegate = self;
                    [self.changePwdInterface ChangePwdInterfaceDelegateWithCrid:self.sv_relation_id andCode:self.cTxt.text andPasswd:self.pTxt1.text];
                }
            }else {
                [Utils errorAlert:@"请输入验证码!"];
            }
        }else {
            [Utils errorAlert:@"请设置两次密码一致!"];
        }
    }else {
        [Utils errorAlert:@"请设置6位数字密码!"];
    }

}
#pragma mark GetcodeInterfaceDelegate; 
-(void)getCodeInfoDidFinished; {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            AppDelegate *app = [AppDelegate shareInstance];
            [MBProgressHUD hideHUDForView:app.window animated:YES];
            [Utils errorAlert:@"验证码已发送"];
        });
    });
}
-(void)getCodeInfoDidFailed:(NSString *)errorMsg; {
    AppDelegate *app = [AppDelegate shareInstance];
    [MBProgressHUD hideHUDForView:app.window animated:YES];
    [Utils errorAlert:errorMsg];
}
#pragma mark ChangePwdInterfaceDelegate
-(void)getPwdInfoDidFinished; {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            AppDelegate *app = [AppDelegate shareInstance];
            [MBProgressHUD hideHUDForView:app.window animated:YES];
            [Utils errorAlert:@"密码修改成功"];
            CGRect frame1 = CGRectMake(0, 0, 425, 222);
            CGRect frame2 = CGRectMake(-425, 0, 425, 222);
            [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionBeginFromCurrentState animations:^{
                [self.cardView setFrame:frame1];
                [self.passView setFrame:frame2];
            }
                             completion:^(BOOL finished){
                                 self.pageValue = 1;
                             }];
        });
    });
}
-(void)getPwdInfoDidFailed:(NSString *)errorMsg; {
    AppDelegate *app = [AppDelegate shareInstance];
    [MBProgressHUD hideHUDForView:app.window animated:YES];
    [Utils errorAlert:errorMsg];
}


- (void)keyBoardWillShow:(id)sender{
    [UIView beginAnimations:nil context:nil];
    CGRect frame = self.view.frame;
    if (frame.origin.y==273) {
        frame.origin.y = 200;
    }
    self.view.frame = frame;
    
    [UIView commitAnimations];
}

- (void)keyBoardWillHide:(id)sender{
    [UIView beginAnimations:nil context:nil];
    CGRect frame = self.view.frame;
    if (frame.origin.y==200) {
        frame.origin.y = 273;
    }
    self.view.frame = frame;
    [UIView commitAnimations];
}
@end
