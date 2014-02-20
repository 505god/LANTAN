//
//  LoginViewController.m
//  LanTaiOrder
//
//  Created by Ruby on 13-1-23.
//  Copyright (c) 2013年 LanTai. All rights reserved.
//

#import "LoginViewController.h"
#import "AppDelegate.h"
#import "IPViewController.h"
#import "LanTaiMenuMainController.h"

@implementation LoginViewController

@synthesize txtName,txtPwd,loginView;


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
    self.navigationController.navigationBar.hidden = YES;
    [DataService sharedService].isLoging = NO;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
   
    //监听键盘
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name: UIKeyboardWillHideNotification object:nil];
    
    self.errorView.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(IBAction)setIp:(id)sender {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"IP"];
    [defaults synchronize];
    
    [DataService sharedService].kHost = nil;
    [DataService sharedService].kDomain = nil;
    [DataService sharedService].user_id = nil;
    [DataService sharedService].store_id = nil;
    
    NSUserDefaults *defaultss = [NSUserDefaults standardUserDefaults];
    [defaultss removeObjectForKey:@"userId"];
    [defaultss removeObjectForKey:@"storeId"];
    [defaultss synchronize];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (BOOL)checkForm{
    NSString *passport = [[NSString alloc] initWithString: self.txtName.text?:@""];
    NSString *password = [[NSString alloc] initWithString: self.txtPwd.text?:@""];
    NSString *msgStr = @"";
    if (passport.length == 0){
        msgStr = @"请输入用户名";
    }else if (password.length == 0){
        msgStr = @"请输入密码";
    }
    
    if (msgStr.length > 0){
        [Utils errorAlert:msgStr];
        return FALSE;
    }
    return TRUE;
}

- (IBAction)clickLogin:(id)sender{
    
    [self.txtName resignFirstResponder];
    [self.txtPwd resignFirstResponder];
    if ([self checkForm]) {
        if ([[Utils isExistenceNetwork] isEqualToString:@"NotReachable"]) {
            [Utils errorAlert:@"暂无网络!"];
        }else{
            [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            LogInterface *log = [[LogInterface alloc]init];
            self.logInterface = log;
            self.logInterface.delegate = self;
            [self.logInterface getLogInterfaceDelegateWithName:self.txtName.text andPassWord:self.txtPwd.text];
        }
    }
}

- (void)keyBoardWillShow:(id)sender{
    [UIView beginAnimations:nil context:nil];
    CGRect frame = self.loginView.frame;
    if (frame.origin.y==192) {
        frame.origin.y = 70;
    }
    self.loginView.frame = frame;
    [UIView commitAnimations];
}

- (void)keyBoardWillHide:(id)sender{
    [UIView beginAnimations:nil context:nil];
    CGRect frame = self.loginView.frame;
    if (frame.origin.y==70) {
        frame.origin.y = 192;
    }
    self.loginView.frame = frame;
    [UIView commitAnimations];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return (interfaceOrientation == UIInterfaceOrientationLandscapeLeft || interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}
#pragma mark - LogInterface

-(void)getLogInfoDidFinished:(NSDictionary *)result {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            LanTaiMenuMainController *messageView = [[LanTaiMenuMainController alloc]initWithNibName:@"LanTaiMenuMainController" bundle:nil];
            [self.navigationController pushViewController:messageView animated:YES];

        });
    });
}
-(void)getLogInfoDidFailed:(NSString *)errorMsg {
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    if ([DataService sharedService].isError == YES) {
        self.errorView.hidden = NO;
    }
    [Utils errorAlert:errorMsg];
}

@end
