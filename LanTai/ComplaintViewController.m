//
//  ComplaintViewController.m
//  LanTaiOrder
//
//  Created by Ruby on 13-3-3.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "ComplaintViewController.h"
#import "LanTanDB.h"
#import "AppDelegate.h"
@implementation ComplaintViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
- (void)rightTapped:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)refreshServeItemsBtClicked:(id)sender {
    
}

- (void)viewDidLoad
{
    if (Platform>=7.0) {
        self.sub_view.frame = CGRectMake(0, 44, 1024, 724);
    }else {
        self.sub_view.frame = CGRectMake(0, 0, 1024, 724);
    }
    [super viewDidLoad];
    if (![self.navigationItem rightBarButtonItem]) {
        [DataService sharedService].payNumber = 0;
        [self addRightnaviItemsWithImage:@"shareBt" andImage:nil];
    }
    if (self.info) {
        self.lblCarNum.text = [self.info objectForKey:@"cnum"];
        self.lblProduct.text = [self.info objectForKey:@"opname"];
        self.lblCode.text = [self.info objectForKey:@"ocode"];
    }
    
    UIColor * cc = [UIColor grayColor];
    NSDictionary * dict = [NSDictionary dictionaryWithObject:cc forKey:UITextAttributeTextColor];
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.title = [NSString stringWithFormat:@"%@",[DataService sharedService].userModel.store_name];
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self.reasonView becomeFirstResponder];
}
- (IBAction)clickSubmit:(id)sender{
    [self.reasonView resignFirstResponder];
    [self.requestView resignFirstResponder];
    if (self.reasonView.text.length==0 || self.requestView.text.length==0) {
        [Utils errorAlert:@"请输入投诉理由和要求"];
    }else{
        if ([[Utils isExistenceNetwork] isEqualToString:@"NotReachable"] ) {
            BOOL success = NO;
            LanTanDB *db = [[LanTanDB alloc]init];
            OrderInfo *order = [db getLocalOrderInfoWhereSid:[self.info objectForKey:@"oid"]];
            if (order.reason == NULL) {
                order.order_id =[NSString stringWithFormat:@"%@",[self.info objectForKey:@"oid"]];
                order.is_please = [NSString stringWithFormat:@"%d",0];
                order.reason =[NSString stringWithFormat:@"%@",self.reasonView.text];
                order.request =[NSString stringWithFormat:@"%@",self.requestView.text];
                order.status = [NSString stringWithFormat:@"%d",2];
                success = [db addDataWithDictionary:order];
            }else {
                success = [db updateOrderInfoReason:self.reasonView.text Reaquest:self.requestView.text WhereSid:[self.info objectForKey:@"oid"]];
            }
            
            if (success) {
                [DataService sharedService].payNumber = 1;
                [self.navigationController popViewControllerAnimated:YES];
            }else {
                [Utils errorAlert:@"添加评论失败!"];
            }
        }else {
            AppDelegate *app = [AppDelegate shareInstance];
            [MBProgressHUD showHUDAddedTo:app.window animated:YES];
            ComplainInterface *log = [[ComplainInterface alloc]init];
            self.complainInterface = log;
            self.complainInterface.delegate = self;
            [self.complainInterface getComplainInterfaceDelegateWithReson:self.reasonView.text andRequest:self.requestView.text andOrder:[self.info objectForKey:@"oid"]];
            
        }
    }
}

-(IBAction)clickCancle:(id)sender {
    [UIView animateWithDuration:0.5 delay:0.0 options: UIViewAnimationOptionBeginFromCurrentState animations:^{
        [self.reasonView resignFirstResponder];
        [self.requestView resignFirstResponder];
    }
                     completion:^(BOOL finished){
                         [self.navigationController popViewControllerAnimated:YES];
                     }];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark ComplainInterfaceDelegate
-(void)getComplainInfoDidFinished; {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            AppDelegate *app = [AppDelegate shareInstance];
            [MBProgressHUD hideHUDForView:app.window animated:YES];
            [DataService sharedService].payNumber = 1;
            [self.navigationController popViewControllerAnimated:YES];
        });
    });
    
}
-(void)getComplainInfoDidFailed:(NSString *)errorMsg; {
    AppDelegate *app = [AppDelegate shareInstance];
    [MBProgressHUD hideHUDForView:app.window animated:YES];
    [Utils errorAlert:errorMsg];
}


@end
